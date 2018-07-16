//
//  MyInvestCell.m
//  FinancialManager
//
//  Created by xnkj on 29/06/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyInvestCell.h"

@interface MyInvestCell()

@property (nonatomic, weak) IBOutlet UIImageView * logoImageView;
@property (nonatomic, weak) IBOutlet UILabel     * investingMoneyLabel;
@property (nonatomic, weak) IBOutlet UILabel     * investProfitLabel;
@end

@implementation MyInvestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//更新内容
- (void)updateContentWithAgentLogo:(NSString *)logo investMoney:(NSString *)investMoney investProfit:(NSString *)investProfit
{
    NSString *urlString = [NSString stringWithFormat:@"%@?f=png", [_LOGIC getImagePathUrlWithBaseUrl:logo]];
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    
    self.investingMoneyLabel.text = investMoney;
    self.investProfitLabel.text = investProfit;
}

@end
