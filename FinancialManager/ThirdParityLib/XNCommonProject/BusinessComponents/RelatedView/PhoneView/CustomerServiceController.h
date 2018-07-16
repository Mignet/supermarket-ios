//
//  CustomerServiceController.h
//  FinancialManager
//
//  Created by xnkj on 15/10/27.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"

@interface CustomerServiceController : BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil customerServer:(BOOL)customerServer phoneNumber:(NSString *)phoneNumber phoneTitle:(NSString *)phoneTitle;
@end
