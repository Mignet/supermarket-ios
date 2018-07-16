//
//  CoreContextLabel.m
//  JinFuZiApp
//
//  Created by LiaoChangping on 3/10/15.
//  Copyright (c) 2015 com.jinfuzi. All rights reserved.
//

#import "CoreTextLabel.h"
#import "NSString+common.h"

@interface CoreTextLabel()

@property (nonatomic, assign) NSInteger clickLength;
@property (nonatomic, strong) NSMutableAttributedString * attributeString;
@property (nonatomic, strong) NSMutableArray * picPropertyArray;
@property (nonatomic, assign) CTFrameRef coreTextFrame;

@end

@implementation CoreTextLabel

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.lineSpace = 2.0f;
}

- (void)dealloc
{
    CFRelease(_coreTextFrame);
}

//////////////
#pragma mark - 获取文字的宽度，用以调整对齐方式
///////////////////////////////////////////
- (CGFloat )adjustLocationWithFontSize:(NSInteger )font WithText:(NSString *)content
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:font], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [content boundingRectWithSize:self.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return size.width;
}

//////////////
#pragma mark - 获取文字的宽度
///////////////////////////////////////////
- (CGFloat )adjustLocationWithFont:(UIFont *)font WithText:(NSString *)content
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [content boundingRectWithSize:self.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return size.width;
}


//////////////
#pragma mark - 中间对齐
///////////////////////////////////////////
- (CGFloat )setCenterAlignment
{
    CGFloat width = 0;
    for (NSDictionary * dic in _arr_Property) {
        
        width = width + [self  adjustLocationWithFont:[dic valueForKey:@"font"] WithText:[dic valueForKey:@"range"]];
    }

    return SCREEN_FRAME.size.width / 2 - width / 2;
}

//////////////
#pragma mark - 左对齐
///////////////////////////////////////////
- (CGFloat )setLeftAlignment
{
    return 0;
}

//////////////
#pragma mark - 右对齐
///////////////////////////////////////////
- (CGFloat )setRightAlignment
{
    CGFloat width = 0;
    for (NSDictionary * dic in _arr_Property) {
        
        width = width + [self  adjustLocationWithFont:[dic valueForKey:@"font"] WithText:[dic valueForKey:@"range"]];
    }

    return SCREEN_FRAME.size.width - width;
}

#pragma mark- 创建属性字符串
- (void)buildAttributeString
{
    if(!self.textAlignment){
        self.textAlignment = NSTextAlignmentLeft;
    }
    
    self.attributeString = [[NSMutableAttributedString alloc]initWithString:@""];
    NSDictionary* attrs = nil;
    //为每一run设置一个属性
    for (NSDictionary * dic in _arr_Property) {
        
        if (![NSObject isValidateInitString:[dic objectForKey:@"imageName"]]) {
            
            
            if ([[dic objectForKey:@"color"] isEqual:UIColorFromHex(0x2298F3)] || [[dic objectForKey:@"clickArea"] isEqualToString:@"Yes"]) {
                
                self.clickLength = [[dic objectForKey:@"range"] sizeWithStringFont:self.clickAbleFontSize InRect:self.frame.size].width;
                attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                         (id)[dic valueForKey:@"color"], kCTForegroundColorAttributeName,
                         (id)[dic valueForKey:@"font"], kCTFontAttributeName,
                         @"click",@"ClickArea",
                         nil];
            }else
            {
                
                attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                         (id)[dic valueForKey:@"color"], kCTForegroundColorAttributeName,
                         (id)[dic valueForKey:@"font"], kCTFontAttributeName,
                         nil];
            }
            
            [self.attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:[dic valueForKey:@"range"] attributes:attrs]];
        
        }else{
            
            //设置图片回调
            CTRunDelegateCallbacks callBack;
            memset(&callBack, 0, sizeof(CTRunDelegateCallbacks));
            callBack.version = kCTRunDelegateVersion1;
            callBack.getAscent = ascentCallBacks;
            callBack.getDescent = descentCallBacks;
            callBack.getWidth = widthCallBacks;
            
            CTRunDelegateRef delegate = CTRunDelegateCreate(&callBack, (__bridge void *)@{@"height":[dic objectForKey:@"height"],@"width":[dic objectForKey:@"width"],@"descent":[dic objectForKey:@"descent"]});
            
            unichar placeHolder = 0xFFFC;//空白字符
            NSString * placeHolderStr = [NSString stringWithCharacters:&placeHolder length:1];
            NSMutableAttributedString * placeHolderAttr = [[NSMutableAttributedString alloc] initWithString:placeHolderStr];
            CFAttributedStringSetAttribute((CFMutableAttributedStringRef)placeHolderAttr,  CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
            CFRelease(delegate);
            
            [self.attributeString appendAttributedString:placeHolderAttr];
            
            [self.picPropertyArray addObject:[dic objectForKey:@"imageName"]];
        }
        
       
    }
    
    NSMutableParagraphStyle *styleAlignment = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [styleAlignment setLineSpacing:self.lineSpace];
    [styleAlignment setAlignment:self.textAlignment];
    [styleAlignment setLineBreakMode:NSLineBreakByCharWrapping];
    NSDictionary *attr = [NSDictionary dictionaryWithObject:styleAlignment forKey:NSParagraphStyleAttributeName];
    [self.attributeString addAttributes:attr range:NSMakeRange(0, [self.attributeString length])];
}

