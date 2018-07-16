//
//  RedPacketCell.m
//  FinancialManager
//
//  Created by xnkj on 20/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "ComissionCouponCell.h"
#import "ComissionCouponItemMode.h"

@interface ComissionCouponCell()

@property (nonatomic, weak) IBOutlet UILabel * titleNameLabel;
@property (nonatomic, weak) IBOutlet UILabel * platformLimitLabel;
@property (nonatomic, weak) IBOutlet UILabel * investLimitLabel;
@property (nonatomic, weak) IBOutlet UILabel * startTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel * expiredTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel * comissionRateLabel;
@property (nonatomic, weak) IBOutlet UILabel * conditionLimitLabel;
@property (nonatomic, weak) IBOutlet UIImageView * tagImageView;
@end

@implementation ComissionCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//更新红包信息
- (void)refreshComissionCouponInfoWithComissionCouponInfoMode:(ComissionCouponItemMode *)mode
{
    self.comissionRateLabel.text = mode.rate;
    
    if (mode.showStatus == 2 || mode.showStatus == 3) {
        
        [self.conditionLimitLabel setTextColor:[UIColorFromHex(0x999999) colorWithAlphaComponent:0.5]];
        //[self.titleNameLabel setTextColor:[UIColorFromHex(0x000000) colorWithAlphaComponent:0.5]];
        [self.platformLimitLabel setTextColor:[UIColorFromHex(0x666666) colorWithAlphaComponent:0.5]];
        [self.investLimitLabel setTextColor:[UIColorFromHex(0x666666) colorWithAlphaComponent:0.5]];
        [self.startTimeLabel setTextColor:[UIColorFromHex(0x666666) colorWithAlphaComponent:0.5]];
        [self.expiredTimeLabel setTextColor:[UIColorFromHex(0x666666) colorWithAlphaComponent:0.5]];
        
        [self.tagImageView setHidden:NO];
        if (mode.showStatus == 2) {
            
            [self.tagImageView setImage:[UIImage imageNamed:@"xn_myinfo_redpacket_expired_icon.png"]];
        }else if(mode.showStatus == 3)
        {
            [self.tagImageView setImage:[UIImage imageNamed:@"xn_myinfo_redpacket_used_icon.png"]];
        }
        
        NSArray *propertyArray = @[@{@"range": [NSString stringWithFormat:@"%@",mode.rate],
                                     @"color": [UIColorFromHex(0x666666) colorWithAlphaComponent:0.5],
                                     @"font": [UIFont systemFontOfSize:36]},
                                   @{@"range": @"%",
                                     @"color":[UIColorFromHex(0x666666) colorWithAlphaComponent:0.5],
                                     @"font": [UIFont systemFontOfSize:16]}];
        
        NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
        self.comissionRateLabel.attributedText = string;
    }else
    {
        [self.conditionLimitLabel setTextColor:UIColorFromHex(0x999999)];
        //[self.titleNameLabel setTextColor:UIColorFromHex(0x000000)];
        [self.platformLimitLabel setTextColor:UIColorFromHex(0x666666)];
        [self.investLimitLabel setTextColor:UIColorFromHex(0x666666)];
        [self.expiredTimeLabel setTextColor:UIColorFromHex(0x666666)];
        [self.startTimeLabel setTextColor:UIColorFromHex(0x666666)];
        
        [self.tagImageView setHidden:YES];
        NSArray *propertyArray = @[@{@"range": [NSString stringWithFormat:@"%@",mode.rate],
                                     @"color": mode.type == 1?UIColorFromHex(0xfd5d5d):UIColorFromHex(0xff9000),
                                     @"font": [UIFont systemFontOfSize:36]},
                                   @{@"range": @"%",
                                     @"color":mode.type == 1?UIColorFromHex(0xfd5d5d):UIColorFromHex(0xff9000),
                                     @"font": [UIFont systemFontOfSize:16]}];
        
        NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
        self.comissionRateLabel.attributedText = string;
    }
    
    self.conditionLimitLabel.text = mode.type == 1?@"加佣":@"奖励";
    self.titleNameLabel.text = mode.titleName;
    
    self.platformLimitLabel.text = @"适用平台: 不限";
    if (mode.isPlatformLimit) {
        
        self.platformLimitLabel.text = [NSString stringWithFormat:@"适用平台: %@",mode.platform];
    }
    
    self.investLimitLabel.text = @"首投限制: 不限";
    if (mode.investLimit == 1) {
        
        self.investLimitLabel.text = @"首投限制: 用户首投";
        
    }else if(mode.investLimit == 2)
    {
        self.investLimitLabel.text = @"首投限制: 平台首投";
    }

    self.startTimeLabel.text = [NSString stringWithFormat:@"开始时间：%@",mode.validBeginTime];
    self.expiredTimeLabel.text = [NSString stringWithFormat:@"结束时间：%@",mode.validEndTime];
}

@end
