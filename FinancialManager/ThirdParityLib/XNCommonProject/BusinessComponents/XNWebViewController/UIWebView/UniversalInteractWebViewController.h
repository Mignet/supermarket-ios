//
//  UniversalInteractWebViewController.h
//  FinancialManager
//
//  Created by xnkj on 3/23/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNInterfaceController.h"

#import "SharedViewController.h"
#import "UniversalInteractWebViewControllerDelegate.h"

@interface UniversalInteractWebViewController : XNInterfaceController

@property (nonatomic, assign) BOOL currentBindCardOperation;//当前是否处于绑卡处理
@property (nonatomic, assign) BOOL needNewUserGuilder;//是否存在新手指引
@property (nonatomic, assign) id<UniversalInteractWebViewControllerDelegate> delegate;

- (id)initRequestUrl:(NSString *)url requestMethod:(NSString *)requestMethod;

- (id)initRequestUrl:(NSString *)url httpBody:(NSString *)body requestMethod:(NSString *)requestMethod;

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
 * 设置在线客服
 *
 **/
- (void)setCustomerService;

/**
 * 新手指引
 *
 * params rect 位置
 *
 **/
- (void)loadNewUserGuild:(CGRect )rect;

/**
 * 产品推荐
 **/
- (void)setProductDetailRecommend:(XNFMProductListItemMode *)productMode;

@end
