//
//  XNGestureView.h
//  FinancialManager
//
//  Created by xnkj on 14/02/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XNGesturePasswordViewDelegate <NSObject>

- (void)gesturePasswordDidCreatePassword:(NSString *)password;

@end

@interface XNGestureView : UIView

@property (nonatomic, assign) id<XNGesturePasswordViewDelegate> delegate;

//重置密码状态
- (void)resetPasswordStatus;
@end
