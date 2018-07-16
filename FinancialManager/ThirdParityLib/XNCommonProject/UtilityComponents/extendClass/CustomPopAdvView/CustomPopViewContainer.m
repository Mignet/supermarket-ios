//
//  CustomPopViewContainer.m
//  FinancialManager
//
//  Created by xnkj on 27/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "CustomPopViewContainer.h"

@implementation CustomPopViewContainer

- (id)init
{
    self = [super init];
    if (self) {
        
        self.couponPopView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomCouponPopView class]) owner:nil options:nil] firstObject];
        [self.couponPopView setFrame:SCREEN_FRAME];
        [self.couponPopView setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.5]];
        
        self.couponRecordPopView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomCouponRecordPopView class]) owner:nil options:nil] firstObject];
        [self.couponRecordPopView setFrame:SCREEN_FRAME];
        [self.couponRecordPopView setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.5]];
        
        self.doubleElevenPopView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomDoubleElevenPopView class]) owner:nil options:nil] firstObject];
        [self.doubleElevenPopView setFrame:SCREEN_FRAME];
        [self.doubleElevenPopView setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.5]];
    }
    
    return self;
}

//显示佣金券弹出框
- (void)showCouponPopViewInView:(UIViewController *)controller
{
    if (controller)
    {
        [controller.view addSubview:self.couponPopView];
    }
    else
    {
        [_KEYWINDOW addSubview:self.couponPopView];
    }
}

//显示佣金记录弹出框
- (void)showCouponRecordPopViewInView:(UIViewController *)controller
{
    if (controller)
    {
        [controller.view addSubview:self.couponRecordPopView];
    }
    else
    {
        [_KEYWINDOW addSubview:self.couponRecordPopView];
    }
}

//显示双十一弹出框
- (void)showDoubleElevenPopViewInView:(UIViewController *)controller
{
    if (controller)
    {
        [controller.view addSubview:self.doubleElevenPopView];
    }
    else
    {
        [_KEYWINDOW addSubview:self.doubleElevenPopView];
    }
}
@end
