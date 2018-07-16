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

@property (nonatomic, assign) id <SharedViewControllerDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil defaultIconUrl:(NSString *)defaultIconUrl canHideFriendShared:(BOOL)hiddenFriendShared;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil defaultIconUrl:(NSString *)defaultIconUrl canHideFriendShared:(BOOL)hiddenFriendShared isImage:(BOOL)isImage;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isFondPaper:(BOOL)fondPaper;

- (void)resetDelegate;

- (void)show;
- (void)hide;
@end
