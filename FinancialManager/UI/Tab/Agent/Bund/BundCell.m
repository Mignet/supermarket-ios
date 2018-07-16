//
//  BundCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/17/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "BundCell.h"
#import "XNBundItemMode.h"

@interface BundCell()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UILabel *rateLabel;
@property (nonatomic, weak) IBOutlet UILabel *rateDescLabel;

@end

@implementation BundCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showDatas:(XNBundItemMode *)mode selectedPeriodType:(NSString *)selectedPeriodType selectedPeriod:(NSString *)selectedPeriodString
{
    NSString *rateString = @"--";
    if ([selectedPeriodType isEqualToString:@"earningsPer10000"])
    {
        //万份收益率
        rateString = mode.earningsPer10000Msg;
    }
    else if ([selectedPeriodType isEqualToString:@"nav"])
    {
        //基金净值
        rateString = mode.navMsg;
    }
    else if ([selectedPeriodType isEqualToString:@"month3"])
    {
        //3月收益率
        rateString = mode.month3Msg;
    }
    else if ([selectedPeriodType isEqualToString:@"year1"])
    {
        rateString = mode.year1Msg;
    }
    else if ([selectedPeriodType isEqualToString:@"sinceLaunch"])
    {
        rateString = mode.sinceLaunchMsg;
    }else if([selectedPeriodType isEqualToString:@"sevenDaysAnnualizedYield"])
    {
        rateString = mode.sevenDaysAnnualizedYield;
    }
    
    NSArray *propertyArray = @[@{@"range": rateString == nil ? @"0.00" : rateString,
                                 @"color": UIColorFromHex(0xfd5d5d),
                                 @"font": [UIFont fontWithName:@"DINOT" size:18]},
                               @{@"range": @"%",
                                 @"color": UIColorFromHex(0xfd5d5d),
                                 @"font": [UIFont systemFontOfSize:15]}];
    
    if ([selectedPeriodType isEqualToString:@"nav"] || [selectedPeriodType isEqualToString:@"earningsPer10000"])
    {
        propertyArray = @[@{@"range": rateString,
                            @"color": UIColorFromHex(0xfd5d5d),
                            @"font": [UIFont fontWithName:@"DINOT" size:18]}];
    }
    
    if (rateString == nil || [rateString isEqualToString:@"0.00"] || [mode.year1Msg isEqualToString:@"0.0000"])
    {
        propertyArray = @[@{@"range": @"--",
                            @"color": UIColorFromHex(0xfd5d5d),
                            @"font": [UIFont fontWithName:@"DINOT" size:18]}];
    }
    
    NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
    
    self.rateLabel.attributedText = string;
    
    self.rateDescLabel.text = selectedPeriodString;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", mode.fundName, mode.fundCode];
    
    self.typeLabel.text = mode.fundTypeMsg;
    
    
}

@end
