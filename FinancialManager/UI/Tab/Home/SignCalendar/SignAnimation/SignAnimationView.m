//
//  SignAnimationView.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/17.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SignAnimationView.h"
#import "UserSignModel.h"
#import <AVFoundation/AVFoundation.h>

#define SCALE (SCREEN_FRAME.size.width / 375.f)

@interface SignAnimationView ()

@property (nonatomic, strong) NSMutableArray *animationImgArr;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *animationImgView;
@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UIImageView *coinImgView;

/*** 约束属性 **/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coinWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coinHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animationImgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animationImgTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *bonusLabel;

/*** 音频播放器 **/
@property (strong, nonatomic) AVPlayer *player;

@end

@implementation SignAnimationView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //适配
    self.coinWidth.constant = 103.f * SCALE;
    self.coinHeight.constant = 101.f * SCALE;
    
    self.animationImgHeight.constant = 359.f * SCALE;
    self.animationImgTop.constant = 45.f * SCALE;
    
    
    self.msgLabelTop.constant = 65.f * SCALE;
    
    //self.popViewHeight.constant = 200.f * SCALE;
    
    self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];

    self.popView.alpha = 0;
    self.coinImgView.alpha = 0;
}

///////////////////////////////
#pragma mark - custom method
/////////////////////////////////

+ (instancetype)signAnimationView
{
    SignAnimationView *animationView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SignAnimationView class]) owner:nil options:nil] firstObject];
    return animationView;
}

- (void)startAnimation
{
    // 设置图片的序列帧 图片数组
    self.animationImgView.animationImages = self.animationImgArr;
    //动画重复次数
    self.animationImgView.animationRepeatCount = 1;
    //动画执行时间,多长时间执行完动画
    self.animationImgView.animationDuration = 2.0;
    //开始动画
    [self.animationImgView startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startVoice];
        });
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.popView.alpha = 1;
            self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        });
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1 animations:^{
                self.coinImgView.alpha = 1;
            }];
        });
    });
}

- (IBAction)shareClick
{
    if ([self.delegate respondsToSelector:@selector(signAnimationViewDid:btnClickType:)]) {
        [self.delegate signAnimationViewDid:self btnClickType:Share_Btn_Click];
    }
}

- (IBAction)closeClick
{
    if ([self.delegate respondsToSelector:@selector(signAnimationViewDid:btnClickType:)]) {
        [self.delegate signAnimationViewDid:self btnClickType:Close_Btn_Click];
    }
}

/*** 播放声音 **/
- (void)startVoice
{
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"voice" ofType:@"wav"];

    NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
    
    self.player = [[AVPlayer alloc] initWithURL:audioUrl];
    
    if (self.player == NULL) {
        return;
    }
    
    [self.player setVolume:1];
    [self.player play];
}

///////////////////////////////
#pragma mark - setter / getter
/////////////////////////////////

- (void)setUserSignModel:(UserSignModel *)userSignModel
{
    if ([userSignModel.times floatValue] > 0) {
        
        NSArray *propertyArray = @[@{@"range": @"签到奖励",
                                     @"color": UIColorFromHex(0x4F5960),
                                     @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                   @{@"range": [NSString stringWithFormat:@"%@元", userSignModel.bonus],
                                     @"color": UIColorFromHex(0XFD5D5D),
                                     @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                   
                                   @{@"range": @"+",
                                     @"color": UIColorFromHex(0x4F5960),
                                     @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                   @{@"range":[NSString stringWithFormat:@"%@元*%@", userSignModel.bonus, userSignModel.times],
                                     @"color":UIColorFromHex(0XFD5D5D),
                                     @"font": [UIFont fontWithName:@"DINOT" size:17]}
                                   ];
        
        // 赋值页面上的数据
        NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
        self.bonusLabel.attributedText = string;
        
    } else {
        
        NSArray *propertyArray = @[@{@"range": @"签到奖励",
                                     @"color": UIColorFromHex(0x4F5960),
                                     @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                   @{@"range": [NSString stringWithFormat:@"%@元", userSignModel.bonus],
                                     @"color": UIColorFromHex(0XFD5D5D),
                                     @"font": [UIFont fontWithName:@"DINOT" size:17]},
                                   ];
        
        // 赋值页面上的数据
        NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
        self.bonusLabel.attributedText = string;
    }
}

- (NSMutableArray *)animationImgArr {
    
    if (!_animationImgArr) {
        _animationImgArr = [NSMutableArray arrayWithCapacity:0];
        
        for (NSInteger i = 1; i < 33; i++) {
            
            NSString *imageName = [NSString stringWithFormat:@"animation_%ld.png", i];
            NSBundle *bundle = [NSBundle mainBundle];
            NSString *path = [bundle pathForResource:imageName ofType:nil];
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            [_animationImgArr addObject:image];
        }
    }
    return _animationImgArr;
}

- (void)animationHide
{
    [UIView animateWithDuration:1.0 animations:^{
        
        self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.popView.alpha = 0;
        self.coinImgView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self.popView removeFromSuperview];
        [self.coinImgView removeFromSuperview];
        
        [self removeFromSuperview];
        
        if ([self.delegate respondsToSelector:@selector(signAnimationViewHidden:)]) {
            [self.delegate signAnimationViewHidden:self];
        }
    }];
}

- (AVPlayer *)player {
    
    if (_player == nil) {
        _player = [[AVPlayer alloc] init];
        _player.volume = 1.0; // 默认最大音量
    }
    return _player;
}





@end
