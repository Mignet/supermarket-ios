//
//  QquestionResultRecomListItem.h
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/6.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QquestionResultRecomListItem : NSObject

@property (nonatomic, copy) NSString *categoryImage;

@property (nonatomic, copy) NSString *recomCategory;

+ (instancetype)createResultRecomListItemWithPramas:(NSDictionary *)params;

@end
