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

#define XN_GESTURE_DOT_WIDTH        65

@interface XNGesturePasswordView ()

@property (nonatomic, strong) NSMutableArray *gestureDots;
@property (nonatomic, strong) NSMutableArray *selectedIndexes;

@property (nonatomic, assign) CGPoint currentTouchPoint;

@end

@implementation XNGesturePasswordView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createAndAddSubViews];
        [self createConstraintsForSubViews];
        [self createGestureDots];
        [self layoutGestureDots];
        
        _selectedIndexes = [NSMutableArray array];
    }
    return self;
}

- (void)createAndAddSubViews {
    
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
    title.textColor = [UIColor whiteColor];
    title.textAlignment=NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    [self addSubview:title];
    _titleLabel = title;
    
    UILabel *tips = [[UILabel alloc] init];
    tips.font = [UIFont systemFontOfSize:16.f];
    tips.textColor = [UIColor whiteColor];
    tips.textAlignment = NSTextAlignmentCenter;
    tips.backgroundColor = [UIColor clearColor];
    [self addSubview:tips];
    _topTipsLabel = tips;
    
    UILabel *tips1 = [[UILabel alloc] init];
    tips1.numberOfLines = 0;
    tips1.font = [UIFont systemFontOfSize:15.f];
    tips1.textColor = [UIColor whiteColor];
    tips1.textAlignment = NSTextAlignmentCenter;
    tips1.backgroundColor = [UIColor clearColor];
    [self addSubview:tips1];
    _topTipsLabel1 = tips1;
    
    UIButton *forgotPassword = [[UIButton alloc] initWithFrame:CGRectZero];
    [forgotPassword setTitle:@"忘记手势密码" forState:UIControlStateNormal];
    [forgotPassword.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [forgotPassword.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:forgotPassword];
    _forgotPasswordButton = forgotPassword;
    
    UIButton *loginWithOthers = [[UIButton alloc] initWithFrame:CGRectZero];
    [loginWithOthers setTitle:@"使用其他账号登录" forState:UIControlStateNormal];
    [loginWithOthers.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [loginWithOthers.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:loginWithOthers];
    _loginWithOthersButton = loginWithOthers;
}

- (void)createConstraintsForSubViews {
    
    weakSelf(weakSelf)
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(weakSelf.mas_leading).offset(12);
        make.width.equalTo(@(13));
        make.top.mas_equalTo(weakSelf.mas_top).offset(42);
        make.height.equalTo(@(22));
    }];
    
    [_forgotPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(@(self.bottom)).offset(-20);
        make.left.equalTo(@(self.left)).offset(30);
        make.height.equalTo(@(50));
    }];
    
    [_loginWithOthersButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(@(self.bottom)).offset(-20);
        make.right.equalTo(@(self.right)).offset(-30);
        make.height.equalTo(@(50));
    }];
}

- (void)createGestureDots {
    
    UIView *dotsContent = [[UIView alloc] init];
    dotsContent.backgroundColor = [UIColor clearColor];
    [self addSubview:dotsContent];
    _gestureDotsContentView = dotsContent;
    
    _gestureDots = [NSMutableArray arrayWithCapacity:9];
    for (int i = 0; i < 9; i++) {
        
        UIButton *gestureDot = [UIButton buttonWithType:UIButtonTypeCustom];
        gestureDot.tag = i;
        gestureDot.frame = CGRectMake(0, 0, XN_GESTURE_DOT_WIDTH, XN_GESTURE_DOT_WIDTH);
        gestureDot.userInteractionEnabled = NO;
        [gestureDot setImage:[UIImage imageNamed:@"XN_User_Gesture_Normal_btn.png"]  forState:UIControlStateNormal];
        [gestureDot setImage:[UIImage imageNamed:@"XN_User_Gesture_Press_btn.png"]  forState:UIControlStateSelected];
        [_gestureDotsContentView addSubview:gestureDot];
        [_gestureDots addObject:gestureDot];
    }
}

