//
//  CustomScrollLabel.m
//  FinancialManager
//
//  Created by ancyeXie on 16/11/14.
//  Copyright © 2016年 xiaoniu. All rights reserved.
//

#import "CustomScrollLabel.h"

#define DELAY_TITLE_IN_MIDDLE 3.0
#define DELAY_TITLE_IN_BOTTOM 0.0

@interface CustomScrollLabel ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) NSArray *urlsArray;
@property (nonatomic, assign) CGPoint topPosition;
@property (nonatomic, assign) CGPoint middlePosition;
@property (nonatomic, assign) CGPoint bottomPosition;

@property (nonatomic, assign) CGFloat fDelay; //延迟动画时间
@property (nonatomic, assign) NSInteger nCurrentIndex;
@property (nonatomic, assign) BOOL isStop; //是否停止
@property (nonatomic, assign) NSInteger nScrollDirection; //滚动方向

@property (nonatomic, assign) BOOL isShowUnderline;

@end

@implementation CustomScrollLabel

- (id)initWithFrame:(CGRect)frame isShowUnderline:(BOOL)isShowUnderline textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor textFont:(UIFont *)textFont scrollDirection:(NSInteger)nScrollDirection
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.nScrollDirection = nScrollDirection;
        self.isShowUnderline = isShowUnderline;
        [self initView:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor textFont:(UIFont *)textFont];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.isShowUnderline = YES;
        [self initView:NSTextAlignmentLeft textColor:UIColorFromHex(0x128df5) textFont:[UIFont systemFontOfSize:12]];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.nScrollDirection = ScrollDirectionTopType;
    self.isShowUnderline = NO;
}

//设置frame
- (void)setLabelFrame:(CGRect)frame
{
    self.frame = frame;
    
    [self initView:NSTextAlignmentLeft textColor:UIColorFromHex(0x4d585f) textFont:[UIFont systemFontOfSize:12]];
}

#pragma mark - 初始化
- (void)initView:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor textFont:(UIFont *)textFont
{
    self.isStop = NO;
    self.topPosition = CGPointMake(self.frame.size.width / 2 , self.frame.size.height * 3 / 2);
    self.middlePosition = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 );
    self.bottomPosition = CGPointMake(self.frame.size.width / 2, - self.frame.size.height / 2); /// 2 * 3);
    
    self.label = [[UILabel alloc] init];
    self.label.textColor = textColor;
    self.label.font = textFont;
    self.label.textAlignment = textAlignment;
    self.label.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.label.layer.position = self.middlePosition;
    

    [self addSubview:self.label];
    weakSelf(weakSelf)
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    self.clipsToBounds = YES; //保证文字不跑出视图
    self.fDelay = DELAY_TITLE_IN_MIDDLE; //第一次显示时间
    self.nCurrentIndex = 0;
}

#pragma mark - 显示标题
- (void)animationWithTitles:(NSArray *)titleArray urls:(NSArray *)urlArray
{
    self.titlesArray = titleArray;
    self.urlsArray = urlArray;
    
    if (self.isShowUnderline)
    {
        self.label.attributedText = [self addUnderlineToLabel:[titleArray objectAtIndex:0]];
    }
    else
    {
        self.label.attributedText = [NSString getAttributeStringWithAttributeArray:[titleArray objectAtIndex:0]];
    }
    
    if (self.titlesArray.count > 1)
    {
        //先取消之前的动画
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startAnimation) object:nil];
        
        [self performSelector:@selector(startAnimation) withObject:nil afterDelay:self.fDelay];
    }
    
}

