//
//  XNBundModuleObserver.h
//  FinancialManager
//
//  Created by ancye.Xie on 8/16/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

@protocol XNInsuranceModuleObserver <NSObject>
@optional

//精选保险
- (void)XNFinancialManagerModuleSelectedInsuranceItemDidReceive:(XNInsuranceModule *)module;
- (void)XNFinancialManagerModuleSelectedInsuranceItemDidFailed:(XNInsuranceModule *)module;

//保险列表
- (void)XNFinancialManagerModuleInsuranceListDidReceive:(XNInsuranceModule *)module;
- (void)XNFinancialManagerModuleInsuranceListDidFailed:(XNInsuranceModule *)module;

//保险列表
- (void)XNFinancialManagerModuleInsuranceDetailDidReceive:(XNInsuranceModule *)module;
- (void)XNFinancialManagerModuleInsuranceDetailDidFailed:(XNInsuranceModule *)module;

//保险订单
- (void)XNFinancialManagerModuleInsuranceOrderLinkDidReceive:(XNInsuranceModule *)module;
- (void)XNFinancialManagerModuleInsuranceOrderLinkDidFailed:(XNInsuranceModule *)module;

//甄选保险
- (void)insurance_Qixin_Insurance_SelectDidReceive:(XNInsuranceModule *)module;
- (void)insurance_Qixin_Insurance_SelectDidFailed:(XNInsuranceModule *)module;

//保险种类
- (void)insurance_Qixin_Insurance_CategoryDidReceive:(XNInsuranceModule *)module;
- (void)insurance_Qixin_Insurance_CategoryDidFailed:(XNInsuranceModule *)module;

//保险banner
- (void)request_insurance_banner_DidReceive:(XNInsuranceModule *)module;
- (void)request_insurance_banner_DidFailed:(XNInsuranceModule *)module;

//保险测评接口
- (void)request_Qixin_QuestionSummary_DidReceive:(XNInsuranceModule *)module;
- (void)request_Qixin_QuestionSummary_DidFailed:(XNInsuranceModule *)module;

//首页-保险评测结果
- (void)request_Insurance_Qixin_queryQquestionResultDidReceive:(XNInsuranceModule *)module;
- (void)request_Insurance_Qixin_queryQquestionResultDidFailed:(XNInsuranceModule *)module;

//保险测评
- (void)request_insurance_qixin_questionSummaryParamsDidReceive:(XNInsuranceModule *)module;
- (void)request_insurance_qixin_questionSummaryParamsDidFailed:(XNInsuranceModule *)module;



@end
