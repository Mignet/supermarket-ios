//
//  MIAccountBalanceCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 11/22/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "MIAccountBalanceCell.h"
#import "MIAccountBalanceProfixItemMode.h"

@interface MIAccountBalanceCell()

@property (nonatomic, weak) IBOutlet UILabel *incomeLabel;
@property (nonatomic, weak) IBOutlet UILabel *moneyLabel;

@end

@implementation MIAccountBalanceCell

#pragma mark - 展示数据
- (void)showDatas:(MIAccountBalanceProfixItemMode *)params
{
    self.incomeLabel.text = params.monthDesc;
    self.moneyLabel.text = params.totalAmount;
}

@end
