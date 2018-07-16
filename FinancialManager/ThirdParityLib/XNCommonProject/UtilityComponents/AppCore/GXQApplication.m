//
//  GXQApplication.m
//  GXQApp
//
//  Created by ganquan on 14-8-6.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import "GXQApplication.h"
#import "AppCommon.h"

//用户5分钟无操作
const int kUserIdleTimeoutInMinutes = 5;

@implementation GXQApplication

- (void)sendEvent:(UIEvent *)event {
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

- (void)resetIdleTimer
{
    if (_idleTimer) {
        [_idleTimer invalidate];
    }
    
	int timeout = kUserIdleTimeoutInMinutes * 60;
    _idleTimer = [NSTimer scheduledTimerWithTimeInterval:timeout
                                                  target:self
                                                selector:@selector(idleTimerExceeded)
                                                userInfo:nil
                                                 repeats:NO];
    
}

- (void)idleTimerExceeded {

}

@end
