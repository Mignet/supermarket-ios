//
//  UseLoginViewController.h
//  FinancialManager
//
//  Created by xnkj on 15/9/25.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"

@class UseLoginViewController;
@protocol UseLoginViewControllerDelegate <NSObject>
@optional

- (void)UserLoginViewController:(UseLoginViewController *)ctrl didLoginSuccess:(BOOL)success;
@end

@interface UseLoginViewController : BaseViewController

@property (nonatomic, weak) id<UseLoginViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL canReSetGesture;
@property (nonatomic, assign) BOOL showNewAnimation;
@end
