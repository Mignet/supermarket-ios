//
//  WKHandleBridgeEventManager.h
//  FinancialManager
//
//  Created by xnkj on 09/01/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UniversalInteractWebViewController, XNFMProductListItemMode;
@interface WVHandleBridgeEventManager : NSObject


/**
 * 设置代理
 *
 * params mainWebViewController 代理对象
 **/
- (void)setDelegateMainWebViewController:(UniversalInteractWebViewController *)mainWebViewController;

/**
 * native分享
 *
 * params sharedDictionary 分享字典
 **/
- (void)setNativeSharedDictionary:(NSDictionary *)sharedDictionary;

/**
 * 添加推荐操作
 *
 * */
- (void)setRecommendOperation;

/**
 * 通过产品id进行分享
 *
 * params productId 产品id
 **/
- (void)setSharedProductId:(NSString *)productId;

/**
 * 产品推荐
 **/
- (void)productDetailRecommend:(XNFMProductListItemMode *)productMode;

//调用下一张
- (void)swiperEvent;

//添加右上角邀请操作
- (void)addRightItemWithTitle:(NSString *)title;

/**
 * 页面有大的变化的时候回调用此方法，用以将之前的操作删除
 **/
- (void)changeCurrentPage;

/**
 * 邀请客户操作
 **/
- (void)addRightInvitedCustomer;

/**
 *邀请理财师
 **/
- (void)invitedCfgAfter;

/**产品购买**/
- (void)buyAction:(NSDictionary *)params;

@end
