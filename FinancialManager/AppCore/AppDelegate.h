//
//  AppDelegate.h
//  FinancialManager
//
//  Created by xnkj on 15/9/17.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomApplication.h"

#import "UILayer.h"
#import "LogicLayer.h"
#import "AssistLayer.h"
#import "SkinManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow       *window;

@property (strong, nonatomic) UILayer        *objUILayer;
@property (strong, nonatomic) LogicLayer     *objLogicLayer;
@property (strong, nonatomic) AssistLayer    *objAssistLayer;

@property (nonatomic, strong) SkinManager    *objSkinManager;

@end

