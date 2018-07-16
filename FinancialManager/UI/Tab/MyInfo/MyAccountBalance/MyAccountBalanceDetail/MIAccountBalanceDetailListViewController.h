//
//  MIAccountBalanceDetailListViewController.h
//  FinancialManager
//
//  Created by ancye.Xie on 2/14/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"

@class MIAccountBalanceDetailItemMode, MIAccountBalanceCommonMode;
@protocol MIAccountBalanceDetailListViewControllerDelegate <NSObject>

@optional
- (void)showExplain:(MIAccountBalanceDetailItemMode *)mode;

@end

@interface MIAccountBalanceDetailListViewController : BaseViewController

@property (nonatomic, assign) id<MIAccountBalanceDetailListViewControllerDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(NSString *)type;

- (void)reloadList:(NSArray *)datasList monthProfitDetailListMode:(MIAccountBalanceCommonMode *)listMode;

@end
