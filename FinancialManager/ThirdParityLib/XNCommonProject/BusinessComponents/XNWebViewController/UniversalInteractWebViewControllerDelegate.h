//
//  UniversalWebViewDelegate.h
//  FinancialManager
//
//  Created by xnkj on 11/01/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

@protocol UniversalInteractWebViewControllerDelegate<NSObject>
@optional

- (void)universalWebViewControllerDidScrollToOffset:(CGFloat )offset;

//调用本地的佣金计算处理
- (void)getAppLhlcsCommissionCalc:(NSDictionary *)params;

//产品推荐
- (void)productRecommend;

//请求产品分享
- (void)getProductSharedContentWithProductId:(NSString *)productId;

- (void)webViewDidSwitchNewWebWithUrl:(NSString *)url;

//进入客服
- (void)webViewEnterChat;

//进入机构详情
- (void)agentDetailSwitch:(NSString *)agentOrgNumber;

//绑卡认证
- (void)bindCardAuthenticate;

//邀请顾客
- (void)invitedCustomer;

//邀请理财师
- (void)invitedCfg;

//判断是否已经绑卡
- (void)authenticateBindCardSuccess;

- (void)buyAction:(NSDictionary *)params;

@end
