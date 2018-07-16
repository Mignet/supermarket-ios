//
//  UIView+TradePasswordView.h
//  Lhlc
//
//  Created by ancye.Xie on 5/11/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPasswordView.h"

#define WHITE_COLOR [UIColor whiteColor]
#define BLACK_COLOR [UIColor blackColor]

#define COMMON_PADDING 12.0f
#define COMMON_GREY_WORD UIColorFromHex(0x969696)
#define COMMON_LINE_COLOR UIColorFromHex(0xc8c8c8)
#define COMMON_RED UIColorFromHex(0xda3021)
#define COMMON_PAGE_BACKGROUND UIColorFromHex(0xebe7e8)
#define COMMON_BLUE_WORD UIColorFromHex(0x007aff)

@interface TradePasswordViewController : UIViewController

@property (nonatomic, strong) PayPasswordView *passwordView;
@property (nonatomic, assign) id<PasswordViewDelegate> delegate;

- (id)initWithTitle:(NSString *)title;

- (void)refreshAmount;

@end
