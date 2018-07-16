//
//  MIAccountBalanceHeaderCell.h
//  FinancialManager
//
//  Created by ancye.Xie on 11/22/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MIAccountBalanceHeaderCellDelegate <NSObject>

@optional

//猎财账户说明
- (void)accountExplain;

//资金明细
- (void)accountBalanceDetail;

//提现
- (void)withdrawDeposit;
//提现记录
- (void)withdrawDepositRecord;

@end

@class MIAccountBalanceMode;
@interface MIAccountBalanceHeaderCell : UITableViewCell

@property (nonatomic, assign) id<MIAccountBalanceHeaderCellDelegate> delegate;

- (void)showDatas:(MIAccountBalanceMode *)params;

@end
