//
//  MIMyProfitDetailCell.m
//  FinancialManager
//
//  Created by xnkj on 15/9/22.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "MIAccountRecordCell.h"
#import "XNAccountRecordItemMode.h"

@interface MIAccountRecordCell()

@property (nonatomic, weak) IBOutlet UILabel * titleLabel;
@property (nonatomic, weak) IBOutlet UILabel * dateLabel;
@property (nonatomic, weak) IBOutlet UILabel * profitLabel;
@property (nonatomic, weak) IBOutlet UILabel * profitfeelabel;
@property (nonatomic, weak) IBOutlet UILabel * descLable;
@end

@implementation MIAccountRecordCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 刷新数据-账户记录
- (void)refreshAccountRecordItemCell:(XNAccountRecordItemMode *)params
{
        [self.titleLabel setText:params.typeName];
        [self.dateLabel setText:params.time];

        NSString * profit = [NSString stringWithFormat:@"%@",[NSString convertUnits:params.amount]];
        [self.profitLabel setTextColor:MONEYCOLOR];
        if ([params.amount floatValue] < 0) {
    
            [self.profitLabel setTextColor:UIColorFromHex(0x5cb565)];
        }
    
        [self.profitfeelabel setText:@""];
        if (![params.profitFee isEqualToString:@"0.00"]) {
            
            [self.profitfeelabel setText:[NSString stringWithFormat:@"(手续费%@)",params.profitFee]];
        }
    
        [self.profitLabel setText:profit];
        [self.descLable setText:params.content];
}

@end
