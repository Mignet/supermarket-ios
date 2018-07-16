//
//  ShareGroupView.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/1.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareGroupView, XNInvestPlatformMode;

typedef NS_ENUM(NSInteger, ShareGroupViewClickType) {

    Share_Group_Photo = 0,
    Share_Group_QQ,
    Share_Group_WeCat,
    Share_Group_Circle
};

@protocol ShareGroupViewDelegate <NSObject>

- (void)shareGroupViewDid:(ShareGroupView *)shareGroupView clickType:(ShareGroupViewClickType)clickType cutImg:(UIImage *)cutImg;

@end

@interface ShareGroupView : UIView

+ (instancetype)shareGroupView;

- (void)show;

- (void)hide;

@property (weak, nonatomic) IBOutlet UIImageView *erweimaImgView;

@property (nonatomic, weak) id <ShareGroupViewDelegate> delegate;

@property (nonatomic, strong) XNInvestPlatformMode *investPlatformMode;


@end
