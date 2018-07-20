//
//  XNGesturePasswordView.h
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/24/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XNGesturePasswordViewDelegate <NSObject>

- (void)gesturePasswordDidCreatePassword:(NSString *)password;

@end

@interface XNGesturePasswordView : UIView

@property (nonatomic, weak) id<XNGesturePasswordViewDelegate> delegate;

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *topTipsLabel;
@property (nonatomic, weak) UILabel *topTipsLabel1;

@property (nonatomic, weak) UIButton *forgotPasswordButton;
@property (nonatomic, weak) UIButton *loginWithOthersButton;
@property (nonatomic, weak) UIButton *backButton;

@property (nonatomic, weak) UIView *gestureDotsContentView;
@property (nonatomic, weak) UIView *separatorView;

#pragma mark - reset draw
- (void)resetPasswordStatus;

- (void)layoutSetGesutre;
- (void)layoutLoginGesture;
- (void)layoutChangeGesture;

@end
