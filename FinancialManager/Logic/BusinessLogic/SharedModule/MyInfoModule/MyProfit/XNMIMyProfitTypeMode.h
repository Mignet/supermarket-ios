//
//  XNMyAccountDetailType.h
//  FinancialManager
//
//  Created by xnkj on 15/10/22.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*“datas”:[
 {
 “configCode”:”1”//类别id
 “configName”:”佣金收益”//类别名
 }…
*/

#define XN_ACCOUNT_MYACCOUNT_DETAIL_TYPE_TYPEID   @"configCode"
#define XN_ACCOUNT_MYACCOUNT_DETAIL_TYPE_TYPENAME @"configName"

@interface XNMIMyProfitTypeMode : NSObject

@property (nonatomic, strong) NSString * typeId;
@property (nonatomic, strong) NSString * typeName;

+ (instancetype )initMyProfitTypeWithObject:(NSDictionary *)params;
@end
