//
//  XNLCBrandListItemManager.h
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/7.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XNLCBrandListItem;

@interface XNLCBrandListItemManager : NSObject

+ (instancetype)shareInstance;


- (void)setChooseBrandListItem:(XNLCBrandListItem *)brandItem;

- (XNLCBrandListItem *)getChooseBrandListItem;

@end