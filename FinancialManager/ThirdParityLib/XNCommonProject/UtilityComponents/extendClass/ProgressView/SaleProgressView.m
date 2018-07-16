//
//  SaleProgressView.m
//  FinancialManager
//
//  Created by xnkj on 10/02/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "SaleProgressView.h"

@interface SaleProgressView()

@property (nonatomic, copy) operationBlock block;

@property (nonatomic, strong) UIButton      *  operationButton;
@property (nonatomic, strong) CAShapeLayer * progressLayer;
@property (nonatomic, strong) CAShapeLayer * backgroundLayer;
@end

@implementation SaleProgressView

#pragma mark - cycle life

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.layer addSublayer:self.progressLayer];
        
        [self addSubview:self.operationButton];
        
        weakSelf(weakSelf)
        [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.equalTo(weakSelf);
        }];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        [self.layer addSublayer:self.progressLayer];
        
        weakSelf(weakSelf)
        [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakSelf);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    
    [self.layer addSublayer:self.backgroundLayer];
    [self.layer addSublayer:self.progressLayer];
     
    [self addSubview:self.operationButton];
     
     weakSelf(weakSelf)
     [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf);
    }];
}

#pragma mark - 自定义方法

/**
 * 显示产品购买进度
 *
 * params value 进度值
 * params imageName 图片名
 *
 **/
- (void)showSaleProgressWithProgressValue:(CGFloat )value
                      backgroundImageName:(NSString *)imageName
{
    self.progressLayer.strokeStart = 0.0f;
    self.progressLayer.strokeEnd = value;
    
    if (imageName) {
        
        [self.operationButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }else
    {
        self.operationButton.backgroundColor = UIColor.whiteColor;
    }
    
    
    [self percentAnimationLayer:self.progressLayer];
}

/**
 * 操作按钮回调设置
 *
 * params block 回调处理
 *
 **/
- (void)clickOperationCompletation:(operationBlock )block
{
    if (self.block) {
        
        self.block = nil;
    }
    
    self.block = [block copy];
}

//开始动画
- (void)percentAnimationLayer:(CAShapeLayer *)layer
{
    [layer removeAllAnimations];
    
    CABasicAnimation *strokeEndAnimation = nil;
    strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.duration = 1.0f;
    strokeEndAnimation.fromValue = @(layer.strokeStart);
    strokeEndAnimation.toValue = @(layer.strokeEnd);
    strokeEndAnimation.autoreverses = NO;
    [layer addAnimation:strokeEndAnimation forKey:@"strokeEnd"];
}

//相关按钮操作
- (void)operationClicked
{
    if (self.block) {
        
        self.block();
    }
}

#pragma mark - setter/getter

//progressLayer
- (CAShapeLayer *)progressLayer
{
    if (!_progressLayer) {
        
        _progressLayer = [[CAShapeLayer alloc]init];
        [_progressLayer setPath:[[UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:self.frame.size.width / 2 startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES] CGPath]];
        
        _progressLayer.frame = CGRectMake(0, 0, self.frame.size.width , self.frame.size.height);
        _progressLayer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        _progressLayer.fillColor = [UIColor whiteColor].CGColor;
        _progressLayer.lineWidth = 2;
        _progressLayer.strokeColor = (UIColorFromHex(0x4e8cef)).CGColor;
    }
    
    return _progressLayer;
}

//backgroundLayer
- (CAShapeLayer *)backgroundLayer
{
    if (!_backgroundLayer) {
        
        _backgroundLayer = [[CAShapeLayer alloc]init];
        [_backgroundLayer setPath:[[UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:self.frame.size.width / 2 startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES] CGPath]];
        
        _backgroundLayer.frame = CGRectMake(0, 0, self.frame.size.width , self.frame.size.height);
        _backgroundLayer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        _backgroundLayer.fillColor = [UIColor whiteColor].CGColor;
        _backgroundLayer.lineWidth = 3;
        _backgroundLayer.strokeColor = UIColorFromHex(0xdedede).CGColor;
        
        _backgroundLayer.strokeStart = 0.0f;
        _backgroundLayer.strokeEnd = 1;

    }
    
    return _backgroundLayer;
}

//titleLabel
- (UIButton *)operationButton
{
    if (!_operationButton) {
        
        _operationButton = [[UIButton alloc]initWithFrame:self.frame];
        [_operationButton addTarget:self action:@selector(operationClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operationButton;
}

@end
