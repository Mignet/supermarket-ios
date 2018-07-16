//
//  CustomPopView.m
//  FinancialManager
//
//  Created by xnkj on 27/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "CustomDoubleElevenPopView.h"

@interface CustomDoubleElevenPopView()

@end

@implementation CustomDoubleElevenPopView

//设置详情block
- (void)setClickActivityDetailBlock:(ActivityDetailBlock)block
{
    if (block) {
        
        self.detailBlock = block;
    }
}

//设置取消block
- (void)setClickActivityCancelBlock:(ActivityCancelBlock)block
{
    if (block) {
        
        self.cancelBlock = block;
    }
}

//完成的操作
- (void)setOperationFinishedBlock:(FinishedBlock)block
{
    if (block) {
        
        self.finishedBlock = block;
    }
}

//取消操作
- (IBAction)cancelClick:(UIButton *)btn
{
    if (self.cancelBlock) {
        
        self.cancelBlock();
    }
    
    weakSelf(weakSelf)
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0;
        CGRect originRect = weakSelf.frame;
        originRect.origin.y = SCREEN_FRAME.size.height;
        weakSelf.frame = originRect;
    } completion:^(BOOL finished) {
        if (finished)
        {
            weakSelf.alpha = 1;
          
            CGRect originRect = weakSelf.frame;
            originRect.origin.y = 0;
            weakSelf.frame = originRect;
            
            weakSelf.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5];
            
            [weakSelf removeFromSuperview];
            
            if (weakSelf.finishedBlock)
                weakSelf.finishedBlock();
        }
    }];
}

//详情
- (IBAction)clickDetail:(id)sender
{
    if (self.detailBlock) {
        
        self.detailBlock();
    }
    
    [self removeFromSuperview];
    
    if (self.finishedBlock)
        self.finishedBlock();
}

@end
