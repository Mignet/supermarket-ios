//
//  XNGesturePasswordViewController.m
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/24/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "XNGesturePasswordViewController.h"

#import "UIColor+XNUtil.h"

@interface XNGesturePasswordViewController ()

@end

@implementation XNGesturePasswordViewController

- (void)loadView {
    [super loadView];
    
    [self initData];
}

//////////////////
#pragma mark - Custom Methods
////////////////////////////////

#pragma mark - 初始化操作
- (void)initData
{
    self.view = self.gesturePasswordView;
    self.gesturePasswordView.backgroundColor = UIColorFromHex(0xdc4437);
}

//////////////////
#pragma mark - Protocal
////////////////////////////////

#pragma mark - XNGesturePasswordViewDelegate
- (void)gesturePasswordDidCreatePassword:(NSString *)password {
    
    [_gesturePasswordView resetPasswordStatus];
}

////////////////
#pragma mark - setter/getter
//////////////////////////////

#pragma mark - gesturePasswordView
- (XNGesturePasswordView *)gesturePasswordView
{
    if (!_gesturePasswordView) {
        
        _gesturePasswordView = [[XNGesturePasswordView alloc] initWithFrame:self.view.bounds];
        _gesturePasswordView.delegate = self;
    }
    return _gesturePasswordView;
}

@end
