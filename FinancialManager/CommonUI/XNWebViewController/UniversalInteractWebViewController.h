//
//  UniversalInteractWebViewController.h
//  FinancialManager
//
//  Created by xnkj on 3/23/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNInterfaceController.h"

#import "SharedViewController.h"

typedef NS_ENUM(NSInteger, sharedMethodType)
{
    SystemSharedType,
    WebSharedType,
    IMaxShared
};

@protocol UniversalInteractWebViewControllerDelegate<NSObject>
@optional

- (NSDictionary *)SharedViewControllerDidReceiveSharedParamsWithKey:(SharedType)type;
@end


@interface UniversalInteractWebViewController : XNInterfaceController

@property (nonatomic, assign) id<UniversalInteractWebViewControllerDelegate> delegate;
@property (nonatomic, strong) SharedViewController * sharedCtrl;

- (id)initRequestUrl:(NSString *)url requestMethod:(NSString *)requestMethod;

- (void)setSharedButton;
@end
