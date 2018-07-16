//
//  MFSystemInvitedEmptyCell.m
//  FinancialManager
//
//  Created by xnkj on 15/11/13.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "MFProductListEmptyCell.h"

@interface MFProductListEmptyCell()

@property (nonatomic, weak) IBOutlet UILabel * titleLabel;
@end

@implementation MFProductListEmptyCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 更新标题
- (void)refreshTitle:(NSString *)title
{
//    [self.titleLabel setText:title];
}

@end