#pragma mark - 设置block
- (void)setClickBlock:(clickBlock)block
{
    self.clickFunction = nil;
    self.clickFunction = [block copy];
}

//////////////
#pragma mark - 开始绘制操作
///////////////////////////////////////////
- (void)drawRect:(CGRect)rect {
    
    /*
     coreText 起初是为OSX设计的，而OSX得坐标原点是左下角，y轴正方向朝上。iOS中坐标原点是左上角，y轴正方向向下。
     若不进行坐标转换，则文字从下开始，还是倒着的
     */
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGMutablePathRef path = CGPathCreateMutable(); //1
    CGPathAddRect(path, NULL, rect);
    
    self.clickLength = 0;
    [self buildAttributeString];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributeString);
    
    //在画布中绘制出来
    self.coreTextFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, [self.attributeString length]), path, NULL);
    CTFrameDraw(self.coreTextFrame, context);
    
    //开始绘制图片
    NSArray * picFrameArray = [self getImageLocationFromCTFrame];
    
    NSInteger index = 0;
    for (NSValue * value in picFrameArray) {
        
        CGContextDrawImage(context, [value CGRectValue], [UIImage imageNamed:[self.picPropertyArray objectAtIndex:index]].CGImage);
        index += 1;
    }
    
    CFRelease(framesetter);
    CFRelease(path);
}

#pragma mark -点击处理
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self]; //屏幕坐标
    
    //检查是否点击到相关的图片
//    [self handleImgClick:touchPoint];
    
    //检查是否点击到相关可点击的文字
    [self handleTextClick:touchPoint];
}

//触发点击图片对应的事件
- (void)handleImgClick:(CGPoint)touchPoint
{
    NSArray * imgRectArray = [self getImageLocationFromCTFrame];
    
    CGRect imgFrame = CGRectZero;
    for (NSInteger index = 0 ; index < imgRectArray.count; index ++) {
        
        imgFrame = [[imgRectArray objectAtIndex:index] CGRectValue];
        if (CGRectContainsPoint(imgFrame, touchPoint)) {
            

        }
    }
}

