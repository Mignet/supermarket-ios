//
//  XNMessageModule.h
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "AppModuleBase.h"

@class DoubleElevenMode;
@interface XNActivityModule : AppModuleBase

@property (nonatomic, strong) DoubleElevenMode * doubleElevenMode;//双十一活动

+ (instancetype)defaultModule;

/**
 * 双十一活动任务
 **/
- (void)requestDoubleEleventActivity;      
@end
