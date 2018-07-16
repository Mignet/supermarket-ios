//
//  MIDeportDetailCell.m
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "MIDeportDetailCell.h"
#import "XNMyAccountWithDrawRecordItemMode.h"

@interface MIDeportDetailCell()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleDescLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *moneyLabel;

@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UILabel *buyProductLabel;
@property (nonatomic, weak) IBOutlet UILabel *descLabel;

@property (nonatomic, weak) IBOutlet UIImageView *explainImageView;
@property (nonatomic, weak) IBOutlet UIButton *explainButton;

@property (nonatomic, strong) NSArray         * statusArray;

@property (nonatomic, strong) XNMyAccountWithDrawRecordItemMode *mode;

@end

@implementation MIDeportDetailCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 更新内容
- (void)showDatas:(XNMyAccountWithDrawRecordItemMode *)mode
{
    self.mode = mode;
    //提现失败
    if ([mode.status integerValue] == 6 || [mode.status integerValue] == 7)
    {
        self.explainImageView.hidden = NO;
        self.explainButton.hidden = NO;
        _descLabel.hidden = YES;
    }
    else
    {
        self.explainImageView.hidden = YES;
        self.explainButton.hidden = YES;
        _descLabel.hidden = NO;
    }
    
    _titleLabel.text = mode.bisName;
    _titleDescLabel.text = [NSString stringWithFormat:@"(%@)", mode.userType];
    _timeLabel.text = mode.transDate;
    _buyProductLabel.textColor = ([mode.status integerValue] == 3 || [mode.status integerValue] == 4 || [mode.status integerValue] == 6 || [mode.status integerValue] == 7)?UIColorFromHex(0xfd5353): UIColorFromHex(0xa2a2a2);
    _buyProductLabel.text = [mode.status integerValue] > 7?@"提现中":[self.statusArray objectAtIndex:[mode.status integerValue]];
    _moneyLabel.text = [NSString stringWithFormat:@"%@元", mode.amount];
    
    if ([mode.status integerValue] != withDrawSuccess)
    {
        
        _descLabel.textColor = ([mode.status integerValue] == 3 || [mode.status integerValue] == 4 || [mode.status integerValue] == 6 || [mode.status integerValue] == 7)?UIColorFromHex(0xfd5353): UIColorFromHex(0xa2a2a2);
        [_descLabel setFont:[UIFont systemFontOfSize:12]];
        if ([mode.status integerValue] > 7 || [[self.statusArray objectAtIndex:[mode.status integerValue]] isEqualToString:@"提现中"])
        {
            [_descLabel setFont:[UIFont systemFontOfSize:11]];
            [_descLabel setText:mode.paymentDate];
        }
    }
    else
    {
        if ([NSObject isValidateInitString:mode.fee] && mode.fee.integerValue > 0)
        {
            _descLabel.textColor = DEPORTMONEYFEECOLOR;
            [_descLabel setText:[NSString stringWithFormat:@"手续费:%@元",mode.fee]];
        }else
        {
            [_descLabel setHidden:YES];
        }
    }
    
    
}

/*
- (void)updateContent:(XNMyAccountWithDrawRecordItemMode *)params isLastLine:(BOOL)isLastLine
{
    [self.moneyLabel setText:[NSString stringWithFormat:@"%@",[NSString convertUnits:params.amount]]];
    [self.startDateLabel setText:params.transDate];

    if ([params.status integerValue] != withDrawSuccess)
    {
        [self.finisedLabel setHidden:YES];
        [self.deportingLabel setHidden:NO];
        [self.endDateLabel setHidden:NO];
        
        self.deportingLabel.textColor = ([params.status integerValue] == 3 || [params.status integerValue] == 4 || [params.status integerValue] == 6 || [params.status integerValue] == 7)?UIColorFromHex(0xfd5353): UIColorFromHex(0xa2a2a2);
        [self.deportingLabel setText:[params.status integerValue] > 7?@"提现中":[self.statusArray objectAtIndex:[params.status integerValue]]];
        
        self.endDateLabel.textColor = ([params.status integerValue] == 3 || [params.status integerValue] == 4 || [params.status integerValue] == 6 || [params.status integerValue] == 7)?UIColorFromHex(0xfd5353): UIColorFromHex(0xa2a2a2);
        [self.endDateLabel setFont:[UIFont systemFontOfSize:12]];
        if ([params.status integerValue] > 7 || [[self.statusArray objectAtIndex:[params.status integerValue]] isEqualToString:@"提现中"]) {
            
            [self.endDateLabel setFont:[UIFont systemFontOfSize:11]];
            [self.endDateLabel setText:params.paymentDate];
        }else
            [self.endDateLabel setText:params.paymentDate];
    }else
    {
        
        if ([NSObject isValidateInitString:params.fee] && params.fee.integerValue > 0) {
            
            [self.finisedLabel setHidden:YES];
            [self.deportingLabel setHidden:NO];
            [self.endDateLabel setHidden:NO];
            
            self.deportingLabel.textColor = DEPORTMONEYCOLOR;
            [self.deportingLabel setText:@"成功"];
            
            self.endDateLabel.textColor = DEPORTMONEYFEECOLOR;
            [self.endDateLabel setText:[NSString stringWithFormat:@"手续费:%@元",params.fee]];
        }else
        {
            [self.finisedLabel setHidden:NO];
            [self.deportingLabel setHidden:YES];
            [self.endDateLabel setHidden:YES];
            
            self.finisedLabel.textColor = DEPORTMONEYCOLOR;
            [self.finisedLabel setText:@"成功"];
        }
    }
    
    [self.seperatorLineLabel setHidden:isLastLine];
    [self.lastSeperatorLineLabel setHidden:!isLastLine];
    
}
*/

- (IBAction)failExplainClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showExplain:)])
    {
        [self.delegate showExplain:self.mode];
    }
}

#pragma mark - statusArray
- (NSArray *)statusArray
{
    if (!_statusArray) {
        
        _statusArray = [[NSArray alloc]initWithObjects:@"提现中",@"提现中",@"提现中",@"提现失败",@"提现失败",@"提现成功",@"提现失败",@"提现失败",@"提现中", nil];
    }
    return _statusArray;
}

@end
