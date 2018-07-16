//
//  SharedViewController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/24.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "SharedViewController.h"
#import "WeChatManager.h"
#import "QQManager.h"

@interface SharedViewController ()<WeChatManagerDelegate>

@property (nonatomic, assign) BOOL          canHideFriend;
@property (nonatomic, assign) BOOL          isShareImage;
@property (nonatomic, strong) NSString     * defaultIconUrl;
@property (nonatomic, strong) NSDictionary * sharedDictionary;

@property (nonatomic, weak) IBOutlet UIButton * cancelBtn;
@property (nonatomic, weak) IBOutlet UIButton * wxBtn;
@property (nonatomic, weak) IBOutlet UIButton * friendBtn;
@property (nonatomic, weak) IBOutlet UIButton * pastBtn;

@property (nonatomic, strong) IBOutlet UIView   * sharedView;
@property (nonatomic, strong) IBOutlet UIView   * outerSharedView;
@property (nonatomic, assign) BOOL fondPaper;
@property (strong, nonatomic) IBOutlet UIView *fondPaperSharedView;

@end

@implementation SharedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil defaultIconUrl:(NSString *)defaultIconUrl canHideFriendShared:(BOOL)hiddenFriendShared
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.canHideFriend = hiddenFriendShared;
        self.defaultIconUrl = defaultIconUrl;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil defaultIconUrl:(NSString *)defaultIconUrl canHideFriendShared:(BOOL)hiddenFriendShared isImage:(BOOL)isImage
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.canHideFriend = hiddenFriendShared;
        self.defaultIconUrl = defaultIconUrl;
        self.isShareImage = isImage;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isFondPaper:(BOOL)fondPaper
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.fondPaper = fondPaper;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.fondPaper) {
        [self initFondPaperView];
    } else {
        [self initView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [[WeChatManager sharedManager] setDelegate:nil];
}

///////////////////////
#pragma mark - Custom Method
////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    [self.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    [self.view setHidden:YES];
    
    [[WeChatManager sharedManager] setDelegate:self];
    
    //设置默认icon的链接地址
    if (![NSObject isValidateInitString:self.defaultIconUrl]) {
        self.defaultIconUrl = @"https://image.toobei.com/dfa3e35be331f6ec67566130f67820b9?f=png";
    }
    
    if (!self.canHideFriend) {
        
        [self.view addSubview:self.sharedView];
        
        weakSelf(weakSelf)
        [self.sharedView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(weakSelf.view.mas_leading);
            make.top.mas_equalTo(weakSelf.view.mas_bottom);
            make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.mas_equalTo(@(150));
        }];
    }else
    {
        [self.view addSubview:self.outerSharedView];
        
        
        weakSelf(weakSelf)
        [self.outerSharedView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(weakSelf.view.mas_leading);
            make.top.mas_equalTo(weakSelf.view.mas_bottom);
            make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.mas_equalTo(@(150));
        }];
        
    }
    
    [self.view layoutIfNeeded];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)initFondPaperView
{
    
    [self.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    [self.view setHidden:YES];
    [[WeChatManager sharedManager] setDelegate:self];
    [self.view addSubview:self.fondPaperSharedView];
    weakSelf(weakSelf)
    [self.fondPaperSharedView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.top.mas_equalTo(weakSelf.view.mas_bottom);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(@(150));
    }];
    
    
    [self.view layoutIfNeeded];
    
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

#pragma mark - qq
- (IBAction)qqShared:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SharedViewControllerDidReceiveSharedParamsWithKey:)]) {
        
        self.sharedDictionary = [self.delegate SharedViewControllerDidReceiveSharedParamsWithKey:QQ_SharedType];
    }
    
    [self doQQShare:QQ_SharedType];
    [self hide];
    
}

#pragma mark - 粘贴复制
- (IBAction)copyShared:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SharedViewControllerDidReceiveSharedParamsWithKey:)]) {
        
        self.sharedDictionary = [self.delegate SharedViewControllerDidReceiveSharedParamsWithKey:Copy_SharedType];
    }
    
    [self copyOperationWithUrl:[self.sharedDictionary objectForKey:XN_COPY_CONTENT]];
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
        if (!self.isShareImage)
        {
            NSString *title = [self.sharedDictionary objectForKey:XN_WEIBO_PUBLIC_TITLE];
            if (title.length == 0) {
                title = XN_WEIBO_PUBLIC_DEFAULT_TITLE;
            }
            
            NSString *content = [self.sharedDictionary objectForKey:XN_WEIBO_PUBLIC_CONTENT];
            NSString *url = [self.sharedDictionary objectForKey:XN_WEIBO_PUBLIC_URL];
            NSString *imageUrl = [self.sharedDictionary objectForKey:XN_WEIBO_PUBLIC_ICON];
            if (![NSObject isValidateInitString:imageUrl]) {
                imageUrl = self.defaultIconUrl;
            }
            
            [[WeChatManager sharedManager] sendLinkWithTitle:title description:content imageUrl:imageUrl link:url scene:shareType];
        }
        else
        {
            UIImage *image = [self.sharedDictionary objectForKey:XN_WEIBO_PUBLIC_ICON];
            [[WeChatManager sharedManager] sendImage:image atScene:shareType];
        }
        
    }
    else {
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:@"您还没有安装微信,是否去App Store下载" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"马上去下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *strUrl = [WeChatManager weChatUrl];
            NSURL *url = [NSURL URLWithString:strUrl];
            [[UIApplication sharedApplication] openURL:url];
            
            [_UI dismissNaviModalViewCtrlAnimated:YES];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [_UI dismissNaviModalViewCtrlAnimated:YES];
        }]];
        
        [_UI presentNaviModalViewCtrl:alertController animated:YES];
    }
}

