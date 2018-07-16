//
//  ModuleBase.m
//  GXQApp
//
//  Created by jinfuzi on 14-2-26.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import "ModuleBase.h"

@implementation ModuleBase

@synthesize observers = __observers;

-(id)init {
    if (self = [super init]) {
        _obervers = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return self;
}

-(void)addObserver:(id)observer {
    if (!observer || ![observer isKindOfClass:[NSObject class]]) {
        
        assert(0);
        return ;
    }
    
    ModuleObserver* mo = [[ModuleObserver alloc] init];
    mo.obj = observer;
    if (![_obervers containsObject:mo]) {
        
        [_obervers addObject:mo];
    }
}

-(void)removeObserver:(id)observer {
    for (int i = 0; i < _obervers.count; i++) {
        ModuleObserver* mo = [_obervers objectAtIndex:i];
        if (mo.obj == observer) {
            [_obervers removeObject:mo];
            break;
        }
    }
}

-(void)notifyObservers:(SEL)selector {
    [self notifyObservers:selector withObject:self];
}

-(void) notifyObservers:(SEL)selector withObject:(id)param {
    NSArray* observers = self.observers;
    for (id o in observers) {
        if ([o respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [o performSelector:selector withObject:param];
#pragma clang diagnostic pop
        }
    }
}

-(void) notifyObservers:(SEL)selector withObject:(id)param withObject:(id)param1 {
    NSArray* observers = self.observers;
    for (id o in observers) {
        if ([o respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [o performSelector:selector withObject:param withObject:param1];
#pragma clang diagnostic pop
        }
    }
}

-(NSArray *)observers {
    
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:_obervers.count];
    NSMutableArray *removedArray = [NSMutableArray array];
    for (ModuleObserver* mo in _obervers) {
        if (mo.obj != nil) {
            [array addObject:mo.obj];
        }
        else {
            
            [removedArray addObject:mo];
        }
    }
    [_obervers removeObjectsInArray:removedArray];
    
    return array;
}

-(void)clearErrorCode
{
    _retCode.ret = @"0";
    _retCode.errorCode = @"";
    _retCode.errorMsg = @"";
}

- (id)convertRetJsonData:(id)jsonData
{
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dic = (NSDictionary*)jsonData;
        _resDic = [dic objectForKey:@"res"];
        
        ReqCallBackCode* u = [ReqCallBackCode initWithDictionary:dic];
        
        if (u.errorCode.length > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GXQNETWORKRESPONSEERRORNOTIFICATION" object:nil userInfo:@{@"GXQNETWORKERRORCODE": u.errorCode}];
        }
        return u;
    }
    
    return nil;
}

- (void)convertRetWithError:(NSError *)error {
    
    ReqCallBackCode *retCode = [[ReqCallBackCode alloc] init];
    retCode.errorCode = [NSString stringWithFormat:@"%ld", (long)error.code];
    retCode.errorMsg = error.localizedDescription;
    self.retCode = retCode;
}

@end

@implementation ModuleObserver

@synthesize obj = _obj;

-(BOOL)isEqual:(id)object {
    if ([object isMemberOfClass:[ModuleObserver class]]) {
        ModuleObserver* other = (ModuleObserver*)object;
        return other.obj == _obj;
    }
    return NO;
}
@end


@implementation ReqCallBackCode

+(ReqCallBackCode *)initWithDictionary:(NSDictionary*)dict
{
    if (dict) {
        
        ReqCallBackCode* u = [[ReqCallBackCode alloc] init];
        NSNumber* retNum = [dict objectForKey:@"code"];
        u.ret = [NSString stringWithFormat:@"%i",[retNum intValue]];
            
        NSNumber* nErrorCode = [dict objectForKey:@"code"];
        
        u.errorCode = [NSString stringWithFormat:@"%i",[nErrorCode intValue]];
        u.errorMsg = [dict objectForKey:@"msg"];
        
        if (![u.errorCode isEqualToString:@"100001"] && ![u.errorCode isEqualToString:@"100002"] && ![u.errorCode isEqualToString:@"100003"] && ![u.errorCode isEqualToString:@"100004"] && ![u.errorCode isEqualToString:@"100005"] && ![u.errorCode isEqualToString:@"100006"]) {
            
            u.errorMsg = ALERT_NO_NETWORK;
            return u;
        }
        
        u.detailErrorDic = nil;
        if ([NSObject isValidateObj:[dict objectForKey:@"errors"]] && [[dict objectForKey:@"errors"] isKindOfClass:[NSArray class]] && [[dict objectForKey:@"errors"] count] > 0)
            u.detailErrorDic = [[dict objectForKey:@"errors"] objectAtIndex:0];
        
        return u;
    }
    return nil;
}

@end
