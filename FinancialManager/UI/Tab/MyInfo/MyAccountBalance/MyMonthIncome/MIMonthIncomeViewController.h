//
//  MonthIncomeViewController.h
//  FinancialManager
//
//  Created by ancye.Xie on 2/16/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"

@interface MIMonthIncomeViewController : BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)title month:(NSString *)month;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)title month:(NSString *)month profitType:(NSString *)profitTypeCode;

@end
