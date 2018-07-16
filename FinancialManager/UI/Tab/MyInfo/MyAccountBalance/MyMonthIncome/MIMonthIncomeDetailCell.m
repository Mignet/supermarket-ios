//
//  MIMonthIncomeDetailCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 11/23/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "MIMonthIncomeDetailCell.h"
#import "MIMonthProfixItemMode.h"

@interface MIMonthIncomeDetailCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleDescLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *moneyLabel;
@property (nonatomic, weak) IBOutlet UILabel *buyProductLabel;
@property (nonatomic, weak) IBOutlet UILabel *buyDescLabel;

@property (nonatomic, strong) MIMonthProfixItemMode *mode;

@end

@implementation MIMonthIncomeDetailCell

- (void)showDatas:(MIMonthProfixItemMode *)params
{
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
        _moneyLabel.text = [NSString stringWithFormat:@"%@元", params.amount];
    }
    
    _buyProductLabel.text = params.desc;
    _buyDescLabel.text = [NSString stringWithFormat:@"年化佣金  %@    产品期限  %@", params.feeRate, params.deadline];
    
}

- (IBAction)explainClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showExplain:)])
    {
        [self.delegate showExplain:_mode];
    }
}


@end
