//
//  HotBundCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/16/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "HotBundCell.h"
#import "XNBundItemMode.h"

@interface HotBundCell()

@property (nonatomic, weak) IBOutlet UILabel *rateLabel;
@property (nonatomic, weak) IBOutlet UILabel *rateDescLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;

@end

@implementation HotBundCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showDatas:(XNBundItemMode *)mode
{
    NSArray *propertyArray = @[@{@"range": ![NSObject isValidateInitString:mode.sevenDaysAnnualizedYield]? @"0.00" : mode.sevenDaysAnnualizedYield,
                                 @"color": UIColorFromHex(0xfd5d5d),
                                 @"font": [UIFont fontWithName:@"DINOT" size:22]},
                               @{@"range": @"%",
                                 @"color": UIColorFromHex(0xfd5d5d),
                                 @"font": [UIFont systemFontOfSize:15]}];
    
    if (mode.sevenDaysAnnualizedYield == nil || [mode.sevenDaysAnnualizedYield isEqualToString:@"0.00"] || [mode.sevenDaysAnnualizedYield isEqualToString:@"0.0000"])
    {
        propertyArray = @[@{@"range": @"--",
                            @"color": UIColorFromHex(0xfd5d5d),
                            @"font": [UIFont fontWithName:@"DINOT" size:15]}];
    }
    
    NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
    
    self.rateLabel.attributedText = string;
    
    self.rateDescLabel.text = [NSString stringWithFormat:@"七日年化 (%@%@)",mode.fundName,mode.fundCode];
}

@end
