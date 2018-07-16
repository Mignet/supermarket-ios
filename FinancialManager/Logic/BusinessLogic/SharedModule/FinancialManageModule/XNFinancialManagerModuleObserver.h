//
//  XNFinancialManagerModule.h
//  FinancialManager
//
//  Created by xnkj on 15/10/14.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

@class XNFinancialManagerModule;
@protocol XNFinancialManagerModuleObserver <NSObject>
@optional

//产品列表
- (void)XNFinancialManagerModuleProductStatisticCategoryListDidReceive:(XNFinancialManagerModule *)module;
- (void)XNFinancialManagerModuleProductStatisticCategoryListDidFailed:(XNFinancialManagerModule *)module;

//热门产品列表
- (void)XNFinancialManagerModuleHotProductStatisticCategoryListDidReceive:(XNFinancialManagerModule *)module;
- (void)XNFinancialManagerModuleHotProductStatisticCategoryListDidFailed:(XNFinancialManagerModule *)module;

//产品分类统计
- (void)XNFinancialManagerModuleProductCategoryStatisticListDidReceive:(XNFinancialManagerModule *)module;
- (void)XNFinancialManagerModuleProductCategoryStatisticListDidFailed:(XNFinancialManagerModule *)module;

//产品详情
- (void)XNFinancialManagerModuleProductDetailDidReceive:(XNFinancialManagerModule *)module;
- (void)XNFinancialManagerModuleProductDetailDidFailed:(XNFinancialManagerModule *)module;

//产品详情
- (void)XNFinancialManagerModuleProductDetailProfitCaculateDidReceive:(XNFinancialManagerModule *)module;
- (void)XNFinancialManagerModuleProductDetailProfitCaculateDidFailed:(XNFinancialManagerModule *)module;

//机构列表
- (void)XNFinancialManagerModuleAgentListDidReceive:(XNFinancialManagerModule *)module;
- (void)XNFinancialManagerModuleAgentListDidFailed:(XNFinancialManagerModule *)module;

//机构筛选条件
- (void)XNFinancialManagerModuleAgentSelectConditionDidReceive:(XNFinancialManagerModule *)module;
- (void)XNFinancialManagerModuleAgentSelectConditionDidFailed:(XNFinancialManagerModule *)module;

//平台信息和详情
- (void)XNFinancialManagerModuleAgentDetailDidReceive:(XNFinancialManagerModule *)module;
- (void)XNFinancialManagerModuleAgentDetailDidFailed:(XNFinancialManagerModule *)module;

//平台在售产品
- (void)XNFinancialManagerModuleAgentSaleProductListDidReceive:(XNFinancialManagerModule *)module;
- (void)XNFinancialManagerModuleAgentSaleProductListDidFailed:(XNFinancialManagerModule *)module;

// 精选平台
- (void)XNFinancialManagerModuleAgentChoicenessPlatformDidReceive:(XNFinancialManagerModule *)module;
- (void)XNFinancialManagerModuleAgentChoicenessPlatformDidFailed:(XNFinancialManagerModule *)module;


//获取产品可用红包
- (void)product_Product_RedPacket_DidReceive:(XNFinancialManagerModule *)module;
- (void)product_Product_RedPacket_DidFailed:(XNFinancialManagerModule *)module;


@end
