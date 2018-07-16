//
//  LogicLayer.m
//  GXQApp
//
//  Created by jinfuzi on 14-2-24.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//
#import "LogicLayer.h"
#import "AppFramework.h"
#import "NSString+common.h"
#import "NSString+Digest.h"
#import "UIDevice+Common.h"
#import "AppCommon.h"
#import "CommonReachability.h"
#import "SFHFKeychainUtils.h"

#import "objc/runtime.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

#define FINGER_GESTURE_SUCCESS_TAG @"FINGER_GESTURE_SUCCESS_TAG"
#define FINGER_GESTURE_FAILED_TAG @"FINGER_GESTURE_FAILED_TAG"
#define FINGER_GESTURE_CONTAXT @"FINGER_GESTURE_CONTAXT"

@implementation LogicLayer

#pragma mark - 请求基本的请求url
- (NSString *)getRequestBaseUrl:(NSString *)baseUrl
{
    NSString * requestUrl = [NSString stringWithFormat:@"%@%@",[AppFramework getConfig].XN_REQUEST_HTTPS_BASE_URL,baseUrl];

    return requestUrl;
}

- (NSString *)getShaRequestBaseUrl:(NSString *)baseUrl
{
    
    NSString * requestUrl = @"";

#if APP_OPEN_HTTPS_ENVIRONMENT
    requestUrl = [NSString stringWithFormat:@"%@%@",[AppFramework getConfig].XN_REQUEST_HTTPS_BASE_URL,baseUrl];
#else
    requestUrl = [NSString stringWithFormat:@"%@%@",[AppFramework getConfig].XN_REQUEST_HTTP_BASE_URL,baseUrl];
#endif
    
    return requestUrl;
}

//针对部分接口使用moke数据
- (NSString *)getMockRequestBaseUrl:(NSString *)baseUrl
{
    NSString * requestUrl = @"";

    requestUrl = [NSString stringWithFormat:@"http://10.16.0.204:8080/mockjs/8%@",baseUrl];
    
    return requestUrl;
}

#pragma mark - 
- (NSString *)getImagePathUrlWithBaseUrl:(NSString *)imageUrl
{
    if ([imageUrl hasPrefix:@"http"] || [imageUrl hasPrefix:@"https"]) {
        
        return imageUrl;
    }

    NSString * path = @"";
    if ([NSObject isValidateInitString:imageUrl]) {
        
        path = [NSString stringWithFormat:@"%@%@",[[[XNCommonModule defaultModule] configMode] imgServerUrl],imageUrl];
    }
    
    return path;
}

#pragma mark - 拼接链接
- (NSString *)getComposeUrlWithBaseUrl:(NSString *)base compose:(NSString *)composeStr
{
    NSString * composeUrl = @"";
    
    if ([base componentsSeparatedByString:@"?"].count >= 2) {
        
        composeUrl = [NSString stringWithFormat:@"%@&%@",base, composeStr];
    }else
    {
        composeUrl = [NSString stringWithFormat:@"%@?%@",base, composeStr];
    }
    
    return composeUrl;
}

//分享链接
- (NSString *)getSharedUrlWithBaseUrl:(NSString *)base
{
    NSString * composeUrl = @"";
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString * composeStr = [NSString stringWithFormat:@"fromApp=liecai&os=ios&v=%@",appVersion];
    if ([base componentsSeparatedByString:@"?"].count >= 2) {
        
        composeUrl = [NSString stringWithFormat:@"%@&%@",base, composeStr];
    }else
    {
        composeUrl = [NSString stringWithFormat:@"%@?%@",base, composeStr];
    }
    
    return composeUrl;
}

#pragma mark - 组装网页链接
- (NSString *)getWebUrlWithBaseUrl:(NSString *)base
{
    if ([base hasPrefix:@"http"] || [base hasPrefix:@"https"]) {
        
        return base;
    }
    
    NSString * path = [NSString stringWithFormat:@"%@%@",[AppFramework getConfig].XN_REQUEST_H5_BASE_URL,base];
    
    return path;
}

