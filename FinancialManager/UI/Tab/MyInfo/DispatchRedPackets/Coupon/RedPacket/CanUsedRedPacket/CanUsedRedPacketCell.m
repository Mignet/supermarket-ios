//
//  RedPacketCell.m
//  FinancialManager
//
//  Created by xnkj on 20/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "CanUsedRedPacketCell.h"
#import "RedPacketInfoMode.h"

@interface CanUsedRedPacketCell()

@property (nonatomic, weak) IBOutlet UILabel * titleNameLabel;
@property (nonatomic, weak) IBOutlet UILabel * platformLimitLabel;
@property (nonatomic, weak) IBOutlet UILabel * productLimitLabel;
@property (nonatomic, weak) IBOutlet UILabel * investLimitLabel;
@property (nonatomic, weak) IBOutlet UILabel * expiredTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel * redPacketMoneyLabel;
@property (nonatomic, weak) IBOutlet UILabel * conditionLimitLabel;
@property (nonatomic, weak) IBOutlet UILabel * useLabel;
@end

@implementation CanUsedRedPacketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//更新红包信息
- (void)refreshRedPacketInfoWithRedPacketInfoMode:(RedPacketInfoMode *)mode
{
//    NSArray *propertyArray = @[@{@"range": @"¥",
//                                 @"color": UIColorFromHex(0xfd5d5d),
//                                 @"font": [UIFont systemFontOfSize:16]},
//                               @{@"range": mode.redPacketMoney,
//                                 @"color": UIColorFromHex(0xfd5d5d),
//                                 @"font": [UIFont systemFontOfSize:36]}];
//
//    NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
//    self.redPacketMoneyLabel.attributedText = string;
    self.redPacketMoneyLabel.textColor = UIColorFromHex(0xfd5d5d);
    self.redPacketMoneyLabel.text = mode.redPacketMoney;
    self.redPacketMoneyLabel.adjustsFontSizeToFitWidth = YES;
    
    if (mode.amountLimit == 0) {
        
        self.conditionLimitLabel.text = @"金额不限";
        
    }else
    {
        self.conditionLimitLabel.text = [NSString stringWithFormat:@"%@元起",mode.investAmount];
    }

    self.titleNameLabel.text = mode.redPacketName;
    
    self.platformLimitLabel.text = @"适用平台: 网贷";
    if (mode.isPlatformLimit) {
        
        self.platformLimitLabel.text = [NSString stringWithFormat:@"适用平台: %@",mode.platform];
    }
    
    self.productLimitLabel.text = @"适用产品: 不限";
    if (mode.nProductLimit == 1) {
        
        self.productLimitLabel.text = [NSString stringWithFormat:@"适用产品: %@",mode.productName];
    }else if(mode.nProductLimit == 2)
    {
        self.productLimitLabel.text = [NSString stringWithFormat:@"适用产品: %@天产品",mode.productDeadline];
    }else if(mode.nProductLimit == 3)
    {
        self.productLimitLabel.text = [NSString stringWithFormat:@"适用产品: %@天以上产品（含%@天)",mode.productDeadline,mode.productDeadline];
    }
    
    self.investLimitLabel.text = @"首投限制: 不限";
    if (mode.nInvestLimit == 1) {
        
        self.investLimitLabel.text = @"首投限制: 用户首投";
        
    }else if(mode.nInvestLimit == 2)
    {
        self.investLimitLabel.text = @"首投限制: 平台首投";
    }
    
    self.expiredTimeLabel.text = [NSString stringWithFormat:@"过期时间：%@",mode.expireTime];
}

@end
