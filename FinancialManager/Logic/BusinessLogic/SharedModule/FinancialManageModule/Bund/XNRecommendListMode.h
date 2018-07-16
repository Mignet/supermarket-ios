//
//  XNRecommondListMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 10/17/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_RECOMMOND_LIST_MODE_ALL_FEE_LIST @"allFeeList"
#define XN_RECOMMOND_LIST_MODE_HAVE_FEE_LIST @"haveFeeList"
#define XN_RECOMMOND_LIST_MODE_NOT_HAVE_FEE_LIST @"notHaveFeeList"
#define XN_RECOMMOND_LIST_MODE_ORG_ISSTATIC_PRODUCT @"orgIsstaticproduct"

@interface XNRecommendListMode : NSObject

@property (nonatomic, strong) NSArray *allFeeList; //未对接平台所有投资人
@property (nonatomic, strong) NSArray *haveFeeList; //拥有佣金的投资人
@property (nonatomic, strong) NSArray *notHaveFeeList; //无佣金的投资人
@property (nonatomic, assign) NSInteger orgIsstaticproduct; //是未技术对接,1：是 ,0：否 当为1时取allFeeList ，当为0时取haveFeeList和notHaveFeeList

+ (instancetype)initWithObject:(NSDictionary *)params;

@end
