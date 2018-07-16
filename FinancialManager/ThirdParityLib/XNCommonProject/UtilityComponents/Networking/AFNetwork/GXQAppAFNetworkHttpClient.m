//
//  GXQAppAFNetworkHttpsClient.m
//  GXQApp
//
//  Created by 振增 黄 on 14-11-27.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import "GXQAppAFNetworkHttpClient.h"
#import "AppCommon.h"
#import "AFHTTPRequestOperation+Extension.h"

@interface GXQAppAFNetworkHttpSessionManager : AFHTTPSessionManager

@end

@implementation GXQAppAFNetworkHttpSessionManager

@end

@interface GXQAppAFNetworkHttpRequestOperationManager : AFHTTPRequestOperationManager

@end

@implementation GXQAppAFNetworkHttpRequestOperationManager

@end

@interface GXQAppAFNetworkHttpClient() {
    
}

@property(strong, nonatomic) id<GXQAppAFNetworkClientDelegate> httpClient;

@end

@implementation GXQAppAFNetworkHttpClient

+ (instancetype)sharedClient {
    static GXQAppAFNetworkHttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[GXQAppAFNetworkHttpClient alloc] init];
        
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        if ([systemVersion floatValue] < 7.0)
        {
            NSString *webServiceBaseUrl = [AppFramework getConfig].webServiceBaseUrl;
            GXQAppAFNetworkHttpRequestOperationManager *httpClient = [[GXQAppAFNetworkHttpRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:webServiceBaseUrl]];
            httpClient.requestSerializer = [AFHTTPRequestSerializer serializer];
            httpClient.requestSerializer.timeoutInterval = HTTP_REQUEST_TIMEOUT;
            httpClient.responseSerializer = [AFJSONResponseSerializer serializer];
            httpClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];//[NSSet setWithObject:@"text/html"];
            _sharedClient.httpClient = httpClient;
        }
        else {
            NSString *webServiceBaseUrl = [AppFramework getConfig].webServiceBaseUrl;
            GXQAppAFNetworkHttpSessionManager *httpClient = [[GXQAppAFNetworkHttpSessionManager alloc] initWithBaseURL:[NSURL URLWithString:webServiceBaseUrl]];
            httpClient.requestSerializer = [AFHTTPRequestSerializer serializer];
            httpClient.requestSerializer.timeoutInterval = HTTP_REQUEST_TIMEOUT;
            httpClient.responseSerializer = [AFJSONResponseSerializer serializer];
            httpClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];//[NSSet setWithObject:@"text/html"];
            _sharedClient.httpClient = httpClient;
        }
    });
    
    return _sharedClient;
}

- (id )GET:(NSString *)URLString
parameters:(id)parameters
   success:(void (^)(id operation, id responseObject))success
   failure:(void (^)(id operation, NSError *error))failure {
    return [self.httpClient GET:URLString parameters:parameters success:success failure:failure];
}

- (id )HEAD:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id operation))success
    failure:(void (^)(id operation, NSError *error))failure {
    return [self.httpClient HEAD:URLString parameters:parameters success:success failure:failure];
}

- (id )POST:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id operation, id responseObject))success
    failure:(void (^)(id operation, NSError *error))failure {
    return [self.httpClient POST:URLString parameters:parameters success:success failure:failure];
}

- (id )POST:(NSString *)URLString
 parameters:(id)parameters
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
    success:(void (^)(id operation, id responseObject))success
    failure:(void (^)(id operation, NSError *error))failure {
    return [self.httpClient POST:URLString parameters:parameters constructingBodyWithBlock:block success:success failure:failure];
}

- (id )PUT:(NSString *)URLString
parameters:(id)parameters
   success:(void (^)(id operation, id responseObject))success
   failure:(void (^)(id operation, NSError *error))failure {
    return [self.httpClient PUT:URLString parameters:parameters success:success failure:failure];
}

- (id )PATCH:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id operation, id responseObject))success
     failure:(void (^)(id operation, NSError *error))failure {
    return [self.httpClient PATCH:URLString parameters:parameters success:success failure:failure];
}

- (id )DELETE:(NSString *)URLString
   parameters:(id)parameters
      success:(void (^)(id operation, id responseObject))success
      failure:(void (^)(id operation, NSError *error))failure {
    return [self.httpClient DELETE:URLString parameters:parameters success:success failure:failure];
}

@end
