//
//  BaseModule.m
//  FinancialManager
//
//  Created by xnkj on 28/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "BaseModule.h"

@implementation BaseModule

#pragma mark - 数据转化
- (id)convertRetJsonData:(id)jsonData
{
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
       
        NSDictionary* dic = (NSDictionary*)jsonData;
       
        if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            
            if (self.dataDic) {
                
                self.dataDic = nil;
            }
            
            self.dataDic = [dic objectForKey:@"data"];
        }else if([[dic objectForKey:@"data"] isKindOfClass:[NSArray class]])
        {
            if (self.dataArr) {
                
                self.dataArr = nil;
            }
            self.dataArr = [dic objectForKey:@"data"];
        }
        
        ReqCallBackCode* u = [ReqCallBackCode initWithDictionary:dic];
       
        return u;
    }
    
    return nil;
}

#pragma mark - 网络原因导致加载失败
- (void)convertRetWithError:(NSError *)error {
    
    ReqCallBackCode *retCode = [[ReqCallBackCode alloc] init];
    retCode.errorCode = [NSString stringWithFormat:@"%ld", (long)error.code];
    retCode.errorMsg = error.localizedDescription;
    self.retCode = retCode;
    
    //如果网络不好
    self.retCode.errorMsg = ALERT_NO_NETWORK;
}

#pragma mark - 清楚错误对象数据
-(void)clearErrorCode
{
    self.retCode.ret = @"0";
    self.retCode.errorCode = @"";
    self.retCode.errorMsg = @"";
}

@end

@implementation BaseModuleObserver

-(BOOL)isEqual:(id)object {
   
    if ([object isMemberOfClass:[BaseModuleObserver class]]) {
    
        BaseModuleObserver* other = (BaseModuleObserver*)object;
        return other.obj == self.obj;
    }
    
    return NO;
}
@end


@implementation BaseReqCallBackCode

+(BaseReqCallBackCode *)initWithDictionary:(NSDictionary*)dict
{
    if (dict) {
      
        BaseReqCallBackCode* u = [[BaseReqCallBackCode alloc] init];
        NSNumber* retNum = [dict objectForKey:@"code"];
        u.ret = [NSString stringWithFormat:@"%i",[retNum intValue]];
        
        NSNumber* nErrorCode = [dict objectForKey:@"code"];
        
        u.errorCode = [NSString stringWithFormat:@"%i",[nErrorCode intValue]];
        u.errorMsg = [dict objectForKey:@"msg"];
        
        if (![u.errorCode isEqualToString:@"100001"] && ![u.errorCode isEqualToString:@"100002"] && ![u.errorCode isEqualToString:@"100003"] && ![u.errorCode isEqualToString:@"100004"] && ![u.errorCode isEqualToString:@"100005"]) {
            
            u.errorMsg = ALERT_NO_NETWORK;
            return u;
        }
        
        u.detailErrorDic = nil;
        if ([NSObject isValidateObj:[dict objectForKey:@"errors"]] && [[dict objectForKey:@"errors"] isKindOfClass:[NSArray class]] && [[dict objectForKey:@"errors"] count] > 0)
            u.detailErrorDic = [[dict objectForKey:@"errors"] objectAtIndex:0];
        
        return u;
    }
    return nil;
}

@end