- (void)layoutGestureDots {
    
    // 点与屏幕边框的距离是两点之间距离的1.5倍
    CGFloat dotLeftGap = ([XNDeviceUtil screenWidth] - XN_GESTURE_DOT_WIDTH * 3) * 1.5 / 5.f;
//    CGFloat dotCenterGap = ([XNDeviceUtil screenWidth] - XN_GESTURE_DOT_WIDTH * 3) / 5.f;
    
    [_gestureDotsContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@([XNDeviceUtil screenWidth]));
        make.centerX.equalTo(self);
        make.height.equalTo(@([XNDeviceUtil screenWidth] - dotLeftGap * 2));
        make.centerY.equalTo(self).offset(30);
    }];
    
    [_gestureDots enumerateObjectsUsingBlock:^(UIButton *gestureDot, NSUInteger index, BOOL *stop) {
        
        [gestureDot mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@(XN_GESTURE_DOT_WIDTH));
            make.height.equalTo(@(XN_GESTURE_DOT_WIDTH));
            if (index % 3 == 0) {
                
                make.left.equalTo(_gestureDotsContentView).offset(dotLeftGap);
            } else if (index % 3 == 1) {
                
                make.centerX.equalTo(_gestureDotsContentView);
            } else if (index % 3 == 2) {
                
                make.right.equalTo(_gestureDotsContentView).offset(-dotLeftGap);
            }
            if (index / 3 == 0) {
                
                make.top.equalTo(_gestureDotsContentView);
            } else if (index / 3 == 1) {
                
                make.centerY.equalTo(_gestureDotsContentView);
            } else if (index / 3 == 2) {
                
                make.bottom.equalTo(_gestureDotsContentView);
            }
            
        }];
    }];
}

#pragma mark - 设置手势密码更新约束
- (void)layoutSetGesutre
{
    [self.backButton setHidden:YES];
    [self.topTipsLabel setHidden:YES];
    [self.forgotPasswordButton setHidden:YES];
    [self.loginWithOthersButton setHidden:YES];
    
    weakSelf(weakSelf)
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
     
        make.top.mas_equalTo(weakSelf.mas_top).offset(32);
        make.leading.trailing.equalTo(weakSelf);
        make.height.equalTo(@(44));
    }];
    
    CGFloat dotLeftGap = ([XNDeviceUtil screenWidth] - XN_GESTURE_DOT_WIDTH * 3) * 1.5 / 5.f;
    [_gestureDotsContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@([XNDeviceUtil screenWidth]));
        make.centerX.equalTo(weakSelf);
        make.height.equalTo(@([XNDeviceUtil screenWidth] - dotLeftGap * 2));
        make.centerY.equalTo(weakSelf).offset(30 * (SCREEN_FRAME.size.height / 667.0));
    }];

    
    __weak UIView * tmpGestureView = _gestureDotsContentView;
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
    [self.loginWithOthersButton setHidden:YES];
    
    weakSelf(weakSelf)
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakSelf.mas_top).offset(32);
        make.leading.trailing.equalTo(weakSelf);
        make.height.equalTo(@(44));
    }];
    
    CGFloat dotLeftGap = ([XNDeviceUtil screenWidth] - XN_GESTURE_DOT_WIDTH * 3) * 1.5 / 5.f;
    [_gestureDotsContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@([XNDeviceUtil screenWidth]));
        make.centerX.equalTo(weakSelf);
        make.height.equalTo(@([XNDeviceUtil screenWidth] - dotLeftGap * 2));
        make.centerY.equalTo(weakSelf).offset(30 * (SCREEN_FRAME.size.height / 667.0));
    }];
    
    
    __weak UIView * tmpGestureView = _gestureDotsContentView;
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
    [_gestureDotsContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@([XNDeviceUtil screenWidth]));
        make.centerX.equalTo(weakSelf);
        make.height.equalTo(@([XNDeviceUtil screenWidth] - dotLeftGap * 2));
        make.centerY.equalTo(weakSelf).offset(30 * (SCREEN_FRAME.size.height / 667.0));
    }];
    
    
    __weak UIView * tmpGestureView = _gestureDotsContentView;
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

