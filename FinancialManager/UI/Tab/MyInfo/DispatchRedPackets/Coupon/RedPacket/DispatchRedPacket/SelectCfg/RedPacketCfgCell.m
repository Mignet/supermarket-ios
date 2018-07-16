//
//  CSCustomerCell.m
//  FinancialManager
//
//  Created by xnkj on 15/9/21.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "RedPacketCfgCell.h"

#import "UIView+CornerRadius.h"
#import "UIImageView+WebCache.h"

#import "XNCSCfgItemMode.h"

#import "XNCommonModule.h"
#import "XNConfigMode.h"

@interface RedPacketCfgCell()

@property (nonatomic, strong) UILabel            * descLabel;

@property (nonatomic, weak) IBOutlet UIImageView * statusImageView;
@property (nonatomic, weak) IBOutlet UIImageView * userHeaderImageView;
@property (nonatomic, weak) IBOutlet UILabel * customerNameLabel;
@property (nonatomic, weak) IBOutlet UILabel * customPhoneLabel;
@property (nonatomic, weak) IBOutlet UILabel * regTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel * cfgCountLabel;
@property (nonatomic, weak) IBOutlet UILabel * bottomLineLabel;

@property (nonatomic, strong) UIView * freshFalgView;
@property (nonatomic, strong) UIView * sysFlagView;
@end

@implementation RedPacketCfgCell

- (void)awakeFromNib {
    // Initeialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

////////////////////////////
#pragma mark - Custom Method
//////////////////////////////////////////

#pragma mark - 更新内容
- (void)updateContent:(XNCSCfgItemMode *)params
{
    NSString * imageUrl = [_LOGIC getImagePathUrlWithBaseUrl:params.headImage];
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    [self.userHeaderImageView.layer setCornerRadius:20];
    [self.userHeaderImageView.layer setMasksToBounds:YES];
    
    [self.customerNameLabel setText:params.userName];
    [self.customPhoneLabel setText:params.mobile];
    [self.regTimeLabel setText:[NSObject isValidateInitString:params.registTime]?[NSString stringWithFormat:@"%@",params.registTime]:@"未注册"];
    [self.cfgCountLabel setText:[NSString stringWithFormat:@"直推理财师%@人",params.teamMemberCount]];
}

#pragma mark - 设置隐藏
- (void)setBottomHiden:(BOOL)hide
{
    [self.bottomLineLabel setHidden:hide];
}

#pragma mark - 更新状态
- (void)updateStatus:(BOOL)selected
{
    [self.statusImageView setImage:[UIImage imageNamed:selected?@"XN_Home_Invite_Checked_blue.png":@"XN_Home_Invite_unChecked.png"]];
}

#pragma mark - 选中操作
- (IBAction)clickSelectOperation:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(RedPacketCfgCell:didSelectedAtIndexPath:)]) {
        
        [self.delegate RedPacketCfgCell:self didSelectedAtIndexPath:self.indexPath];
    }
}

//跳转理财师详情
- (IBAction)clickCfgDetail:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(RedPacketCfgCell:didClickDetailAtIndexPath:)]) {
        
        [self.delegate RedPacketCfgCell:self didClickDetailAtIndexPath:self.indexPath];
    }
}

@end
