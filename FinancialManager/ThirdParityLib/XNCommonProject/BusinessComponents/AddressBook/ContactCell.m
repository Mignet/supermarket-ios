//
//  ContactCell.m
//  FinancialManager
//
//  Created by xnkj on 15/12/22.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "ContactCell.h"

@interface ContactCell()

@property (nonatomic, weak) IBOutlet UIImageView * statusImageView;
@property (nonatomic, weak) IBOutlet UILabel     * nameLabel;
@property (nonatomic, weak) IBOutlet UILabel     * telLabel;
@property (nonatomic, weak) IBOutlet UILabel *recommendLabel;

@end

@implementation ContactCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 更新名字
- (void)refreshName:(NSString *)name tel:(NSString *)phoneNumber
{
    [self.nameLabel setText:name];
    [self.telLabel setText:phoneNumber];
}

#pragma mark - 更新状态
- (void)updateStatus:(BOOL)status
{
    if (status)
    {
        [self.statusImageView setImage:[UIImage imageNamed:@"XN_Invite_Checked_blue.png"]];
        return;
    }
    [self.statusImageView setImage:[UIImage imageNamed:@"XN_Home_Invite_unChecked.png"]];
}

#pragma mark - 显示已推荐
- (void)showRecommendLabel:(BOOL)flag
{
    self.recommendLabel.hidden = !flag;
}

@end
