//
//  CustomApplication.h
//  LHKJ
//
//  Created by LCP on 16-10-08.
//  Copyright (c) 2016年 lhkj. All rights reserved.
//

#import "CustomApplication.h"
#import "AppCommon.h"

//用户5分钟无操作
static float kUserIdleTimeoutInSecond = 600;

@interface CustomApplication()
{
    NSTimer * _idleTimer;
}

@end

@implementation CustomApplication

//重写事件传递
- (void)sendEvent:(UIEvent *)event
{
	[super sendEvent:event];
    
	if(!_idleTimer) {
		[self resetIdleTimer];
	}
    
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0) {
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        if (phase == UITouchPhaseBegan) {
            [self resetIdleTimer];
		}
    }
}

//进入后台
- (void)enterBackgroundMode
{
    kUserIdleTimeoutInSecond = 120;
    
    [self resetIdleTimer];
}

//进入前台
- (void)enterFrontMode
{
    kUserIdleTimeoutInSecond = 600;
    
    [self resetIdleTimer];
}

- (void)resetIdleTimer
{
    if (_idleTimer) {
        [_idleTimer invalidate];
        _idleTimer = nil;
    }

    _idleTimer = [NSTimer scheduledTimerWithTimeInterval:kUserIdleTimeoutInSecond
                                                  target:self
                                                selector:@selector(idleTimerExceeded)
                                                userInfo:nil
                                                 repeats:NO];
}

- (void)idleTimerExceeded {

    [[NSNotificationCenter defaultCenter] postNotificationName:XN_SHOW_GESTURE_PASSWORD_NOTIFICTION object:nil];
}

@end
