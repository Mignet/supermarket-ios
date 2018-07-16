//
//  XNInvitedCustomerMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/16.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*"url":"https://localhost:9090/lsdfsdfs.png"  //二维码图片地址
 “shareContent”:{
	“title”: “”, // 分享标题
 “desc”: “”, // 分享描述
 “link”: “”, // 分享链接
 “imgUrl”: “”, // 分享图标
 }
*/

#define XN_CS_INVITED_CUSTOMER_CODEURL @"url"
#define XN_CS_INVITED_CUSTOMER_SHAREDCONTENT @"shareContent"
#define XN_CS_INVITED_CUSTOMER_SHARED_TITLE @"title"
#define XN_CS_INVITED_CUSTOMER_SHARED_DESCRIPTION @"desc"
#define XN_CS_INVITED_CUSTOMER_SHARED_LINK @"link"
#define XN_CS_INVITED_CUSTOMER_SHARED_IMGURL @"imgUrl"

@interface XNCSInvitedCustomerMode : NSObject

@property (nonatomic, strong) NSString * codeUrl;
@property (nonatomic, strong) NSString * sharedTitle;
@property (nonatomic, strong) NSString * sharedDescription;
@property (nonatomic, strong) NSString * sharedLink;
@property (nonatomic, strong) NSString * sharedImageUrl;

+ (instancetype )initInvitedCustomerWithObject:(NSDictionary *)params;
@end
