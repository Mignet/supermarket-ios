//
//  InvestClassifyCell.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/28.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "InvestClassifyCell.h"

@interface InvestClassifyCell ()



@end

@implementation InvestClassifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.loansBtn.selected = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.lineView.mj_h = 3.f;
    self.lineView.mj_y = self.mj_h - 10.f;
    self.lineView.width = 80.f;
    
    [self.loansBtn layoutIfNeeded];
    
    self.lineView.mj_x = self.loansBtn.selected ? (self.loansBtn.width - self.lineView.width) / 2 + 10.f : ((self.loansBtn.width - self.lineView.mj_w) / 2 + SCREEN_FRAME.size.width / 2 + 10.f);

}

- (IBAction)btnClick:(UIButton *)sender
{
    if (sender == self.loansBtn) {
        
        if (self.loansBtn.selected == NO) {
            
            self.loansBtn.selected = !self.loansBtn.selected;
            self.insuranceBtn.selected = !self.loansBtn.selected;
            [UIView animateWithDuration:0.35 animations:^{
                self.lineView.mj_x = (self.loansBtn.width - self.lineView.mj_w) / 2 + 10.f;
            }];

            if ([self.delegate respondsToSelector:@selector(investClassifyCellDid:clickType:)]) {
                [self.delegate investClassifyCellDid:self clickType:Invest_Classify_Cell_Loans];
            }
            
        }
        
    } else if (sender == self.insuranceBtn) {
        
        if (self.insuranceBtn.selected == NO) {
            
            self.insuranceBtn.selected = !self.insuranceBtn.selected;
            self.loansBtn.selected = !self.insuranceBtn.selected;
            
            [UIView animateWithDuration:0.35 animations:^{
                self.lineView.mj_x = (self.insuranceBtn.width - self.lineView.mj_w) / 2 + SCREEN_FRAME.size.width / 2 + 10.f;
            }];
            
            if ([self.delegate respondsToSelector:@selector(investClassifyCellDid:clickType:)]) {
                [self.delegate investClassifyCellDid:self clickType:Invest_Classify_Cell_Insurance];
            }
        }
    }

}



@end