//触发点击文字的事件
- (void)handleTextClick:(CGPoint)touchPoint
{
    CFArrayRef lines = CTFrameGetLines(self.coreTextFrame);
    CGPoint originsPointArrayOfLine[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(self.coreTextFrame, CFRangeMake(0, 0), originsPointArrayOfLine);
    
    CGPathRef path = CTFrameGetPath(self.coreTextFrame);
    CGRect rect = CGPathGetBoundingBox(path);
    CGPoint originPoint = CGPointZero;
    CGFloat ctY = 0.0f;
    CTLineRef findLine = NULL;
    CGPoint findOriginPoint = CGPointZero;
    for (int i = 0 ; i < CFArrayGetCount(lines); i ++) {
        
        //获取到的是CoreText坐标系统的位置
        originPoint = originsPointArrayOfLine[i];
        
        //将CoreText坐标系统坐标转化为屏幕坐标
        ctY = rect.origin.y + rect.size.height - originPoint.y;
        
        //判断点击位置属于ctframe中的那一行,并找到对应的行的原点位置
        if (touchPoint.y <= ctY && touchPoint.x >= self.frame.origin.x) {
            
            findLine = CFArrayGetValueAtIndex(lines, i);
            findOriginPoint = originPoint;
            break;
        }
    }
    
    //找到CTLine对应的CTRun的位置
    CGFloat xPostion = [self positionXOfSpecialStringAtLine:findLine originPoint:findOriginPoint];
    
    if (self.clickLength !=0 && xPostion != -1) {
        
        //判断点击的字符是否是需要处理的字符串
        if (touchPoint.x >= (xPostion + self.frame.origin.x) && touchPoint.x <= self.clickLength + (xPostion + self.frame.origin.x)) {
            
            self.clickFunction();
        }
    }
}

//获取到指定可点击文字的run的X
- (CGFloat)positionXOfSpecialStringAtLine:(CTLineRef)line originPoint:(CGPoint)originPoint
{
    //开始计算
    NSArray * runArray = (NSArray *)CTLineGetGlyphRuns(line);
    for (NSInteger runIndex = 0; runIndex < runArray.count; runIndex ++)
    {
        CTRunRef run = (__bridge CTRunRef)runArray[runIndex];
        
        NSDictionary * attrDic = (NSDictionary *)CTRunGetAttributes(run);
        NSString * clickTag  = [attrDic objectForKey:@"ClickArea"];
        if ([NSObject isValidateInitString:clickTag] && [clickTag isEqualToString:@"click"]) {
            
            //获取到相对于origin点的坐标
            const CGPoint * point =  CTRunGetPositionsPtr(run);
            CGFloat x = point->x + originPoint.x;
         
            return x;
        }
    }
    
    return -1;
}

#pragma mark - 获取图片在富文本中的位置
- (NSMutableArray *)getImageLocationFromCTFrame
{
    NSMutableArray * picRectArray = [NSMutableArray array];
    
    NSArray * linesArray = (NSArray *)CTFrameGetLines(self.coreTextFrame);//获取frame 中的line数
    CGPoint originPoints[linesArray.count];//每行原始点数组
    CTFrameGetLineOrigins(self.coreTextFrame, CFRangeMake(0, 0), originPoints);//获取原始点
    
    //开始计算
    CGRect actualRect = CGRectZero;
    NSArray * runArray = nil;
    for (NSInteger lineIndex = 0 ; lineIndex < linesArray.count; lineIndex ++)
    {
        
        //获取每行中的run数
        CTLineRef line = (__bridge CTLineRef)linesArray[lineIndex];
        runArray = (NSArray *)CTLineGetGlyphRuns(line);
        for (NSInteger runIndex = 0; runIndex < runArray.count; runIndex ++)
        {
            
            //判断run的属性中是否有delegate设置，如果设置了一般都是图片
            CTRunRef run = (__bridge CTRunRef)runArray[runIndex];
            
            NSDictionary * attrDic = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[attrDic objectForKey:(id)kCTRunDelegateAttributeName];
            
            if (delegate == NULL) {
                
                continue;
            }
            
            //判断内容字典是否存在，如果存在说明是图片
            NSDictionary * propertyDic = CTRunDelegateGetRefCon(delegate);
            if (![propertyDic isKindOfClass:[NSDictionary class]]) {
                
                continue;
            }
            
            //开始计算图片的位置
            CGPoint originPoint = originPoints[lineIndex];
            CGFloat ascent;
            CGFloat descent;
            CGRect runRect;//图片的大小位置
            
            runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runRect.size.height = ascent + descent;
            
            //获取run在line中的偏移量
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            
            runRect.origin.x = originPoint.x + xOffset;
            runRect.origin.y = originPoint.y - descent;
            
            //获取绘制区域
            CGPathRef path = CTFrameGetPath(self.coreTextFrame);
            CGRect colRect = CGPathGetBoundingBox(path);
            
            actualRect = CGRectOffset(runRect, colRect.origin.x, colRect.origin.y);//获取父系统坐标系中的位置
            
            [picRectArray addObject:[NSValue valueWithCGRect:actualRect]];
        }
    }
    
    return picRectArray;
}


#pragma mark - 设置图片顶部距离基线的距离
CGFloat ascentCallBacks(void *ref)
{
   return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"height"] floatValue];
}

#pragma mark - 设置图片底部与基线的距离
CGFloat descentCallBacks(void *ref)
{
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"descent"] floatValue];
}

#pragma mark - 图片宽度
static CGFloat widthCallBacks(void * ref)
{
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"width"] floatValue];
}


/////////////////////
#pragma mark - setter/getter
///////////////////////////////////

#pragma mark - picPropertyArray
- (NSMutableArray *)picPropertyArray
{
    if (!_picPropertyArray) {
        
        _picPropertyArray = [[NSMutableArray alloc]init];
    }
    return _picPropertyArray;
}
@end
