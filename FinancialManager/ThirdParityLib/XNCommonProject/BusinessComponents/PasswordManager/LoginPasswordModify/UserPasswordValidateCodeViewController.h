//
//  UserPasswordValidateCodeViewController.h
//  FinancialManager
//
//  Created by xnkj on 15/10/10.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPasswordValidateCodeViewController : BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil hideNavigationStatus:(BOOL)hideStatus;

@property (nonatomic, strong) NSString * phoneNumber;
@end
