//
//  CustomPopViewContainer.h
//  FinancialManager
//
//  Created by xnkj on 27/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomCouponPopView.h"
#import "CustomCouponRecordPopView.h"
#import "CustomDoubleElevenPopView.h"

@interface CustomPopViewContainer : NSObject

@property (nonatomic, strong) CustomCouponPopView * couponPopView;
@property (nonatomic, strong) CustomCouponRecordPopView * couponRecordPopView;
@property (nonatomic, strong) CustomDoubleElevenPopView * doubleElevenPopView;

//显示内容
- (void)showCouponPopViewInView:(UIViewController *)controller;
- (void)showCouponRecordPopViewInView:(UIViewController *)controller;
- (void)showDoubleElevenPopViewInView:(UIViewController *)controller;
@end
