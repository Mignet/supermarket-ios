//
//  DrawProgressView.m
//  XNCommonProject
//
//  Created by xnkj on 5/10/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

#import "DrawProgressView.h"
#import "UILabel+Extend.h"

#define DEGREES_TO_RADIANS(degrees) ((3.1415926 * degrees)/ 180)

@interface DrawProgressView()

@property (nonatomic, assign) NSInteger      currentIndex;
@property (nonatomic, assign) NSInteger        angle;
@property (nonatomic, assign) CGFloat        radius;
@property (nonatomic, assign) CGFloat        progressValue;
@property (nonatomic, assign) BOOL           isLimitRema;

@property (nonatomic, strong) NSString     * yearRateStr;
@property (nonatomic, strong) NSString     * comissionStr;

@property (nonatomic, strong) UILabel      * progressValueLabel;
@property (nonatomic, strong) UIView       * progressValueView;
@property (nonatomic, strong) UILabel      * expectTitleLabel;
@property (nonatomic, strong) UILabel      * expectValueLabel;
@property (nonatomic, strong) UILabel      * comissionTitleLabel;
@property (nonatomic, strong) UIView       * contentContainerView;

@property (nonatomic, strong) NSTimer      * timer;
@property (nonatomic, strong) NSArray      * movePointArray;

@property (nonatomic, strong) UIBezierPath * bezierPath;
@property (nonatomic, strong) CAShapeLayer * shaperLayer;
@property (nonatomic, strong) CAShapeLayer * bgShaperLayer;
@end

@implementation DrawProgressView

- (instancetype)initWithFrame:(CGRect)frame andWithRadius:(CGFloat)radius
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.radius = radius;
        self.isLimitRema = NO;
        self.progressValueColor = UIColorFromHex(0xfe4747);
        self.progressValueBgImage = [UIImage imageNamed:@"XN_FinancialManager_Product_Detail_progress_icon.png"];
        self.yearRateColor = UIColorFromHex(0xef4a3c);
        self.isSellOut = NO;
        
        [self.layer addSublayer:self.bgShaperLayer];
    }
    return self;
}

////////////////////
#pragma mark - Custom Method
////////////////////////////

#pragma mark - 进度条创建
- (void)drawProgressViewWithProgressValue:(CGFloat )progressValue
{
    self.progressValue = progressValue > 100?100:progressValue;
    self.angle = (int)((3.6 * progressValue) > 360?360:(3.6 * progressValue));
    
    self.movePointArray = [self caculateArcPointWithDegress:self.angle];

    [self.layer addSublayer:self.shaperLayer];
    [self addSubview:self.progressValueView];
}

#pragma mark - 理财师进度条
- (void)setProgressAnimationWithProgressValue:(CGFloat )progressValue yearRateStr:(NSString *)yearRateStr comissionStr:(NSString *)comissionStr isLimitRema:(BOOL)isLimitRema
{
    self.isLimitRema = isLimitRema;
    self.yearRateStr = yearRateStr;
    self.comissionStr = comissionStr;
    
    //有额度才有进度
    [self.contentContainerView addSubview:self.expectValueLabel];
    [self.contentContainerView addSubview:self.expectTitleLabel];
    [self.contentContainerView addSubview:self.comissionTitleLabel];
    [self addSubview:self.contentContainerView];
    
    weakSelf(weakSelf)
    __weak UIView * tmpContainerView = self.contentContainerView;
    [self.expectValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpContainerView.mas_leading);
        make.bottom.mas_equalTo(tmpContainerView.mas_centerY).offset(15);
        make.trailing.mas_equalTo(tmpContainerView.mas_trailing);
        make.height.mas_equalTo(@(50));
    }];
    
    __weak UILabel * tmpExpectValueLabel = self.expectValueLabel;
    [self.expectTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpContainerView.mas_leading);
        make.bottom.mas_equalTo(tmpExpectValueLabel.mas_top).offset(-16);
        make.trailing.mas_equalTo(tmpContainerView.mas_trailing);
        make.height.mas_equalTo(@(16));
    }];
    
    [self.comissionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpContainerView.mas_leading);
        make.top.mas_equalTo(tmpExpectValueLabel.mas_bottom).offset(38);
        make.trailing.mas_equalTo(tmpContainerView.mas_trailing);
        make.height.mas_equalTo(@(21));
    }];
    
    [self.contentContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(weakSelf);
        make.height.mas_equalTo(@(132));
        make.width.mas_equalTo(weakSelf.size.width);
    }];
    
    if (self.isLimitRema) {
    
        [self drawProgressViewWithProgressValue:progressValue];
    }else
    {
        self.bgShaperLayer.strokeColor = self.progressValueColor.CGColor;
    }
}

