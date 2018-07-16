//
//  SharedViewController.h
//  FinancialManager
//
//  Created by xnkj on 15/9/24.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedConstDefine.h"

@protocol SharedViewControllerDelegate <NSObject>
@optional

- (NSDictionary *)SharedViewControllerDidReceiveSharedParamsWithKey:(SharedType )type;

- (void)sharedImageUrlLoadingFinished:(BOOL)status;
@end

@interface SharedViewController : UIViewController

@property (nonatomic, assign) BOOL canHideFriend;
@property (nonatomic, assign) id<SharedViewControllerDelegate> delegate;

- (void)resetDelegate;

- (void)show;
- (void)hide;
@end
