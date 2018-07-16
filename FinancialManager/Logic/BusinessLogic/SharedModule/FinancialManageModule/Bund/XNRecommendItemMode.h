//
//  XNRecommondItemMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 10/17/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_RECOMMOND_ITEM_MODE_USERNAME @"userName"
#define XN_RECOMMOND_ITEM_MODE_MOBILE @"mobile"
#define XN_RECOMMOND_ITEM_MODE_USERID @"userId"
#define XN_RECOMMOND_ITEM_MODE_HEADIMAGE @"headImage"
#define XN_RECOMMOND_ITEM_MODE_IS_RECOMMEND @"ifRecommend"

@interface XNRecommendItemMode : NSObject

@property (nonatomic, copy) NSString *userName; //姓名
@property (nonatomic, copy) NSString *mobile; //手机号码
@property (nonatomic, copy) NSString *userId; //用户id
@property (nonatomic, copy) NSString *headImage; //头像图片url
@property (nonatomic, assign) NSInteger ifRecommend; //是否理财师推荐 0-否 其他-是

@property (nonatomic, assign) NSInteger sectionNumber; //用来做本地分类的index

+ (instancetype)initWithObject:(NSDictionary *)params;

@end
