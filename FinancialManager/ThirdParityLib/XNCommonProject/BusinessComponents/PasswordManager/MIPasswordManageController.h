//
//  MIPasswordManageController.h
//  FinancialManager
//
//  Created by xnkj on 15/9/22.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, PasswordOperationType){
    
    ChangeLoginPasswordType,
    ChangeTradePasswordType,
    ChangeGesturePasswordType,
    ChangeFingerPasswordType,
    iMaxType = 4
};

@interface MIPasswordManageController : BaseViewController

@end
