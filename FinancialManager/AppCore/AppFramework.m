//
//  GXQFramework.m
//  GXQApp
//
//  Created by jinfuzi on 14-2-24.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import "AppFramework.h"

@interface AppFramework ()

@property (nonatomic, strong) NSMutableArray * arGlobalClassObjs;
@end

@implementation AppFramework

#pragma mark - cycle

+ (AppFramework*)getObj
{
    static AppFramework* obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        obj = [[AppFramework alloc]init];
    });
    
    return obj;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.config = [[AppFrameworkConfig alloc] init];
        self.globalHandler = [[AppGlobalHandler alloc]init];
    }
    return self;
}

#pragma mark - 自定义方法

//获取配置信息对象
+ (AppFrameworkConfig*)getConfig
{
    return [AppFramework getObj].config;
}

//获取全局对象
+ (AppGlobalHandler *)getGlobalHandler
{
    return [AppFramework getObj].globalHandler;
}

//获取全局对象中保存的对象
-(id)getGlobalClassObj:(Class)objClass
{
    for (id obj in self.arGlobalClassObjs) {
       
        if ([obj class] == objClass) {
          
            return obj;
        }
    }
    
    return nil;
}

//全局对象中保存对象
-(BOOL)addGlobalClassObj:(id)obj
{
    if (obj == nil) {
      
        return NO;
    }
    
    if ([self getGlobalClassObj:[obj class]])
    {
        return NO;
    }
    
    [self.arGlobalClassObjs addObject:obj];
    
    return YES;
}

//全局对象中移除对象
-(BOOL)removeGlobalClassObj:(Class)objClass
{
    id obj = [self getGlobalClassObj:objClass];
    if (!obj)
    {
        return NO;
    }
    
    [self.arGlobalClassObjs removeObject:obj];
    
    return YES;
}

#pragma mark - setter/getter

//arGlobalClassObjs
- (NSMutableArray *)arGlobalClassObjs
{
    if (!_arGlobalClassObjs) {
        
        _arGlobalClassObjs = [[NSMutableArray alloc]init];
    }
    return _arGlobalClassObjs;
}


@end
