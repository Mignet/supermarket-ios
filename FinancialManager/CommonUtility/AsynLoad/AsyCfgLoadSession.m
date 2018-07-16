//
//  AsyLoadSession.m
//  FinancialManager
//
//  Created by xnkj on 08/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "AsyCfgLoadSession.h"

typedef void(^SuccessBlock)(id operation, id responseObject);
typedef void(^FailedBlock)(id response, NSError * error);

@interface AsyCfgLoadSession()

@property (nonatomic, copy) SuccessBlock sucBlock;
@property (nonatomic, copy) FailedBlock faiBlock;
@end

@implementation AsyCfgLoadSession

+ (instancetype)asyLoadInstance
{
    static AsyCfgLoadSession * distance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
       
        distance = [[AsyCfgLoadSession alloc]init];
    });
    
    return distance;
}

- (void)setSucBlock:(SuccessBlock)sucBlock
{
    if (_sucBlock) {
        
        _sucBlock = nil;
    }
    
    if(sucBlock)
     _sucBlock = [sucBlock copy];
}

- (void)setFaiBlock:(FailedBlock)faiBlock
{
    if (_faiBlock) {
        
        _faiBlock = nil;
    }
    
    if (faiBlock) {
        _faiBlock = [faiBlock copy];
    }
}

- (void)POST:(NSString *)url parameters:(NSDictionary *)params success:(void (^)(id operation, id responseObject))successBlock failure:(void (^)(id operation, NSError * error))failureBlock
{
    if (![NSObject isValidateInitString:url]) {
        
        return;
    }
    
    self.sucBlock = successBlock;
    self.faiBlock = failureBlock;
    
    NSURL * requestUrl = [NSURL URLWithString:url];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:requestUrl];
    request.timeoutInterval = 60.0f;
    request.HTTPMethod = @"POST";
    
    //将参数字符串化
    NSMutableString * parameterString = [NSMutableString string];
    
    for (NSString * key in params.allKeys) {
        
        [parameterString appendFormat:@"%@=%@&", key, [params objectForKey:key]];
    }
    
    NSData * data = [[parameterString substringToIndex:parameterString.length - 1] dataUsingEncoding:NSUTF8StringEncoding];

    //设置请求报文
    request.HTTPBody = data;
    
    //构建session
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession * session = [NSURLSession sessionWithConfiguration:config];
    
    weakSelf(weakSelf)
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
        NSInteger responseStatusCode = [httpResponse statusCode];
        if (responseStatusCode == 200) {
            
            NSError * errorObj = nil;
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&errorObj];
            if (errorObj) {
                
                weakSelf.faiBlock(response, errorObj);
            }else
            {
                weakSelf.sucBlock(object, response);
            }
        }else
        {
             weakSelf.faiBlock(response, error);
        }
    }];
    
    [task resume];
}

@end
