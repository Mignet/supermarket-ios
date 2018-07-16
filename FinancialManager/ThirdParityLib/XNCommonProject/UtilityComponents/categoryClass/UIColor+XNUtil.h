//
//  UIColor+XNUtil.h
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/9/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (XNUtil)

#pragma mark - Color from Hex
+ (instancetype)colorFromHexString:(NSString *)hexString;

#pragma mark - RGBA Helper method
+ (instancetype)colorWithR:(CGFloat)red
                         G:(CGFloat)green
                         B:(CGFloat)blue
                         A:(CGFloat)alpha;

@end
