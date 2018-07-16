//
//  CSCustomerOptionalCell.m
//  FinancialManager
//
//  Created by xnkj on 6/22/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "CSCustomerOptionalCell.h"

@interface CSCustomerOptionalCell()

@property (nonatomic, weak) IBOutlet UILabel * unInvestCustomerLabel;
@property (nonatomic, weak) IBOutlet UILabel * caredCustomerLabel;
@end

@implementation CSCustomerOptionalCell

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
    self.unInvestCustomerLabel.text = [NSString stringWithFormat:@"未投资客户 (%@人)",unInvestCustomerCount];
    self.caredCustomerLabel.text = [NSString stringWithFormat:@"我关注的客户 (%@人)",caredCustomerCount];
}

//手机通讯录
- (IBAction)clickMobileContact:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customerListDidClickMobileContact)]) {
        
        [self.delegate customerListDidClickMobileContact];
    }
}

//未投资客户
- (IBAction)clickUnInvestedCustomer:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customerListDidClickUnInvestedCustomer)]) {
        
        [self.delegate customerListDidClickUnInvestedCustomer];
    }
}

//关注的客户
- (IBAction)clickCaredCustomer:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customerListDidClickCaredCustomer)]) {
        
        [self.delegate customerListDidClickCaredCustomer];
    }
}
@end
