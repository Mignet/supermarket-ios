//
//  XNConfigMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/30.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNConfigMode.h"

@implementation XNConfigMode

+ (instancetype )initConfigWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNConfigMode * pd = [[XNConfigMode alloc]init];
        
        pd.aboutMeUrl = [params objectForKey:XN_COMMON_CONFIG_ABOUTME];
        pd.questionUrl = [params objectForKey:XN_COMMON_CONFIG_QUESTION];
        pd.showLevelUrl = [params objectForKey:XN_COMMON_CONFIG_SHOWLEVEL];
        pd.rcIntroductionUrl = [params objectForKey:XN_COMMON_CONFIG_RCINTRODUCTION];
        pd.serviceMail = [params objectForKey:XN_COMMON_CONFIG_SERVICEMAIL];
        pd.serviceTelephone = [params objectForKey:XN_COMMON_CONFIG_SERVICETELEPHONE];
        pd.shareLogoIconUrl = [params objectForKey:XN_COMMON_CONFIG_SHARELOGOICON];
        pd.wechatNumber = [params objectForKey:XN_COMMON_CONFIG_WECHATNUMBER];
        pd.zfProtocal = [params objectForKey:XN_COMMON_CONFIG_ZFXY];
        pd.cfpRegisterProtocol = [params objectForKey:XN_COMMON_CONFIG_CFPREGISTERPROTOCOL];
        pd.bankLimitDetail = [params objectForKey:XN_COMMON_CONFIG_BANK_LIMIT_DETAIL];
        pd.saleUserlevelUrl = [params objectForKey:XN_COMMON_CONFIG_LEVEL_URL];
        pd.imgServerUrl = [params objectForKey:XN_COMMON_CONFIG_IMG_SERVER_URL];
        pd.kefuEasemobileName = [params objectForKey:XN_COMMON_CONFIG_KEFU_EASE_MOBILE_NAME];
        pd.lcNews = [params objectForKey:XN_COMMON_CONFIG_LCNEWS_URL];
        pd.informationDetailUrl = [params objectForKey:XN_COMMON_CONFIG_LCNEWS_Detail_URL];
        pd.recommandRule = [params objectForKey:XN_COMMON_CONFIG_RECOMMANDRULE];
        pd.redpacketOprInstruction = [params objectForKey:XN_COMMON_CONFIG_REDPACKETOPRINSTRUCTION];
        pd.bulletinDetailDefaultUrl = [params objectForKey:XN_COMMON_CONFIG_BULLETINDETAILDEFAULTURL];
        pd.tutorial = [params objectForKey:XN_COMMON_CONFIG_TUTORIAL];
        pd.commissionCalculationRuleUrl = [params objectForKey:XN_COMMON_CONFIG_COMMISSION_CALCULATION_RULE_URL];
        pd.investmentStrategy = [params objectForKey:XN_COMMON_CONFIG_INVESTMENT_STRATEGY];
        pd.domainUrl = [params objectForKey:XN_COMMON_CONFIG_DOMAIN_URL];
        pd.frameWebUrl = [params objectForKey:XN_COMMON_CONFIG_FRAME_WEB_URL];
        pd.plateformDetailUrl = [params objectForKey:XN_COMMON_CONFIG_PLATEFORM_DETAIL_URL];
        pd.leaderRule = [params objectForKey:XN_COMMON_CONFIG_LEAER_RULE_URL];
        
        //保存到本地plist文件
        [_LOGIC saveDataDictionary:params intoFileName:@"config.plist"];
        
        return pd;
    }
    return nil;
}
@end
