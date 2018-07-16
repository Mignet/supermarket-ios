//
//  DeportMoneyModuleObserver.h
//  XNCommonProject
//
//  Created by xnkj on 4/26/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

@class DeportMoneyModule;
@protocol DeportMoneyModuleObserver <NSObject>
@optional

//查询打款信息
- (void)XNAccountModuleUserBindBankCardInfoDidReceive:(DeportMoneyModule *)module;
- (void)XNAccountModuleUserBindBankCardInfoDidFailed:(DeportMoneyModule *)module;

//提款银行卡信息
- (void)XNAccountModuleWithDrawBankCardInfoDidReceive:(DeportMoneyModule *)module;
- (void)XNAccountModuleWithDrawBankCardInfoDidFailed:(DeportMoneyModule *)module;

//提款
- (void)XNAccountModuleWithDrawDidReceive:(DeportMoneyModule *)module;
- (void)XNAccountModuleWithDrawDidFailed:(DeportMoneyModule *)module;

//查询省份
- (void)XNAccountModuleGetProvinceDidReceive:(DeportMoneyModule *)module;
- (void)XNAccountModuleGetProvinceDidFailed:(DeportMoneyModule *)module;

//查询城市
- (void)XNAccountModuleGetCityDidReceive:(DeportMoneyModule *)module;
- (void)XNAccountModuleGetCityDidFailed:(DeportMoneyModule *)module;

//提现累计值
- (void)XNAccountModuleMyAccountTotalDeportDidReceive:(DeportMoneyModule *)module;
- (void)XNAccountModuleMyAccountTotalDeportDidFailed:(DeportMoneyModule *)module;

//提现记录列表
- (void)XNAccountModuleMyAccountDeportListDidReceive:(DeportMoneyModule *)module;
- (void)XNAccountModuleMyAccountDeportListDidFailed:(DeportMoneyModule *)module;
@end
