//
//  MIMonthIncomeDetailListViewController.h
//  FinancialManager
//
//  Created by ancye.Xie on 11/24/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"

@class MIMonthProfixItemMode, MIAccountBalanceCommonMode;
@protocol MIMonthIncomeDetailListViewControllerDelegate <NSObject>

@optional
- (void)showExplain:(MIMonthProfixItemMode *)mode;

@end

@interface MIMonthIncomeDetailListViewController : BaseViewController

@property (nonatomic, assign) id<MIMonthIncomeDetailListViewControllerDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil profitType:(NSInteger)profitType;

- (void)reloadList:(NSArray *)datasList monthProfitDetailListMode:(MIAccountBalanceCommonMode *)listMode;

@end
