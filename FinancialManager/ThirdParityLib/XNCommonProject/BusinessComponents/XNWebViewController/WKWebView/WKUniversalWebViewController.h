//
//  WKUniversalWebViewController.h
//  FinancialManager
//
//  Created by xnkj on 09/01/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "WKInterfaceController.h"

typedef void(^CompletionBlock)(id data);

@interface WKUniversalWebViewController : WKInterfaceController

/**
 * 设置产品分享
 *
 * params 分享内容字典
 **/
- (void)setSharedOpertionWithParams:(NSDictionary *)params;

/**
 * 设置分享的产品id
 **/
- (void)setSharedProductId:(NSString *)productId;

/**
 * 添加代理桥接方法
 *
 * params methodName 方法名
 * params completion 回调对象
 *
 **/
- (void)addJSBridgeOCMethodName:(NSString *)methodName completionHandle:(CompletionBlock)completion;
@end
