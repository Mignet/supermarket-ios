//
//  XNMIHomePageInfoMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/23.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNMIHomePageInfoMode.h"

#import "UIImageView+WebCache.h"

#import "XNCommonModule.h"
#import "XNConfigMode.h"

@interface XNMIHomePageInfoMode()

@property (nonatomic, strong) UIImageView * sdLoadImageView;
@end

@implementation XNMIHomePageInfoMode

+ (instancetype )initHomePageWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNMIHomePageInfoMode * pd = [[XNMIHomePageInfoMode alloc]init];
        
        pd.headImage = [params objectForKey:XN_MYINFO_HOMEPAGE_USER_HEADERIMAGE];
        pd.mobile = [params objectForKey:XN_MYINFO_HOMEPAGE_MOBILE];
        pd.authentication = [[params objectForKey:XN_MYINFO_HOMEPAGE_AUTHENTICATION] boolValue];
        pd.cfgLevelName = [params objectForKey:XN_MYINFO_HOMEPAGE_CFGLEVELNAME];
        
        pd.packetMoneyIncome = [NSString stringWithFormat:@"%@",[params objectForKey:XN_MYINFO_HOMEPAGE_PACKETMONEY]];
        pd.monthIncome = [params objectForKey:XN_MYINFO_HOMEPAGE_MONTH_PROFIT];
        pd.totalIncome = [params objectForKey:XN_MYINFO_HOMEPAGE_TOTAL_INCOME];
        
        pd.accountBook = [params objectForKey:XN_MYINFO_HOMEPAGE_BOOK];
        pd.coupon = [params objectForKey:XN_MYINFO_HOMEPAGE_COUPON];
        pd.customerMember = [params objectForKey:XN_MYINFO_HOMEPAGE_CUSTOMERMEMBER];
        pd.gradePrivi = [params objectForKey:XN_MYINFO_HOMEPAGE_GRADEPRIVI];
        pd.insurance = [params objectForKey:XN_MYINFO_HOMEPAGE_INSURANCE];
        pd.p2p = [params objectForKey:XN_MYINFO_HOMEPAGE_P2P];
        pd.paymentDate = [params objectForKey:XN_MYINFO_HOMEPAGE_PAYMENTDATE];
        pd.tranRecordDate= [params objectForKey:XN_MYINFO_HOMEPAGE_TRANRECORDDATE];
        pd.teamMember = [params objectForKey:XN_MYINFO_HOMEPAGE_TEAMMEMBER];
        pd.newTranRecordStatus = [[params objectForKey:XN_MYINFO_HOMEPAGE_NEW_TRANRECORDSTATUS] boolValue];
        pd.newPaymentRecordStatus = [[params objectForKey:XN_MYINFO_HOMEPAGE_NEW_PAYMENTRECORDSTATUS] boolValue];
        pd.msgCount = [params objectForKey:XN_MYINFO_HOMEPAGE_MSGCOUNT];
        pd.grade = [params objectForKey:@"grade"];
        
        [pd.sdLoadImageView sd_setImageWithURL:[NSURL URLWithString:[_LOGIC getImagePathUrlWithBaseUrl:pd.headImage]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            //将用户头像下载到本地
            [_LOGIC saveImageIntoLocalBox:image imageName:[NSString stringWithFormat:@"%@_userPic.png",[[NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]] md5]]];
        }];
        
        return pd;
    }
    return nil;
}

//////////
#pragma mark - setter/getter
///////////////////////////////

#pragma mark - sdLoadImageView
- (UIImageView *)sdLoadImageView
{
    if (!_sdLoadImageView) {
        
        _sdLoadImageView = [[UIImageView alloc]init];
    }
    return _sdLoadImageView;
}

@end
