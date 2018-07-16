//
//  CustomPopView.m
//  FinancialManager
//
//  Created by xnkj on 27/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "CustomCouponRecordPopView.h"

@interface CustomCouponRecordPopView()

@property (nonatomic, weak) IBOutlet UIImageView * headerImageView;
@property (nonatomic, weak) IBOutlet UILabel     * titleLabel;
@property (nonatomic, weak) IBOutlet UILabel     * subTitleLabel;
@end

@implementation CustomCouponRecordPopView

//通用的弹出提示
- (void)initImageName:(NSString *)imageName titleName:(NSString *)title subTitleName:(NSString *)subTitle
{
    [self.headerImageView setImage:[UIImage imageNamed:imageName]];
    self.titleLabel.text = title;
    self.subTitleLabel.text = subTitle;
}

//设置取消block
- (void)setClickCancelBlock:(CancelCouponRecordBlock)block
{
    if (block) {
        
        self.cancelBlock = block;
    }
}

//完成的操作
- (void)setOperationFinishedBlock:(FinishedCouponRecordBlock)block
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
    if (self.cancelBlock) {
        
        self.cancelBlock();
    }
    
    [self removeFromSuperview];
    
    if (self.finishedBlock)
        self.finishedBlock();
}

@end
