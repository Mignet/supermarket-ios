//
//  MIMonthIncomeOtherDetailCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 11/30/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "MIMonthIncomeOtherDetailCell.h"

#import "MIMonthProfixItemMode.h"
#import "MIAccountBalanceDetailItemMode.h"

@interface MIMonthIncomeOtherDetailCell ()

@property (nonatomic, weak) IBOutlet UIView *topView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleDescLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *moneyLabel;

@property (nonatomic, weak) IBOutlet UIView *sepView;
@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UILabel *buyProductLabel;
@property (nonatomic, weak) IBOutlet UILabel *descLabel;

@property (nonatomic, weak) IBOutlet UIImageView *explainImageView;
@property (nonatomic, weak) IBOutlet UIButton *explainButton;

@property (nonatomic, strong) MIMonthProfixItemMode *mode;
@property (nonatomic, strong) MIAccountBalanceDetailItemMode *accountDetailItemMode;

@end

@implementation MIMonthIncomeOtherDetailCell

- (void)showDatas:(MIMonthProfixItemMode *)params
{
    self.explainImageView.hidden = YES;
    self.explainButton.hidden = YES;
    __weak UIView *weakBottomView = self.bottomView;
    [self.buyProductLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakBottomView.mas_top).offset(10);
        make.left.mas_equalTo(weakBottomView.mas_left).offset(12);
        make.right.mas_equalTo(weakBottomView.mas_right);
    }];
    
    weakSelf(weakSelf)
    __weak UIView *weakTopView = self.topView;
    __weak UIView *weakSepView = self.sepView;
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left);
        make.right.mas_equalTo(weakSelf.mas_right);
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
        make.height.mas_equalTo(10);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left);
        make.top.mas_equalTo(weakTopView.mas_bottom);
        make.right.mas_equalTo(weakSelf.mas_right);
        make.bottom.mas_equalTo(weakSepView.mas_top);
    }];
    
    _mode = params;
    _titleLabel.text = params.profixTypeName;
    if (params.productTypeDesc.length > 0)
    {
        _titleDescLabel.text = [NSString stringWithFormat:@"(%@)", params.productTypeDesc];
    }
    _timeLabel.text = params.time;
    if ([params.amount floatValue] > 0)
    {
        _moneyLabel.text = [NSString stringWithFormat:@"+%@元", params.amount];
    }
    else
    {
        _moneyLabel.text = params.amount;
    }
    _buyProductLabel.text = params.desc;
    
}

//资金明细
- (void)showAccountBalanceDetailDatas:(MIAccountBalanceDetailItemMode *)mode lastSepViewHeight:(float)fLastSepViewHeight
{
    weakSelf(weakSelf)
    __weak UIView *weakTopView = self.topView;
    __weak UIView *weakSepView = self.sepView;
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left);
        make.right.mas_equalTo(weakSelf.mas_right);
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
        make.height.mas_equalTo(fLastSepViewHeight);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left);
        make.top.mas_equalTo(weakTopView.mas_bottom);
        make.right.mas_equalTo(weakSelf.mas_right);
        make.bottom.mas_equalTo(weakSepView.mas_top);
    }];
    
    
    //提现失败
    if ([mode.status integerValue] == 6 || [mode.status integerValue] == 7)
    {
        self.explainImageView.hidden = NO;
        self.explainButton.hidden = NO;
    }
    else
    {
        self.explainImageView.hidden = YES;
        self.explainButton.hidden = YES;
        _descLabel.text = mode.withdrawRemark;
        __weak UIView *weakBottomView = self.bottomView;
        [self.buyProductLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakBottomView.mas_top).offset(10);
            make.left.mas_equalTo(weakBottomView.mas_left).offset(12);
            make.right.mas_equalTo(weakBottomView.mas_right);
        }];

    }
    
    self.accountDetailItemMode = mode;
    _titleLabel.text = mode.tranName;
    if (mode.userType.length > 0)
    {
        _titleDescLabel.text = [NSString stringWithFormat:@"(%@)", mode.userType];
    }
    _timeLabel.text = mode.tranTime;
    
    _moneyLabel.text = [NSString stringWithFormat:@"%@元", mode.amount];
    _buyProductLabel.text = mode.remark;
    
}

- (IBAction)failExplainClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showExplain:)])
    {
        [self.delegate showExplain:self.accountDetailItemMode];
    }
}

@end
