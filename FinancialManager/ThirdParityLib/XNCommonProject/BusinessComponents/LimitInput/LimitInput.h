//
//  LimitInput.h
//  00001限制输入字符个数
//
//  Created by berChina on 16/6/6.
//  Copyright © 2016年 berchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>


#define PROPERTY_NAME @"LimitInput"

#define DECLARE_PROPERTY(className) \
@interface className (Limit) @end

DECLARE_PROPERTY(UITextField)
DECLARE_PROPERTY(UITextView)


@interface LimitInput : NSObject

@property (nonatomic, assign) BOOL enableLimitCount;

+ (LimitInput *)sharedInstance;

@end
