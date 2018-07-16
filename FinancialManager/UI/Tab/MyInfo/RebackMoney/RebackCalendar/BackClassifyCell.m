//
//  BackClassifyCell.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/28.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "BackClassifyCell.h"

@interface BackClassifyCell ()

@end

@implementation BackClassifyCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.yetBtn.selected = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.lineView.mj_h = 3.f;
    self.lineView.mj_y = self.mj_h - 10.f;
    self.lineView.width = 80.f;
    
    [self.yetBtn layoutIfNeeded];
    
    self.lineView.mj_x = self.yetBtn.selected ? (self.yetBtn.width - self.lineView.width) / 2 + 10.f : ((self.yetBtn.width - self.lineView.mj_w) / 2 + SCREEN_FRAME.size.width / 2 + 10.f);
}

- (IBAction)btnClick:(UIButton *)sender
{
    if (sender == self.yetBtn) {
        
        if (self.yetBtn.selected == NO) {
            
            self.yetBtn.selected = !self.yetBtn.selected;
            self.waitBtn.selected = !self.yetBtn.selected;
            [UIView animateWithDuration:0.35 animations:^{
                self.lineView.mj_x = (self.yetBtn.width - self.lineView.mj_w) / 2 + 10.f;
            }];
            
            if ([self.delegate respondsToSelector:@selector(backClassifyCellDid:clickType:)]) {
                [self.delegate backClassifyCellDid:self clickType:Back_Classify_Yet_Click];
            }
            
        }

    } else if (sender == self.waitBtn) {
        
        if (self.waitBtn.selected == NO) {
            
            self.waitBtn.selected = !self.waitBtn.selected;
            self.yetBtn.selected = !self.waitBtn.selected;
            
            [UIView animateWithDuration:0.35 animations:^{
                self.lineView.mj_x = (self.yetBtn.width - self.lineView.mj_w) / 2 + SCREEN_FRAME.size.width / 2 + 10.f;
            }];
            
            
            
            if ([self.delegate respondsToSelector:@selector(backClassifyCellDid:clickType:)]) {
                [self.delegate backClassifyCellDid:self clickType:Back_Classify_Wait_Click];
            }

        }
    }
    
}



@end
