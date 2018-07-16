//
//  PersonalCardViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/3/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "PersonalCardViewController.h"
#import "UniversalInteractWebViewController.h"
#import "SharedViewController.h"

@interface PersonalCardViewController ()<SharedViewControllerDelegate,UniversalInteractWebViewControllerDelegate,UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIButton  * cfgButton;
@property (nonatomic, weak) IBOutlet UIButton  * customerButton;
@property (nonatomic, strong) IBOutlet UIView    * cursorView;
@property (nonatomic, weak) IBOutlet UIView    * headerContainerView;
@property (nonatomic, weak) IBOutlet UIView    * webContainerView;

@property (nonatomic, strong) UniversalInteractWebViewController *webController;
@property (nonatomic, weak) IBOutlet UIWebView * webView;
@property (nonatomic, assign) NSInteger nSelectedTabType; //1:推荐理财师 2:邀请客户
@property (nonatomic, assign) CGRect persionCardPosition;

@property (nonatomic, strong) SharedViewController *sharedCtrl; //分享控件
@property (nonatomic, assign) BOOL  existSharedView;//是否已经存在分享视图

@end

@implementation PersonalCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.title = @"个人名片";
    self.nSelectedTabType = 1;
    
    [self.headerContainerView addSubview:self.cursorView];
    __weak UIButton * tmpButton = self.cfgButton;
    [self.cursorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(tmpButton.mas_centerX);
        make.top.mas_equalTo(tmpButton.mas_bottom).offset(-3);
        make.width.mas_equalTo(@(100));
        make.height.mas_equalTo(@(2));
    }];
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    
    NSString *urlString = [NSString stringWithFormat:@"/pages/card/card.html?type=%@&token=%@", [NSNumber numberWithInteger:self.nSelectedTabType],token];
    
    urlString = [[AppFramework getConfig].XN_REQUEST_H5_BASE_URL stringByAppendingString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: [NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
    self.webView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:self.sharedCtrl.view];
    [self addChildViewController:self.sharedCtrl];
    
    weakSelf(weakSelf)
    [self.sharedCtrl.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark -  推荐理财师／邀请客户
- (IBAction)tabClickAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    self.nSelectedTabType = btn.tag;
    
    if (self.nSelectedTabType == 1) {
       
        [self.cfgButton setTitleColor:UIColorFromHex(0x4e8cef) forState:UIControlStateNormal];
        [self.customerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        __weak UIButton * tmpButton = self.cfgButton;
        [self.cursorView mas_remakeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(tmpButton.mas_centerX);
            make.top.mas_equalTo(tmpButton.mas_bottom).offset(-3);
            make.width.mas_equalTo(@(100));
            make.height.mas_equalTo(@(2));
        }];
    }else
    {
        [self.cfgButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.customerButton setTitleColor:UIColorFromHex(0x4e8cef) forState:UIControlStateNormal];
        
        __weak UIButton * tmpButton = self.customerButton;
        [self.cursorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(tmpButton.mas_centerX);
            make.top.mas_equalTo(tmpButton.mas_bottom).offset(-3);
            make.width.mas_equalTo(@(100));
            make.height.mas_equalTo(@(2));
        }];
    }
    
    [self.headerContainerView layoutIfNeeded];
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    
    NSString *urlString = [NSString stringWithFormat:@"/pages/card/card.html?type=%@&token=%@", [NSNumber numberWithInteger:self.nSelectedTabType],token];
    
    urlString = [[AppFramework getConfig].XN_REQUEST_H5_BASE_URL stringByAppendingString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: [NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
    self.webView.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark - 分享
- (IBAction)sharedAction:(id)sender
{
    [self.sharedCtrl show];
}

#pragma mark - 剪切图片
- (UIImage *)cutPicture
{
    UIImage * image = [self.webView screenSnapWithRect:self.webView.frame.size captureSize:self.webView.bounds];
    UIImageWriteToSavedPhotosAlbum(image, nil,nil, nil);
    
    return image;
}

//换一张
- (IBAction)clickNext:(id)sender
{
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"androidEvent('%@');",@"swiperEvent"]];
}
//////////////////////////////
#pragma mark - protocol Methods
//////////////////////////////////////////

#pragma mark - SharedViewDelegate 分享
- (NSDictionary *)SharedViewControllerDidReceiveSharedParamsWithKey:(SharedType)type
{
    switch (type) {
        case  WXFriend_SharedType:
        case WXFriendArea_SharedType:
        {
            UIImage *image = [self cutPicture];
            
            return @{XN_WEIBO_PUBLIC_ICON:image};
        }
            break;
        default:
        {
            [self showCustomWarnViewWithContent:@"暂不支持"];
        }
            break;
    }
    
    return nil;
}

- (void)persionCardPostion:(CGRect)position
{
    self.persionCardPosition = position;
}

////////////////////
#pragma mark - setter/getter
////////////////////////////////////////////

#pragma mark－ 分享view
- (SharedViewController *)sharedCtrl
{
    if (!_sharedCtrl)
    {
        _sharedCtrl = [[SharedViewController alloc] initWithNibName:@"SharedViewController" bundle:nil defaultIconUrl:@"" canHideFriendShared:NO isImage:YES];
        _sharedCtrl.delegate = self;
    }
    return _sharedCtrl;
}

@end
