//
//  MyFundRecordingCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/22/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyFundRecordingCell.h"
#import "XNMyBundRecordingItemMode.h"

@interface MyFundRecordingCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *tradeDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *tradeAmountLabel;
@property (nonatomic, weak) IBOutlet UILabel *fundStatueLabel;

@end

@implementation MyFundRecordingCell

- (void)showDatas:(XNMyBundRecordingItemMode *)mode
{
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@", mode.fundName, mode.fundCode];
    self.tradeDateLabel.text = mode.transactionDate;
    self.tradeAmountLabel.text = mode.transactionAmount;
    
    UIColor *statusColor = UIColorFromHex(0x4e8cef);
    if ([mode.transactionStatus isEqualToString:@"failure"] || [mode.transactionStatus isEqualToString:@"void"])
    {
        statusColor = UIColorFromHex(0xfd5d5d);
    }
    
    NSArray *propertyArray = @[@{@"range": [NSString stringWithFormat:@"%@-", mode.transactionTypeMsg],
                                 @"color": UIColorFromHex(0x4f5960),
                                 @"font": [UIFont systemFontOfSize:14]},
                               @{@"range": mode.transactionStatusMsg,
                                 @"color": statusColor,
                                 @"font": [UIFont systemFontOfSize:14]}];
    
    NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
    
    self.fundStatueLabel.attributedText = string;
}

@end