#pragma mark - 微信分享组装网页链接
- (NSString *)getWeChatWebUrlWithBaseUrl:(NSString *)base
{
    if ([base hasPrefix:@"http"] || [base hasPrefix:@"https"]) {
        
        return base;
    }
    
    NSString * path = [NSString stringWithFormat:@"%@%@",[AppFramework getConfig].WECHAT_XN_REQUEST_H5_BASE_URL,base];
    
    return path;
}

#pragma mark - 是否可以显示引导页面
- (BOOL)canShowGuildViewAt:(UIViewController *)ctrl withKey:(NSString *)key
{
    if ([[_LOGIC getValueForKey:key] isEqualToString:@"1"] && [self canShowViewAt:ctrl])
    {
        
        return YES;
    }
    
    return NO;
}

#pragma mark - 是否能在当前视图显示
- (BOOL)canShowViewAt:(UIViewController *)ctrl
{
    if (_UI.finishedInitStart && [[_UI topController] isEqual:ctrl]) {
        
        return YES;
    }
    
    return NO;
}

#pragma mark - 获取设备id
- (NSString *)getDeviceId
{
    NSString *serviceName = [JFZ_APP_URL stringByAppendingString:COMMON_JFZ_APP_UUID_TAG];
    NSString *peerid = [SFHFKeychainUtils getPasswordForUsername:COMMON_JFZ_APP_UUID_TAG andServiceName:serviceName error:nil];
    if (peerid.length == 0) {
        if (IOS6_OR_LATER) {
            NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
            peerid = [uuid UUIDString];
        } else {
            CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
            NSString *strUUID = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
            peerid = strUUID;
        }
        
        [SFHFKeychainUtils storeUsername:COMMON_JFZ_APP_UUID_TAG andPassword:peerid forServiceName:serviceName updateExisting:YES error:nil];
    }
    
    return peerid;
}

#pragma mark - Get System Params
- (NSString *)getSystemParams
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * dateInterval = [formatter stringFromDate:[NSDate date]];
    
    NSString * app_key = @"channel _ios";
    
    NSString * systemStr = [NSString stringWithFormat:@"v=%@&timestamp=%@&app_key=%@",appVersion,dateInterval,app_key];
   
//    JCLogInfo(@"appVersion:%@,dateInterval:%@,appKey:%@",appVersion,dateInterval,app_key);
    
    return systemStr;
}

- (NSDictionary *)getSystemParamsDictionary
{
    NSString *appClient = @"ios";
    NSString *appKind = @"channel";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *orgNumber = @"App_channel_ios";
    
    NSString *v = XN_SERVICE_INTERFACE_VERSION;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:orgNumber, @"orgNumber", appKind, @"appKind", appClient, @"appClient", appVersion, @"appVersion", v, @"v", timestamp, @"timestamp", nil];
    
    return params;
}

#pragma mark - Sign
- (NSDictionary *)getSignParams:(NSDictionary *)params
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param addEntriesFromDictionary:[self getSystemParamsDictionary]];
    if (param.allKeys.count > 0) {
        
        [param addEntriesFromDictionary:params];
    }
                                   
    //开始对参数进行排序
    NSArray * keyArray = param.allKeys;
    keyArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString * obj1Str =  (NSString *)obj1;
        NSString * obj2Str =  (NSString *)obj2;
        
        NSComparisonResult result = [obj1Str compare:obj2Str];
        
        return result;
    }];
    
    //拼接字符串
    NSString * queryStr = @"";
    NSString * key = @"";
    for (int i = 0 ; i < keyArray.count; i ++) {
        
        key = [keyArray objectAtIndex:i];
        
        queryStr = [queryStr stringByAppendingFormat:@"%@%@",key,[param objectForKey:key]];
    }
    
    //开始进行签名
    NSString * signStr = [NSString stringWithFormat:@"%@%@%@",REQUESTSIGNAPPSECURATE,queryStr,REQUESTSIGNAPPSECURATE];
    
    NSString * signedStr = [signStr md5HexDigest];
    
    [param setObject:signedStr forKey:@"sign"];
    
    return param;
}

