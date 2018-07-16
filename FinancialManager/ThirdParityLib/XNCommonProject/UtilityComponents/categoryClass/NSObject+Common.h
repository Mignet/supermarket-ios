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

+ (BOOL)containObject:(id)object;

+ (BOOL)isValidateObj:(id)obj;
+ (BOOL)isValidateInitString:(id)object;

//获取配置文件里的数据
- (NSDictionary *)dictionaryFromConfigPlist:(NSString *)fileName fileType:(NSString *)fileType;

//利用一个NSInvocation对象包装一次方法调用（方法调用者、方法名、方法参数、方法返回值）
- (id)performSelectorForClass:(Class)class selector:(SEL)selector withObjects:(NSArray *)objects;
//- (id)performSelector:(SEL)selector withObjects:(NSArray *)objects;


@end
