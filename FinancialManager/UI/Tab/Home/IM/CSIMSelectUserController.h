//
//  MFSystemInvitedController.h
//  FinancialManager
//
//  Created by xnkj on 15/9/29.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"

@class CSIMSelectUserController;
@protocol CSIMSelectUserControllerDelegate <NSObject>
@optional

- (void)CSIMSelectUserController:(CSIMSelectUserController *)ctrl didSelectUser:(NSArray *)userArray;
@end

@interface CSIMSelectUserController : BaseViewController
@property (nonatomic, assign) id<CSIMSelectUserControllerDelegate> delegate;
@property (nonatomic, strong) NSString * conversationTheme;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil selectedUser:(NSArray *)array;
@end
