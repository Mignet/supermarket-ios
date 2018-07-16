//
//  CustomTimer.m
//  FinancialManager
//
//  Created by xnkj on 08/03/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "CustomTimer.h"

@interface CustomTimer()

@property (nonatomic, assign) double intervalTime;
@property (nonatomic, assign) BOOL repeat;

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, copy) HandleBlock block;
@end

@implementation CustomTimer

//设置定时器
- (void)scheduleDispatchTimerWithTimerInterval:(double)intervalTime
                               repeat:(BOOL)repeat
                               handle:(HandleBlock)handleBlock
{
    if (!handleBlock) {
        
        return;
    }
    
    self.block = nil;
    self.block = [handleBlock copy];
    
    self.repeat = repeat;
    self.intervalTime = intervalTime;
        
    if (self.timer) {
            
        dispatch_source_cancel(self.timer);
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t newTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(newTimer, DISPATCH_TIME_NOW, intervalTime * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(newTimer, ^{
        
        self.block();
        
        if (!repeat) {
            
            dispatch_source_cancel(self.timer);
        }
    });
    dispatch_resume(newTimer);
    
    self.timer = newTimer;
}

//取消定时处理
- (void)cancelTimer
{
    if (self.timer) {
        
        dispatch_source_cancel(self.timer);
    }
}

@end
