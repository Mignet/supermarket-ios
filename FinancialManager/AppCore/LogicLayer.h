//
//  LogicLayer.h
//  GXQApp
//
//  Created by jinfuzi on 14-2-24.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

typedef void(^completeUnlock)();
typedef void(^failedUnlock)(NSError * error);

typedef NS_ENUM(NSInteger, ServiceType) {
    
    serviceType_User_Module,
    ServiceType_MAX = 1
};

@interface LogicLayer : NSObject

#pragma mark - 微信分享组装网页链接
- (NSString *)getWeChatWebUrlWithBaseUrl:(NSString *)base;

//组装请求链接
- (NSString *)getRequestBaseUrl:(NSString *)baseUrl;

//https
- (NSString *)getShaRequestBaseUrl:(NSString *)baseUrl;

//针对部分接口使用moke数据
- (NSString *)getMockRequestBaseUrl:(NSString *)baseUrl;

//获取图片链接地址
- (NSString *)getImagePathUrlWithBaseUrl:(NSString *)imageUrl;

//拼接链接
- (NSString *)getComposeUrlWithBaseUrl:(NSString *)base compose:(NSString *)composeStr;

//分享链接
- (NSString *)getSharedUrlWithBaseUrl:(NSString *)base;

//组装网页链接
- (NSString *)getWebUrlWithBaseUrl:(NSString *)base;

//是否可显示引导页面
- (BOOL)canShowGuildViewAt:(UIViewController *)ctrl withKey:(NSString *)key;

//是否可显示在当前视图页面
- (BOOL)canShowViewAt:(UIViewController *)ctrl;

//获取数据信息
- (NSString *)getDeviceId;

- (NSString *)getSystemParams;
- (NSDictionary *)getSystemParamsDictionary;
- (NSDictionary *)getSignParams:(NSDictionary *)params;

//本地默认数据库
- (void)saveValueForKey:(NSString *)key Value:(NSString *)value;
- (void)saveNSDictionary:(NSDictionary *)dict key:(NSString *)key;
- (void)saveInt:(int)value key:(NSString *)key;
- (NSString *)getValueForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)defaultName;
- (NSArray *)getNSArrayForKey:(NSString *)key;
- (NSDictionary *)getNSDictionaryForKey:(NSString *)key;

//本地文件
- (void)createXNCommonDirectoryAtPath:(NSString *)directPath;
- (void)deleteFileAtDirectoryAtPath:(NSString *)path;
- (BOOL)isExitDirectory:(NSString *)directory;
- (BOOL)isExitFileName:(NSString *)fileName;

- (void)saveDataArray:(NSArray *)arrData intoFileName:(NSString *)fileName;
- (NSArray *)readDataFromFileName:(NSString *)fileName;

- (void)saveDataDictionary:(NSDictionary *)dicData intoFileName:(NSString *)fileName;
- (NSDictionary *)readDicDataFromFileName:(NSString *)fileName;

- (void)saveString:(NSString *)str intoFileName:(NSString *)fileName;
- (NSString *)readStringFromFileName:(NSString *)fileName;

//将图片保存至沙盒
- (BOOL)saveImageIntoLocalBox:(UIImage *)image imageName:(NSString *)imageName;
- (UIImage *)getImageFromLocalBox:(NSString *)imageName;

//指纹解锁
- (BOOL)canEvaluatePolicy;
- (void)evaluatePolicyWithSuccess:(completeUnlock)block failed:(failedUnlock )fail;
- (BOOL)deviceSupportfingerPassword;
- (void)cancelFinger;

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color;





@end
