//
//  SignShareAward.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/22.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SignShareAwardView.h"
#import "SignShareModel.h"
#import "RedPacketInfoMode.h"
#import "SignShareModel.h"

@interface SignShareAwardView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImgViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *awardLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@property (weak, nonatomic) IBOutlet UIButton *drawBtn;

@property (nonatomic, retain) UIControl *overlayView;
@property (weak, nonatomic) IBOutlet UILabel *daydayLabel;

@end

@implementation SignShareAwardView

+ (instancetype)signShareAwardView
{
    SignShareAwardView *awardView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SignShareAwardView class]) owner:nil options:nil] firstObject];
    awardView.width = SCREEN_FRAME.size.width - 80.f;
    awardView.height = 300.f;
    return awardView;
}

- (void)show
{
    if (self.awardType == No_Award) {
        
        [self.iconImgView setImage:[UIImage imageNamed:@"sign_share_succee_no"]];
        self.titleLabel.text = @"手慢了!";
        self.awardLabel.text = @"今日翻倍奖励已经抢完了!";
        self.drawBtn.hidden = YES;
        self.daydayLabel.hidden = YES;
        
    } else if (self.awardType == Coin_Award) {
        
        [self.iconImgView setImage:[UIImage imageNamed:@"one_coin_img"]];
        
        
    } else if (self.awardType == RedBack_Award) {
        
        
        [self.iconImgView setImage:[UIImage imageNamed:@"sign_share_redpacket.png"]];
    }
    
    
    
    UIWindow *keywindow = [[UIApplication sharedApplication] windows][0];
    [keywindow addSubview:self.overlayView];
    [keywindow addSubview:self];
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f);
    [self fadeIn];
    
}

- (void)dismiss
{
    [self fadeOut];
}

#pragma mark - animations
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)fadeOut
{
    
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.overlayView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

- (IBAction)drawClick
{
    if ([self.delegate respondsToSelector:@selector(signShareAwardViewDid:)]) {
        [self.delegate signShareAwardViewDid:self];
    }
    
    [self dismiss];
}

- (IBAction)closeClick
{
    if ([self.delegate respondsToSelector:@selector(signShareAwardViewDid:)]) {
        [self.delegate signShareAwardViewDid:self];
    }
    
    [self dismiss];
}

/////////////////////////
#pragma mark - setter / getter
//////////////////////////

- (UIControl *)overlayView {
    
    if (!_overlayView) {
        _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.7];
    }
    return _overlayView;
}

- (void)setSignShareModel:(SignShareModel *)signShareModel
{
    _signShareModel = signShareModel;
    
    self.daydayLabel.hidden = YES;
    
    if ([signShareModel.prizeType integerValue] == 1) {
        
        self.drawBtn.hidden = NO;
        self.titleLabel.text = @"恭喜您";
        self.awardLabel.text = nil;
        
        NSArray *propertyArray = @[@{@"range": @"已获得奖励金翻倍",
                                     @"color": UIColorFromHex(0x4F5960),
                                     @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                   @{@"range": [NSString stringWithFormat:@"%@元", signShareModel.bouns],
                                     @"color": UIColorFromHex(0XFD5D5D),
                                     @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                   ];
        
        // 赋值页面上的数据
        NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
        self.awardLabel.attributedText = string;
        
        self.awardLabel.hidden = NO;
        self.msgLabel.hidden = YES;
        
        self.daydayLabel.hidden = NO;
        
    } else if ([signShareModel.prizeType integerValue] == 2) {
    
        self.drawBtn.hidden = YES;
        self.titleLabel.text = @"恭喜您";
        
        self.awardLabel.text = nil;
        
        NSArray *propertyArray = @[@{@"range": @"获得",
                                     @"color": UIColorFromHex(0x4F5960),
                                     @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                   @{@"range": [NSString stringWithFormat:@"%@元", signShareModel.redpacketResponse.redPacketMoney],
                                     @"color": UIColorFromHex(0XFD5D5D),
                                     @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                   
                                   @{@"range": [NSString stringWithFormat:@"%@!", signShareModel.redpacketResponse.name],
                                     @"color": UIColorFromHex(0x4F5960),
                                     @"font": [UIFont fontWithName:@"DINOT" size:17]}
                                   ];
        
        // 赋值页面上的数据
        NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
        self.awardLabel.attributedText = string;
        
        self.awardLabel.hidden = NO;
        
        self.msgLabel.text = @"请到我的-优惠卷-红包查看";
        self.daydayLabel.hidden = NO;
    
    } else {
        
        self.msgLabel.text = [NSString stringWithFormat:@"你已获得签到奖励%@元", signShareModel.bouns];
    }
}


@end
