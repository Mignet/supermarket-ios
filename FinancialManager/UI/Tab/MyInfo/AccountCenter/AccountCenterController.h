//
//  AccountCenterController.h
//  FinancialManager
//
//  Created by xnkj on 15/9/21.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, AccountCenterType){
    
    RankType = 0, // 级职特权
    AvatarType, //头像
    MobileType,
    RealnameAuthenticationType, //实名认证
    BankCardManagerType,
    PasswordManagerType,
    MoreType,
    ServicePhoneType, //客服电话
    ExitType,
    PersonSetIMax
};

@interface AccountCenterController : BaseViewController

/**
 * 初始化
 * params nibNameOrNil
 * params nibBundleOrNil
 * params levelName (经理，见习生)
 **/
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil levelName:(NSString *)levelName;

@end
