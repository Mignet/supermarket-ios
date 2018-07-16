//
//  GXQGlobalConfig.m
//  GXQApp
//
//  Created by jinfuzi on 14-2-24.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import "GXQFrameworkConfig.h"
#import "AFSecurityPolicy.h"


@implementation GXQFrameworkConfig

- (id)init
{
    self = [super init];
    if (self) {
        // 初始化一些默认值
        _vc.fBarShadowHeight = 4.0f;
        _vc.fXLActivityIndicatorViewFontSize = 13.0f;
        _vc.fXLTableCellDefHeight = 44;
    }
    return self;
}

@end
