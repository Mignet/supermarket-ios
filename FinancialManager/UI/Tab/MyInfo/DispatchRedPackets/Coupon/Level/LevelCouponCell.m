//
//  RedPacketCell.m
//  FinancialManager
//
//  Created by xnkj on 20/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "LevelCouponCell.h"
#import "LevelCouponItemMode.h"

@interface LevelCouponCell()

@property (nonatomic, weak) IBOutlet UIImageView * levelImageView;
@property (nonatomic, weak) IBOutlet UILabel * LevelNameLabel;
@property (nonatomic, weak) IBOutlet UILabel * LevelAwardLabel;
@property (nonatomic, weak) IBOutlet UILabel * LevelSubAwardLabel;
@property (nonatomic, weak) IBOutlet UILabel * startTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel * expiredTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel * rightTagLabel;
@property (nonatomic, weak) IBOutlet UIImageView * tagImageView;
@end

@implementation LevelCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//更新红包信息
- (void)refreshLevelCouponInfoWithLevelCouponInfoMode:(LevelCouponItemMode *)mode
{
    if (mode.showStatus == 2 || mode.showStatus == 3 || mode.showStatus == 4) {
        
        
        if ([mode.voucherType isEqualToString:@"30"]) {
            
            [self.levelImageView setImage:[UIImage imageNamed:@"xn_myinfo_LevelCoupon_jingli_gray_icon.png"]];
        }else
        {
            [self.levelImageView setImage:[UIImage imageNamed:@"xn_myinfo_LevelCoupon_zongjian_gray_icon.png"]];
        }

        [self.LevelAwardLabel setTextColor:[UIColorFromHex(0x666666) colorWithAlphaComponent:0.5]];
        [self.LevelSubAwardLabel setTextColor:[UIColorFromHex(0x666666) colorWithAlphaComponent:0.5]];
        [self.startTimeLabel setTextColor:[UIColorFromHex(0x666666) colorWithAlphaComponent:0.5]];
        [self.expiredTimeLabel setTextColor:[UIColorFromHex(0x666666) colorWithAlphaComponent:0.5]];
        [self.rightTagLabel setTextColor:[UIColorFromHex(0x666666) colorWithAlphaComponent:0.5]];
        
        NSArray *propertyArray = @[@{@"range": mode.voucherName,
                                     @"color": [UIColorFromHex(0x666666) colorWithAlphaComponent:0.5],
                                     @"font": [UIFont systemFontOfSize:21]},
                                   @{@"range": @" 体验券",
                                     @"color": [UIColorFromHex(0x666666) colorWithAlphaComponent:0.5],
                                     @"font": [UIFont systemFontOfSize:14]}];
        
        NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
        self.LevelNameLabel.attributedText = string;
    }else
    {
        if ([mode.voucherType isEqualToString:@"30"]) {
            
            [self.levelImageView setImage:[UIImage imageNamed:@"xn_myinfo_LevelCoupon_jingli_icon.png"]];
        }else
        {
            [self.levelImageView setImage:[UIImage imageNamed:@"xn_myinfo_LevelCoupon_zongjian_icon.png"]];
        }
        
        [self.LevelAwardLabel setTextColor:UIColorFromHex(0x666666)];
        [self.LevelSubAwardLabel setTextColor:[UIColor blackColor]];
        [self.startTimeLabel setTextColor:UIColorFromHex(0x666666)];
        [self.expiredTimeLabel setTextColor:UIColorFromHex(0x666666)];
        [self.rightTagLabel setTextColor:UIColorFromHex(0x666666)];
        
        NSArray *propertyArray = @[@{@"range": mode.voucherName,
                                     @"color": UIColorFromHex(0xfd5d5d),
                                     @"font": [UIFont systemFontOfSize:21]},
                                   @{@"range": @" 体验券",
                                     @"color": UIColorFromHex(0x666666),
                                     @"font": [UIFont systemFontOfSize:14]}];
        
        NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
        self.LevelNameLabel.attributedText = string;
    }

    self.LevelAwardLabel.text = [NSString stringWithFormat:@"职级福利：%@", mode.jobGradeWelfare1];
    self.LevelSubAwardLabel.text = mode.jobGradeWelfare2;
    
    self.startTimeLabel.text = [NSString stringWithFormat:@"开始时间：%@",mode.useTime];
    self.expiredTimeLabel.text = [NSString stringWithFormat:@"结束时间：%@",mode.expiresTime];
    self.rightTagLabel.text = mode.activityAttr;

    [self.tagImageView setHidden:YES];
    if (mode.showStatus == 2) {
        
        [self.tagImageView setHidden:NO];
        [self.tagImageView setImage:[UIImage imageNamed:@"xn_myinfo_redpacket_used_icon.png"]];
        
    }else if (mode.showStatus == 3) {
       
        [self.tagImageView setHidden:NO];
        [self.tagImageView setImage:[UIImage imageNamed:@"xn_myinfo_redpacket_expired_icon.png"]];
    }else if (mode.showStatus == 4)
    {
        [self.tagImageView setHidden:NO];
        [self.tagImageView setImage:[UIImage imageNamed:@"xn_myinfo_redpacket_unable_icon.png"]];
    }
}

@end