#pragma mark - 金服进度条
- (void)setProgressAnimationWithProgressValue:(CGFloat )progressValue yearRateStr:(NSString *)yearRateStr isLimitRema:(BOOL)isLimitRema
{
    self.isLimitRema = isLimitRema;
    self.yearRateStr = yearRateStr;
    
    [self.contentContainerView addSubview:self.expectTitleLabel];
    [self.contentContainerView addSubview:self.expectValueLabel];
    [self addSubview:self.contentContainerView];
    
    weakSelf(weakSelf)
    __weak UIView * tmpContainerView = self.contentContainerView;
    [self.expectValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpContainerView.mas_leading);
        make.centerY.mas_equalTo(tmpContainerView);
        make.trailing.mas_equalTo(tmpContainerView.mas_trailing);
        make.height.mas_equalTo(@(50));
    }];

    __weak UILabel * tmpExpectTitleLabel = self.expectValueLabel;
    [self.expectTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpContainerView.mas_leading);
        make.bottom.mas_equalTo(tmpExpectTitleLabel.mas_top).offset(- 16);
        make.trailing.mas_equalTo(tmpContainerView.mas_trailing);
        make.height.mas_equalTo(@(16));
    }];
    
    
    [self.contentContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(weakSelf);
        make.height.mas_equalTo(@(132));
        make.width.mas_equalTo(weakSelf.size.width);
    }];

    
    //有额度才有进度
    if (self.isLimitRema) {
        
        [self drawProgressViewWithProgressValue:progressValue];
    }else
    {
        //无额度则显示背景图片为进度条颜色
        self.bgShaperLayer.strokeColor = self.progressValueColor.CGColor;
    }
}

#pragma mark - 开始动画
- (void)showProgressAnimation
{
    if (!self.isSellOut && self.isLimitRema) {
        
        CGPoint point = [[self.movePointArray objectAtIndex:0] CGPointValue];
        
        self.bezierPath = NULL;
        self.shaperLayer.path = NULL;
        [self.bezierPath moveToPoint:point];
        self.shaperLayer.path = self.bezierPath.CGPath;
        
        weakSelf(weakSelf)
        [self.progressValueView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(weakSelf.mas_leading).offset(point.x - 10);
            make.top.mas_equalTo(weakSelf.mas_top).offset(point.y - 10);
            make.width.mas_equalTo(22);
            make.height.mas_equalTo(22);
        }];

        
       self.currentIndex = 1;
       [self.timer setFireDate:[NSDate distantPast]];
    }
}

#pragma mark - 计算坐标点
- (CGPoint)calcCircleCoordinateWithCenter:(CGPoint)center andWithAngle:(CGFloat)angle andWithRadius:(CGFloat) radius
{
    CGFloat x2 = radius*cosf((angle)*M_PI/180);
    CGFloat y2 = radius*sinf((angle)*M_PI/180);
    
    return CGPointMake(center.x+x2, center.y-y2);
}

