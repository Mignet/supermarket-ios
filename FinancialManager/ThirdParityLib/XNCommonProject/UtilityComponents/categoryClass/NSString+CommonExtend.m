//
//  NSString+CommonExtend.m
//  FinancialManager
//
//  Created by xnkj on 15/10/30.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "NSString+CommonExtend.h"
#import "objc/runtime.h"

@implementation NSString(CommonExtend)

+ (void)load
{
    Class currentClass = [self class];
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        SEL oldSetTextSelector = NSSelectorFromString(@"isEqualToString:");
        SEL newSetTextSelector = NSSelectorFromString(@"newisEqualToString:");
        
        Method oldSetTextMethod = class_getInstanceMethod(currentClass, oldSetTextSelector);
        Method newSetTextMethod = class_getInstanceMethod(currentClass, newSetTextSelector);
        
        BOOL result = class_addMethod(currentClass, newSetTextSelector, method_getImplementation(newSetTextMethod), method_getTypeEncoding(oldSetTextMethod));
        if (result) {
            
            class_replaceMethod(currentClass, oldSetTextSelector, method_getImplementation(newSetTextMethod), method_getTypeEncoding(oldSetTextMethod));
        }else
            method_exchangeImplementations(oldSetTextMethod, newSetTextMethod);
    });
}

#pragma mark - 检查uilabel中settext中的字符串是否为空
- (BOOL)newisEqualToString:(NSString *)text
{
    NSString * str = text;
    if (!text || [text isEqual:[NSNull null]] || [text isKindOfClass:[NSNull class]] || [text isEqualToString:@"null"]) {
        
        str = @"";
    }
    
    return [self newisEqualToString:str];
}


@end
