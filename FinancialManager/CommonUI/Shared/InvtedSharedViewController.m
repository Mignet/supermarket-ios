//
//  SharedViewController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/24.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "InvtedSharedViewController.h"
#import "WeChatManager.h"

#import "XNCommonModule.h"
#import "XNConfigMode.h"

@interface InvtedSharedViewController ()<WeChatManagerDelegate>

@property (nonatomic, strong) NSDictionary * sharedDictionary;

@property (nonatomic, weak) IBOutlet UIButton * cancelBtn;
@property (nonatomic, weak) IBOutlet UIButton * wxBtn;
@property (nonatomic, weak) IBOutlet UIButton * friendBtn;
@property (nonatomic, weak) IBOutlet UIButton * pastBtn;

@property (nonatomic, strong) IBOutlet UIView   * sharedView;
@end

@implementation InvtedSharedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self resetDelegate];
}

///////////////////////
#pragma mark - Custom Method
////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    [self.view setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5]];
    [self.view setHidden:YES];
    
    [self.view addSubview:self.sharedView];
    weakSelf(weakSelf)
    [self.sharedView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.top.mas_equalTo(weakSelf.view.mas_bottom);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(@(165));
    }];
    
    [[WeChatManager sharedManager] setDelegate:self];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 微信朋友分享
- (IBAction)wxFriendShared:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SharedViewControllerDidReceiveSharedParamsWithKey:)]) {
        
        self.sharedDictionary = [self.delegate SharedViewControllerDidReceiveSharedParamsWithKey:WXFriend_SharedType];
    }
    
    [self doWechatShare:Session_WXSceneType];
    [self hide];
}

#pragma mark - 微信朋友圈分享
- (IBAction)wxFriendAreaShared:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SharedViewControllerDidReceiveSharedParamsWithKey:)]) {
        
        self.sharedDictionary = [self.delegate SharedViewControllerDidReceiveSharedParamsWithKey:WXFriendArea_SharedType];
    }
    
    [self doWechatShare:TimeLine_WXSceneType];
    [self hide];
}

#pragma mark - 粘贴复制
- (IBAction)copyShared:(id)sender
{
    [self.delegate sharedViewControllerDidClickContractShared];
    [self hide];
}

#pragma mark - 重置代理
- (void)resetDelegate
{
    self.delegate = nil;
    [[WeChatManager sharedManager] setDelegate:nil];
}

////////
#pragma mark - 根据是否安装微信进行对应操作
//////////////////////////////////////
- (void)doWechatShare:(int)shareType
{
    if ([WeChatManager isWeChatInstall])
    {
        NSString *title = [self.sharedDictionary objectForKey:XN_WEIBO_PUBLIC_TITLE];
        if (title.length == 0) {
            title = XN_WEIBO_PUBLIC_DEFAULT_TITLE;
        }
        
        NSString *content = [self.sharedDictionary objectForKey:XN_WEIBO_PUBLIC_CONTENT];
        NSString *url = [self.sharedDictionary objectForKey:XN_WEIBO_PUBLIC_URL];
        NSString *imageUrl = [self.sharedDictionary objectForKey:XN_WEIBO_PUBLIC_ICON];
        if (imageUrl.length == 0) {
            imageUrl = [[[XNCommonModule defaultModule] configMode] shareLogoIconUrl];
        }
        
        [[WeChatManager sharedManager] sendLinkWithTitle:title description:content imageUrl:imageUrl link:url scene:shareType];
    }
    else {
        id alert = [JFZModelView showAlertViewWithTitle:nil message:@"您还没有安装微信,是否去App Store下载？" cancelButtonTitle:@"取消" cancelBlock:nil okButtonTitle:@"马上下载" okBlock:^{
            NSString *strUrl = [WeChatManager weChatUrl];
            NSURL *url = [NSURL URLWithString:strUrl];
            [[UIApplication sharedApplication] openURL:url];
        }];
        
        [_CORE observerPopup:alert];
    }
}

#pragma mark - 显示
- (void)show
{
    [self.view setHidden:NO];
    [self.view layoutIfNeeded];
    
    weakSelf(weakSelf)
    
    [self.sharedView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(@(165));
    }];
    [UIView animateWithDuration:VIEWANIMATIONDURATION animations:^{
       
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 隐藏
- (void)hide
{
    weakSelf(weakSelf)
    
    [self.sharedView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.top.mas_equalTo(weakSelf.view.mas_bottom);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(@(165));
    }];
    
    [UIView animateWithDuration:VIEWANIMATIONDURATION animations:^{
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        [self.view setHidden:YES];
    }];
}

#pragma mark -tap
- (IBAction)clickTapExit:(id)sender
{
    [self hide];
}

#pragma mark - 返回微信加载图片状态
- (void)weChatSharedImageLoadingStatus:(BOOL)status
{
    [self.delegate sharedImageUrlLoadingFinished:status];
}

////////////////////
#pragma mark - setter/getter
/////////////////////////////////////////////

#pragma mark - sharedDictionary
- (NSDictionary *)sharedDictionary
{
    if (!_sharedDictionary) {
    
        _sharedDictionary = [[NSDictionary alloc]init];
    }
    return _sharedDictionary;
}

@end
