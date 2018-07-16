//
//  NetworkUnReachStatusView.h
//  FinancialManager
//
//  Created by xnkj on 10/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RetryNetworkBlock)();

@interface NetworkUnReachStatusView : UIView

@property (nonatomic, copy) RetryNetworkBlock retryNetworkBlock;

/**
 * 设置重制block
 * params block 回调block
 **/
- (void)setNetworkRetryOperation:(RetryNetworkBlock)block;

/**
 * 设置重制图片和标题
 * params iconName 无网图片名
 * params title 标题名字
 **/
- (void)setNetworkUnReachStatusImage:(NSString *)iconName title:(NSString *)title;
@end
