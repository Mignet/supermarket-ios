//
//  UniversalWebViewController.h
//  FinancialManager
//
//  Created by xnkj on 15/9/24.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNInterfaceController.h"
#import "SharedViewController.h"

@class UniversalWebViewController;
@protocol UniversalWebViewControllerDelegate <NSObject>
@optional

- (void)universalWebViewController:(UniversalWebViewController *)ctrl didScrollToOffset:(CGFloat )offset;
@end

@interface UniversalWebViewController : BaseViewController

@property (nonatomic, assign) id<UniversalWebViewControllerDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil requestUrl:(NSString *)url;

- (void)loadWebViewWithUrl:(NSString *)url;
@end
