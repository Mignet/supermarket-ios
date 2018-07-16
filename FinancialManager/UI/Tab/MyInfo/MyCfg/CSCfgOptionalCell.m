//
//  CSCustomerOptionalCell.m
//  FinancialManager
//
//  Created by xnkj on 6/22/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "CSCfgOptionalCell.h"

@interface CSCfgOptionalCell()

@property (nonatomic, weak) IBOutlet UILabel * unInvestCustomerLabel;
@property (nonatomic, weak) IBOutlet UILabel * caredCustomerLabel;
@end

@implementation CSCfgOptionalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//刷新信息
- (void)showUnInvestCustomer:(NSString *)unInvestCustomerCount careCustomer:(NSString *)caredCustomerCount
{
    self.unInvestCustomerLabel.text = [NSString stringWithFormat:@"未出单的直推理财师 (%@人)",unInvestCustomerCount];
    self.caredCustomerLabel.text = [NSString stringWithFormat:@"我关注的直推理财师 (%@人)",caredCustomerCount];
}

//手机通讯录
- (IBAction)clickMobileContact:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cfgListDidClickMobileContact)]) {
        
        [self.delegate cfgListDidClickMobileContact];
    }
}

//未投资客户
- (IBAction)clickInvestedCustomer:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cfgListDidClickUnInvestedCfg)]) {
        
        [self.delegate cfgListDidClickUnInvestedCfg];
    }
}

//我的关注客户
- (IBAction)clickUnInvestedCustomer:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cfgListDidClickCaredCfg)]) {
        
        [self.delegate cfgListDidClickCaredCfg];
    }
}
@end
