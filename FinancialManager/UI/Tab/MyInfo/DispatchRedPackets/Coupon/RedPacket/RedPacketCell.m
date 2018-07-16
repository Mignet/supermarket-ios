//
//  RedPacketCell.m
//  FinancialManager
//
//  Created by xnkj on 20/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "RedPacketCell.h"
#import "RedPacketInfoMode.h"

@interface RedPacketCell()

@property (nonatomic, strong) NSString * redPacketId;
@property (nonatomic, strong) NSString * redPacketMoney;
@property (nonatomic, strong) NSString * redPacketUseStatus;

@property (nonatomic, weak) IBOutlet UILabel * titleNameLabel;
@property (nonatomic, weak) IBOutlet UILabel * platformLimitLabel;
@property (nonatomic, weak) IBOutlet UILabel * productLimitLabel;
@property (nonatomic, weak) IBOutlet UILabel * investLimitLabel;
@property (nonatomic, weak) IBOutlet UILabel * expiredTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel * redPacketMoneyLabel;
@property (nonatomic, weak) IBOutlet UILabel * conditionLimitLabel;
@property (nonatomic, weak) IBOutlet UIButton * sendButton;
@property (nonatomic, weak) IBOutlet UIImageView * tagImageView;
@property (nonatomic, weak) IBOutlet UIButton * useButton;
@end

@implementation RedPacketCell

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
    self.redPacketId = mode.redPacketRid;
    self.redPacketMoney = mode.redPacketMoney;
    self.redPacketUseStatus = mode.redPacketUseStatus;
    
    [self.sendButton setHidden:NO];
    if ([mode.sendStatus isEqualToString:@"0"]) {
        [self.sendButton setHidden:YES];
    }
    if ([mode.redPacketUseStatus integerValue] == 1 || [mode.redPacketUseStatus integerValue] == 2) {
        
        [self.conditionLimitLabel setTextColor:[UIColorFromHex(0x999999) colorWithAlphaComponent:0.5]];
        
        [self.sendButton setImage:[UIImage imageNamed:@"xn_myinfo_send_expire_icon.png"] forState:UIControlStateNormal];
        [self.useButton setImage:[UIImage imageNamed:@"xn_myinfo_used_icon.png"] forState:UIControlStateNormal];
        //[self.titleNameLabel setTextColor:[UIColorFromHex(0x000000) colorWithAlphaComponent:0.5]];
        [self.platformLimitLabel setTextColor:[UIColorFromHex(0x666666) colorWithAlphaComponent:0.5]];
        [self.investLimitLabel setTextColor:[UIColorFromHex(0x666666) colorWithAlphaComponent:0.5]];
        [self.productLimitLabel setTextColor:[UIColorFromHex(0x666666) colorWithAlphaComponent:0.5]];
        [self.expiredTimeLabel setTextColor:[UIColorFromHex(0x666666) colorWithAlphaComponent:0.5]];
        
        [self.tagImageView setHidden:NO];
        if (mode.redPacketUseStatus.integerValue == 1) {
            
            [self.tagImageView setImage:[UIImage imageNamed:@"xn_myinfo_redpacket_used_icon.png"]];
        }else
        {
            [self.tagImageView setImage:[UIImage imageNamed:@"xn_myinfo_redpacket_expired_icon.png"]];
        }
        
//        NSArray *propertyArray = @[@{@"range": @"¥",
//                                     @"color": [UIColorFromHex(0x666666) colorWithAlphaComponent:0.5],
//                                     @"font": [UIFont systemFontOfSize:16]},
//                                   @{@"range": mode.redPacketMoney,
//                                     @"color": [UIColorFromHex(0x666666) colorWithAlphaComponent:0.5],
//                                     @"font": [UIFont systemFontOfSize:36]}];
//
//        NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
//        self.redPacketMoneyLabel.attributedText = string;
        self.redPacketMoneyLabel.textColor = UIColorFromHex(0x666666);
        self.redPacketMoneyLabel.text = mode.redPacketMoney;
        
    }else
    {
        [self.conditionLimitLabel setTextColor:UIColorFromHex(0x999999)];
        [self.sendButton setImage:[UIImage imageNamed:@"xn_myinfo_send_icon.png"] forState:UIControlStateNormal];
        [self.useButton setImage:[UIImage imageNamed:@"xn_myinfo_use_icon.png"] forState:UIControlStateNormal];
        //[self.titleNameLabel setTextColor:UIColorFromHex(0x000000)];
        [self.titleNameLabel setTextColor:UIColorFromHex(0x666666)];
        [self.platformLimitLabel setTextColor:UIColorFromHex(0x666666)];
        [self.investLimitLabel setTextColor:UIColorFromHex(0x666666)];
        [self.productLimitLabel setTextColor:UIColorFromHex(0x666666)];
        [self.expiredTimeLabel setTextColor:UIColorFromHex(0x666666)];
        
        [self.tagImageView setHidden:YES];
        
//        NSArray *propertyArray = @[@{@"range": @"¥",
//                                     @"color": UIColorFromHex(0xfd5d5d),
//                                     @"font": [UIFont systemFontOfSize:16]},
//                                   @{@"range": mode.redPacketMoney,
//                                     @"color": UIColorFromHex(0xfd5d5d),
//                                     @"font": [UIFont systemFontOfSize:36]}];
//
//        NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
//        self.redPacketMoneyLabel.attributedText = string;
        self.redPacketMoneyLabel.textColor = UIColorFromHex(0xfd5d5d);
        self.redPacketMoneyLabel.text = mode.redPacketMoney;
    }
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

//设置派发红包block
- (void)setClickSendRedPacketBlock:(SendBlock)block
{
    if (block) {
        
        self.sendRedPacketBlock = block;
    }
}

//设置使用红包block
- (void)setClickUseRedPacketBlock:(UseRedPacketBlock)block
{
    if (block) {
    
        self.useRedPacketBlock = block;
    }
}

//派发
- (IBAction)clickSendRedPacket:(id)sender
{
    if (self.sendRedPacketBlock && self.redPacketUseStatus.integerValue == 0) {
        
        self.sendRedPacketBlock(self.redPacketId, self.redPacketMoney);
    }
}

//适用红包
- (IBAction)clickUseRedPacket:(id)sender
{
    if (self.useRedPacketBlock && self.redPacketUseStatus.integerValue == 0) {
        
        self.useRedPacketBlock();
    }

}

@end
