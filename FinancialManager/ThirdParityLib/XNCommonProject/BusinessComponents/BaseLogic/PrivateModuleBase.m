//
//  PrivateModuleBase.m
//  FinancialManager
//
//  Created by xnkj on 28/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "PrivateModuleBase.h"

@interface PrivateModuleBase()

@property (nonatomic, weak) id delegate;
@end

@implementation PrivateModuleBase

#pragma mark - 添加观察者
-(void)addObserver:(id)observer {
    
    if (!observer || ![observer isKindOfClass:[NSObject class]]) {
        
        assert(0);
        return ;
    }
    
    self.delegate = observer;
}

#pragma mark - 移除观察者
- (void)removeObserver:(id)observer
{
    self.delegate = nil;
}

#pragma mark - target-action处理
-(void)notifyObservers:(SEL)selector {
    
    [self notifyObservers:selector withObject:self];
}

-(void) notifyObservers:(SEL)selector withObject:(id)param {
        
    if ([self.delegate respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.delegate performSelector:selector withObject:param];
#pragma clang diagnostic pop
    }
}

-(void) notifyObservers:(SEL)selector withObject:(id)param withObject:(id)param1 {
    
    if ([self.delegate respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.delegate performSelector:selector withObject:param withObject:param1];
#pragma clang diagnostic pop
    }
}

- (void)dealloc
{
    self.delegate = nil;
}
@end
