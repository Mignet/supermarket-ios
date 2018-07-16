//
//  XNAdViewModule.h
//  XNCommonProject
//
//  Created by xnkj on 5/20/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

#import "AppModuleBase.h"

@interface XNAdViewModule : AppModuleBase

@property (nonatomic, strong) UIImageView * asyLoadImageView;

+ (instancetype)defaultModule;

/*
 * 广告
 * params appType 理财师/金服
 * params advType
 **/
- (void)requestAppAdvertisementWithAppType:(NSString *)appType advType:(NSString *)advType;

@end
