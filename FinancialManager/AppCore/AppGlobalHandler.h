//
//  XNGlobalNotificationHandler.h
//  FinancialManager
//
//  Created by xnkj on 06/01/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AppGlobalHandler : NSObject

@property (nonatomic, assign) BOOL isSwitchingViewController;//当前视图正在转化中
@property (nonatomic, assign) BOOL            adLoadingSuccess;//广告是否加载成功
@property (nonatomic, assign) BOOL isHasRemoteUserInfo;  //是否有远程推送消息
@property (nonatomic, strong) NSDictionary *remoteUserInfoDictionary; //远程推送消息

@property (nonatomic, weak) id currentPopup; //当前最上层的视图
@property (nonatomic, weak) UIViewController * currentPopupCtrl;//当前弹出最上层控制器

@property (nonatomic, assign) Boolean frontStatus;//当前是否处于前台

//启动加载的接口处理
- (void)loadData;

//移除最上层
- (void)removePopupView;

//移除控制器
- (void)removePopupCtrl;

//刷新数据
- (void)refreshNewData;
@end
