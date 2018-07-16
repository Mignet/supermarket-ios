//
//  MFSystemInvitedEmptyCell.m
//  FinancialManager
//
//  Created by xnkj on 15/11/13.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "MFSystemInvitedEmptyCell.h"

@interface MFSystemInvitedEmptyCell()

@property (nonatomic, weak) IBOutlet UIImageView *errorImageView;
@property (nonatomic, weak) IBOutlet UILabel * titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *button;

@property (nonatomic, copy) buttonBlock buttonBlock;

@end

@implementation MFSystemInvitedEmptyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 更新标题
- (void)refreshTitle:(NSString *)title
{
    self.button.hidden = YES;
    [self.titleLabel setText:title];
}

- (void)refreshTitle:(NSString *)title imageView:(NSString *)imageString
{
    self.titleLabel.text = title;
    self.errorImageView.image = [UIImage imageNamed:imageString];
    self.button.hidden = YES;
}

- (void)refreshTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle
{
    self.titleLabel.text = title;
    
    self.button.hidden = YES;
    
    if (buttonTitle.length > 0)
    {
        self.button.hidden = NO;
        [self.button setTitle:buttonTitle forState:UIControlStateNormal];
    }
}

- (void)setButtonClick:(buttonBlock)buttonBlock
{
    self.buttonBlock = nil;
    self.buttonBlock = [buttonBlock copy];
}

- (IBAction)buttonClick:(id)sender
{
    if (self.buttonBlock)
    {
        self.buttonBlock();
    }
}

@end
