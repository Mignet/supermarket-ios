//
//  ReturnSwithView.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/20.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SwithView.h"

@interface SwithView ()

@end

@implementation SwithView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.lineView.mj_y = CGRectGetMaxY(self.customerBtn.frame);
    self.lineView.mj_h = 2.f;
    self.lineView.mj_w = self.customerBtn.mj_w;
}

+ (instancetype)returnSwithView
{
    SwithView *swithView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SwithView class]) owner:nil options:nil] firstObject];
    
    return swithView;
}

- (IBAction)btnClick:(UIButton *)sender
{
    if (sender == self.customerBtn) {
        if (self.lineView.frame.origin.x != self.customerBtn.frame.origin.x) {
            weakSelf(weakSelf);
            [UIView animateWithDuration:VIEWANIMATIONDURATION animations:^{
                weakSelf.lineView.mj_x = weakSelf.customerBtn.frame.origin.x;
            } completion:^(BOOL finished) {
            }];
        }
        
        if ([self.delegate respondsToSelector:@selector(swithViewDid:clickType:)]) {
            [self.delegate swithViewDid:self clickType:CUSTOMERTYPE];
        }
        
        
    } else if (sender == self.cfgBtn) {
    
        if (self.lineView.frame.origin.x != self.cfgBtn.frame.origin.x) {
            weakSelf(weakSelf);
            [UIView animateWithDuration:VIEWANIMATIONDURATION animations:^{
                weakSelf.lineView.mj_x = weakSelf.cfgBtn.frame.origin.x;
            } completion:^(BOOL finished) {
            }];
        }
        
        if ([self.delegate respondsToSelector:@selector(swithViewDid:clickType:)]) {
            [self.delegate swithViewDid:self clickType:CFGTYPE];
        }
    }
}



@end
