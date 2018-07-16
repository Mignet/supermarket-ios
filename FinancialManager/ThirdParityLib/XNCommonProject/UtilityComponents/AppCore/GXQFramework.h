//
//  GXQFramework.h
//  GXQApp
//
//  Created by jinfuzi on 14-2-24.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GXQFrameworkConfig.h"

@interface GXQFramework : NSObject

@property (weak, nonatomic) UIWindow* mainWindow;
@property (strong, nonatomic, readonly) GXQFrameworkConfig* config;

+ (GXQFramework*)getObj;
+ (GXQFrameworkConfig*)getConfig;

// 逻辑层全局管理内存
-(id)getGlobalClassObj:(Class)objClass;
-(BOOL)addGlobalClassObj:(id)obj;
-(BOOL)removeGlobalClassObj:(Class)objClass;

@end
