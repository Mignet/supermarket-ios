//
//  XNLCSaleGoodNewsItemMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 7/26/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XNLC_SALE_GOOD_NEWS_ITEM_MODE_AMOUNT @"amount"
#define XNLC_SALE_GOOD_NEWS_ITEM_MODE_BILLID @"billId"
#define XNLC_SALE_GOOD_NEWS_ITEM_MODE_INVESTTIME @"investTime"
#define XNLC_SALE_GOOD_NEWS_ITEM_MODE_USERNAME @"userName"

@interface XNLCSaleGoodNewsItemMode : NSObject

@property (nonatomic, copy) NSString *amount; //出单金额
@property (nonatomic, copy) NSString *billId; //投资订单ID
@property (nonatomic, copy) NSString *investTime; //出单时间
@property (nonatomic, copy) NSString *userName; //出单者姓名

+ (instancetype)initWithObject:(NSDictionary *)params;

@end
