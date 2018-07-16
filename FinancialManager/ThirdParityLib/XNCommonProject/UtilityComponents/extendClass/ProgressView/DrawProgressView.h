//
//  DrawProgressView.h
//  XNCommonProject
//
//  Created by xnkj on 5/10/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AppType){
    CFGProgressType = 0,
    InvestProgressType,
};

@interface DrawProgressView : UIView

@property (nonatomic, strong) UIColor * progressValueColor;//滑动进度条的颜色值
@property (nonatomic, strong) UIImage * progressValueBgImage;//滑动块中的背景图片
@property (nonatomic, strong) UIColor * yearRateColor; //年化率的颜色值
@property (nonatomic, assign) BOOL      isSellOut;//是否售罄

- (instancetype)initWithFrame:(CGRect)frame andWithRadius:(CGFloat)radius;

//设置理财师相关信息
- (void)setProgressAnimationWithProgressValue:(CGFloat )progressValue yearRateStr:(NSString *)yearRateStr comissionStr:(NSString *)comissionStr isLimitRema:(BOOL)isLimitRema;

//设置金服相关信息
- (void)setProgressAnimationWithProgressValue:(CGFloat )progressValue yearRateStr:(NSString *)yearRateStr isLimitRema:(BOOL)isLimitRema;

//自定义进度条内部的内容
- (void)drawProgressViewWithProgressValue:(CGFloat )progressValue;

//开始动画
- (void)showProgressAnimation;
@end
