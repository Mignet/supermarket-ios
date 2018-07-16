//
//  GXQAppAFNetworkHttpsClient.m
//  GXQApp
//
//  Created by 振增 黄 on 14-11-27.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import "GXQAppAFNetworkHttpsClient.h"
#import "AppCommon.h"
#import "AFHTTPRequestOperation+Extension.h"
#import "AFURLSessionManager+Extension.h"


@implementation GXQAppAFNetworkHttpsSessionManager

@end

@implementation GXQAppAFNetworkHttpsRequestOperationManager

@end

@interface GXQAppAFNetworkHttpsClient ()

@property(strong, nonatomic) id<GXQAppAFNetworkClientDelegate> httpClient;

@end

@implementation GXQAppAFNetworkHttpsClient

+ (instancetype)sharedClient {
    static GXQAppAFNetworkHttpsClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[GXQAppAFNetworkHttpsClient alloc] init];
        
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        if ([systemVersion floatValue] < 7.0) {
            
            NSString *passportBaseUrl = [AppFramework getConfig].passportBaseUrl;
            
            GXQAppAFNetworkHttpsRequestOperationManager *httpClient = [[GXQAppAFNetworkHttpsRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:passportBaseUrl]];
            httpClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
            httpClient.securityPolicy.allowInvalidCertificates = YES;
            httpClient.requestSerializer = [AFHTTPRequestSerializer serializer];
            httpClient.requestSerializer.timeoutInterval = HTTP_REQUEST_TIMEOUT;
            httpClient.responseSerializer = [AFJSONResponseSerializer serializer];
            httpClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
            _sharedClient.httpClient = httpClient;
        }
        else {
            NSString *passportBaseUrl = [AppFramework getConfig].passportBaseUrl;
            GXQAppAFNetworkHttpsSessionManager *httpClient = [[GXQAppAFNetworkHttpsSessionManager alloc] initWithBaseURL:[NSURL URLWithString:passportBaseUrl]];
            
            //采用CA签发的证书，做证书比对+域名检查+公钥校验+不校验证书链
            httpClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            httpClient.securityPolicy.validatesCertificateChain = NO;
            [httpClient.securityPolicy setAllowInvalidCertificates:NO];
            
            httpClient.requestSerializer = [AFHTTPRequestSerializer serializer];
            httpClient.requestSerializer.timeoutInterval = HTTP_REQUEST_TIMEOUT;
            httpClient.responseSerializer = [AFJSONResponseSerializer serializer];
            httpClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
            _sharedClient.httpClient = httpClient;
        }
        
    });
    
    return _sharedClient;
}

/**
 Creates an `AFHTTPRequestOperation`, and sets the response serializers to that of the HTTP client.
 
 @param request The request object to be loaded asynchronously during execution of the operation.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the created request operation and the object created from the response data of request.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes two arguments:, the created request operation and the `NSError` object describing the network or parsing error that occurred.
 */
/*
- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    AFHTTPRequestOperation *requestOperation = [super HTTPRequestOperationWithRequest:request success:success failure:failure];
    [requestOperation setAuthenticationChallenge];
    
    return requestOperation;
}
*/

///---------------------------
/// @name Making HTTP Requests
///---------------------------

/**
 Creates and runs an `AFHTTPRequestOperation` with a `GET` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the request operation, and the response object created by the client response serializer.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the request operation and the error describing the network or parsing error that occurred.
 
 @see -HTTPRequestOperationWithRequest:success:failure:
 */
- (id )GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(id operation, id responseObject))success
                        failure:(void (^)(id operation, NSError *error))failure {
    id request = [self.httpClient GET:URLString parameters:parameters success:success failure:failure];
    if ([self.httpClient isKindOfClass:[AFURLSessionManager class]]) {
        AFURLSessionManager *pSelf = (AFURLSessionManager *)self.httpClient;
        [pSelf setAuthenticationChallenge];
    }
    else {
        [request setAuthenticationChallenge];
    }
    
    return request;
}

/**
 Creates and runs an `AFHTTPRequestOperation` with a `HEAD` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes a single arguments: the request operation.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the request operation and the error describing the network or parsing error that occurred.
 
 @see -HTTPRequestOperationWithRequest:success:failure:
 */
- (id )HEAD:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(id operation))success
                         failure:(void (^)(id operation, NSError *error))failure {
    id request = [self.httpClient HEAD:URLString parameters:parameters success:success failure:failure];
    if ([self.httpClient isKindOfClass:[AFURLSessionManager class]]) {
        AFURLSessionManager *pSelf = (AFURLSessionManager *)self.httpClient;
        [pSelf setAuthenticationChallenge];
    }
    else {
        [request setAuthenticationChallenge];
    }
    
    return request;
}

/**
 Creates and runs an `AFHTTPRequestOperation` with a `POST` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the request operation, and the response object created by the client response serializer.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the request operation and the error describing the network or parsing error that occurred.
 
 @see -HTTPRequestOperationWithRequest:success:failure:
 */
