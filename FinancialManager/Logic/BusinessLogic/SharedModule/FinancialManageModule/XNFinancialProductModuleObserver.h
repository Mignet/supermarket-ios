//
//  XNFinancialProductModuleObserver.h
//  FinancialManager
//
//  Created by xnkj on 20/09/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

@protocol XNFinancialProductModuleObserver <NSObject>

@optional
//产品列表
- (void)XNFinancialManagerModuleProductStatisticCategoryListDidReceive:(XNFinancialProductModule *)module;
- (void)XNFinancialManagerModuleProductStatisticCategoryListDidFailed:(XNFinancialProductModule *)module;

//选中的产品数量
- (void)xnFinancialManagerModuleConditionProductCountDidReceive:(XNFinancialProductModule *)module;
- (void)XNFinancialManagerModuleConditionSelectedProductCountDidFailed:(XNFinancialProductModule *)module;

//产品详情
- (void)XNFinancialManagerModuleSetProductRecommendDidReceive:(XNFinancialProductModule *)module;
- (void)XNFinancialManagerModuleSetProductRecommendDidFailed:(XNFinancialProductModule *)module;

//取消推荐
- (void)XNFinancialManagerModuleCancelProductRecommendDidReceive:(XNFinancialProductModule *)module;
- (void)XNFinancialManagerModuleCancelProductRecommendDidFailed:(XNFinancialProductModule *)module;

//产品分享
- (void)XNFinancialManagerModuleProductSharedDidReceive:(XNFinancialProductModule *)module;
- (void)XNFinancialManagerModuleProductSharedDidFailed:(XNFinancialProductModule *)module;

//产品推荐列表
- (void)XNFinancialManagerModuleRecommendProductDidReceive:(XNFinancialProductModule *)module;
- (void)XNFinancialManagerModuleRecommendProductDidFailed:(XNFinancialProductModule *)module;

//产品推荐
- (void)XNFinancialManagerModuleRecommendDidReceive:(XNFinancialProductModule *)module;
- (void)XNFinancialManagerModuleRecommendDidFailed:(XNFinancialProductModule *)module;

//机构推荐列表
- (void)XNFinancialManagerModuleRecommendAgentListDidReceive:(XNFinancialProductModule *)module;
- (void)XNFinancialManagerModuleRecommendAgentListDidFailed:(XNFinancialProductModule *)module;

//机构推荐
- (void)XNFinancialManagerModuleRecommendAgentDidReceive:(XNFinancialProductModule *)module;
- (void)XNFinancialManagerModuleRecommendAgentDidFailed:(XNFinancialProductModule *)module;

//热推
- (void)XNFinancialManagermoduleHotRecommendTopDidReceive:(XNFinancialProductModule *)module;
- (void)XNFinancialManagerModuleHotRecommendTopDidFailed:(XNFinancialProductModule *)module;

//精选产品分类列表
- (void)XNFinancialProductModuleSelectProductListDidReceive:(XNFinancialProductModule *)module;
- (void)XNFinancialProductModuleSelectProductListDidFailed:(XNFinancialProductModule *)module;

@end
