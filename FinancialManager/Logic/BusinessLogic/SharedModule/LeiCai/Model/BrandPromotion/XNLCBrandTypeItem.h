//
//  XNLCBrandTypeItem.h
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/6.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNLCBrandTypeItem : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSString *typeValue;

@property (nonatomic, assign) BOOL isChoose;

+ (instancetype)brandTypeItem:(NSDictionary *)params;

@end