#pragma mark - touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    UIButton *gestureDot = [self gestureDotContainsPoint:location];
    if (gestureDot) {
        
        [_selectedIndexes addObject:[NSNumber numberWithInteger:gestureDot.tag]];
        [gestureDot setSelected:YES];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    UIButton *gestureDot = [self gestureDotContainsPoint:location];
    
    if ([_selectedIndexes count] > 0) {
        
        // 第一个点已经选中之后的移动
        if (gestureDot) {
            
            [_selectedIndexes addObject:[NSNumber numberWithInteger:gestureDot.tag]];
            [gestureDot setSelected:YES];
            _currentTouchPoint = [self convertPoint:gestureDot.center fromView:_gestureDotsContentView];
        } else {
            
            _currentTouchPoint = location;
        }
        
        [self setNeedsDisplay];
    } else if (gestureDot) {
        
        // 第一个点
        [_selectedIndexes addObject:[NSNumber numberWithInteger:gestureDot.tag]];
        [gestureDot setSelected:YES];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([_selectedIndexes count] > 0) {
        
        [self gestureDidEnd];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([_selectedIndexes count] > 0) {
        
        [self gestureDidEnd];
    }
}

- (UIButton *)gestureDotContainsPoint:(CGPoint)point {
    
    __block UIButton *gestureDot1 = nil;
    [_gestureDots enumerateObjectsUsingBlock:^(UIButton *gestureDot, NSUInteger idx, BOOL *stop) {
        
        CGRect gestureDotFrameInSelf = [self convertRect:gestureDot.frame fromView:_gestureDotsContentView];
        if (CGRectContainsPoint(gestureDotFrameInSelf, point)) {
            
            if (![_selectedIndexes containsObject:[NSNumber numberWithInteger:gestureDot.tag]]) {
                
                gestureDot1 = gestureDot;
            }
            *stop = YES;
        }
    }];
    return gestureDot1;
}

- (void)gestureDidEnd {
    
    UIButton *lastGestureDot = [_gestureDots objectAtIndex:[[_selectedIndexes lastObject] integerValue]];
    if (lastGestureDot) {
        
        _currentTouchPoint = [self convertPoint:lastGestureDot.center fromView:_gestureDotsContentView];
    }
    [self setNeedsDisplay];
    
    NSMutableString *password = [NSMutableString stringWithCapacity:[_selectedIndexes count]];
    [_selectedIndexes enumerateObjectsUsingBlock:^(NSNumber *dotIndex, NSUInteger idx, BOOL *stop) {
        
        [password appendString:[dotIndex stringValue]];
    }];
    
    if (_delegate) {
        
        [_delegate gesturePasswordDidCreatePassword:password];
    }
}

#pragma mark - draw rect
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if ([_selectedIndexes count] > 0) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[UIColor colorWithR:245 G:225 B:148 A:0.5] set];
        CGContextSetLineWidth(context, 5.f);
        [_selectedIndexes enumerateObjectsUsingBlock:^(NSNumber *selectedIndex, NSUInteger idx, BOOL *stop) {
            
            UIButton *gestureDots = [_gestureDots objectAtIndex:[selectedIndex integerValue]];
            
            CGPoint gestureDotPointInSelf = [self convertPoint:gestureDots.center fromView:_gestureDotsContentView];
            
            if (idx == 0) {
                
                CGContextMoveToPoint(context, gestureDotPointInSelf.x, gestureDotPointInSelf.y);
            } else {
                
                CGContextAddLineToPoint(context, gestureDotPointInSelf.x, gestureDotPointInSelf.y);
            }
            
        }];
        
        CGContextAddLineToPoint(context, _currentTouchPoint.x, _currentTouchPoint.y);
        CGContextStrokePath(context);
    }
}

#pragma mark - reset draw
- (void)resetPasswordStatus {
    
    [_selectedIndexes enumerateObjectsUsingBlock:^(NSNumber *dotIndex, NSUInteger idx, BOOL *stop) {
        
        UIButton *gestureDot = [_gestureDots objectAtIndex:[dotIndex integerValue]];
        [gestureDot setSelected:NO];
    }];
    [_selectedIndexes removeAllObjects];
    _currentTouchPoint = CGPointZero;
    [self setNeedsDisplay];
}

@end
