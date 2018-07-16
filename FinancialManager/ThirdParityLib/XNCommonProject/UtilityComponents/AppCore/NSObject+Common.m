//
//  NSObject+Common.m
//  GXQApp
//
//  Created by jinfuzi on 14-2-26.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import "NSObject+Common.h"
#import "GXQFramework.h"


@implementation NSObject (Common)

- (UInt64)getUniqueNumber
{
    static UInt64 uNumber = 0;
    return ++uNumber;
}

+ (id)globalClassObject
{
    id obj = [[GXQFramework getObj] getGlobalClassObj:[self class]];
    if (obj == nil) {
        obj = [[self alloc] init];
        [[GXQFramework getObj] addGlobalClassObj:obj];
    }
    return obj;
}

+ (void)releaseGlobalClassObject
{
    [[GXQFramework getObj] removeGlobalClassObj:[self class]];
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
    if ( ![NSObject isValidateObj:object] || [object isEqualToString:@""])
    {
        return NO;
    }
    
    return YES;
}

@end