#pragma mark - 开始动画
- (void)startAnimation
{
    weakSelf(weakSelf)
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
       if (weakSelf.nScrollDirection == ScrollDirectionTopType)
       {
           if ([weakSelf currentTitlePosition] == CustomTitlePositionMiddle)
           {
               weakSelf.label.layer.position = weakSelf.bottomPosition;
           }
           else if ([weakSelf currentTitlePosition] == CustomTitlePositionTop)
           {
               weakSelf.label.layer.position = weakSelf.middlePosition;
           }
       }
       else if (weakSelf.nScrollDirection == ScrollDirectionDownType)
       {
           if ([weakSelf currentTitlePosition] == CustomTitlePositionMiddle)
           {
               weakSelf.label.layer.position = weakSelf.topPosition;
           }
           else if ([weakSelf currentTitlePosition] == CustomTitlePositionBottom)
           {
               weakSelf.label.layer.position = weakSelf.middlePosition;
           }
       }
 
    } completion:^(BOOL finished) {
        
        if (weakSelf.nScrollDirection == ScrollDirectionTopType)
        {
            if ([weakSelf currentTitlePosition] == CustomTitlePositionBottom)
            {
                weakSelf.label.layer.position = weakSelf.topPosition;
                weakSelf.fDelay = DELAY_TITLE_IN_BOTTOM;
                weakSelf.nCurrentIndex ++;
                if (weakSelf.isShowUnderline)
                {
                    weakSelf.label.attributedText = [weakSelf addUnderlineToLabel:[weakSelf.titlesArray objectAtIndex:[weakSelf realCurrentIndex]]];
                }
                else
                {
                    weakSelf.label.attributedText = [NSString getAttributeStringWithAttributeArray:[weakSelf.titlesArray objectAtIndex:[weakSelf realCurrentIndex]]];
                }
            }
            else
            {
                weakSelf.fDelay = DELAY_TITLE_IN_MIDDLE;
            }
        }
        else if (weakSelf.nScrollDirection == ScrollDirectionDownType)
        {
            if ([weakSelf currentTitlePosition] == CustomTitlePositionTop)
            {
                weakSelf.label.layer.position = weakSelf.bottomPosition;
                weakSelf.fDelay = DELAY_TITLE_IN_BOTTOM;
                weakSelf.nCurrentIndex ++;
                if (weakSelf.isShowUnderline)
                {
                    weakSelf.label.attributedText = [weakSelf addUnderlineToLabel:[weakSelf.titlesArray objectAtIndex:[weakSelf realCurrentIndex]]];
                }
                else
                {
                    weakSelf.label.attributedText = [NSString getAttributeStringWithAttributeArray:[weakSelf.titlesArray objectAtIndex:[weakSelf realCurrentIndex]]];
                }
            }
            else
            {
                weakSelf.fDelay = DELAY_TITLE_IN_MIDDLE;
            }
        }

        if (!weakSelf.isStop)
        {
            [weakSelf performSelector:@selector(startAnimation) withObject:nil afterDelay:weakSelf.fDelay];
        }
        else
        {
            //停止动画后，要设置label位置和label显示内容
            weakSelf.label.layer.bounds = weakSelf.bounds;
            weakSelf.label.layer.position = weakSelf.middlePosition;
            if (weakSelf.isShowUnderline)
            {
                weakSelf.label.attributedText = [weakSelf addUnderlineToLabel:[weakSelf.titlesArray objectAtIndex:[weakSelf realCurrentIndex]]];
            }
            else
            {
                weakSelf.label.attributedText = [NSString getAttributeStringWithAttributeArray:[weakSelf.titlesArray objectAtIndex:[weakSelf realCurrentIndex]]];
                
            }
        }
    }];

}

#pragma mark - 增加下划线
- (NSMutableAttributedString *)addUnderlineToLabel:(NSString *)title
{
    //增加下划线
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange range = {0, titleString.length};
    [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
    return titleString;
}

#pragma mark - 停止动画
- (void)stopAnimation
{
    self.isStop = YES;
}

#pragma mark -
- (NSInteger)realCurrentIndex
{
    return self.nCurrentIndex % [self.titlesArray count];
}

#pragma mark - 当前位置
- (CustomTitlePosition)currentTitlePosition
{
    if (_label.layer.position.y == self.topPosition.y)
    {
        return CustomTitlePositionTop;
    }
    else if (_label.layer.position.y == self.middlePosition.y)
    {
        return CustomTitlePositionMiddle;
    }
    return CustomTitlePositionBottom;
}

#pragma mark - 开始点击
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(customScrollLabel:didSelectedAtIndex:didSelectedAtUrl:)]) {
        [self.delegate customScrollLabel:self didSelectedAtIndex:[self realCurrentIndex] didSelectedAtUrl:[self.urlsArray objectAtIndex:[self realCurrentIndex]]];
    }
}

///////////////////////////////////////////////
#pragma mark - setter/getter
/////////////////////////////////////////////

- (NSArray *)titlesArray
{
    if (!_titlesArray)
    {
        _titlesArray = [[NSArray alloc] init];
    }
    return _titlesArray;
}

- (NSArray *)urlsArray
{
    if (!_urlsArray)
    {
        _urlsArray = [[NSArray alloc] init];
    }
    return _urlsArray;
}


@end
