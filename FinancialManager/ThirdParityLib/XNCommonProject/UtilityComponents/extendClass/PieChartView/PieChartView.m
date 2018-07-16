//
//  PieChartView.m
//  FinancialManager
//
//  Created by ancye.Xie on 11/23/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "PieChartView.h"
#import "PieChartModel.h"

@interface PieChartView()<CAAnimationDelegate>

@property (nonatomic, strong) CAShapeLayer *bgCircleLayer;
@property (nonatomic, strong) UIBezierPath *circlePath;
@property (nonatomic, strong) CAShapeLayer *percentLayer;

@property (nonatomic, assign) CGFloat fStrokeWidth;
@property (nonatomic, strong) UIColor *percentColor;
@property (nonatomic, strong) NSArray *percentArray;
@property (nonatomic, strong) NSMutableArray *layerArray;
@property (nonatomic, assign) BOOL isAnimation;

@end

@implementation PieChartView

- (id)initWithFrame:(CGRect)frame withStrokeWidth:(CGFloat)width bgColor:(UIColor *)color percentArray:(NSArray *)perArray isAnimation:(BOOL)animation
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _fStrokeWidth = width;
        _percentColor = color;
        self.percentArray = perArray;
        _isAnimation = animation;
        
        CGPoint centrePoint = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        CGFloat radius = frame.size.height / 2;
//        _circlePath = [UIBezierPath bezierPathWithArcCenter:centrePoint radius:radius startAngle:M_PI_2 * 3 endAngle:-M_PI_2 clockwise:NO];
        _circlePath = [UIBezierPath bezierPathWithArcCenter:centrePoint radius:radius startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
        
        [self initView];
        
    }
    return self;
}

#pragma mark - 初始化视图
- (void)initView
{
    _bgCircleLayer = [CAShapeLayer layer];
    _bgCircleLayer.path = _circlePath.CGPath;
    _bgCircleLayer.strokeColor = _percentColor.CGColor;
    _bgCircleLayer.fillColor = [UIColor clearColor].CGColor;
    _bgCircleLayer.lineWidth = _fStrokeWidth;
    [self.layer addSublayer:_bgCircleLayer];
    
    [self buildPercentLayer];
}

#pragma mark - 分布布局
- (void)buildPercentLayer
{
    CGFloat fStartPercent = 0;
    for (PieChartModel *model in self.percentArray)
    {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = _circlePath.CGPath;
        layer.strokeColor = [model.color CGColor];
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.lineWidth = _fStrokeWidth;
        layer.strokeStart = fStartPercent;
        layer.strokeEnd = fStartPercent + model.fpercent;
        [self.layer addSublayer:layer];
        [self.layerArray addObject:layer];
        
        fStartPercent += model.fpercent;
        if (_isAnimation)
        {
            [self percentAnimationLayer:layer];
        }
    }
}

#pragma mark - 动画
- (void)percentAnimationLayer:(CAShapeLayer *)layer
{
    CABasicAnimation *strokeEndAnimation = nil;
    strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.duration = 1.0f;
    strokeEndAnimation.fromValue = @(layer.strokeStart);
    strokeEndAnimation.toValue = @(layer.strokeEnd);
    strokeEndAnimation.autoreverses = NO;
    strokeEndAnimation.delegate = self;
    [layer addAnimation:strokeEndAnimation forKey:@"strokeEnd"];
}

#pragma mark - 动画结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
}

///////////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

#pragma mark - percentArray
- (NSArray *)percentArray
{
    if (!_percentArray)
    {
        _percentArray = [[NSArray alloc] init];
    }
    return _percentArray;
}

#pragma mark - layerArray
- (NSMutableArray *)layerArray
{
    if (!_layerArray)
    {
        _layerArray = [[NSMutableArray alloc] init];
    }
    return _layerArray;
}


@end
