//
//  NSObject+Common.m
//  GXQApp
//
//  Created by jinfuzi on 14-2-26.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import "NSObject+Common.h"
#import "AppFramework.h"


@implementation NSObject (Common)

- (UInt64)getUniqueNumber
{
    static UInt64 uNumber = 0;
    return ++uNumber;
}

+ (id)globalClassObject
{
    id obj = [[AppFramework getObj] getGlobalClassObj:[self class]];
    if (obj == nil) {
        obj = [[self alloc] init];
        [[AppFramework getObj] addGlobalClassObj:obj];
    }
    return obj;
}

+ (void)releaseGlobalClassObject
{
    [[AppFramework getObj] removeGlobalClassObj:[self class]];
}

#pragma mark - 是否有效地对象
+ (BOOL)isValidateObj:(id)obj
{
    if ( obj == nil || [obj isKindOfClass:[NSNull class]] || [obj isEqual:[NSNull null]])
    {
        return NO;
    }
    
    return YES;
}

#pragma mark - 验证是否有效地值
+ (BOOL)isValidateInitString:(id)object
{
    if ( ![NSObject isValidateObj:object] || [[object stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""])
    {
        return NO;
    }
    
    return YES;
}

#pragma mark - 获取配置文件里的数据
- (NSDictionary *)dictionaryFromConfigPlist:(NSString *)fileName fileType:(NSString *)fileType
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}

#pragma mark - 利用一个NSInvocation对象包装一次方法调用（方法调用者、方法名、方法参数、方法返回值）
- (id)performSelectorForClass:(Class)class selector:(SEL)selector withObjects:(NSArray *)objects
//- (id)performSelector:(SEL)selector withObjects:(NSArray *)objects
{
    // 方法签名(方法的描述)
    NSMethodSignature *signature = [class instanceMethodSignatureForSelector:selector];
    if (signature == nil)
    {
        [NSException raise:@"签名无效" format:@"%@方法找不到", NSStringFromSelector(selector)];
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    id obj = [class alloc];
    invocation.target = obj;
    invocation.selector = selector;
    
    //设置参数
    NSInteger nParamCount = signature.numberOfArguments - 2; //除self、_cmd以外的参数个数
    nParamCount = MIN(nParamCount, objects.count);
    for (NSInteger i = 0; i < nParamCount; i++)
    {
        id object = objects[i];
        if ([object isKindOfClass:[NSNull class]] || [object isEqualToString:@"nil"] || [object isEqualToString:@""])
        {
            object = [NSBundle mainBundle];
        }
        [invocation setArgument:&object atIndex:i + 2];
    }
    
    //调用方法
    [invocation invoke];
    
    //获取返回值
    id returnValue = nil;
    // 有返回值类型，才去获得返回值
    if (signature.methodReturnLength)
    {
        [invocation getReturnValue:&returnValue];
    }
    return returnValue;
}

@end
