//
//  BrandPromotionImageShareView.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/28.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "BrandPromotionImageShareView.h"

@interface BrandPromotionImageShareView ()

@property (weak, nonatomic) IBOutlet UIButton *friend_btn;

@property (weak, nonatomic) IBOutlet UIButton *circle_btn;

@end

@implementation BrandPromotionImageShareView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor =  [[UIColor whiteColor] colorWithAlphaComponent:0.7];
}

+ (instancetype)brandPromotionImageShareView
{
    BrandPromotionImageShareView *shareView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BrandPromotionImageShareView class]) owner:nil options:nil] firstObject];
    shareView.frame = CGRectMake(0.f, SCREEN_FRAME.size.height, SCREEN_FRAME.size.width, 0.f);
    return shareView;
}

- (void)show
{
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0.f, SCREEN_FRAME.size.height - 219.f, SCREEN_FRAME.size.width, 110.f);
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0.f, SCREEN_FRAME.size.height, SCREEN_FRAME.size.width, 0.f);
    }];
}


- (IBAction)btnClick:(UIButton *)sender
{
    if (sender == self.friend_btn) {
        
        if ([self.delegate respondsToSelector:@selector(brandPromotionImageShareViewDid:withShareType:)]) {
            [self.delegate brandPromotionImageShareViewDid:self withShareType:Brand_Promotion_Image_Share_WeCat_Friend];
        }
    }
    
    if (sender == self.circle_btn) {
        
        if ([self.delegate respondsToSelector:@selector(brandPromotionImageShareViewDid:withShareType:)]) {
            [self.delegate brandPromotionImageShareViewDid:self withShareType:Brand_Promotion_Image_Share_WeCat_Circle];
        }
    }
    
}




@end
