//
//  GXQFramework.m
//  GXQApp
//
//  Created by jinfuzi on 14-2-24.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import "GXQFramework.h"

@interface GXQFramework ()
{
    NSMutableArray* _arGlobalClassObjs;
}
@end

@implementation GXQFramework


+ (GXQFramework*)getObj
{
    static GXQFramework* obj = nil;
    if (obj == nil) {
        obj = [[GXQFramework alloc] init];
    }
    return obj;
}

+ (GXQFrameworkConfig*)getConfig
{
    return [GXQFramework getObj].config;
}

- (id)init
{
    self = [super init];
    if (self) {
        _config = [[GXQFrameworkConfig alloc] init];
    }
    return self;
}

-(id)getGlobalClassObj:(Class)objClass
{
    if (_arGlobalClassObjs == nil) {
        return nil;
    }
    
    for (id obj in _arGlobalClassObjs) {
        if ([obj class] == objClass) {
            return obj;
        }
    }
    return nil;
}

-(BOOL)addGlobalClassObj:(id)obj
{
    if (_arGlobalClassObjs == nil) {
        _arGlobalClassObjs = [[NSMutableArray alloc] init];
        if (!_arGlobalClassObjs) {
            return NO;
        }
    }
    if (obj == nil) {
        return NO;
    }
    if ([self getGlobalClassObj:[obj class]])
    {
        return NO;
    }
    
    [_arGlobalClassObjs addObject:obj];
    
    return YES;
}

-(BOOL)removeGlobalClassObj:(Class)objClass
{
    if (_arGlobalClassObjs == nil) {
        return NO;
    }
    
    id obj = [self getGlobalClassObj:objClass];
    if (!obj)
    {
        return NO;
    }
    [_arGlobalClassObjs removeObject:obj];
    return YES;
}

@end
