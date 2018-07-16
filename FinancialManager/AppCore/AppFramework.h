//
//  GXQFramework.h
//  GXQApp
//
//  Created by jinfuzi on 14-2-24.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppFrameworkConfig.h"
#import "AppGlobalHandler.h"

@interface AppFramework : NSObject

@property (weak, nonatomic) UIWindow* mainWindow;
@property (strong, nonatomic) AppFrameworkConfig* config;
@property (strong, nonatomic) AppGlobalHandler * globalHandler;

+ (AppFramework*)getObj;
+ (AppFrameworkConfig*)getConfig;
+ (AppGlobalHandler *)getGlobalHandler;

// 逻辑层全局管理内存
-(id)getGlobalClassObj:(Class)objClass;
-(BOOL)addGlobalClassObj:(id)obj;
-(BOOL)removeGlobalClassObj:(Class)objClass;

@end
