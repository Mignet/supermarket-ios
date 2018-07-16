//
//  TabBaseViewController.h
//  FinancialManager
//
//  Created by xnkj on 15/9/17.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Extend.h"

@interface TabBaseViewController : UIViewController

//开始刷新数据
- (void)switchToHomePageRefresh;
- (void)switchToManageFinancialRefresh;
- (void)switchToLeiCaiRefresh;
- (void)switchToCustomerServiceRefresh;
- (void)switchToMyInfoRefresh;

- (void)loginSuccessRfreshData;

//导航条上的入口
- (void)clickMessageRemind:(id)sender;
@end
