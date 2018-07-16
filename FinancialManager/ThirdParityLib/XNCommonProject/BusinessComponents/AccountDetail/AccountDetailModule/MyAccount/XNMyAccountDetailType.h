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
 “typeId”:”1”//类别id
 “typeName”:”佣金收益”//类别名
 }…
*/

#define XN_ACCOUNT_MYACCOUNT_DETAIL_TYPE_TYPEID   @"typeValue"
#define XN_ACCOUNT_MYACCOUNT_DETAIL_TYPE_TYPENAME @"typeName"

@interface XNMyAccountDetailType : NSObject

@property (nonatomic, strong) NSString * typeId;
@property (nonatomic, strong) NSString * typeName;

+ (instancetype )initMyAccountDetailTypeWithObject:(NSDictionary *)params;
@end
