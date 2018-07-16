//
//  XNGesturePasswordView.m
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/24/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "XNGesturePasswordView.h"
#import "XNDeviceUtil.h"
#import "UIColor+XNUtil.h"

#define XN_GESTURE_DOT_WIDTH        56

@interface XNGesturePasswordView ()<XNGesturePasswordViewDelegate>

@property (nonatomic, strong) UIImageView   * bgImageView;
@property (nonatomic, strong) XNGestureView * gestureContentView;

@end

@implementation XNGesturePasswordView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createAndAddSubViews];
        [self createConstraintsForSubViews];
    }
    return self;
}

- (void)createAndAddSubViews {
    
    [self addSubview:self.bgImageView];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitleColor:[UIColor colorWithRed:179/255.0
                                              green:145/255.0
                                               blue:80/255.0
                                              alpha:1.0]
                     forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"XN_Common_back_btn"] forState:UIControlStateNormal];
    [self addSubview:backButton];
    _backButton = backButton;
    
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont systemFontOfSize:16.f];
    title.textColor = MONEYCOLOR;
    title.textAlignment=NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    [self addSubview:title];
    _titleLabel = title;
    
    UILabel *tips = [[UILabel alloc] init];
    tips.font = [UIFont systemFontOfSize:16.f];
    tips.textColor = MONEYCOLOR;
    tips.textAlignment = NSTextAlignmentCenter;
    tips.backgroundColor = [UIColor clearColor];
    [self addSubview:tips];
    _topTipsLabel = tips;
    
    UILabel *tips1 = [[UILabel alloc] init];
    tips1.numberOfLines = 0;
    tips1.font = [UIFont systemFontOfSize:15.f];
    tips1.textColor = UIColorFromHex(0x6464643);
    tips1.textAlignment = NSTextAlignmentCenter;
    tips1.backgroundColor = [UIColor clearColor];
    [self addSubview:tips1];
    _topTipsLabel1 = tips1;
    
    [self addSubview:self.gestureContentView];
    
    UIButton *forgotPassword = [[UIButton alloc] initWithFrame:CGRectZero];
    [forgotPassword setTitle:@"忘记手势密码" forState:UIControlStateNormal];
    [forgotPassword setTitleColor:UIColorFromHex(0x6464643) forState:UIControlStateNormal];
    [forgotPassword.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [forgotPassword.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:forgotPassword];
    _forgotPasswordButton = forgotPassword;
    
    UIButton *fingerPasswordButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [fingerPasswordButton setTitle:@"指纹解锁" forState:UIControlStateNormal];
    [fingerPasswordButton setTitleColor:UIColorFromHex(0x6464643) forState:UIControlStateNormal];
    [fingerPasswordButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [fingerPasswordButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:fingerPasswordButton];
    _fingerPasswordButton = fingerPasswordButton;
    
    [_fingerPasswordButton setHidden:YES];
    if ([_LOGIC integerForKey:XN_USER_FINGER_PASSWORD_SET] == 1) {
        [_fingerPasswordButton setHidden:NO];
    }
    
    UIButton *loginWithOthers = [[UIButton alloc] initWithFrame:CGRectZero];
    [loginWithOthers setTitle:@"使用其他账号登录" forState:UIControlStateNormal];
    [loginWithOthers setTitleColor:UIColorFromHex(0x6464643) forState:UIControlStateNormal];
    [loginWithOthers.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [loginWithOthers.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:loginWithOthers];
    _loginWithOthersButton = loginWithOthers;
    
}

- (void)createConstraintsForSubViews {
    
    weakSelf(weakSelf)
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(weakSelf);
    }];

    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(weakSelf.mas_leading).offset(12);
        make.width.equalTo(@(13));
        make.top.mas_equalTo(weakSelf.mas_top).offset(42);
        make.height.equalTo(@(22));
    }];
    
    // 点与屏幕边框的距离是两点之间距离的1.5倍
    CGFloat dotLeftGap = ([XNDeviceUtil screenWidth] - XN_GESTURE_DOT_WIDTH * 3) * 1.5 / 5.f;
    
    [self.gestureContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@([XNDeviceUtil screenWidth]));
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.height.equalTo(@([XNDeviceUtil screenWidth] - dotLeftGap * 2));
        make.centerY.equalTo(weakSelf.mas_centerY).offset(30);
    }];

    [_forgotPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(@(weakSelf.bottom)).offset(-20);
        make.left.equalTo(@(weakSelf.left)).offset(30);
        make.height.equalTo(@(50));
    }];
    
    if ([_LOGIC deviceSupportfingerPassword]) {
       
        [_fingerPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(@(weakSelf.bottom)).offset(-20);
            make.centerX.equalTo(weakSelf.mas_centerX);
            make.height.equalTo(@(50));
        }];
    }
    
    [_loginWithOthersButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(@(weakSelf.bottom)).offset(-20);
        make.right.equalTo(@(weakSelf.right)).offset(-30);
        make.height.equalTo(@(50));
    }];
}

