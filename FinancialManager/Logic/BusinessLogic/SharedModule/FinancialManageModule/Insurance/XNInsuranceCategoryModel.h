//
//  XNInsuranceCategoryModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/2.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNInsuranceCategoryModel : NSObject

@property (nonatomic, copy) NSString *category;

@property (nonatomic, copy) NSString *message;

/*** 是否选中 **/
@property (nonatomic, assign) BOOL isChoose;

+ (instancetype)createInsuranceCategoryModel:(NSDictionary *)params;

@end
