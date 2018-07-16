//
//  XNMessageModule.h
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

@class XNActivityModule;
@protocol XNActivityModuleObserver <NSObject>
@optional

//升级信息
- (void)XNActivityModuleDoubleElevenActivityDidReceive:(XNActivityModule *)module;
- (void)XNActivityModuleDoubleElevenActivityDidFailed:(XNActivityModule *)module;
@end
