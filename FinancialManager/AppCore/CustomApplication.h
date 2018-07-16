//
//  CustomApplication.h
//  LHKJ
//
//  Created by LCP on 16-10-08.
//  Copyright (c) 2016年 lhkj. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 使用这个Application监听全部触摸事件，配合定时器实现用户呆滞后自动锁定
 */
@interface CustomApplication : UIApplication

//进入后台
- (void)enterBackgroundMode;

//进入前台
- (void)enterFrontMode;

//重置操作
- (void)resetIdleTimer;
@end
