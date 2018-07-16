//
//  InsuranceListCell.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/26.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "InsuranceListCell.h"

#import "XNInsuranceItem.h"
#import "XNCommonModule.h"
#import "XNConfigMode.h"

@interface InsuranceListCell ()

@property (nonatomic, weak) IBOutlet UIImageView *headImageView;

@property (nonatomic, weak) IBOutlet UIImageView *tagImageView;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *tagLabel;

@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@property (nonatomic, weak) IBOutlet UILabel *comissionLabel;

@end

@implementation InsuranceListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setInsuranceItemModel:(XNInsuranceItem *)insuranceItemModel
{
    _insuranceItemModel = insuranceItemModel;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?f=png", [XNCommonModule defaultModule].configMode.imgServerUrl, insuranceItemModel.productBakimg];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"xn_FinancialManager_insurance_default_icon.png"]];
    
    NSString *tagImageString = @"";
    if ([NSObject isValidateObj:insuranceItemModel.fristCategory])
    {
        switch ([insuranceItemModel.fristCategory integerValue]) {
            case 1: //意外险
                tagImageString = @"XN_Accident_Insurance_icon";
                break;
            case 2: //旅游险
                tagImageString = @"XN_Tourism_Insurance_icon";
                break;
            case 3: //家财险
                tagImageString = @"XN_Home_Insurance_icon";
                break;
            case 4: //医疗险
                tagImageString = @"XN_Health_Insurance_icon";
                break;
            case 5: //重疾险
                tagImageString = @"XN_Serious_illness_Insurance_icon";
                break;
            case 6: //年金险
                tagImageString = @"XN_Pension_Insurance_icon";
                break;
            case 7://住院险
                tagImageString = @"XN_doctor_Insurance_icon";
                break;
            default:
                break;
        }
    }
    
    self.tagImageView.image = [UIImage imageNamed:tagImageString];
    
    self.titleLabel.text = insuranceItemModel.productName;
    self.tagLabel.text = insuranceItemModel.fullDescription;
    
    NSArray *propertyArray = @[@{@"range": [NSString stringWithFormat:@"¥%@", insuranceItemModel.priceString == nil ? @"0.00" : insuranceItemModel.priceString],
                                 @"color": UIColorFromHex(0xfd5d5d),
                                 @"font": [UIFont fontWithName:@"DINOT" size:17]},
                               @{@"range": @"元起",
                                 @"color": UIColorFromHex(0x999999),
                                 @"font": [UIFont systemFontOfSize:12]}];
    
    NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
    self.amountLabel.attributedText = string;
    
    propertyArray = @[
                      @{@"range": insuranceItemModel.feeRatio,
                        @"color": UIColorFromHex(0xfd5d5d),
                        @"font": [UIFont systemFontOfSize:14]},
                      @{@"range": @"%",
                        @"color": UIColorFromHex(0xfd5d5d),
                        @"font": [UIFont systemFontOfSize:12]},
                      @{@"range": @"佣金率",
                        @"color": UIColorFromHex(0x999999),
                        @"font": [UIFont fontWithName:@"DINOT" size:12]}
                      ];
    string = [NSString getAttributeStringWithAttributeArray:propertyArray];
    
    
    
    self.comissionLabel.attributedText = string;
}

@end
