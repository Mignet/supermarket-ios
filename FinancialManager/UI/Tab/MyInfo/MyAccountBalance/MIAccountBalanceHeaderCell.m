//
//  MIAccountBalanceHeaderCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 11/22/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "MIAccountBalanceHeaderCell.h"
#import "MIAccountBalanceMode.h"

#define PIECHART_SIZE 52.0f
@interface MIAccountBalanceHeaderCell ()

@property (nonatomic, weak) IBOutlet UILabel *accountBalanceLabel; //账户余额
@property (nonatomic, weak) IBOutlet UIButton *withdrawalRecordButton;

@end

@implementation MIAccountBalanceHeaderCell

#pragma mark - 展示数据
- (void)showDatas:(MIAccountBalanceMode *)params
{
    _accountBalanceLabel.text = params.accountBalance;
    //iphone5以下屏幕大小
    if (IS_SHOTIPHONE_SCREEN())
    {
        _accountBalanceLabel.font = [UIFont systemFontOfSize:26.0f];
    }
    self.withdrawalRecordButton.layer.borderWidth = 1;
    self.withdrawalRecordButton.layer.borderColor = JFZ_COLOR_BLUE.CGColor;
}

#pragma mark - 猎财余额说明
- (IBAction)accountExplainClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(accountExplain)])
    {
        [self.delegate accountExplain];
    }
}

#pragma mark - 资金明细
- (IBAction)accountBalanceDetailClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(accountBalanceDetail)])
    {
        [self.delegate accountBalanceDetail];
    }
}

#pragma mark - 提现
- (IBAction)withdrawalClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(withdrawDeposit)])
    {
        [self.delegate withdrawDeposit];
    }
}

#pragma mark - 提现记录
- (IBAction)withdrawalRecordClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(withdrawDepositRecord)])
    {
        [self.delegate withdrawDepositRecord];
    }
}

@end
