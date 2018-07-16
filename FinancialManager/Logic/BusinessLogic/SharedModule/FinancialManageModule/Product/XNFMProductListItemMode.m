//
//  XNFMProductListItemMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/14.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNFMProductListItemMode.h"

@implementation XNFMProductListItemMode

+ (instancetype )initProductListItemWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNFMProductListItemMode * pd = [[XNFMProductListItemMode alloc]init];
        
        pd.buyTotalMoney = [[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_BUYTOTALMONEY] floatValue];
        pd.buyedTotalMoney = [[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_BUYEDTOTALMONEY] floatValue];
        pd.deadLine = [params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_DEADLINE];
        pd.deadLineType = [[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_DEADLINETYPE] integerValue];
        pd.deadLineMaxValue = [NSString stringWithFormat:@"%@",[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_DEADLINEMAXVALUE]];
        pd.deadLineMinValue = [NSString stringWithFormat:@"%@",[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_DEADLINEMINVALUE]];
        pd.fixRate = [[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_FIXRATE] floatValue];
        pd.feeRatio = [[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_FEERATIO] floatValue];
        pd.flowMaxRate = [[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_FLOWMAXRATE] floatValue];
        pd.flowMinRate = [[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_FLOWMINRATE] floatValue];
        pd.isFlow = [[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_ISFLOW] integerValue];
        pd.productId = [params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_ID];
        pd.productName = [params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_NAME];
        pd.saleStatus = [[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_SALESTATUS] integerValue];
        pd.isQuota = [[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_ISQUOTA] integerValue];
        pd.isFixedDeadline = [[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_ISFIXEDDEADLINE] integerValue];
        pd.isRedemption = [[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_ISREDEMPTION] integerValue];
        pd.ifRookie = [[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_IFROOKIE] integerValue];
        pd.buyedTotalPeople = [[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_BUYEDTOTALPEOPLE] integerValue];
        pd.cfpRecommend = [NSObject isValidateObj:[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_CFPRECOMMEND]]?[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_CFPRECOMMEND]:@"1";
        pd.orgName = [params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_ORGNAME];
        pd.orgNumber = [params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRUDUCT_ORGNUMBER];
        pd.thirdProductId = [params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRUDUCT_THIRDPRODUCTID];
        pd.openType = [[params objectForKey:XN_FM_PRODUCTLIST_ITEM_OPENTYPE] integerValue];
        pd.openLinkUrl = [params objectForKey:XN_FM_PRODUCTLIST_ITEM_OPENLINKURL];
        pd.productLogo = [params objectForKey:XN_FM_PRODUCT_ITEM_PRODUCT_LOGO];
        pd.tagArray = [params objectForKey:XN_FM_PRODUCTLIST_ITEM_TAG_ARRAY];
        
        
        //暂时未用到
        pd.productDesc = [params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_PRODUCTDESC];
        pd.remaMoney = [[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_REMAMONEY] floatValue];
        pd.typeName = [params objectForKey:XN_FM_PRODUCTLIST_ITEM_TYPE_NAME];
        pd.typeValue = [params objectForKey:XN_FM_PRODUCTLIST_ITEM_TYPE_VALUE];
        pd.invLabelStr = [params objectForKey:XN_FM_PRODUCTLIST_ITEM_INVLABELSTR];
        pd.beginSaleTimeText = [params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_BEGINSALETIMETEXT];
        pd.buyMaxMoney = [[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_BUYMAXMONEY] floatValue];
        pd.buyMinMoney = [[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_BUYMINMONEY] floatValue];
        pd.cateId = [params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_CATEID];
        pd.cateName = [params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_CATENAME];
        pd.identifier = [params objectForKey:XN_FM_PRODUCTLSIT_ITEM_PRODUCT_IDENTIFIER];
        pd.currentRecommendProduct = [params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_CURRENTRECOMMENDPRODUCT];
        pd.rewardRatio = [[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRUDUCT_REWARDRATIO] floatValue];
        pd.isHaveProgress = [[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_ISHAVEPROGRESS] integerValue];
        
        pd.orgFeeType = [NSString stringWithFormat:@"%@",[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRUDUCT_ORGFEETYPE]];
        pd.assignmentTime = [NSString stringWithFormat:@"%@",[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_ASSIGNMENTTIME]];
        pd.redemptionTime = [NSString stringWithFormat:@"%@",[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_REDEMPTIONTIME]];
        pd.orgIsstaticproduct = [[params objectForKey:XN_FM_PRODUCTLIST_ITEM_PRODUCT_ORG_ISSTATIC_PRODUCT] integerValue];
        
        pd.saleStartTime = [params objectForKey:XN_FM_PRODUCTLIST_ITEM_SALE_START_TIME];
        pd.timeNow = [params objectForKey:XN_FM_PRODUCTLIST_ITEM_TIME_NOW];
        
        //计算服务器时间与本地时间的差值
        pd.intervalSecondFromServerTimerToLocalTimer = [NSString intervalSecondFromDate:pd.timeNow];

        return pd;
    }
    return nil;
}
@end
