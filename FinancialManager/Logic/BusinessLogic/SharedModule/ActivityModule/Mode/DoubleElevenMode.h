//
//  DoubleElevenMode.h
//  FinancialManager
//
//  Created by xnkj on 24/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_DOUBLEELEVEN_HASNEWDOUBLEELEVEN @"hasNewDoubleEleven"

@interface DoubleElevenMode : NSObject

@property (nonatomic, assign) NSInteger hasNewDoubleEleven; //0：没有 1：有

+ (instancetype)initDoubleElevenWithParams:(NSDictionary *)params;
@end
