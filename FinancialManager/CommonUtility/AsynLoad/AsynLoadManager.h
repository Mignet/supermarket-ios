//
//  AsynLoad.h
//  FinancialManager
//
//  Created by xnkj on 1/26/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsynLoadManager : NSObject

+ (instancetype)defaultAsynLoadManager;

- (void)loadCustomerList;

- (void)loadCfgList;

@end