#pragma mark - 系统默认数据库操作
- (void)saveValueForKey:(NSString *)key Value:(NSString *)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

- (NSString *)getValueForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *valueStr = [defaults objectForKey:key];
    return valueStr;
}

- (void)saveInt:(int)value key:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:value forKey:key];
    [defaults synchronize];
}

- (NSInteger)integerForKey:(NSString *)defaultName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger value = [[defaults objectForKey:defaultName] integerValue];
    return value;
}

- (void)saveNSDictionary:(NSDictionary *)dict key:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dict forKey:key];
    BOOL bRet = [defaults synchronize];
    
    return ;
}

- (NSArray *)getNSArrayForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *valueArray = [defaults objectForKey:key];
    return valueArray;
}

- (NSDictionary *)getNSDictionaryForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *valueDict = [defaults objectForKey:key];
    return valueDict;
}

#pragma mark - 创建目录
- (void)createXNCommonDirectoryAtPath:(NSString *)directPath
{
    NSString * directoryPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:directPath];
    
    BOOL directory = YES;
    NSError * error = nil;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:directoryPath isDirectory:&directory]) {
        
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
           
            JCLogError(@"创建文件目录失败!!!!!!!!!");
        }
    }
}

- (void)deleteFileAtDirectoryAtPath:(NSString *)path
{
    NSString * directoryPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:path];
    
    BOOL directory = YES;
    NSError * error = nil;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:directoryPath isDirectory:&directory]) {
        
        [fileManager removeItemAtPath:directoryPath error:&error];
    }
}

- (BOOL)isExitDirectory:(NSString *)directory
{
    NSString * filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:directory];
    
    BOOL isDirectory = NO;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

#pragma mark - 是否存在对应的文件
- (BOOL)isExitFileName:(NSString *)fileName
{
    NSString * filePath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:XN_LIBRARY_COMMON_DIRECTORY] stringByAppendingPathComponent:fileName];
    
    BOOL directory = NO;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:filePath isDirectory:&directory];
}

#pragma mark - 本地plist文件处理

- (void)saveDataArray:(NSArray *)arrData intoFileName:(NSString *)fileName
{
    NSString * filePath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:XN_LIBRARY_COMMON_DIRECTORY] stringByAppendingPathComponent:fileName];
    
    BOOL directory = NO;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath isDirectory:&directory]) {
        
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    if (arrData.count > 0)
    [arrData writeToFile:filePath atomically:YES];
}

#pragma mark - 从本地读取数组
- (NSArray *)readDataFromFileName:(NSString *)fileName
{
    NSString * filePath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:XN_LIBRARY_COMMON_DIRECTORY] stringByAppendingPathComponent:fileName];
    
    NSArray * data = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    return data;
}

#pragma mark - 保存字典信息
- (void)saveDataDictionary:(NSDictionary *)dicData intoFileName:(NSString *)fileName
{
    NSString * filePath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:XN_LIBRARY_COMMON_DIRECTORY] stringByAppendingPathComponent:fileName];
    
    BOOL directory = NO;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath isDirectory:&directory]) {
        
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    if (dicData.count > 0)
        [dicData writeToFile:filePath atomically:YES];
}

- (NSDictionary *)readDicDataFromFileName:(NSString *)fileName
{
    NSString * filePath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:XN_LIBRARY_COMMON_DIRECTORY] stringByAppendingPathComponent:fileName];
    
    NSDictionary * data = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    return data;
}

