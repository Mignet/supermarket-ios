//
//  XNAdViewModule.m
//  XNCommonProject
//
//  Created by xnkj on 5/20/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

#import "XNAdViewModule.h"
#import "NSObject+common.h"
#import "XNAdModuleObserver.h"

#import "UIImageView+WebCache.h"

#define XNADMETHOD @"/homepage/opening"

@implementation XNAdViewModule

#pragma mark - 初始化
+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

#pragma mark - 拉取广告页面
- (void)requestAppAdvertisementWithAppType:(NSString *)appType advType:(NSString *)advType
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                //将相关信息写入本地文件
                [_LOGIC saveDataDictionary:self.dataDic intoFileName:@"openAdvertisement.plist"];
                
                weakSelf(weakSelf)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    NSData * imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[[[weakSelf.dataDic objectForKey:@"datas"] firstObject] objectForKey:XN_ADVERTISEMENT_OPENING_IMGURL]]];
                    
                    [_LOGIC saveImageIntoLocalBox:[UIImage imageWithData:imageData] imageName:@"openAdImage.png"];
                });
                
                
                
                [self notifyObservers:@selector(XNAdModuleDidGetAdSuccess:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNAdModuleDidGetAdFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNAdModuleDidGetAdFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNAdModuleDidGetAdFailed:) withObject:self];
    };
    
    NSDictionary * params = @{@"method":XNADMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNADMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

///////////
#pragma mark - setter/getter
//////////////////////////////

#pragma mark - asyLoadImageView
- (UIImageView *)asyLoadImageView
{
    if (!_asyLoadImageView) {
        
        _asyLoadImageView = [[UIImageView alloc]init];
    }
    return _asyLoadImageView;
}

@end
