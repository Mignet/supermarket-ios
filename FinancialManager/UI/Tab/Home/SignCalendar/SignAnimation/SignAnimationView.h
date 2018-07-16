//
//  SignAnimationView.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/17.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SignAnimationView, UserSignModel;

typedef NS_ENUM(NSInteger, SignAnimationViewBtnClickType) {

    Share_Btn_Click = 0,
    Close_Btn_Click
};

@protocol SignAnimationViewDelegate <NSObject>

- (void)signAnimationViewDid:(SignAnimationView *)animationView btnClickType:(SignAnimationViewBtnClickType)clickType;

- (void)signAnimationViewHidden:(SignAnimationView *)signAnimationView;

@end

@interface SignAnimationView : UIView

+ (instancetype)signAnimationView;

- (void)startAnimation;

@property (nonatomic, weak) id <SignAnimationViewDelegate> delegate;

- (void)animationHide;

// 绑定一个数据模型
@property (nonatomic, strong) UserSignModel *userSignModel;

@end
