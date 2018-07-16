//
//  JHttpClient.m
//  GXQApp
//
//  Created by ganquan on 11/27/14.
//  Copyright (c) 2014 jinfuzi. All rights reserved.
//

#import "JHttpClient.h"
#import "GXQAppAFNetworkHttpClient.h"

@implementation JHttpClient

+ (instancetype)sharedClient {
    static JHttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[JHttpClient alloc] init];
    });
    
    return _sharedClient;
}

#if 0
- (id )HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(id operation, id responseObject))success
                                                    failure:(void (^)(id operation, NSError *error))failure {
#if USE_AFNETWORKING_SWITCH
    id requestOperation = [[GXQAppAFNetworkHttpClient sharedClient] HTTPRequestOperationWithRequest:request success:success failure:failure];
    return requestOperation;
#else
    //HttpManager* manager = [HttpManager sharedManager];
    //[manager sendhttpRequest:URLString parameters:parameters success:success failure:failure];
    return nil;
#endif
}
#endif

///---------------------------
/// @name Making HTTP Requests
///---------------------------

- (id )GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(id operation, id responseObject))success
                        failure:(void (^)(id operation, NSError *error))failure {

    id request = [[GXQAppAFNetworkHttpClient sharedClient] GET:URLString parameters:parameters success:success failure:failure];
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
#if USE_AFNETWORKING_SWITCH
    id request = [[GXQAppAFNetworkHttpClient sharedClient] HEAD:URLString parameters:parameters success:success failure:failure];
    return request;
#else
    return nil;
#endif
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

    id request = [[GXQAppAFNetworkHttpClient sharedClient] POST:URLString parameters:parameters success:success failure:failure];
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
    id request = [[GXQAppAFNetworkHttpClient sharedClient] POST:URLString parameters:parameters constructingBodyWithBlock:block success:success failure:failure];
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
#if USE_AFNETWORKING_SWITCH
    id request = [[GXQAppAFNetworkHttpClient sharedClient] PUT:URLString parameters:parameters success:success failure:failure];
    return request;
#else
    return nil;
#endif
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
#if USE_AFNETWORKING_SWITCH
    id request = [[GXQAppAFNetworkHttpClient sharedClient] PATCH:URLString parameters:parameters success:success failure:failure];
    return request;
#else
    return nil;
#endif
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
                           success:(void (^)(id operation, id responseObject))success
                           failure:(void (^)(id operation, NSError *error))failure {
#if USE_AFNETWORKING_SWITCH
    id request = [[GXQAppAFNetworkHttpClient sharedClient] DELETE:URLString parameters:parameters success:success failure:failure];
    return request;
#else
    return nil;
#endif
}

@end
