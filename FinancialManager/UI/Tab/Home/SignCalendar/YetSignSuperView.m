//
//  YetSignSuperView.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/20.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "YetSignSuperView.h"

#import "UserSignMsgModel.h"
#import "UserSignMsgInfoModel.h"

#define SCALE (SCREEN_FRAME.size.width / 320.f)

@interface YetSignSuperView ()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIImageView *red_back_img;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dayLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareBtnTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBtnTop;


@end

@implementation YetSignSuperView

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.red_back_img.hidden = YES;
}

+ (instancetype)yetSignSuperView
{
    YetSignSuperView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YetSignSuperView class]) owner:nil options:nil] firstObject];
    
    return view;
}

- (IBAction)checkSum
{
    if ([self.delegate respondsToSelector:@selector(yetSignSuperViewDid:ClickType:)]) {
        [self.delegate yetSignSuperViewDid:self ClickType:YetSign_Check_Type];
    }
}

- (IBAction)shareBtnClick
{
    if ([self.delegate respondsToSelector:@selector(yetSignSuperViewDid:ClickType:)]) {
        [self.delegate yetSignSuperViewDid:self ClickType:YetSign_Share_Type];
    }
}

/////////////////////
#pragma mark - setter / getter
////////////////////////

- (void)setUserSignMsgModel:(UserSignMsgModel *)userSignMsgModel
{
    _userSignMsgModel = userSignMsgModel;
    
    self.red_back_img.hidden = YES;
    
    self.dayLabel.text = [NSString stringWithFormat:@"今日签到已完成！连续签到%@天", userSignMsgModel.consecutiveDays];
    
    if ([userSignMsgModel.signInfo.timesType integerValue] == 1) { //分享翻倍
        
        if (userSignMsgModel.signInfo.redpacketId.length > 0) { // 有红包
            
            NSArray *propertyArray = @[@{@"range": @"签到奖励",
                                         @"color": UIColorFromHex(0x4F5960),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                       @{@"range": [NSString stringWithFormat:@"%@元", userSignMsgModel.signInfo.signAmount],
                                         @"color": UIColorFromHex(0XFD5D5D),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                       
                                       @{@"range": @"+",
                                         @"color": UIColorFromHex(0x4F5960),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                       @{@"range":[NSString stringWithFormat:@"分享翻倍%@元", userSignMsgModel.signInfo.timesAmount],
                                         @"color":UIColorFromHex(0XFD5D5D),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                       
                                       @{@"range": @"+",
                                         @"color": UIColorFromHex(0x4F5960),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                       @{@"range":@"分享奖励",
                                         @"color":UIColorFromHex(0XFD5D5D),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]}
                                       ];
            
            // 赋值页面上的数据
            NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
            self.priceLabel.attributedText = string;
            
            self.red_back_img.hidden = NO;
            
        } else { //分享翻倍 + 无红包
            
            NSArray *propertyArray = @[@{@"range": @"签到奖励",
                                         @"color": UIColorFromHex(0x4F5960),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                       @{@"range": [NSString stringWithFormat:@"%@元", userSignMsgModel.signInfo.signAmount],
                                         @"color": UIColorFromHex(0XFD5D5D),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                       
                                       @{@"range": @"+",
                                         @"color": UIColorFromHex(0x4F5960),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                       @{@"range":[NSString stringWithFormat:@"分享翻倍%@元", userSignMsgModel.signInfo.timesAmount],
                                         @"color":UIColorFromHex(0XFD5D5D),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]}
                                       ];
            
            // 赋值页面上的数据
            NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
            self.priceLabel.attributedText = string;
        }
    }
    
    else if ([userSignMsgModel.signInfo.timesType integerValue] == 2) { // 连续签到翻倍
        
        if (userSignMsgModel.signInfo.redpacketId.length > 0) { // 连续签到翻倍 有分享红包
            
            NSArray *propertyArray = @[@{@"range": @"签到奖励",
                                         @"color": UIColorFromHex(0x4F5960),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                       @{@"range": [NSString stringWithFormat:@"%@元", userSignMsgModel.signInfo.signAmount],
                                         @"color": UIColorFromHex(0XFD5D5D),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                       
                                       @{@"range": @"+",
                                         @"color": UIColorFromHex(0x4F5960),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                       @{@"range":[NSString stringWithFormat:@"%@元*%@", userSignMsgModel.signInfo.signAmount, userSignMsgModel.times],
                                         @"color":UIColorFromHex(0XFD5D5D),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                       
                                       @{@"range": @"+",
                                         @"color": UIColorFromHex(0x4F5960),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                       @{@"range":@"分享奖励",
                                         @"color":UIColorFromHex(0XFD5D5D),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]}
                                       
                                       ];
            
            // 赋值页面上的数据
            NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
            self.priceLabel.attributedText = string;
           
            self.red_back_img.hidden = NO;
        
        } else { // 无分享红包
            
            NSArray *propertyArray = @[@{@"range": @"签到奖励",
                                         @"color": UIColorFromHex(0x4F5960),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                       @{@"range": [NSString stringWithFormat:@"%@元", userSignMsgModel.signInfo.signAmount],
                                         @"color": UIColorFromHex(0XFD5D5D),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                       @{@"range": @"+",
                                         @"color": UIColorFromHex(0x4F5960),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                       @{@"range":[NSString stringWithFormat:@"%@元*%@", userSignMsgModel.signInfo.signAmount, userSignMsgModel.times],
                                         @"color":UIColorFromHex(0XFD5D5D),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]}
                                       ];
            
            // 赋值页面上的数据
            NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
            self.priceLabel.attributedText = string;
        }
    }
    
    else { // 没有翻倍
        
        if (userSignMsgModel.signInfo.redpacketId.length > 0) { //没有翻倍 有红包奖励
            
            NSArray *propertyArray = @[@{@"range": @"签到奖励",
                                         @"color": UIColorFromHex(0x4F5960),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                       
                                       @{@"range": [NSString stringWithFormat:@"%@元", userSignMsgModel.signInfo.signAmount],
                                         @"color": UIColorFromHex(0XFD5D5D),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                       
                                       @{@"range": @"+",
                                         @"color": UIColorFromHex(0x4F5960),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                       @{@"range":@"分享奖励",
                                         @"color":UIColorFromHex(0XFD5D5D),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]}
                                       ];
            
            // 赋值页面上的数据
            NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
            self.priceLabel.attributedText = string;
            
            self.self.red_back_img.hidden = NO;
            
            
        } else { // 没有翻倍 + 没有分享红包
            
            NSArray *propertyArray = @[@{@"range": @"签到奖励",
                                         @"color": UIColorFromHex(0x4F5960),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                       
                                       @{@"range": [NSString stringWithFormat:@"%@元", userSignMsgModel.signInfo.signAmount],
                                         @"color": UIColorFromHex(0XFD5D5D),
                                         @"font": [UIFont fontWithName:@"DINOT" size:17]},
                            
                                       ];
            // 赋值页面上的数据
            NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
            self.priceLabel.attributedText = string;
        }
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];

    self.dayLabelTop.constant = 15.f;
    self.shareBtnTop.constant = 15.f;
    self.shareBtnWidth.constant = (SCREEN_FRAME.size.width > 375.f) ? 250.f : 240.f;
    self.checkBtnTop.constant = (SCREEN_FRAME.size.width > 375.f) ? 15.f : 10.f;
    
    if ([self.userSignMsgModel.signInfo.shareStatus integerValue] == 1) { // 已分享
        self.priceLabelTop.constant = (SCREEN_FRAME.size.width > 375.f) ? 35.f : 20.f;
        self.shareBtn.hidden = YES;
        self.shareBtnHeight.constant = 0.f;
    } else { // 未分享
        self.priceLabelTop.constant = (SCREEN_FRAME.size.width > 375.f) ? 10.f : 5.f;
        self.shareBtn.hidden = NO;
        self.shareBtnHeight.constant = (SCREEN_FRAME.size.width > 375.f) ? 49.f : 44.f;
    }
    
    // 是非有红包，位置移动
    if (self.userSignMsgModel.signInfo.redpacketId.length > 0) {
        self.priceLabel.center = CGPointMake(self.width / 2.f - 8.f, self.priceLabel.center.y);
    } else {
        self.priceLabel.center = CGPointMake(self.width / 2.f, self.priceLabel.center.y);
    }
    
}


@end