#pragma mark -
- (void)doQQShare:(int)shareType
{
    if ([QQManager isInstalledQQ])
    {
        NSString *title = [self.sharedDictionary objectForKey:XN_WEIBO_PUBLIC_TITLE];
        if (title.length == 0) {
            title = XN_WEIBO_PUBLIC_DEFAULT_TITLE;
        }
        
        NSString *content = [self.sharedDictionary objectForKey:XN_WEIBO_PUBLIC_CONTENT];
        NSString *url = [self.sharedDictionary objectForKey:XN_WEIBO_PUBLIC_URL];
        NSString *imageUrl = [self.sharedDictionary objectForKey:XN_WEIBO_PUBLIC_ICON];
        if (![NSObject isValidateInitString:imageUrl]) {
            imageUrl = self.defaultIconUrl;
        }
        
        [[QQManager sharedInstance] sendTitle:title Description:content Url:url ImageUrl:imageUrl];
    }
    else {
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:@"您还没有安装QQ,是否去App Store下载" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"马上去下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *strUrl = QQDOWNLOADLINK;
            NSURL *url = [NSURL URLWithString:strUrl];
            [[UIApplication sharedApplication] openURL:url];
            
            [_UI dismissNaviModalViewCtrlAnimated:YES];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [_UI dismissNaviModalViewCtrlAnimated:YES];
        }]];
        
        [_UI presentNaviModalViewCtrl:alertController animated:YES];
    }
}


#pragma mark - 复制操作
- (void)copyOperationWithUrl:(NSString *)content
{
    if (content) {
        
    UIPasteboard * pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = content;
    }
}

#pragma mark - 显示
- (void)show
{
    [self.view setHidden:NO];
    [self.view layoutIfNeeded];
    
    weakSelf(weakSelf)

    if (self.fondPaper == NO) {
        
        if (!self.canHideFriend)
            [self.sharedView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.mas_equalTo(weakSelf.view.mas_leading);
                make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
                make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
                make.width.mas_equalTo(SCREEN_FRAME.size.width);
                make.height.mas_equalTo(@(150));
            }];
        else
            [self.outerSharedView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.mas_equalTo(weakSelf.view.mas_leading);
                make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
                make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
                make.width.mas_equalTo(SCREEN_FRAME.size.width);
                make.height.mas_equalTo(@(150));
            }];
        
    } else {
        
        [self.fondPaperSharedView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(weakSelf.view.mas_leading);
            make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
            make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.mas_equalTo(@(150));
        }];
        
    }
    
    
    [UIView animateWithDuration:VIEWANIMATIONDURATION animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 隐藏
- (void)hide
{
    weakSelf(weakSelf)
    
    if (self.fondPaper == NO) {
        
        if (!self.canHideFriend)
            [self.sharedView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.mas_equalTo(weakSelf.view.mas_leading);
                make.top.mas_equalTo(weakSelf.view.mas_bottom);
                make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
                make.width.mas_equalTo(SCREEN_FRAME.size.width);
                make.height.mas_equalTo(@(150));
            }];
        else
            [self.outerSharedView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.mas_equalTo(weakSelf.view.mas_leading);
                make.top.mas_equalTo(weakSelf.view.mas_bottom);
                make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
                make.width.mas_equalTo(SCREEN_FRAME.size.width);
                make.height.mas_equalTo(@(150));
            }];
    
    } else {
        
        [self.fondPaperSharedView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(weakSelf.view.mas_leading);
            make.top.mas_equalTo(weakSelf.view.mas_bottom);
            make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.mas_equalTo(@(150));
        }];
    }
    
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

- (IBAction)paperWeChatCriClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SharedViewControllerDidReceiveSharedParamsWithKey:)]) {
        
        self.sharedDictionary = [self.delegate SharedViewControllerDidReceiveSharedParamsWithKey:WXFriendArea_SharedType];
    }
    
    if ([WeChatManager isWeChatInstall]) {
        
        UIImage *image = [self.sharedDictionary objectForKey:XN_WEIBO_PUBLIC_ICON];
        [[WeChatManager sharedManager] sendImage:image atScene:1];
        
    } else {
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:@"您还没有安装微信,是否去App Store下载" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"马上去下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *strUrl = [WeChatManager weChatUrl];
            NSURL *url = [NSURL URLWithString:strUrl];
            [[UIApplication sharedApplication] openURL:url];
            
            [_UI dismissNaviModalViewCtrlAnimated:YES];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [_UI dismissNaviModalViewCtrlAnimated:YES];
        }]];
        
        [_UI presentNaviModalViewCtrl:alertController animated:YES];
        
    }
    
    
    [self hide];
}

- (IBAction)paperWeChatFriClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SharedViewControllerDidReceiveSharedParamsWithKey:)]) {
        
        self.sharedDictionary = [self.delegate SharedViewControllerDidReceiveSharedParamsWithKey:WXFriend_SharedType];
    }
    
    if ([WeChatManager isWeChatInstall]) {
        
        UIImage *image = [self.sharedDictionary objectForKey:XN_WEIBO_PUBLIC_ICON];
        [[WeChatManager sharedManager] sendImage:image atScene:0];
        
    } else {
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:@"您还没有安装微信,是否去App Store下载" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"马上去下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *strUrl = [WeChatManager weChatUrl];
            NSURL *url = [NSURL URLWithString:strUrl];
            [[UIApplication sharedApplication] openURL:url];
            
            [_UI dismissNaviModalViewCtrlAnimated:YES];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [_UI dismissNaviModalViewCtrlAnimated:YES];
        }]];
        
        [_UI presentNaviModalViewCtrl:alertController animated:YES];
    }

    [self hide];
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