#pragma mark - 将内容写入文件
- (void)saveString:(NSString *)str intoFileName:(NSString *)fileName
{
    NSString * filePath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:XN_LIBRARY_COMMON_DIRECTORY] stringByAppendingPathComponent:fileName];
    
    BOOL directory = NO;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath isDirectory:&directory]) {
        
        [fileManager removeItemAtPath:filePath error:nil];
    }
    
    [fileManager createFileAtPath:filePath contents:[str  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}

#pragma mark - 从文件中读取数据
- (NSString *)readStringFromFileName:(NSString *)fileName
{
    NSString * filePath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:XN_LIBRARY_COMMON_DIRECTORY] stringByAppendingPathComponent:fileName];
    
    return [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - 将图片保存至沙盒
- (BOOL)saveImageIntoLocalBox:(UIImage *)image imageName:(NSString *)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];   // 保存文件的名称
    
    NSData * imageData = UIImageJPEGRepresentation(image, 0.1);
   return [imageData writeToFile: filePath atomically:YES];
}

- (UIImage *)getImageFromLocalBox:(NSString *)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
    
    UIImage * image = [[UIImage alloc]initWithContentsOfFile:filePath];
    
    return image;
}

#pragma mark - 指纹解锁
#pragma mark - 检测设备是否可以使用touch ID 进行指纹解锁
- (BOOL)canEvaluatePolicy
{
    LAContext *context = [[LAContext alloc] init];
    NSError *error;
    BOOL success;
    
    // test if we can evaluate the policy, this test will tell us if Touch ID is available and enrolled
    success = [context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (success) {
        
        return YES;
    }
    
    if ([error.localizedDescription isEqualToString:@""]) {
        
        
    }
    
    return NO;
}

#pragma mark - 开启指纹解锁功能
- (void)evaluatePolicyWithSuccess:(completeUnlock)block failed:(failedUnlock )fail
{
    LAContext *context = [[LAContext alloc] init];
    
    [context setLocalizedFallbackTitle:@""];
    
    objc_setAssociatedObject(self, FINGER_GESTURE_CONTAXT, context, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, FINGER_GESTURE_SUCCESS_TAG, block, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, FINGER_GESTURE_FAILED_TAG, fail, OBJC_ASSOCIATION_RETAIN);
    
    weakSelf(weakSelf)
    // show the authentication UI with our reason string
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"请您按Home键，用指纹解锁应用～", nil) reply:
     ^(BOOL success, NSError *authenticationError) {
         if (success) {
             
             completeBlock block = objc_getAssociatedObject(weakSelf, FINGER_GESTURE_SUCCESS_TAG);
             objc_setAssociatedObject(self, FINGER_GESTURE_CONTAXT, nil, OBJC_ASSOCIATION_RETAIN);
             block();
         } else {
             
            failedUnlock block = objc_getAssociatedObject(weakSelf, FINGER_GESTURE_FAILED_TAG);
            objc_setAssociatedObject(self, FINGER_GESTURE_CONTAXT, nil, OBJC_ASSOCIATION_RETAIN);
             block(authenticationError);
         }
     }];
}

#pragma mark - 取消指纹解锁功能
- (void)cancelFinger
{
    LAContext * context = objc_getAssociatedObject(self, FINGER_GESTURE_CONTAXT);
    
    if ([NSObject isValidateObj:context])
    [context invalidate];
}

#pragma mark - 检测设备是否是iphone5s及以上，且系统是ios8及以上
- (BOOL)deviceSupportfingerPassword
{
    if (IOS8_OR_LATER && IS_WIDTH_SCREEN() && ([[UIDevice deviceDescript] hasPrefix:@"iPhone"] && ![[UIDevice deviceDescript] isEqualToString:@"iPhone5,1"] && ![[UIDevice deviceDescript] isEqualToString:@"iPhone5,2"] && ![[UIDevice deviceDescript] isEqualToString:@"iPhone5,3"] && ![[UIDevice deviceDescript] isEqualToString:@"iPhone5,4"])) {
        
        return YES;
    }
    
    return NO;
}

//设置状态栏的颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color
{
    UIView * statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        
        [statusBar setBackgroundColor:color];
    }
}
@end
