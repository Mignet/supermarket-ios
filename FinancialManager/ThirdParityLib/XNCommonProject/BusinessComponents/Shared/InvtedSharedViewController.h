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

@property (nonatomic, assign) id<InvtedSharedViewControllerDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil defaultIconUrl:(NSString *)defaultIconUrl canHideFriendShared:(BOOL)hiddenFriendShared;

- (void)setInvitedViewTitle:(NSString *)title;

- (void)resetDelegate;

- (void)show;
- (void)hide;
@end
