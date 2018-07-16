//
//  DateFormatter.m
//  FinancialManager
//
//  Created by xnkj on 23/02/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "DateFormatter.h"

@implementation DateFormatter

//由于比较耗用性能，故创建单例
+ (instancetype)defaultManager
{
    static DateFormatter * defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        defaultManager = [[DateFormatter alloc]init];
    });
    
    return defaultManager;
}
@end
