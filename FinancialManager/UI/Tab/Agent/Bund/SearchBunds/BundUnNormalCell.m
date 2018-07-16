//
//  MFSystemInvitedEmptyCell.m
//  FinancialManager
//
//  Created by xnkj on 15/11/13.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "BundUnNormalCell.h"

@interface BundUnNormalCell()

@property (nonatomic, weak) IBOutlet UILabel * titleLabel;
@property (nonatomic, weak) IBOutlet UILabel * subTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView * iconImageView;
@end

@implementation BundUnNormalCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark - 更新标题
- (void)refreshTitle:(NSString *)title
{
//    [self.titleLabel setText:title];
}
@end
