//
//  InsuranceKnowLedgeCell.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/26.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "InsuranceKnowLedgeCell.h"

@interface InsuranceKnowLedgeCell ()

@property (weak, nonatomic) IBOutlet UILabel *issueOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *issueTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *issueThreeLabel;

@end

@implementation InsuranceKnowLedgeCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self startAnimation];
}

- (void)startAnimation
{
    CAAnimation *one_animation = [self one_animation];
    CAAnimation *two_animation = [self two_animation];
    CAAnimation *three_animation = [self three_animation];
    
    // transform.rotation.y  position.x
    [self.issueOneLabel.layer addAnimation:one_animation forKey:@"position.x"];
    [self.issueTwoLabel.layer addAnimation:two_animation forKey:@"position.x"];
    [self.issueThreeLabel.layer addAnimation:three_animation forKey:@"position.x"];

}


/*
 * 向左
 */
- (CAAnimation *)one_animation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    
    CGFloat centerX = self.issueOneLabel.center.x;
    
    animation.fromValue = [NSNumber numberWithFloat:centerX - 6];
    animation.toValue                = [NSNumber numberWithFloat:centerX + 6]; // (-5, 0)
    animation.duration               = 1;
    animation.autoreverses           = YES;
    animation.repeatCount            = FLT_MAX;  //"forever"
    animation.removedOnCompletion    = NO;
    
    return animation;
}

- (CAAnimation *)two_animation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    
    CGFloat centerX = self.issueTwoLabel.center.x;
    
    animation.fromValue = [NSNumber numberWithFloat:centerX - 3];
    animation.toValue                = [NSNumber numberWithFloat:centerX + 3]; // (-5, 0)
    animation.duration               = 0.6;
    animation.autoreverses           = YES;
    animation.repeatCount            = FLT_MAX;  //"forever"
    
    animation.removedOnCompletion    = NO;
    
    return animation;
}

- (CAAnimation *)three_animation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    
    CGFloat centerX = self.issueThreeLabel.center.x;
    
    animation.fromValue = [NSNumber numberWithFloat:centerX - 7];
    animation.toValue                = [NSNumber numberWithFloat:centerX + 7]; // (-5, 0)
    animation.duration               = 1.3;
    animation.autoreverses           = YES;
    animation.repeatCount            = FLT_MAX;  //"forever"
    
    animation.removedOnCompletion    = NO;
    
    return animation;
}

- (IBAction)btnClick {
    
    if ([self.delegate respondsToSelector:@selector(insuranceKnowLedgeCellDid:)]) {
        [self.delegate insuranceKnowLedgeCellDid:self];
    }
}









@end