- (NSArray *)caculateArcPointWithDegress:(CGFloat )degress
{
    NSMutableArray * pointMutaArray = [NSMutableArray array];
    
    CGFloat tmpDegress = degress - 90 >= 0? 0:90 - degress;
    CGFloat leftDegress = degress - (degress - 90> 0?90:degress);
    
    CGPoint  point;
    for (int i = 90 ; i >= tmpDegress; i = (i -5 < 0?tmpDegress:i - 5)) {
        
        point = [self calcCircleCoordinateWithCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) andWithAngle:i andWithRadius:self.radius];
        [pointMutaArray addObject:[NSValue valueWithCGPoint:point]];
        
        if (i == tmpDegress)
            break;
    }
    
    if (leftDegress > 0) {
        
        for (int i = 0; i <= leftDegress; i = (i + 5 > leftDegress? leftDegress:i + 5)) {
            
            point =  [self calcCircleCoordinateWithCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) andWithAngle:(- i) andWithRadius:self.radius];
            [pointMutaArray addObject:[NSValue valueWithCGPoint:point]];
            
            if (i == leftDegress)
                break;
        }
    }
    
    return pointMutaArray;
}

#pragma mark - 动画效果
- (void)animation
{
    if (self.currentIndex < self.movePointArray.count) {
        
        CGPoint point = [[self.movePointArray objectAtIndex:self.currentIndex ++] CGPointValue];
        
        [self.bezierPath addLineToPoint:point];
        self.shaperLayer.path = self.bezierPath.CGPath;
        
        weakSelf(weakSelf)
        [self.progressValueView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(weakSelf.mas_leading).offset(point.x - 10);
            make.top.mas_equalTo(weakSelf.mas_top).offset(point.y - 10);
        }];
        
        [self layoutIfNeeded];
    }else
    {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

////////////////////////////
#pragma mark - setter/getter
/////////////////////////////////////////

#pragma mark - timer
- (NSTimer *)timer
{
    if (!_timer) {
        
        _timer = [NSTimer timerWithTimeInterval:0.01f
                                         target:self
                                       selector:@selector(animation)
                                       userInfo:nil
                                        repeats:YES];

        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    
    return _timer;
}

#pragma mark - imageView
- (UIView *)progressValueView
{
    if (!_progressValueView) {
        
        _progressValueView = [[UIView alloc]init];
        
        UIImageView * bgImageView = [[UIImageView alloc]initWithImage:self.progressValueBgImage];
        [_progressValueView addSubview:bgImageView];
        
        __weak UIView * tmpView = _progressValueView;
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(tmpView);
        }];
        
        self.progressValueLabel = [[UILabel alloc]init];
        [self.progressValueLabel setTextAlignment:NSTextAlignmentCenter];
        [self.progressValueLabel setTextColor:[UIColor whiteColor]];
        [self.progressValueLabel setFont:[UIFont systemFontOfSize:8]];
        [self.progressValueLabel setText:[NSString stringWithFormat:@"%@%@",[NSNumber numberWithFloat:self.progressValue],@"%"]];
        [_progressValueView addSubview:self.progressValueLabel];
        
        [self.progressValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(tmpView);
        }];
    }
    return _progressValueView;
}

#pragma mark - bezierPath
- (UIBezierPath *)bezierPath
{
    if (!_bezierPath) {
        
        _bezierPath = [UIBezierPath bezierPath];
    }
    return _bezierPath;
}

#pragma mark - shaperLayer
- (CAShapeLayer *)shaperLayer
{
    if (!_shaperLayer) {
        
        _shaperLayer = [[CAShapeLayer alloc]init];
        
        _shaperLayer.frame = CGRectMake(0, 0, self.frame.size.width , self.frame.size.height);
        _shaperLayer.position = CGPointMake( self.frame.size.width / 2, self.frame.size.height / 2);
        _shaperLayer.fillColor = [UIColor clearColor].CGColor;
        _shaperLayer.lineWidth = 3;
        _shaperLayer.strokeColor = self.isSellOut?(UIColorFromHex(0xdcdcdc)).CGColor:self.progressValueColor.CGColor;
    }
    return _shaperLayer;
}

