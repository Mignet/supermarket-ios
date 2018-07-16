//
//  SharedViewController.h
//  FinancialManager
//
//  Created by xnkj on 15/9/24.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedConstDefine.h"

@protocol InvtedSharedViewControllerDelegate <NSObject>
@optional

- (NSDictionary *)SharedViewControllerDidReceiveSharedParamsWithKey:(SharedType )type;
- (void)sharedViewControllerDidClickContractShared;

- (void)sharedImageUrlLoadingFinished:(BOOL)status;
@end

@interface InvtedSharedViewController : UIViewController

@property (nonatomic, assign) BOOL canHideFriend;
@property (nonatomic, assign) id<InvtedSharedViewControllerDelegate> delegate;

- (void)resetDelegate;

- (void)show;
- (void)hide;
@end
