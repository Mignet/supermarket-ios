//
//  XNFMProductDetailMode.m
//  FinancialManager
//
//  Created by xnkj on 1/27/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNFMProductDetailMode.h"

@implementation XNFMProductDetailMode

+ (instancetype)initProductDetailWithParams:(NSDictionary *)params
{
    if (params) {
        
        XNFMProductDetailMode * pd = [[XNFMProductDetailMode alloc]init];
        
        pd.buyIncreaseMoney = [[params objectForKey:XN_FM_PRODUCT_DETAIL_BUYINCREASE_MONEY] doubleValue];
        pd.buyLinkUrl = [params objectForKey:XN_FM_PRODUCT_DETAIL_BUYMAX_BUYLINK];
        pd.buyMaxMoney = [[params objectForKey:XN_FM_PRODUCT_DETAIL_BUYMAX_MONEY] doubleValue];
        pd.buyMinMoney = [[params objectForKey:XN_FM_PRODUCT_DETAIL_BUYMIN_MONEY] doubleValue];
        pd.buyTotalMoney = [[params objectForKey:XN_FM_PRODUCT_DETAIL_BUYTOTAL_MONEY] doubleValue];
        pd.buyedTotalMoney = [[params objectForKey:XN_FM_PRODUCT_DETAIL_BUYEDTOTAL_MONEY] doubleValue];
        pd.buyedTotalPeople = [[params objectForKey:XN_FM_PRODUCT_DETAIL_BUYEDTOTAL_PEOPLE] integerValue];
        pd.cfpRecommend = [[params objectForKey:XN_FM_PRODUCT_DETAIL_CFPRECOMMEND] integerValue];
        pd.collectBeginTime = [params objectForKey:XN_FM_PRODUCT_DETAIL_COLLECTBEGINTIME];
        pd.collectEndTime = [params objectForKey:XN_FM_PRODUCT_DETAIL_COLLECTENDTIME];
        pd.createTime = [params objectForKey:XN_FM_PRODUCT_DETAIL_CREATETIE];
        pd.creator = [params objectForKey:XN_FM_PRODUCT_DETAIL_CREATEER];
        pd.deadLineType = [[params objectForKey:XN_FM_PRODUCT_DETAIL_DEADLINETYPE] integerValue];
        pd.deadLineValue = [[params objectForKey:XN_FM_PRODUCT_DETAIL_DEADLINEVALUE] integerValue];
        pd.detailOpenType = [[params objectForKey:XN_FM_PRODUCT_DETAIL_DETAILOPENTYPE] integerValue];
        pd.detailOpenUrl = [[params objectForKey:XN_FM_PRODUCT_DETAIL_DETAILOPENURL] integerValue];
        pd.feeRatio = [[params objectForKey:XN_FM_PRODUCT_DETAIL_FEERATIO] doubleValue];
        pd.fixRate = [[params objectForKey:XN_FM_PRODUCT_DETAIL_FIXRATE] doubleValue];
        pd.flowFinalRate = [[params objectForKey:XN_FM_PRODUCT_DETAIL_FLOWFINALRATE] doubleValue];
        pd.flowMaxRate = [[params objectForKey:XN_FM_PRODUCT_DETAIL_FLOWMAXRATE] doubleValue];
        pd.flowMinRate = [[params objectForKey:XN_FM_PRODUCT_DETAIL_FLOWMINRATE] doubleValue];
        pd.interestWay = [[params objectForKey:XN_FM_PRODUCT_DETAIL_INTERESTWAY] integerValue];
        pd.isCollect = [[params objectForKey:XN_FM_PRODUCT_DETAIL_ISCOLLECT] integerValue];
        pd.isFlow = [[params objectForKey:XN_FM_PRDOCUT_DETAIL_ISFLOW] integerValue];
        pd.isQuota = [[params objectForKey:XN_FM_PRODUCT_DETAIL_ISQUOTA] integerValue];
        pd.isRedemption = [[params objectForKey:XN_FM_PRODUCT_DETAIL_ISREDEMPTION] integerValue];
        pd.isShow = [[params objectForKey:XN_FM_PRODUCT_DETAIL_ISSHOW] integerValue];
        pd.moneyType = [[params objectForKey:XN_FM_PRODUCT_DETAIL_MONEYTYPE] integerValue];
        pd.orgInfoDictionary = [params objectForKey:XN_FM_PRODUCT_DETAIL_ORGINFORESPONSE];
        pd.orgNumber = [params objectForKey:XN_FM_PRODUCT_DETAIL_ORGNUMBER];
        pd.productDesc = [params objectForKey:XN_FM_PRODUCT_DETAIL_PRODUCTDESC];
        pd.productId = [params objectForKey:XN_FM_PRODUCT_DETAIL_PRODUCTID];
        pd.productName = [params objectForKey:XN_FM_PRODUCT_DETAIL_PRODUCTNAME];
        pd.saleStatus = [[params objectForKey:XN_FM_PRODUCT_DETAIL_STATUS] integerValue];
        pd.thirdProductId = [params objectForKey:XN_FM_PRODUCT_DETAIL_THIRDPRODUCTID];
        
        
        return pd;
    }
    
    return nil;
}
@end
