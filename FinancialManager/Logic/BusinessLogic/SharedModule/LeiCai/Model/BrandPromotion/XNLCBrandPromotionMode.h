//
//  XNLCBrandPromotionMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 6/28/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XNLC_BRAND_PROMOTION_HOT_CONTENT @"hotContent"
#define XNLC_BRAND_PROMOTION_HOT_POSTER_LIST @"hotPosterList"
#define XNLC_BRAND_PROMOTION_QRCODE @"qrcode"
#define XNLC_BRAND_PROMOTION_RECOMMENT_CONTENT @"recomContent"
#define XNLC_BRAND_PROMOTION_RECOMMENT_LIST @"recommenList"

@interface XNLCBrandPromotionMode : NSObject

@property (nonatomic, copy) NSString *hotContent; //热点海报内容
@property (nonatomic, strong) NSArray *hotPosterList; //热点海报
@property (nonatomic, copy) NSString *qrcode;
@property (nonatomic, copy) NSString *recomContent; //	精品推荐内容
@property (nonatomic, strong) NSArray *recommenList; //精品推荐

+ (instancetype)initWithObject:(NSDictionary *)params;

@end
