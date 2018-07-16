//
//  SignRecordHeaderView.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/17.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SignRecordHeaderView.h"

#import "SignStatisticsModel.h"

@interface SignRecordHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sumLabelTop;
@property (weak, nonatomic) IBOutlet UILabel *oneMsgLabel;
@property (weak, nonatomic) IBOutlet UIButton *rollOutBtn;
@property (weak, nonatomic) IBOutlet UILabel *twoMsgLabel;

/*** 总奖励金 **/
@property (weak, nonatomic) IBOutlet UILabel *totalBounsLabel;

/*** 已转奖励金 **/
@property (weak, nonatomic) IBOutlet UILabel *transferedBounsLabel;


@end

#define SCALE (SCREEN_FRAME.size.width / 375.f)

@implementation SignRecordHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.sumLabelTop.constant = 170 * SCALE;
    
    // 设置twoMsgLabel文字大小自适应
    self.twoMsgLabel.adjustsFontSizeToFitWidth = YES;
    self.twoMsgLabel.minimumScaleFactor = 0.5;
}

+ (instancetype)signRecordHeaderView
{
    SignRecordHeaderView *signRecordHeaderView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SignRecordHeaderView class]) owner:nil options:nil] firstObject];
    
    return signRecordHeaderView;
}


- (IBAction)rollOutClick
{
    if ([self.delegate respondsToSelector:@selector(signRecordHeaderViewDid:)]) {
        [self.delegate signRecordHeaderViewDid:self];
    }
    
}

//////////////////////////
#pragma mark - setter / getter
////////////////////////////

- (void)setSignStatisticsModel:(SignStatisticsModel *)signStatisticsModel
{
    _signStatisticsModel = signStatisticsModel;

    self.sumLabel.text = [NSString stringWithFormat:@"%@", signStatisticsModel.leftBouns];
    
    // 1.剩余奖励金
    NSArray *propertyArray = @[@{@"range": @"¥",
                                 @"color": UIColorFromHex(0XFFF2F1),
                                 @"font": [UIFont fontWithName:@"DINOT" size:18]},
                               
                               @{@"range": [NSString stringWithFormat:@"%@", signStatisticsModel.leftBouns],
                                 @"color": UIColorFromHex(0XFFF2F1),
                                 @"font": [UIFont fontWithName:@"DINOT" size:30]},
                               @{@"range": [NSString stringWithFormat:@"元"],
                                 @"color": UIColorFromHex(0XFFF2F1),
                                 @"font": [UIFont fontWithName:@"DINOT" size:15]}
                               ];
    // 赋值页面上的数据
    NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
    self.sumLabel.attributedText = string;
    
    // 显示可转出金额
    if ([signStatisticsModel.transferBouns floatValue] >= 10.f) { // 满足转出条件
        
        self.twoMsgLabel.hidden = YES;
        
        NSString *transferBouns = @"立即转出";
        [self.rollOutBtn setBackgroundImage:[UIImage imageNamed:@"share_btn_bg_img.png"] forState:UIControlStateNormal];
        [self.rollOutBtn setTitleColor:UIColorFromHex(0XFFF2F1) forState:UIControlStateNormal];
        [self.rollOutBtn setTitle:transferBouns forState:UIControlStateNormal];
        self.rollOutBtn.userInteractionEnabled = YES;
        
    } else { // 不满足转出条件
        
        self.twoMsgLabel.hidden = NO;
        self.twoMsgLabel.text = [NSString stringWithFormat:@"*%@", signStatisticsModel.dissatisfyDescription];
        
        NSString *transferBouns = @"未满足转出条件";
        [self.rollOutBtn setBackgroundImage:[UIImage imageNamed:@"share_btn_no_bg_img.png"] forState:UIControlStateNormal];
        [self.rollOutBtn setTitleColor:UIColorFromHex(0xF6F6F6) forState:UIControlStateNormal];
        [self.rollOutBtn setTitle:transferBouns forState:UIControlStateNormal];
        self.rollOutBtn.userInteractionEnabled = NO;
    }
    
    // 奖励转出记录
    NSArray *totalArray = @[@{@"range": @"获得奖励金",
                                 @"color": UIColorFromHex(0X999999),
                                 @"font": [UIFont fontWithName:@"DINOT" size:13]},
                               
                               @{@"range": [NSString stringWithFormat:@"%@", signStatisticsModel.totalBouns],
                                 @"color": UIColorFromHex(0XFD5D5D),
                                 @"font": [UIFont fontWithName:@"DINOT" size:13]},
                               @{@"range": [NSString stringWithFormat:@"元"],
                                 @"color": UIColorFromHex(0X999999),
                                 @"font": [UIFont fontWithName:@"DINOT" size:13]}
                               ];
    
    NSAttributedString *totalString = [NSString getAttributeStringWithAttributeArray:totalArray];
    self.totalBounsLabel.attributedText = totalString;
    
    
    NSArray *transferedBounsArray = @[@{@"range": @"转出奖励金",
                              @"color": UIColorFromHex(0X999999),
                              @"font": [UIFont fontWithName:@"DINOT" size:13]},
                            
                            @{@"range": [NSString stringWithFormat:@"%@", signStatisticsModel.transferedBouns],
                              @"color": UIColorFromHex(0XFD5D5D),
                              @"font": [UIFont fontWithName:@"DINOT" size:13]},
                            @{@"range": [NSString stringWithFormat:@"元"],
                              @"color": UIColorFromHex(0X999999),
                              @"font": [UIFont fontWithName:@"DINOT" size:13]}
                            ];
    
    NSAttributedString *transferedString = [NSString getAttributeStringWithAttributeArray:transferedBounsArray];
    self.transferedBounsLabel.attributedText = transferedString;
    
}

@end
