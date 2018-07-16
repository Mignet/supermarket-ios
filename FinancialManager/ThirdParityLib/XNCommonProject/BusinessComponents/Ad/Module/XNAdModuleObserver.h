//
//  XNAdModuleObserver.h
//  XNCommonProject
//
//  Created by xnkj on 5/19/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

@class XNAdViewModule;
@protocol XNAdModuleObserver <NSObject>
@optional

- (void)XNAdModuleDidGetAdSuccess:(XNAdViewModule *)module;
- (void)XNAdModuleDidGetAdFailed:(XNAdViewModule *)module;
@end