- (id )POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(id operation, id responseObject))success
                         failure:(void (^)(id operation, NSError *error))failure {
    id request = [self.httpClient POST:URLString parameters:parameters success:success failure:failure];
    if ([self.httpClient isKindOfClass:[AFURLSessionManager class]]) {
        AFURLSessionManager *pSelf = (AFURLSessionManager *)self.httpClient;
    }
    else {
        [request setAuthenticationChallenge];
    }
    
    return request;
}

/**
 Creates and runs an `AFHTTPRequestOperation` with a multipart `POST` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param block A block that takes a single argument and appends data to the HTTP body. The block argument is an object adopting the `AFMultipartFormData` protocol.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the request operation, and the response object created by the client response serializer.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the request operation and the error describing the network or parsing error that occurred.
 
 @see -HTTPRequestOperationWithRequest:success:failure:
 */
- (id )POST:(NSString *)URLString
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(id operation, id responseObject))success
                         failure:(void (^)(id operation, NSError *error))failure {
    id request = [self.httpClient POST:URLString parameters:parameters constructingBodyWithBlock:block success:success failure:failure];
    if ([self.httpClient isKindOfClass:[AFURLSessionManager class]]) {
        AFURLSessionManager *pSelf = (AFURLSessionManager *)self.httpClient;
        [pSelf setAuthenticationChallenge];
    }
    else {
        [request setAuthenticationChallenge];
    }
    
    return request;
}

/**
 Creates and runs an `AFHTTPRequestOperation` with a `PUT` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the request operation, and the response object created by the client response serializer.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the request operation and the error describing the network or parsing error that occurred.
 
 @see -HTTPRequestOperationWithRequest:success:failure:
 */
- (id )PUT:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(id operation, id responseObject))success
                        failure:(void (^)(id operation, NSError *error))failure {
    id request = [self.httpClient POST:URLString parameters:parameters success:success failure:failure];
    if ([self.httpClient isKindOfClass:[AFURLSessionManager class]]) {
        AFURLSessionManager *pSelf = (AFURLSessionManager *)self.httpClient;
        [pSelf setAuthenticationChallenge];
    }
    else {
        [request setAuthenticationChallenge];
    }
    
    return request;
}

/**
 Creates and runs an `AFHTTPRequestOperation` with a `PATCH` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the request operation, and the response object created by the client response serializer.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the request operation and the error describing the network or parsing error that occurred.
 
 @see -HTTPRequestOperationWithRequest:success:failure:
 */
- (id )PATCH:(NSString *)URLString
                       parameters:(id)parameters
                          success:(void (^)(id operation, id responseObject))success
                          failure:(void (^)(id operation, NSError *error))failure {
    id request = [self.httpClient PATCH:URLString parameters:parameters success:success failure:failure];
    if ([self.httpClient isKindOfClass:[AFURLSessionManager class]]) {
        AFURLSessionManager *pSelf = (AFURLSessionManager *)self.httpClient;
        [pSelf setAuthenticationChallenge];
    }
    else {
        [request setAuthenticationChallenge];
    }
    
    return request;
}

/**
 Creates and runs an `AFHTTPRequestOperation` with a `DELETE` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the request operation, and the response object created by the client response serializer.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the request operation and the error describing the network or parsing error that occurred.
 
 @see -HTTPRequestOperationWithRequest:success:failure:
 */
- (id )DELETE:(NSString *)URLString
                        parameters:(id)parameters
                           success:(void (^)(__unused id operation, id responseObject))success
                           failure:(void (^)(id operation, NSError *error))failure {
    id request = [self.httpClient DELETE:URLString parameters:parameters success:success failure:failure];
    if ([self.httpClient isKindOfClass:[AFURLSessionManager class]]) {
        AFURLSessionManager *pSelf = (AFURLSessionManager *)self.httpClient;
        [pSelf setAuthenticationChallenge];
    }
    else {
        [request setAuthenticationChallenge];
    }
    
    return request;
}

/*
 //Test https
 NSDictionary *dict = @{@"cid":@"CJhtQjaQ6so.",
 @"platform":@"1",
 @"version":@"1.4.0",
 @"c_ip":@"192.168.5.119",
 @"c_systemVersion":@"8.1.1",
 @"c_model":@"iPhone",
 @"c_networkType":@"WiFi",
 @"c_identify":@"8109EBDD-0AB8-4607-AE04-702BCBB4B599",
 @"c_userInfo":@"",
 @"c_phone":@"",
 @"c_channelId":@"test",
 @"sign":@"428b3c95442f53ce64f78c9db59c075f"};
 [[GXQAppAFNetworkHttpsClient sharedClient] GET:@"common/Common/RecommendedProduct/" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
 NSLog(@"JSON: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 NSLog(@"Error: %@ response:%@", error, operation.response);
 }];
 
 */

- (id)getHttpClient {
    return _httpClient;
}
@end
