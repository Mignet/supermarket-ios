//
//  XNUMengHelper.m
//  Lhlc
//
//  Created by ancye.Xie on 6/21/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNUMengHelper.h"
#import "UMMobClick/MobClick.h"

@implementation XNUMengHelper

/*!
 @brief 启动友盟统计功能
 */
+ (void)startUMAnalytics
{
    //捕捉异常
    //    [MobClick setCrashReportEnabled:NO];
    
    //当前app版本
    [MobClick setAppVersion:XcodeAppVersion];
    
    /*
     *  reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
     *  channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
     */
//    [MobClick startWithAppkey:UMKEY reportPolicy:BATCH channelId:@"App Store"];
    
    [[UMAnalyticsConfig sharedInstance] setAppKey:[AppFramework getConfig].UMKEY];
    [[UMAnalyticsConfig sharedInstance] setEPolicy:BATCH];
    [[UMAnalyticsConfig sharedInstance] setChannelId:@"App Store"];
    
    [MobClick startWithConfigure:[UMAnalyticsConfig sharedInstance]];
    
//集成测试使用
    //打开友盟sdk调试（注：Release发布时需注释掉此行，减少io消耗）
    //集成测试获取设备id
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:nil];
//    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//
//    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
//    [[UMAnalyticsConfig sharedInstance] setEPolicy:REALTIME];
//    [MobClick setLogEnabled:YES];
    return;
}

/*!
 @brief 开始对应页面访问(在viewWillAppear调用,才能够获取正确的页面访问路径、访问深度（PV）的数据)
 */
+ (void)beginLogPageView:(__unsafe_unretained Class)pageView
{
    [MobClick beginLogPageView:NSStringFromClass(pageView)];
}

/*!
 @brief 结束对应页面访问(在viewDidDisappeary调用，才能够获取正确的页面访问路径、访问深度（PV）的数据)
 */
+ (void)endLogPageView:(__unsafe_unretained Class)pageView
{
    [MobClick endLogPageView:NSStringFromClass(pageView)];
}

/*!
 @brief 事件数量统计
 */

+ (void)umengEvent:(NSString *)eventId
{
    [MobClick event:eventId];
}

+ (void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes
{
    [MobClick event:eventId attributes:attributes];
}

@end
