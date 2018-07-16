//
//  MyBundCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/21/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyBundCell.h"
#import "XNMyBundHoldingDetailMode.h"

@interface MyBundCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *investingLabel;
@property (nonatomic, weak) IBOutlet UILabel *yesterdayEarningLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalEarningLabel;

@end

@implementation MyBundCell

- (void)showDatas:(XNMyBundHoldingDetailMode *)mode
{
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@", mode.fundName, mode.fundCode];
    self.investingLabel.text = mode.currentValue;
    self.yesterdayEarningLabel.text = mode.previousProfitNLoss;
    self.totalEarningLabel.text = mode.profitNLoss;
    
}

@end
