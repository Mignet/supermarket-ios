//
//  UniversalInteractWebViewController.m
//  FinancialManager
//
//  Created by xnkj on 3/23/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "UniversalInteractWebViewController.h"

#import "UINavigationItem+Extension.h"

@interface UniversalInteractWebViewController ()<SharedViewControllerDelegate>

@property (nonatomic, assign) sharedMethodType       sharedMethod;
@property (nonatomic, assign) BOOL                   existSharedView;
@property (nonatomic, strong) NSDictionary         * sharedDictionary;
@end

@implementation UniversalInteractWebViewController

- (id)initRequestUrl:(NSString *)url requestMethod:(NSString *)requestMethod
{
    self = [super initRequestUrl:url requestMethod:requestMethod];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)dealloc
{
    [self.sharedCtrl resetDelegate];
    self.delegate = nil;
}

////////////////////////
#pragma mark - Custom Method
/////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.navigationController.navigationBarHidden = NO;
    self.existSharedView = NO;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 分享
- (void)sharedOperation:(NSDictionary *)params
{
    self.sharedDictionary = [NSDictionary dictionaryWithDictionary:params];
    self.sharedMethod = WebSharedType;
    
    if (!self.existSharedView) {
        
        self.existSharedView = YES;
        [self.navigationItem addShareButtonItemWithTarget:self action:@selector(clickSharedAction)];
        
        [self.view addSubview:self.sharedCtrl.view];
        [self addChildViewController:self.sharedCtrl];
        
        weakSelf(weakSelf)
        [self.sharedCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakSelf.view);
        }];
        
        [self.view layoutIfNeeded];
    }
    
    [self.sharedCtrl show];
}

#pragma mark - 分享操作
- (void)clickSharedAction
{
    self.sharedMethod = SystemSharedType;
    
    [self.sharedCtrl show];
}

#pragma mark - 打开分享操作
- (void)setSharedButton
{
    if (!self.existSharedView) {
        
        self.existSharedView = YES;
        [self.navigationItem addShareButtonItemWithTarget:self action:@selector(clickSharedAction)];
        
        [self.view addSubview:self.sharedCtrl.view];
        [self addChildViewController:self.sharedCtrl];
        
        weakSelf(weakSelf)
        [self.sharedCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakSelf.view);
        }];
        
        [self.view layoutIfNeeded];
    }
}

/////////////////////
#pragma mark - protocal
////////////////////////////////////////

#pragma mark - 分享回调
- (NSDictionary *)SharedViewControllerDidReceiveSharedParamsWithKey:(SharedType)type
{
    switch (type) {
        case  WXFriend_SharedType:
        {
            if (self.sharedMethod == SystemSharedType)
            if (self.delegate && [self.delegate respondsToSelector:@selector(SharedViewControllerDidReceiveSharedParamsWithKey:)])
                return [self.delegate SharedViewControllerDidReceiveSharedParamsWithKey:WXFriend_SharedType];
            
            NSString *title = [self.sharedDictionary objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_TITLE];
            NSString* url = [self.sharedDictionary objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_LINK];
            NSString* desc = [self.sharedDictionary objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_DESCRIPTION];
            return @{XN_WEIBO_PUBLIC_TITLE: title, XN_WEIBO_PUBLIC_CONTENT: desc, XN_WEIBO_PUBLIC_URL: url,XN_WEIBO_PUBLIC_ICON:[self.sharedDictionary objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_IMGURL]};
        }
            break;
        case WXFriendArea_SharedType:
        {
            if (self.sharedMethod == SystemSharedType)
            if (self.delegate && [self.delegate respondsToSelector:@selector(SharedViewControllerDidReceiveSharedParamsWithKey:)])
                return [self.delegate SharedViewControllerDidReceiveSharedParamsWithKey:WXFriendArea_SharedType];
            
            NSString *title = [self.sharedDictionary objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_TITLE];
            NSString* url = [self.sharedDictionary objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_LINK];
            NSString* desc = [self.sharedDictionary objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_DESCRIPTION];
            return @{XN_WEIBO_PUBLIC_TITLE: title, XN_WEIBO_PUBLIC_CONTENT: desc, XN_WEIBO_PUBLIC_URL: url,XN_WEIBO_PUBLIC_ICON:[self.sharedDictionary objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_IMGURL]};
        }
            break;
        case Copy_SharedType:
        {
            if (self.sharedMethod == SystemSharedType)
            if (self.delegate && [self.delegate respondsToSelector:@selector(SharedViewControllerDidReceiveSharedParamsWithKey:)])
                return [self.delegate SharedViewControllerDidReceiveSharedParamsWithKey:Copy_SharedType];
            
            NSString* url = [self.sharedDictionary objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_LINK];
            return @{XN_COPY_CONTENT:url};
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - 图片加载状态
- (void)sharedImageUrlLoadingFinished:(BOOL)status
{
    if (status) {
        
        [self.view showGifLoading];
    }else
        [self.view hideLoading];
}

/////////////////////
#pragma mark - setter/getter
////////////////////////////////////////

#pragma mark - sharedCtrl123456a
- (SharedViewController *)sharedCtrl
{
    if (!_sharedCtrl) {
        
        _sharedCtrl = [[SharedViewController alloc]init];
        _sharedCtrl.delegate = self;
    }
    return _sharedCtrl;
}

#pragma mark - 分享字典
- (NSDictionary *)sharedDictionary
{
    if (!_sharedDictionary) {
        
        _sharedDictionary = [[NSDictionary alloc]init];
    }
    return _sharedDictionary;
}

@end
