//
//  HttpCacheProtocol.m
//  FinancialManager
//
//  Created by xnkj on 2016/8/4.
//  Copyright © 2016年 xiaoniu. All rights reserved.
//

#import "HttpCacheProtocol.h"
#import "CommonReachability.h"

static NSString * const URLProtocolHandledKey = @"URLProtocolHandledKey";

@interface HttpCacheData:NSObject<NSCoding>

@property (nonatomic, strong) NSData * data;
@property (nonatomic, strong) NSURLResponse * response;
@property (nonatomic, strong) NSURLRequest  * request;
@end

@implementation HttpCacheData

@end

@interface HttpCacheProtocol()<NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection * connect;
@end

@implementation HttpCacheProtocol

//overide whether handle request,if do return YES,or return NO
+(BOOL)canInitWithRequest:(NSURLRequest *)request
{
    //
    NSString * scheme = [[request URL] scheme];
    if ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame || [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame) {
        
        //check the request is handled or not
        //由于url loading system进行url加载的时候会询问这个方法这个自定义类是否需要处理相关的请求，如果需要
        //则返回yes，反之返回no。当返回yes的时候，url loading system会创建一个urlprotocol对象，然后去调用urlconnect/urlsession去获取数据，然而这里也会调用url loading system，这里url loading system
        //同样会调用这个方法，如果返回yes，则形成死循环。为了避免已经处理过的request，我们使用setproperty:forkey：inrequest:来标记那些已经处理过的request
        if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request]) {
            
            return NO;
        }
        return YES;
    }
    return NO;
}

//overide request that send to network
+(NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    NSMutableURLRequest * mutableRequest = [request mutableCopy];
    
    //这里对这个发出去的request做相关的修改，比如：对request添加header，修改host，重定向等等操作
    
    return mutableRequest;
}

//判断两个请求是否相同
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

//开始相应的请求
- (void)startLoading
{
    //先检测当前网络情况
    if (![self useCachePolicy]) {
        
        NSMutableURLRequest * mutableRequest = [[self request] mutableCopy];
        
        [NSURLProtocol setProperty:@(YES) forKey:URLProtocolHandledKey inRequest:mutableRequest];
        
        self.connect = [NSURLConnection connectionWithRequest:mutableRequest delegate:self];
    }else
    {
        
    }
}

//取消相应的请求
- (void)stopLoading
{
    [self.connect cancel];
}

#pragma mark - 当前网络是否可用
- (BOOL)useCachePolicy
{
    BOOL useCache = [[CommonReachability reachabilityWithHostName:[[[self request] URL] host]] currentReachabilityStatus] == Network_NotReachable;
    
    return useCache;
}

#pragma mark - 获取缓存包的路径
- (NSString *)cacheDataPath
{
    NSString * basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * cacheDataName = [[[[self request] URL] absoluteString] md5];
    
    NSString * caseDataPath = [NSString stringWithFormat:@"%@/%@",basePath,cacheDataName];
    
    return caseDataPath;
}
///////////////////
#pragma mark - Protocol
////////////////////////////////////////////////

//在处理网络请求的时候会调用该代理方法，我们需要将受到的消息通过client返回给url loading system
//nsurlconnectdatadelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(nonnull NSURLResponse *)response
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(nonnull NSData *)data
{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.client URLProtocol:self didFailWithError:error];
}

@end