#pragma mark - 设置手势密码更新约束
- (void)layoutSetGesutre
{
    [self.backButton setHidden:YES];
    [self.topTipsLabel setHidden:YES];
    [self.forgotPasswordButton setHidden:YES];
    [self.fingerPasswordButton setHidden:YES];
    [self.loginWithOthersButton setHidden:YES];
    
    weakSelf(weakSelf)
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
     
        make.top.mas_equalTo(weakSelf.mas_top).offset(32);
        make.leading.trailing.equalTo(weakSelf);
        make.height.equalTo(@(44));
    }];
    
    CGFloat dotLeftGap = ([XNDeviceUtil screenWidth] - XN_GESTURE_DOT_WIDTH * 3) * 1.5 / 5.f;
    [self.gestureContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@([XNDeviceUtil screenWidth]));
        make.centerX.equalTo(weakSelf);
        make.height.equalTo(@([XNDeviceUtil screenWidth] - dotLeftGap * 2));
        make.centerY.equalTo(weakSelf).offset(30 * (SCREEN_FRAME.size.height / 667.0));
    }];

    
    __weak UIView * tmpGestureView = self.gestureContentView;
    [_topTipsLabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(tmpGestureView.mas_top).offset(- 40 * (SCREEN_FRAME.size.height / 667.0));
        make.leading.trailing.equalTo(weakSelf);
        make.height.mas_equalTo(@(44));
    }];
}

#pragma mark - 修改手势密码更新约束
- (void)layoutChangeGesture
{
    [self.backButton setHidden:NO];
    [self.topTipsLabel setHidden:YES];
    [self.forgotPasswordButton setHidden:YES];
    [self.fingerPasswordButton setHidden:YES];
    [self.loginWithOthersButton setHidden:YES];
    
    weakSelf(weakSelf)
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakSelf.mas_top).offset(32);
        make.leading.trailing.equalTo(weakSelf);
        make.height.equalTo(@(44));
    }];
    
    CGFloat dotLeftGap = ([XNDeviceUtil screenWidth] - XN_GESTURE_DOT_WIDTH * 3) * 1.5 / 5.f;
    [self.gestureContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@([XNDeviceUtil screenWidth]));
        make.centerX.equalTo(weakSelf);
        make.height.equalTo(@([XNDeviceUtil screenWidth] - dotLeftGap * 2));
        make.centerY.equalTo(weakSelf).offset(30 * (SCREEN_FRAME.size.height / 667.0));
    }];
    
    __weak UIView * tmpGestureView = self.gestureContentView ;
    [_topTipsLabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(tmpGestureView.mas_top).offset(- 40 * (SCREEN_FRAME.size.height / 667.0));
        make.leading.trailing.equalTo(weakSelf);
        make.height.mas_equalTo(@(44));
    }];
}

#pragma mark - 手势密码登入更新约束
- (void)layoutLoginGesture
{
    [self.backButton setHidden:YES];
    [self.titleLabel setHidden:YES];
    [self.separatorView setHidden:YES];
    
    weakSelf(weakSelf)
    CGFloat dotLeftGap = ([XNDeviceUtil screenWidth] - XN_GESTURE_DOT_WIDTH * 3) * 1.5 / 5.f;
    [self.gestureContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@([XNDeviceUtil screenWidth]));
        make.centerX.equalTo(weakSelf);
        make.height.equalTo(@([XNDeviceUtil screenWidth] - dotLeftGap * 2));
        make.centerY.equalTo(weakSelf).offset(30 * (SCREEN_FRAME.size.height / 667.0));
    }];
    
    __weak UIView * tmpGestureView = self.gestureContentView;
    [_topTipsLabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(tmpGestureView.mas_top).offset(- 58 * (SCREEN_FRAME.size.height / 667.0));
        make.leading.trailing.equalTo(weakSelf);
        make.height.mas_equalTo(@(44));
    }];
    
    __weak UILabel * tmpTipLabel = _topTipsLabel1;
    [_topTipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(tmpTipLabel.mas_top).offset(0);
        make.leading.trailing.equalTo(weakSelf);
        make.height.equalTo(@(44));
    }];
}

#pragma mark - reset draw
- (void)resetPasswordStatus {

    [self.gestureContentView resetPasswordStatus];
}

//////////////////
#pragma mark- delegate
////////////////////////////////

#pragma mark - 密码
- (void)gesturePasswordDidCreatePassword:(NSString *)password
{
    if ([self.delegate respondsToSelector:@selector(gesturePasswordDidCreatePassword:)]) {
        
        [self.delegate gesturePasswordDidCreatePassword:password];
    }
}

//////////////////
#pragma mark- setter/getter
////////////////////////////////

#pragma mark - gestureContentView
- (XNGestureView *)gestureContentView
{
    if (!_gestureContentView) {
        
        CGFloat dotLeftGap = ([XNDeviceUtil screenWidth] - XN_GESTURE_DOT_WIDTH * 3) * 1.5 / 5.f;

        _gestureContentView = [[XNGestureView alloc]initWithFrame:CGRectMake(0, self.center.y + 30, SCREEN_FRAME.size.width, [XNDeviceUtil screenWidth] - dotLeftGap * 2)];
        
        _gestureContentView.delegate = self;
    }
    return _gestureContentView;
}

#pragma mark - bgImageView
- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        
        _bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"XN_Gesture_Password_bg"]];
    }
    return _bgImageView;
}

@end
