//
//  MIMonthIncomeDetailCell.h
//  FinancialManager
//
//  Created by ancye.Xie on 11/23/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MIMonthProfixItemMode;
@protocol MIMonthIncomeDetailCellDelegate <NSObject>

@optional
- (void)showExplain:(MIMonthProfixItemMode *)mode;

@end

@interface MIMonthIncomeDetailCell : UITableViewCell

@property (nonatomic, assign) id<MIMonthIncomeDetailCellDelegate> delegate;

- (void)showDatas:(MIMonthProfixItemMode *)params;

@end
