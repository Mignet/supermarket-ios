//
//  AgentIntroductionViewController.h
//  FinancialManager
//
//  Created by ancye.Xie on 10/19/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"

@protocol AgentIntroductionViewControllerDelegate <NSObject>

@optional
- (void)showPlatformMoreMsgWithHeight:(float)fHeight nTabTag:(NSInteger)nTag defaultHeight:(float)fDefaultHeight showDefaultHeight:(BOOL)isShowDefaultHeight;

@end


@class XNFMAgentDetailMode;
@interface AgentIntroductionViewController : BaseViewController

@property (nonatomic, assign) id<AgentIntroductionViewControllerDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil mode:(XNFMAgentDetailMode *)mode;

//简介
- (void)showIntroduction;

//投资相关
- (void)showInvestMessage;

//档案
- (void)showPlatformMessage;

//平台动态
- (void)showPlatDynamic;

//更新箭头图标
- (void)updateArrowImage:(BOOL)isShowMsgDefaultHeight nTabTag:(NSInteger)nTag;

@end
