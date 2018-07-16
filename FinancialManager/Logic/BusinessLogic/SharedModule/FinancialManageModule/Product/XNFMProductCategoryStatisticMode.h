//
//  XNFMProductCategoryStatisticMode.h
//  FinancialManager
//
//  Created by xnkj on 19/09/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/* cateId	分类ID	number
 cateLogo	分类logo	string
 cateName	分类名称	string
 content	分类链接内容	string
 count	产品数量	number
 flowMaxRateStatistics	最大浮动利率统计	number
 flowMinRateStatistics	最小浮动利率统计	number*/

#define XN_FM_PRODUCT_CATEGORY_STATISTIC_CATEID @"cateId"
#define XN_FM_PRODUCT_CATEGORY_STATISTIC_CATELOGO @"cateLogoChannel"
#define XN_FM_PRODUCT_CATEGORY_STATISTIC_CATELOGOINVESTOR @"cateLogoInvestor"
#define XN_FM_PRODUCT_CATEGORY_STATISTIC_CATENAME @"cateName"
#define XN_FM_PRODUCT_CATEGORY_STATISTIC_CONTENT @"urlLink"
#define XN_FM_PRODUCT_CATEGORY_STATISTIC_DECLARE @"cateDeclare"
#define XN_FM_PRODUCT_CATEGORY_STATISTIC_COUNT @"count"
#define XN_FM_PRODUCT_CATEGORY_STATISTIC_FLOWMAXRATESTATISTICS @"flowMaxRateStatistics"
#define XN_FM_PRODUCT_CATEGORY_STATISTIC_FLOWMINRATESTATISTICS @"flowMinRateStatistics"

@interface XNFMProductCategoryStatisticMode : NSObject

@property (nonatomic, strong) NSString * cateId;
@property (nonatomic, strong) NSString * cateLog;
@property (nonatomic, strong) NSString * cateIcon;
@property (nonatomic, strong) NSString * cateName;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * productCount;
@property (nonatomic, strong) NSString * timeLine;
@property (nonatomic, strong) NSString * flowMinStatic;
@property (nonatomic, strong) NSString * flowMaxStatic;

+ (instancetype)initProductCategoryStatisticWithParams:(NSDictionary *)params;
@end
