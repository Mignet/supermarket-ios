//
//  CustomPopView.m
//  FinancialManager
//
//  Created by xnkj on 27/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "CustomCouponPopView.h"

@interface CustomCouponPopView()

@property (nonatomic, weak) IBOutlet UILabel     * titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView * headerImageView;
@end

@implementation CustomCouponPopView

//通用的弹出提示
- (void)initImage:(NSString *)imageName titleName:(NSString *)title CouponType:(CouponPopType)type;
{
    self.titleLabel.text = title;
    self.headerImageView.image = [UIImage imageNamed:imageName];
    self.type = type;
}

//设置详情block
- (void)setClickDetailBlock:(DetailBlock)block
{
    if (block) {
        
        self.detailBlock = block;
    }
}

//设置取消block
- (void)setClickCancelBlock:(CancelBlock)block
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
        
        self.cancelBlock(self.type);
    }
    
    weakSelf(weakSelf)
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.alpha = 0;
        
        CGRect originRect = weakSelf.frame;
        originRect.origin.y = SCREEN_FRAME.size.height;
        weakSelf.frame = originRect;
        
        weakSelf.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.0];
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
        
        self.detailBlock(self.type);
    }
    
    [self removeFromSuperview];
    
    if (self.finishedBlock)
        self.finishedBlock();
}

@end
