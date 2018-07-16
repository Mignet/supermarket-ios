//
//  XNInterfaceController.h
//  FinancialManager
//
//  Created by xnkj on 15/9/24.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"

@interface XNInterfaceController : BaseViewController

@property (nonatomic, strong) UIWebView * webView;

- (id)initRequestUrl:(NSString *)url requestMethod:(NSString *)requestMethod;

- (void)sharedOperation:(NSDictionary *)params;
@end
