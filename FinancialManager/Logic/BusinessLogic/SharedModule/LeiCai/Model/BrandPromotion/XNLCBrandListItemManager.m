//
//  XNLCBrandListItemManager.m
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/7.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import "XNLCBrandListItemManager.h"

@interface XNLCBrandListItemManager ()

@property (nonatomic, strong) XNLCBrandListItem *branditem;

@end

@implementation XNLCBrandListItemManager

+ (instancetype)shareInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)setChooseBrandListItem:(XNLCBrandListItem *)brandItem
{
    self.branditem = brandItem;
}

- (XNLCBrandListItem *)getChooseBrandListItem
{
    return self.branditem;
}

@end
