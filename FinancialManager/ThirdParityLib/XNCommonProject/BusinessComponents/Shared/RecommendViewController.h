//
//  RecommendViewController.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/13.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedConstDefine.h"

typedef NS_ENUM(NSInteger, RecommendViewControllerType) {

    Rmanage = 0, // 我的直推理财师
    Rclient,     // 我的客户
    Rcircle,     // 朋友圈
    Rfriend,      // 好友
    RSignShareWeChatF, //签到分享我的微信好友
    RSignShareWeChatC, //签到分享我的微信朋友圈
    RSignShareQQF      //签到分享我的QQ好友
};

typedef NS_ENUM(NSInteger, ShowShareViewType) {

    ProductShareShow = 0,
    SignShareShow
};

@class RecommendViewController;

@protocol RecommendViewControllerDelegate <NSObject>

@optional
- (NSDictionary *)recommendViewControllerAgentDid:(RecommendViewController *)controller shareType:(RecommendViewControllerType)clickType;

- (NSDictionary *)recommendViewControllerProDid:(RecommendViewController *)controller shareType:(RecommendViewControllerType)clickType;

- (NSDictionary *)recommendViewControllerSignDid:(RecommendViewController *)controller shareType:(RecommendViewControllerType)clickType;

@end

@interface RecommendViewController : UIViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

//- (void)setInvitedViewTitle:(NSString *)title;

- (void)resetDelegate;

- (void)show:(ShowShareViewType)showType;
- (void)hide;

@property (nonatomic, copy) NSString *productOrgId;
@property (nonatomic, copy) NSString *IdType;

@property (nonatomic, weak) id <RecommendViewControllerDelegate> signDelegate;
@property (nonatomic, weak) id <RecommendViewControllerDelegate> proDelegate;
@property (nonatomic, weak) id <RecommendViewControllerDelegate> agentDelegate;

/***** 显示的标题 ***/
@property (nonatomic, copy) NSString *shareTitle;


@end
