//
//  AccountBookInvestCell.m
//  FinancialManager
//
//  Created by xnkj on 18/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "AccountBookInvestCell.h"

@interface AccountBookInvestCell()

@property (nonatomic, weak) IBOutlet UILabel * titleNameLabel;
@property (nonatomic, weak) IBOutlet UILabel * investMoneyLabel;
@property (nonatomic, weak) IBOutlet UILabel * investProfitLabel;
@end

@implementation AccountBookInvestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//刷新内容
- (void)refreshWithTitleName:(NSString *)titleName investMoney:(NSString *)investMoney investProfit:(NSString *)investProfit
{
    self.titleNameLabel.text = titleName;
    self.investMoneyLabel.text = investMoney;
    self.investProfitLabel.text = investProfit;
}
@end
