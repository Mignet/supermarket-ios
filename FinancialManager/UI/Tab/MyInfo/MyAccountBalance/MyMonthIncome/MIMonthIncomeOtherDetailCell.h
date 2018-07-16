//
//  MIMonthIncomeOtherDetailCell.h
//  FinancialManager
//
//  Created by ancye.Xie on 11/30/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MIMonthProfixItemMode, MIAccountBalanceDetailItemMode;

@protocol MIMonthIncomeOtherDetailCellDelegate <NSObject>

@optional
- (void)showExplain:(MIAccountBalanceDetailItemMode *)mode;

@end

@interface MIMonthIncomeOtherDetailCell : UITableViewCell

@property (nonatomic, assign) id<MIMonthIncomeOtherDetailCellDelegate> delegate;

- (void)showDatas:(MIMonthProfixItemMode *)params;

//资金明细
- (void)showAccountBalanceDetailDatas:(MIAccountBalanceDetailItemMode *)mode lastSepViewHeight:(float)fLastSepViewHeight;

@end
