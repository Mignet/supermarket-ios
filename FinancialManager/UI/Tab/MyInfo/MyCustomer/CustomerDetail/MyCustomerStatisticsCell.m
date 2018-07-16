//
//  MyCustomerStatisticsCell.m
//  FinancialManager
//
//  Created by xnkj on 18/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyCustomerStatisticsCell.h"
#import "XNCSCustomerDetailMode.h"
#import "XNCSCfgDetailMode.h"

@interface MyCustomerStatisticsCell()

@property (nonatomic, weak) IBOutlet UILabel     * investingMoneyLabel;
@property (nonatomic, weak) IBOutlet UILabel     * monthProfitLabel;
@property (nonatomic, weak) IBOutlet UILabel     * monthInvestMoneyLabel;
@property (nonatomic, weak) IBOutlet UILabel     * launchAppLabel;
@property (nonatomic, weak) IBOutlet UILabel     * totalProfitLabel;
@property (nonatomic, weak) IBOutlet UILabel     * totalInvestLabel;
@property (nonatomic, weak) IBOutlet UILabel     * firstInvestTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel     * registerTimeLabel;

@property (nonatomic, weak) IBOutlet UIImageView * directionImageView;
@end

@implementation MyCustomerStatisticsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//刷新数据
- (void)refreshData:(XNCSCustomerDetailMode *)mode
{
    self.investingMoneyLabel.text = mode.currInvestAmt;
    self.monthProfitLabel.text = mode.thisMonthProfit;
    self.monthInvestMoneyLabel.text = mode.thisMonthInvestAmt;
    self.launchAppLabel.text = mode.loginTime;
    self.totalProfitLabel.text = mode.totalProfit;
    self.totalInvestLabel.text = mode.totalInvestAmt;
    self.firstInvestTimeLabel.text = mode.firstInvestTime;
    self.registerTimeLabel.text = mode.registTime;
}

//刷新理财师数据
- (void)refreshDataForCfg:(XNCSCfgDetailMode *)mode
{
    self.investingMoneyLabel.text = mode.currInvestAmt;
    self.monthProfitLabel.text = mode.thisMonthProfit;
    self.monthInvestMoneyLabel.text = mode.thisMonthIssueAmt;
    self.launchAppLabel.text = mode.loginTime;
    self.totalProfitLabel.text = mode.totalProfit;
    self.totalInvestLabel.text = mode.totalIssueAmt;
    self.firstInvestTimeLabel.text = mode.firstInvestTime;
    self.registerTimeLabel.text = mode.registTime;
}

//扩展操作
- (IBAction)clickExpandOperation:(id)sender
{
    
    if (self.expandBlock) {
        
        self.expandBlock(!self.expandStatus);
    }
}

//设置扩展处理
- (void)setClickExpandOperation:(ExpandOperation)block
{
    if (block) {
        
        self.expandBlock = block;
    }
}

- (void)refreshCellWithExpandStatus:(BOOL)status
{
    self.expandStatus = status;
    
    if (self.expandStatus) {
        
        [self.directionImageView setImage:[UIImage imageNamed:@"XN_Customer_up_icon.png"]];
    }else
    {
        [self.directionImageView setImage:[UIImage imageNamed:@"XN_Customer_down_icon.png"]];
    }
}
@end
