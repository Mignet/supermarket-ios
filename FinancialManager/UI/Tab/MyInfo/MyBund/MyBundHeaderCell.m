//
//  MyBundHeaderCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/21/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyBundHeaderCell.h"
#import "XNMyBundHoldingStatisticMode.h"

@interface MyBundHeaderCell ()

@property (nonatomic, weak) IBOutlet UILabel *yesterdayEarningsLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalInvestingLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalEarningsLabel;

@end

@implementation MyBundHeaderCell

- (void)showDatas:(XNMyBundHoldingStatisticMode *)mode isAbnormalStatus:(BOOL)isAbnormalStatus
{
    if (isAbnormalStatus && mode == nil)
    {
        self.yesterdayEarningsLabel.text = @"--";
        self.totalInvestingLabel.text = @"--";
        self.totalEarningsLabel.text = @"--";
    }
    
    if (mode == nil)
    {
        return;
    }
    self.yesterdayEarningsLabel.text = mode.profitLossDaily;
    self.totalInvestingLabel.text = mode.currentAmount;
    self.totalEarningsLabel.text = mode.profitLoss;
}

- (IBAction)buttonClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(MyBundHeaderCellDidClick:)])
    {
        [self.delegate MyBundHeaderCellDidClick:btn.tag];
    }
    
}

@end
