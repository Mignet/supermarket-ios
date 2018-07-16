//
//  XNLCBrandPostersmModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/6.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNLCBrandPostersmModel : NSObject

@property (nonatomic, strong) NSMutableArray *posterList;

@property (nonatomic, copy) NSString *qrcode;

+ (instancetype)createBrandPostersmModel:(NSDictionary *)params;

@end
