//
//  CSCustomerCell.m
//  FinancialManager
//
//  Created by xnkj on 15/9/21.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "RedPacketCustomerCell.h"

#import "UIView+CornerRadius.h"
#import "UIImageView+WebCache.h"

#import "XNCSMyCustomerItemMode.h"

#import "XNCommonModule.h"
#import "XNConfigMode.h"

@interface RedPacketCustomerCell()

@property (nonatomic, strong) UILabel            * descLabel;

@property (nonatomic, weak) IBOutlet UIImageView * statusImageView;
@property (nonatomic, weak) IBOutlet UIImageView * userHeaderImageView;
@property (nonatomic, weak) IBOutlet UILabel * customerNameLabel;
@property (nonatomic, weak) IBOutlet UILabel * customPhoneLabel;
@property (nonatomic, weak) IBOutlet UILabel * recentInverstMoneyLabel;
@property (nonatomic, weak) IBOutlet UILabel * investingMoneyLabel;
@property (nonatomic, weak) IBOutlet UILabel * investCountLabel;
@property (nonatomic, weak) IBOutlet UILabel * regTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel * investEndLabel;
@property (nonatomic, weak) IBOutlet UIImageView * improtantCustomerImageView;

@property (nonatomic, weak) IBOutlet UILabel * bottomLineLabel;

@property (nonatomic, strong) UIView * freshFalgView;
@property (nonatomic, strong) UIView * sysFlagView;
@end

@implementation RedPacketCustomerCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}


////////////////////////////
#pragma mark - Custom Method
//////////////////////////////////////////

#pragma mark - 更新内容
- (void)updateContent:(XNCSMyCustomerItemMode *)params
{
    [self.improtantCustomerImageView setHidden:YES];
    if (params.importantCustomer) {
        
        [self.improtantCustomerImageView setHidden:NO];
    }
    
    if ([params.freeCustomer isEqualToString:@"1"]) {
        
        self.descLabel = [[UILabel alloc]init];
        [self.descLabel setFont:[UIFont systemFontOfSize:8]];
        [self.descLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self.descLabel setText:@"自由客户"];
        [self.contentView addSubview:self.descLabel];
        
        __weak UILabel * tmpProductNameLabel = self.customPhoneLabel;
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpProductNameLabel.mas_trailing).offset(6);
            make.top.mas_equalTo(tmpProductNameLabel.mas_top).offset(1);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(15);
        }];
        
        [self.descLabel setTextColor:UIColorFromHex(0xef4a3b)];
        [self.descLabel drawRoundCornerWithRectSize:CGSizeMake(50, 15) backgroundColor:[UIColor clearColor] borderWidth:0.5 borderColor:UIColorFromHex(0xef4a3b) radio:2];
    }
    
    NSString * imageUrl = [_LOGIC getImagePathUrlWithBaseUrl:params.image];
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"CS_ER_expireRedee_defaultHeaderImage"]];
    [self.userHeaderImageView.layer setCornerRadius:20];
    [self.userHeaderImageView.layer setMasksToBounds:YES];
    
    [self.customerNameLabel setText:params.customerName];
    [self.customPhoneLabel setText:params.customerMobile];
    [self.recentInverstMoneyLabel setText:[NSObject isValidateInitString:params.nearInvestAmount]?[NSString stringWithFormat:@"最近投资: %.2f元",[params.nearInvestAmount floatValue]]:@"最近无投资"];
    [self.investingMoneyLabel setText:[NSObject isValidateInitString:params.totalInvestAmount]?[NSString stringWithFormat:@"累计投资: %.2f元",[params.totalInvestAmount floatValue]]:@"累计投资:0.00"];
    [self.investCountLabel setText:[NSString stringWithFormat:@"投资笔数: %@",[NSObject isValidateInitString:params.totalInvestCount]?params.totalInvestCount:@"0"]];
    [self.regTimeLabel setText:[NSObject isValidateInitString:params.registerTime]?[NSString stringWithFormat:@"%@注册",params.registerTime]:@"未注册"];
    [self.investEndLabel setText:[NSObject isValidateInitString:params.nearEndDate]?[NSString stringWithFormat:@"%@有投资到期",params.nearEndDate]:@""];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(RedPacketCustomerCell:didSelectedAtIndexPath:)]) {
        
        [self.delegate RedPacketCustomerCell:self didSelectedAtIndexPath:self.indexPath];
    }
}

@end
