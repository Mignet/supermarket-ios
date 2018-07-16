//
//  XNHomeBannerMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*“imgUrl": "http://hlc.xiaoniuapp.com/backend/images/ad/5.jpg", // 图片URL
 "linkUrl": "http://hlc.xiaoniuapp.com/web/index.html" // 跳转url
*/

#define XN_HOMEPAGE_BANNER_IMG_URL @"imgUrl"
#define XN_HOMEPAGE_BANNER_LINK_URL @"linkUrl"
#define XN_HOMEPAGE_BANNER_TITLE @"shareTitle"
#define XN_HOMEPAGE_BANNER_DESC @"shareDesc"
#define XN_HOMEPAGE_BANNER_LINK @"shareLink"
#define XN_HOMEPAGE_BANNER_ICON @"shareIcon"

@interface XNHomeBannerMode : NSObject

@property (nonatomic, strong) NSString * imgUrl;
@property (nonatomic, strong) NSString * linkUrl;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * link;
@property (nonatomic, strong) NSString * icon;

+ (instancetype )initBannerWithObject:(NSDictionary *)params;
@end
