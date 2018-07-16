//
//  RecommendViewController.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/13.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "RecommendViewController.h"
#import "WeChatManager.h"
#import "QQManager.h"

@interface RecommendViewController ()

@property (strong, nonatomic) IBOutlet UIView *sharedView;

@property (strong, nonatomic) IBOutlet UIView *signShareView;
@property (weak, nonatomic) IBOutlet UILabel *shareTitleLabel;

@end

@implementation RecommendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self initView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self initView];
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
    self.proDelegate = nil;
    self.agentDelegate = nil;
    self.signDelegate = nil;
}

///////////////////////
#pragma mark - Custom Method
////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    [self.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    [self.view setHidden:YES];
    
    [self.view addSubview:self.sharedView];
    [self.view addSubview:self.signShareView];
    
    weakSelf(weakSelf)
    [self.sharedView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.top.mas_equalTo(weakSelf.view.mas_bottom);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(@(150));
    }];
    
    [self.signShareView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.top.mas_equalTo(weakSelf.view.mas_bottom);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(@(150));
    }];

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 我的直推理财师推荐
- (IBAction)rmanageShared:(id)sender
{
    /***
    Rmanage = 0, // 我的直推理财师
    Rclient,     // 我的客户
    Rcircle,     // 朋友圈
    Rfriend      // 好友
    **/
    
    if (self.proDelegate && [self.proDelegate respondsToSelector:@selector(recommendViewControllerProDid:shareType:)]) {
        
        [self.proDelegate recommendViewControllerProDid:self shareType:Rmanage];
    }
    
    if (self.agentDelegate && [self.agentDelegate respondsToSelector:@selector(recommendViewControllerAgentDid:shareType:)]) {
        [self.agentDelegate recommendViewControllerAgentDid:self shareType:Rmanage];
    }
    
    [self hide];
}

#pragma mark - 我的客户推荐
- (IBAction)Rclient:(id)sender
{
   
    
    if (self.proDelegate && [self.proDelegate respondsToSelector:@selector(recommendViewControllerProDid:shareType:)]) {
        
        [self.proDelegate recommendViewControllerProDid:self shareType:Rclient];
    }
    
    if (self.agentDelegate && [self.agentDelegate respondsToSelector:@selector(recommendViewControllerAgentDid:shareType:)]) {
         [self.agentDelegate recommendViewControllerAgentDid:self shareType:Rclient];
    }

    [self hide];
}

#pragma mark - 微信朋友圈
- (IBAction)Rcircle:(id)sender
{
    
    
    if (self.proDelegate && [self.proDelegate respondsToSelector:@selector(recommendViewControllerProDid:shareType:)])
    {
       NSDictionary *  sharedDic = [self.proDelegate recommendViewControllerProDid:self shareType:Rcircle];
        
        [self doWechatShare:1 sharedContent:sharedDic];
    }
    
    if (self.agentDelegate && [self.agentDelegate respondsToSelector:@selector(recommendViewControllerAgentDid:shareType:)]) {
        NSDictionary *  sharedDic =  [self.agentDelegate recommendViewControllerAgentDid:self shareType:Rcircle];
        
        [self doWechatShare:1 sharedContent:sharedDic];
    }
    
    
    
    [self hide];
}

#pragma mark - 微信好友
- (IBAction)Rfriend:(id)sender
{
    if (self.proDelegate && [self.proDelegate respondsToSelector:@selector(recommendViewControllerProDid:shareType:)])
    {
        NSDictionary *  sharedDic =  [self.proDelegate recommendViewControllerProDid:self shareType:Rfriend];
        
        [self doWechatShare:0 sharedContent:sharedDic];
    }
    
    if (self.agentDelegate && [self.agentDelegate respondsToSelector:@selector(recommendViewControllerAgentDid:shareType:)]) {
        NSDictionary *  sharedDic = [self.agentDelegate recommendViewControllerAgentDid:self shareType:Rfriend];
        [self doWechatShare:0 sharedContent:sharedDic];
    }
    
    [self hide];
}

