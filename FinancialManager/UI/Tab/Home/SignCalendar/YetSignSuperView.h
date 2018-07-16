//
//  YetSignSuperView.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/20.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YetSignSuperView, UserSignMsgModel;

typedef NS_ENUM(NSInteger, YetSignSuperViewClickType) {

    YetSign_Share_Type = 0,
    YetSign_Check_Type
};

@protocol YetSignSuperViewDelegate <NSObject>

- (void)yetSignSuperViewDid:(YetSignSuperView *)yetSignSuperView ClickType:(YetSignSuperViewClickType)clickType;

@end

@interface YetSignSuperView : UIView

+ (instancetype)yetSignSuperView;

/*** 代理 **/
@property (nonatomic, weak) id <YetSignSuperViewDelegate> delegate;

@property (nonatomic, strong) UserSignMsgModel *userSignMsgModel;

@end
