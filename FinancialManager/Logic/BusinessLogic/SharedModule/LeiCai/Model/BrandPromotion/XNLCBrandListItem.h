//
//  XNLCBrandListItem.h
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/6.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNLCBrandListItem : NSObject

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *smallImage;

//@property (nonatomic, copy) NSString *qrcode;

@property (nonatomic, assign) BOOL isChoose;

+ (instancetype)createBrandListItem:(NSDictionary *)params;

@end

