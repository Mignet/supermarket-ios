//
//  MIPullListCell.m
//  FinancialManager
//
//  Created by xnkj on 15/9/22.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "MIPullListCell.h"

@interface MIPullListCell()

@property (nonatomic, weak) IBOutlet UILabel     * titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView * statusImageView;
@end

@implementation MIPullListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 更新内容
- (void)updateTitle:(NSString *)title Status:(BOOL)selected
{
    [self.titleLabel setText:title];
    [self.statusImageView setHidden:selected];
    [self.titleLabel setTextColor:!selected?MONEYCOLOR:UIColorFromHex(0x323232)];
}

#pragma mark - 更新状态
- (void)setStatus:(BOOL)selected
{
    [self.statusImageView setHidden:!selected];
    [self.titleLabel setBackgroundColor:selected?MONEYCOLOR:UIColorFromHex(0x323232)];
}

@end
