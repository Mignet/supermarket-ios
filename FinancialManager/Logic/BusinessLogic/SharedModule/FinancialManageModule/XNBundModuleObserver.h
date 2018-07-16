//
//  XNBundModuleObserver.h
//  FinancialManager
//
//  Created by ancye.Xie on 8/16/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

@protocol XNBundModuleObserver <NSObject>
@optional
//精选基金
- (void)XNBundModuleHotBundListDidReceive:(XNBundModule *)module;
- (void)XNBundModuleHotBundListDidFailed:(XNBundModule *)module;

//是否注册基金
- (void)XNBundModuleIsRegisterBundDidReceive:(XNBundModule *)module;
- (void)XNBundModuleIsRegisterBundDidFailed:(XNBundModule *)module;

//注册基金
- (void)XNBundModuleRegisterBundDidReceive:(XNBundModule *)module;
- (void)XNBundModuleRegisterBundDidFailed:(XNBundModule *)module;

//奕丰基金详情页跳转
- (void)XNBundModuleRegisterGotoBundDetailDidReceive:(XNBundModule *)module;
- (void)XNBundModuleRegisterGotoBundDetailDidFailed:(XNBundModule *)module;

//奕丰基金个人资产页跳转
- (void)XNBundModuleGotoBundAccountDidReceive:(XNBundModule *)module;
- (void)XNBundModuleGotoBundAccountDidFailed:(XNBundModule *)module;

//基金列表
- (void)XNBundModuleBundListDidReceive:(XNBundModule *)module;
- (void)XNBundModuleBundListDidFailed:(XNBundModule *)module;

//基金类型选择
- (void)XNBundModuleBundTypeSelectorDidReceive:(XNBundModule *)module;
- (void)XNBundModuleBundTypeSelectorDidFailed:(XNBundModule *)module;

//我的基金-持有资产
- (void)XNBundModuleMyBundHoldingStatisticDidReceive:(XNBundModule *)module;
- (void)XNBundModuleMyBundHoldingStatisticDidFailed:(XNBundModule *)module;

//我的基金-持有明细
- (void)XNBundModuleMyBundHoldingDetailDidReceive:(XNBundModule *)module;
- (void)XNBundModuleMyBundHoldingDetailDidFailed:(XNBundModule *)module;

//基金投资记录
- (void)XNBundModuleMyFundRecordingDidReceive:(XNBundModule *)module;
- (void)XNBundModuleMyFundRecordingDidFailed:(XNBundModule *)module;


@end
