//
//  UIViewController+Extend.h
//  FinancialManager
//
//  Created by xnkj on 15/10/10.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController(Extend)

@property (nonatomic, assign) BOOL customNavigationBarHide;//当前导航条是否隐藏
@property (nonatomic, strong) UIView * snaptView;//截图信息
@property (nonatomic, strong) UIColor * newNavigationBarColor;
@property (nonatomic, strong) UIColor * newNavigationTitleColor;
@property (nonatomic, assign) BOOL navigationSeperatorLineStatus;
@property (nonatomic, assign) BOOL needNewSwitchViewAnimation;//是否需要切换动画
@property (nonatomic, assign) BOOL switchToHomePage;//是否需要跳转到首页，对于推送、网页跳转本地页面、本地页面web登录等操作是不需要跳转到首页的。
@property (nonatomic, strong) NSString * wraperClassName;//包裹的类的名字
@end
