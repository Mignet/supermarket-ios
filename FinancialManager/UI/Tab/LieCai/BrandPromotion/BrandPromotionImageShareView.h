//
//  BrandPromotionImageShareView.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/28.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BrandPromotionImageShareView;

typedef NS_ENUM(NSInteger, BrandPromotionImageShareViewShareType) {
    
    Brand_Promotion_Image_Share_WeCat_Friend = 0,
    Brand_Promotion_Image_Share_WeCat_Circle
};

@protocol BrandPromotionImageShareViewDelegate <NSObject>

- (void)brandPromotionImageShareViewDid:(BrandPromotionImageShareView *)shareView withShareType:(BrandPromotionImageShareViewShareType)shareType;

@end

@interface BrandPromotionImageShareView : UIView

+ (instancetype)brandPromotionImageShareView;

- (void)show;

- (void)dismiss;

@property (nonatomic, weak) id <BrandPromotionImageShareViewDelegate> delegate;

@end