#pragma mark - bgShaperLayer
- (CAShapeLayer *)bgShaperLayer
{
    if (!_bgShaperLayer) {
        
        UIBezierPath * bizerPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:self.radius startAngle:0 endAngle:DEGREES_TO_RADIANS(360) clockwise:YES];
        
        _bgShaperLayer = [CAShapeLayer layer];
        _bgShaperLayer.frame = CGRectMake(0, 0, self.frame.size.width , self.frame.size.height);
        _bgShaperLayer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        _bgShaperLayer.fillColor = [UIColor clearColor].CGColor;
        _bgShaperLayer.lineWidth = 3;
        _bgShaperLayer.strokeColor = (UIColorFromHex(0xdcdcdc)).CGColor;
        _bgShaperLayer.path = bizerPath.CGPath;
    }
    return _bgShaperLayer;
}

#pragma mark - expectTitleLabel
- (UILabel *)expectTitleLabel
{
    if (!_expectTitleLabel) {
        
        _expectTitleLabel = [[UILabel alloc]init];
        [_expectTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [_expectTitleLabel setFont:[UIFont systemFontOfSize:15]];
        [_expectTitleLabel setTextColor:self.isSellOut?UIColorFromHex(0xDCDCDC):UIColorFromHex(0x969696)];
        [_expectTitleLabel setText:@"年化收益"];
    }
    return _expectTitleLabel;
}

#pragma mark - expectValueLabel
- (UILabel *)expectValueLabel
{
    if (!_expectValueLabel) {
        
        _expectValueLabel = [[UILabel alloc]init];
        [_expectValueLabel setTextAlignment:NSTextAlignmentCenter];
        [_expectValueLabel setTextColor:self.isSellOut?UIColorFromHex(0xDCDCDC):self.yearRateColor];
        [_expectValueLabel setText:self.yearRateStr];
        if ([[self.yearRateStr componentsSeparatedByString:@"~"] count] >= 2) {
            
            NSArray * arr_Property = @[@{@"range": self.yearRateStr,
                                         @"color": self.isSellOut?UIColorFromHex(0xDCDCDC):self.yearRateColor,
                                         @"font": [UIFont systemFontOfSize:(40.0 / 667) * SCREEN_FRAME.size.height]},
                                       @{@"range": @"%",
                                         @"color": self.isSellOut?UIColorFromHex(0xDCDCDC):self.yearRateColor,
                                         @"font": [UIFont systemFontOfSize:(30.0 / 667) * SCREEN_FRAME.size.height]}];
            
            [self.expectValueLabel refreshPropertyArray:arr_Property Alignment:NSTextAlignmentCenter];
        }else
        {
            NSArray * arr_Property = @[@{@"range": self.yearRateStr,
                                         @"color": self.isSellOut?UIColorFromHex(0xDCDCDC):self.yearRateColor,
                                         @"font": [UIFont systemFontOfSize:(60.0 / 667) * SCREEN_FRAME.size.height]},
                                       @{@"range": @"%",
                                         @"color": self.isSellOut?UIColorFromHex(0xDCDCDC):self.yearRateColor,
                                         @"font": [UIFont systemFontOfSize:(30.0 / 667) * SCREEN_FRAME.size.height]}];
            
            [self.expectValueLabel refreshPropertyArray:arr_Property Alignment:NSTextAlignmentCenter];
        }
    }
    return _expectValueLabel;
}

#pragma mark - comissionTitleLabel
- (UILabel *)comissionTitleLabel
{
    if (!_comissionTitleLabel) {
        
        _comissionTitleLabel = [[UILabel alloc]init];
        [_comissionTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [_comissionTitleLabel setTextColor:self.isSellOut?UIColorFromHex(0xDCDCDC):UIColorFromHex(0x969696)];
        
        [_comissionTitleLabel setText:[NSString stringWithFormat:@"佣金 %@%@",self.comissionStr,@"%"]];
    }
    return _comissionTitleLabel;
}

#pragma mark - contentContainerView
- (UIView *)contentContainerView
{
    if (!_contentContainerView) {
        
        _contentContainerView = [[UIView alloc]init];
        [_contentContainerView setBackgroundColor:[UIColor clearColor]];
    }
    return _contentContainerView;
}

@end

