//
//  NSObject+Common.h
//  GXQApp
//
//  Created by jinfuzi on 14-2-26.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Common)

// 得到唯一的一个64位数字
- (UInt64)getUniqueNumber;

// 产生后不会被主动回收，若想回收则调用xl_releaseGlobalClassObject
// 调用xl_releaseGlobalClassObject后XL框架会释放此对象的引用，对象走正常的生命管理
// 注意：这里得到的对象是通过默认的init函数进行构造的
+ (id)globalClassObject;

+ (void)releaseGlobalClassObject;

+ (BOOL)isValidateObj:(id)obj;
+ (BOOL)isValidateInitString:(id)object;
@end
