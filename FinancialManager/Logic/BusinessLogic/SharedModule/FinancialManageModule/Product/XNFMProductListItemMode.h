//
//  XNFMProductListItemMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/14.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_BUYTOTALMONEY @"buyTotalMoney"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_BUYEDTOTALMONEY @"buyedTotalMoney"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_DEADLINE @"deadLineValueText"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_DEADLINEMAXVALUE @"deadLineMaxValue"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_DEADLINEMINVALUE @"deadLineMinValue"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_DEADLINETYPE @"deadLineType"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_ISFIXEDDEADLINE @"isFixedDeadline"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_FIXRATE  @"productRateText"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_FLOWMAXRATE @"flowMaxRate"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_FLOWMINRATE @"flowMinRate"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_ISFLOW   @"isFlow"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_PRODUCTDESC @"productDesc"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_ID @"productId"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_NAME @"productName"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_REMAMONEY @"remaMoney"
#define XN_FM_PRODUCTLIST_ITEM_TYPE_NAME @"typeName"
#define XN_FM_PRODUCTLIST_ITEM_TYPE_VALUE @"typeValue"
#define XN_FM_PRODUCTLIST_ITEM_INVLABELSTR @"lcsLabelStr"
#define XN_FM_PRODUCTLIST_ITEM_OPENTYPE @"detailOpenType"
#define XN_FM_PRODUCTLIST_ITEM_OPENLINKURL @"productDetailUrl"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_SALESTATUS @"status"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_ISQUOTA @"isQuota"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_ISREDEMPTION @"isRedemption"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_BEGINSALETIMETEXT @"beginSaleTimeText"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_IFROOKIE @"ifRookie"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_BUYMAXMONEY @"buyMaxMoney"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_BUYMINMONEY @"buyMinMoney"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_BUYEDTOTALPEOPLE @"buyedTotalPeople"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_CATEID @"cateId"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_CATENAME @"cateName"
#define XN_FM_PRODUCTLSIT_ITEM_PRODUCT_IDENTIFIER @"identifier"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_CFPRECOMMEND @"cfpRecommend"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_CURRENTRECOMMENDPRODUCT @"currentRecomendProduct"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_FEERATIO @"feeRatio"
#define XN_FM_PRODUCTLIST_ITEM_PRUDUCT_REWARDRATIO @"rewardRatio"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_ORGNAME @"orgName"
#define XN_FM_PRODUCTLIST_ITEM_PRUDUCT_ORGNUMBER @"orgNumber"
#define XN_FM_PRODUCTLIST_ITEM_PRUDUCT_THIRDPRODUCTID @"thirdProductId"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_ISHAVEPROGRESS @"isHaveProgress"
#define XN_FM_PRODUCTLIST_ITEM_PRUDUCT_ORGFEETYPE @"orgFeeType"//机构收费类型
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_ASSIGNMENTTIME @"assignmentTime"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_REDEMPTIONTIME @"redemptionTime"
#define XN_FM_PRODUCTLIST_ITEM_PRODUCT_ORG_ISSTATIC_PRODUCT @"orgIsstaticproduct"
#define XN_FM_PRODUCT_ITEM_PRODUCT_LOGO @"productLogo"
#define XN_FM_PRODUCTLIST_ITEM_SALE_START_TIME @"saleStartTime"
#define XN_FM_PRODUCTLIST_ITEM_TIME_NOW @"timeNow"
#define XN_FM_PRODUCTLIST_ITEM_TAG_ARRAY @"tagList"

@interface XNFMProductListItemMode : NSObject

@property (nonatomic, assign) CGFloat    buyTotalMoney;
@property (nonatomic, assign) CGFloat    buyedTotalMoney;
@property (nonatomic, assign) NSInteger  buyedTotalPeople;
@property (nonatomic, strong) NSString * cfpRecommend; //(其他-已推荐，0-未推荐)
@property (nonatomic, strong) NSString * deadLine;
@property (nonatomic, strong) NSString * deadLineMaxValue;
@property (nonatomic, strong) NSString * deadLineMinValue;
@property (nonatomic, assign) NSInteger  deadLineType; //1 天，2 月
@property (nonatomic, assign) NSInteger  isFixedDeadline;
@property (nonatomic, assign) CGFloat    fixRate;
@property (nonatomic, assign) CGFloat    feeRatio;
@property (nonatomic, assign) CGFloat    flowMaxRate;
@property (nonatomic, assign) CGFloat    flowMinRate;
@property (nonatomic, assign) NSInteger  isFlow;  // 1 固定  2 浮动
@property (nonatomic, assign) NSInteger  isQuota;
@property (nonatomic, assign) NSInteger  ifRookie;//是否是新手标(1=新手标|2=非新手标)
@property (nonatomic, assign) NSInteger  isRedemption;
@property (nonatomic, strong) NSString * orgName;
@property (nonatomic, strong) NSString * orgNumber;
@property (nonatomic, strong) NSString * productId;
@property (nonatomic, strong) NSString * productName;
@property (nonatomic, assign) NSInteger  saleStatus; //(产品销售状态:1-在售、2-售罄、3-募集失败)
@property (nonatomic, strong) NSString * thirdProductId;
@property (nonatomic, assign) NSInteger isHaveProgress; //是否拥有产品进度 0=有|1没有
@property (nonatomic, strong) NSString * productLogo;//产品logo
@property (nonatomic, strong) NSArray  * tagArray;//标签数组

@property (nonatomic, strong) NSArray  * productDesc;
@property (nonatomic, assign) CGFloat    remaMoney;
@property (nonatomic, strong) NSString * typeName;
@property (nonatomic, strong) NSString * typeValue;
@property (nonatomic, strong) NSArray  * invLabelStr;
@property (nonatomic, assign) NSInteger  openType;
@property (nonatomic, strong) NSString * openLinkUrl;

@property (nonatomic, strong) NSString * beginSaleTimeText;
@property (nonatomic, assign) CGFloat    buyMaxMoney;
@property (nonatomic, assign) CGFloat    buyMinMoney;
@property (nonatomic, strong) NSString * cateId;
@property (nonatomic, strong) NSString * cateName;
@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSString * currentRecommendProduct;
@property (nonatomic, assign) CGFloat    rewardRatio;

@property (nonatomic, strong) NSString * orgFeeType;
@property (nonatomic, strong) NSString * redemptionTime;
@property (nonatomic, strong) NSString * assignmentTime;

@property (nonatomic, assign) NSInteger orgIsstaticproduct; //是否虚拟机构	1：是 ,0：否
@property (nonatomic, strong) NSString *saleStartTime;//产品销售开始时间
@property (nonatomic, strong) NSString *timeNow; //系统当前时间
@property (nonatomic, assign) NSTimeInterval intervalSecondFromServerTimerToLocalTimer;//加载完毕后用于cell的倒计时处

+ (instancetype )initProductListItemWithObject:(NSDictionary *)params;

@end
