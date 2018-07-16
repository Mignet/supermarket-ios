//
//  SharedModuleBase.m
//  FinancialManager
//
//  Created by xnkj on 28/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "SharedModuleBase.h"

@interface SharedModuleBase()

@property (nonatomic, strong) NSMutableArray * observers;
@property (nonatomic, strong) NSMutableArray * responseObservers;
@end

@implementation SharedModuleBase

#pragma mark - 添加观察者
-(void)addObserver:(id)observer {
   
    if (!observer || ![observer isKindOfClass:[NSObject class]]) {
        
        assert(0);
        return ;
    }
    
    BaseModuleObserver* mo = [[BaseModuleObserver alloc] init];
    mo.obj = observer;
    if (![self.observers containsObject:mo]) {
        
        [self.observers addObject:mo];
        [self.responseObservers addObject:observer];
    }
}

#pragma mark - 移除观察者
-(void)removeObserver:(id)observer {
    
    for (int i = 0; i < self.observers.count; i++) {
       
        BaseModuleObserver* mo = [self.observers objectAtIndex:i];
        if (mo.obj == observer) {
          
            [self.observers removeObject:mo];
            [self.responseObservers removeObject:observer];
            break;
        }
    }
}

#pragma mark - target-action处理
-(void)notifyObservers:(SEL)selector {
    
    [self notifyObservers:selector withObject:self];
}

-(void) notifyObservers:(SEL)selector withObject:(id)param {
    
    NSArray* observers = self.responseObservers;
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
   
    NSArray* observers = self.responseObservers;
    for (id o in observers) {
    
        if ([o respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [o performSelector:selector withObject:param withObject:param1];
#pragma clang diagnostic pop
        }
    }
}

////////////////////
#pragma mark - setter/getter
////////////////////////////////

#pragma mark - observers
- (NSMutableArray *)observers
{
    if (!_observers) {
        
        _observers = [[NSMutableArray alloc]init];
    }
    
    return _observers;
}

#pragma mark - responseObservers
- (NSMutableArray *)responseObservers
{
    if (!_responseObservers) {
        
        _responseObservers = [[NSMutableArray alloc]init];
    }
    
    NSMutableArray *removedArray = [NSMutableArray array];
    for (ModuleObserver* mo in self.observers) {
      
        if (mo.obj == nil) {
            
            [_responseObservers removeObject:mo.obj];
            [removedArray addObject:mo];
        }
    }
    [self.observers removeObjectsInArray:removedArray];
    
    return _responseObservers;
}
@end
