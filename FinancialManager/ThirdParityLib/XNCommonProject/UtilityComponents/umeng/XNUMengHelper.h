//
//  XNUMengHelper.h
//  Lhlc
//
//  Created by ancye.Xie on 6/21/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNUMengHelper : NSObject

/*!
 @brief 启动友盟统计功能
 */
+ (void)startUMAnalytics;

/*!
 @brief 开始对应页面访问(在viewWillAppear调用,才能够获取正确的页面访问路径、访问深度（PV）的数据)
 */
+ (void)beginLogPageView:(__unsafe_unretained Class)pageView;

/*!
 @brief 结束对应页面访问(在viewDidDisappeary调用，才能够获取正确的页面访问路径、访问深度（PV）的数据)
 */
+ (void)endLogPageView:(__unsafe_unretained Class)pageView;

/*!
 @brief 事件数量统计
 @param  eventId 网站上注册的事件Id.
 @param attributes 可定义不同属性值
 */

+ (void)umengEvent:(NSString *)eventId; //等同于 event:eventId label:eventId;
+ (void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes;

@end
