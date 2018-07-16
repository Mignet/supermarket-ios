//
//  SignShareAward.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/22.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SignShareAwardView, SignShareModel;

typedef NS_ENUM (NSInteger, AwardType ) {
    
    No_Award = 0,
    Coin_Award,
    RedBack_Award
};

@protocol SignShareAwardViewDelegate <NSObject>

- (void)signShareAwardViewDid:(SignShareAwardView *)signShareAwardView;

@end



@interface SignShareAwardView : UIView

+ (instancetype)signShareAwardView;

@property (nonatomic, assign) AwardType awardType;

- (void)show;

- (void)dismiss;

@property (nonatomic, weak) id <SignShareAwardViewDelegate> delegate;

@property (nonatomic, strong) SignShareModel *signShareModel;

@end
