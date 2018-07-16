//
//  RecommendMemberCell.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/14.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "RecommendMemberCell.h"
#import "XNCSCfgItemMode.h"
#import "XNCSMyCustomerItemMode.h"

@interface RecommendMemberCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *idImageView;


@end

@implementation RecommendMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setCfgItem:(XNCSCfgItemMode *)cfgItem
{
    _cfgItem = cfgItem;
    
    NSString * imageUrl = [_LOGIC getImagePathUrlWithBaseUrl:cfgItem.headImage];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    [self.iconImageView.layer setCornerRadius:21];
    [self.iconImageView.layer setMasksToBounds:YES];
    
    [self.nameLabel setText:cfgItem.userName];
    [self.phoneLabel setText:cfgItem.mobile];

}

- (void)setCustomerItem:(XNCSMyCustomerItemMode *)customerItem
{
    _customerItem = customerItem;

    NSString * imageUrl = [_LOGIC getImagePathUrlWithBaseUrl:customerItem.image];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"CS_ER_expireRedee_defaultHeaderImage"]];
    [self.iconImageView.layer setCornerRadius:20];
    [self.iconImageView.layer setMasksToBounds:YES];
    
    [self.nameLabel setText:customerItem.customerName];
    [self.phoneLabel setText:customerItem.customerMobile];
    
}

#pragma mark - 更新状态
- (void)updateStatus:(BOOL)status
{
    if (status)
    {
        [self.idImageView setImage:[UIImage imageNamed:@"recommendMember_sele.png"]];
        return;
    }
    [self.idImageView setImage:[UIImage imageNamed:@"recommendMember_nor.png"]];
}




@end
