//
//  GXQApplication.h
//  GXQApp
//
//  Created by ganquan on 14-8-6.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 使用这个Application监听全部触摸事件，配合定时器实现用户呆滞后自动锁定
 */
@interface GXQApplication : UIApplication
{
    NSTimer *_idleTimer;
}

- (void)resetIdleTimer;

@end
