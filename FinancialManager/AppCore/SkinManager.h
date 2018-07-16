//
//  SkinManager.h
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/26.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SkinType) {
    
    SkinType_normal = 0,
    SkinType_select
    
};

@interface SkinManager : NSObject

// tabbar item 图标
- (NSString *)getHomeItemIcon:(SkinType)skinType;
- (NSString *)getAgentItemIcon:(SkinType)skinType;
- (NSString *)getLeiCaiItemIcon:(SkinType)skinType;
- (NSString *)getMyInfoItemIcon:(SkinType)skinType;


- (NSString *)getproImgIcon;
- (NSString *)getfundImgIcon;
- (NSString *)getinsuranceImgIcon;
- (NSString *)getpublicImgIcon;



@end
