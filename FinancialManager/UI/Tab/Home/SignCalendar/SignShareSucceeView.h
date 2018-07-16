//
//  SignShareSucceeView.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/21.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SignShareSucceeView, SignShareModel;

@protocol SignShareSucceeViewDelegate <NSObject>

- (void)signShareSucceeViewDid:(SignShareSucceeView *)signShareView;

- (void)checkSignShareSucceeViewDid:(SignShareSucceeView *)signShareView;

@end

@interface SignShareSucceeView : UIView

+ (instancetype)signShareSucceeView;

- (void)show:(UIView *)view;

- (void)dismiss;

@property (nonatomic, weak) id <SignShareSucceeViewDelegate> delegate;

//@property (nonatomic, strong) SignShareModel *signShareModel;

@end
