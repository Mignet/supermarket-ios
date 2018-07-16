//
//  SignRecordHeaderView.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/17.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SignRecordHeaderView, SignStatisticsModel;

@protocol SignRecordHeaderViewDelegate <NSObject>

- (void)signRecordHeaderViewDid:(SignRecordHeaderView *)recordHeaderView;

@end

@interface SignRecordHeaderView : UIView

+ (instancetype)signRecordHeaderView;

/*** 代理 **/
@property (nonatomic, weak) id <SignRecordHeaderViewDelegate> delegate;

@property (nonatomic, strong) SignStatisticsModel *signStatisticsModel;

@end
