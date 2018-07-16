//
//  XNAccountModule.h
//  FinancialManager
//
//  Created by xnkj on 15/10/14.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

@class XNAddBankCardModule;
@protocol XNAddBankCardModuleObserver<NSObject>
@optional

//查询开户行
- (void)XNAccountModuleGetOpenBankInfoDidReceive:(XNAddBankCardModule *)module;
- (void)XNAccountModuleGetOpenBankInfoDidFailed:(XNAddBankCardModule *)module;

//查询银行卡信息
- (void)XNAccountModuleBankBankCardDidReceive:(XNAddBankCardModule *)module;
- (void)XNAccountModuleBankBankCardDidFailed:(XNAddBankCardModule *)module;

//查看用户绑卡信息
- (void)XNAccountModuleGetBindBankCardInfoDidReceive:(XNAddBankCardModule *)module;
- (void)XNAccountModuleGetBindBankCardInfoDidFailed:(XNAddBankCardModule *)module;

//上传银行卡图片
- (void)XNAccountModuleUploadBankCardImageDidReceive:(XNAddBankCardModule *)module;
- (void)XNAccountModuleUploadBankCardImageDidFailed:(XNAddBankCardModule *)module;

//上传生份证图片
- (void)XNAccountModuleUploadIdCardImageDidReceive:(XNAddBankCardModule *)module;
- (void)XNAccountModuleUploadIdCardImageDidFailed:(XNAddBankCardModule *)module;
@end
