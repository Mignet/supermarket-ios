//
//  JFZAppModuleBase.m
//  JinFuZiApp
//
//  Created by ganquan on 3/26/15.
//  Copyright (c) 2015 com.jinfuzi. All rights reserved.
//

#import "AppModuleBase.h"

@implementation AppModuleBase

- (id)convertRetJsonData:(id)jsonData
{
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dic = (NSDictionary*)jsonData;
        
        _dataDic = nil;
        _dataArr = nil;
        if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
        
            _dataDic = [dic objectForKey:@"data"];
        }else if([[dic objectForKey:@"data"] isKindOfClass:[NSArray class]])
        {
            _dataArr = [dic objectForKey:@"data"];
        }
        
        ReqCallBackCode* u = [ReqCallBackCode initWithDictionary:dic];
        
        //如果token失效，则进行重新登入操作
        if ([[dic objectForKey:@"code"] isEqualToString:@"100003"]) {
            
            u.errorMsg = @"";
            u.detailErrorDic = nil;
            [_LOGIC saveValueForKey:XN_USER_TOKEN_TAG Value:@""];
            [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
            [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:[NSNumber numberWithInteger:ILoginSourceMax]];
        }
        
        return u;
    }
    
    return nil;
}

- (void)convertRetWithError:(NSError *)error {
    
    ReqCallBackCode *retCode = [[ReqCallBackCode alloc] init];
    retCode.errorCode = [NSString stringWithFormat:@"%ld", (long)error.code];
    retCode.errorMsg = error.localizedDescription;
    self.retCode = retCode;
    
    //如果网络不好
    self.retCode.errorMsg = ALERT_NO_NETWORK;
}

@end