/////////////////////////////////////////
#pragma mark - 分享操作
//////////////////////////////////////////
- (void)doWechatShare:(int)shareType sharedContent:(NSDictionary *)dic
{
    if ([WeChatManager isWeChatInstall])
    {
        NSString * url = [_LOGIC getComposeUrlWithBaseUrl:[dic objectForKey:@"shareLink"] compose:@"fromApp=liecai&os=ios"];
        NSString *title = [dic objectForKey:@"shareTitle"]; //标题
        NSString *content = [dic objectForKey:@"shareDesc"]; //文案
        NSString *imageUrl = [dic objectForKey:@"shareImgurl"]; // icon url

        [[WeChatManager sharedManager] sendLinkWithTitle:title description:content imageUrl:imageUrl link:url scene:shareType];
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
- (void)doQQShare:(int)shareType sharedContent:(NSDictionary *)dic
{
    if ([QQManager isInstalledQQ])
    {
        NSString * url = [_LOGIC getComposeUrlWithBaseUrl:[dic objectForKey:@"shareLink"] compose:@"fromApp=liecai&os=ios"];
        NSString *title = [dic objectForKey:@"shareTitle"]; //标题
        NSString *content = [dic objectForKey:@"shareDesc"]; //文案
        NSString *imageUrl = [dic objectForKey:@"shareImgurl"]; // icon url
        
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

#pragma mark - 显示
- (void)show:(ShowShareViewType)showType;
{
    [self.view setHidden:NO];
    [self.view layoutIfNeeded];
    
    weakSelf(weakSelf)

    if (showType == ProductShareShow) {
        
        [self.sharedView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(weakSelf.view.mas_leading);
            make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
            make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.mas_equalTo(@(150));
        }];
        [UIView animateWithDuration:VIEWANIMATIONDURATION animations:^{
            
            [self.view layoutIfNeeded];
        }];

    } else if (showType == SignShareShow) {
    
        [self.signShareView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(weakSelf.view.mas_leading);
            make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
            make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.mas_equalTo(@(150));
        }];
        [UIView animateWithDuration:VIEWANIMATIONDURATION animations:^{
            
            [self.view layoutIfNeeded];
        }];
    }
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
        make.height.mas_equalTo(@(150));
    }];
    
    
    [self.signShareView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.top.mas_equalTo(weakSelf.view.mas_bottom);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(@(150));
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

// 签到分享到微信朋友圈
- (IBAction)signShareWXFfriendClick
{
    if (self.signDelegate && [self.signDelegate respondsToSelector:@selector(recommendViewControllerSignDid:shareType:)])
    {
        NSDictionary *dic = [self.signDelegate recommendViewControllerSignDid:self shareType:RSignShareWeChatF];
        
        [self doWechatShare:0 sharedContent:dic];
    }
    [self hide];
}

- (IBAction)signShareWXCircleClick
{
    if (self.signDelegate && [self.signDelegate respondsToSelector:@selector(recommendViewControllerSignDid:shareType:)])
    {
        NSDictionary *dic = [self.signDelegate recommendViewControllerSignDid:self shareType:RSignShareWeChatC];
        
        [self doWechatShare:1 sharedContent:dic];
    }
    [self hide];
}

- (IBAction)signShareQQFriendClick
{
    if (self.signDelegate && [self.signDelegate respondsToSelector:@selector(recommendViewControllerSignDid:shareType:)])
    {
        NSDictionary *dic = [self.signDelegate recommendViewControllerSignDid:self shareType:RSignShareQQF];
        
        [self doQQShare:1 sharedContent:dic];
    }
    [self hide];
}


- (void)setShareTitle:(NSString *)shareTitle
{
    _shareTitle = shareTitle;
    
    self.shareTitleLabel.text = shareTitle;
}



@end
