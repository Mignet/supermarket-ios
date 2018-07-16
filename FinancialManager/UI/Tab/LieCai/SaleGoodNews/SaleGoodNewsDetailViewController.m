//
//  SaleGoodNewsDetailViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/26/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "SaleGoodNewsDetailViewController.h"
#import "SharedViewController.h"
#import "SaleGoodNewsListViewController.h"
#import "XNLeiCaiModule.h"
#import "XNLeiCaiModuleObserver.h"
#import "XNLCSaleGoodNewsItemMode.h"
#import "XNUserModule.h"
#import "XNUserInfo.h"

@interface SaleGoodNewsDetailViewController () <XNLeiCaiModuleObserver,SharedViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *headerLabel;
@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UIView *inviteView;

@property (weak, nonatomic) IBOutlet UIView *bgSupView;


@property (nonatomic, weak) IBOutlet UIView *shareView;

@property (nonatomic, strong) NSString *billId;

@property (nonatomic, strong) SharedViewController *sharedCtrl; //分享控件


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgImgHeight;
@property (weak, nonatomic) IBOutlet UILabel *congratulationLabel;

/*** 名称 **/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/*** 金额 **/
@property (weak, nonatomic) IBOutlet UILabel *accountsLabel;

/*** 出单 **/
@property (weak, nonatomic) IBOutlet UILabel *appearLabel;

/*** 背景图片 **/
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

/*** 未出单视图控件 **/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerLabelHeight;


@property (weak, nonatomic) IBOutlet UIImageView *leftShowImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rightShowImgView;
@property (weak, nonatomic) IBOutlet UILabel *showTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bttomOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *bttomTwoLabel;


@end

@implementation SaleGoodNewsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  billId:(NSString *)billId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.billId = billId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)clickBack:(UIButton *)sender
{
    [_UI currentViewController:self popToRootViewController:YES AndSwitchToTabbarIndex:2 comlite:^{
        
    }];
}

/////////////////
#pragma mark - 自定义
/////////////////////////////////

#pragma mark - 初始化
- (void)initView
{
    self.title = @"猎财喜报";
    
    self.headerLabel.hidden = NO;
    self.inviteView.hidden = YES;
    self.shareView.hidden = NO;
    
    //self.emptyView.hidden = NO;
    //self.contentsView.hidden = YES;
    
    [self.view addSubview:self.sharedCtrl.view];
    [self addChildViewController:self.sharedCtrl];
    
    if (Device_Is_iPhoneX) {
        
        self.bgImgHeight.constant = SCREEN_FRAME.size.height - (50 + 88.f);
        
    } else {
        
        self.bgImgHeight.constant = SCREEN_FRAME.size.height - (50 + 64.f);
    }
    
    weakSelf(weakSelf)

    [self.sharedCtrl.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];
    
    [[XNLeiCaiModule defaultModule] addObserver:self];
    [self loadDatas];
    [self.view showGifLoading];
    
    if ([self.view respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 加载数据
- (void)loadDatas
{
    [[XNLeiCaiModule defaultModule] requestSaleGoodNewsDetailWithId:self.billId];
}

#pragma mark - 展示数据
- (void)showDatas:(XNLCSaleGoodNewsItemMode *)mode
{
    self.headerLabel.hidden = NO;
    self.inviteView.hidden = NO;
    self.shareView.hidden = YES;
    

    if (mode) // 有出单
    {
        self.leftShowImgView.hidden = NO;
        self.rightShowImgView.hidden = NO;
        self.showTitleLabel.hidden = NO;
        self.bttomOneLabel.hidden = NO;
        self.bttomTwoLabel.hidden = NO;
        
        self.headerLabel.hidden = YES;
        self.headerLabelHeight.constant = 0.f;
        self.inviteView.hidden = YES;
        self.shareView.hidden = NO;
        

        self.nameLabel.text = [[XNUserModule defaultModule] userMode].userName;
        self.appearLabel.text = [NSString stringWithFormat:@"名下%@用户出单", mode.userName];
        
        float fMaxSize = 50.0f;
        float fMinSize = 24.0f;
        
        self.congratulationLabel.hidden = NO;
        self.nameLabel.hidden = NO;
        self.appearLabel.hidden = NO;
        self.accountsLabel.hidden = NO;
        
        //self.bgImgHeight.constant = (SCREEN_FRAME.size.width / 375.f) * 600.f;
        
        if ([mode.amount integerValue] >= 10000) {
            self.bgImgView.image = [UIImage imageNamed:@"XN_LieCai_Sale_Good_News_bg_two"];
        } else {
            self.bgImgView.image = [UIImage imageNamed:@"XN_LieCai_Sale_Good_News_bg_one"];
        }
        
        NSArray *propertyArray = @[@{@"range": mode.amount,
                                     @"color": UIColorFromHex(0XF6D5A5),
                                     @"font": [UIFont fontWithName:@"DINOT" size:fMaxSize]},
                                   @{@"range": @"元",
                                     @"color": UIColorFromHex(0XF6D5A5),
                                     @"font": [UIFont systemFontOfSize:fMinSize]}];
        NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
        self.accountsLabel.attributedText = string;
        
        
        if (Device_Is_iPhoneX) {
            
            self.bgImgHeight.constant = SCREEN_FRAME.size.height - (50 + 88.f);
            
        } else {
            
            if (SCREEN_FRAME.size.width == 320.f) {
                
                self.bgImgHeight.constant = 667.f - (50 + 64.f);
                
            } else {
                
                self.bgImgHeight.constant = SCREEN_FRAME.size.height - (50 + 64.f);
            }
        }
        
    } else { // 没有出单
        
        self.leftShowImgView.hidden = YES;
        self.rightShowImgView.hidden = YES;
        self.showTitleLabel.hidden = YES;
        self.bttomOneLabel.hidden = YES;
        self.bttomTwoLabel.hidden = YES;
        
        self.congratulationLabel.hidden = YES;
        self.nameLabel.hidden = YES;
        self.appearLabel.hidden = YES;
        self.accountsLabel.hidden = YES;
        
        self.headerLabelHeight.constant = 30.f;
        
        if (Device_Is_iPhoneX) {
            self.bgImgHeight.constant = SCREEN_FRAME.size.height - (50 + 88.f + 30.f);
        } else {
            if (SCREEN_FRAME.size.width == 320.f) {
                self.bgImgHeight.constant = 667.f - (50 + 64.f) - 30.f;
            } else {
                self.bgImgHeight.constant = SCREEN_FRAME.size.height - (50 + 64.f);
            }
        }
        self.bgImgView.image = [UIImage imageNamed:@"XN_LieCai_Sale_Good_News_bg_no_order.png"];
    }
}

#pragma mark - 邀请好友
- (IBAction)inviteFriendsAction:(id)sender
{
    NSString * tagString = @"S_2_2";
    [XNUMengHelper umengEvent:tagString];
    
    UniversalInteractWebViewController *webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:[_LOGIC getWebUrlWithBaseUrl:@"/pages/guide/plannerInvitation.html"] requestMethod:@"GET"];
    [webCtrl setTitleName:@""];
    [webCtrl setNewWebView:YES];
    [webCtrl setNeedNewSwitchViewAnimation:YES];
    [webCtrl.navigationItem addRightBarItemWithTitle:@"邀请客户" titleColor:[UIColor whiteColor] target:self action:@selector(invitedCustomer)];
    
    [_UI pushViewControllerFromRoot:webCtrl animated:YES];
}

//邀请客户操作
- (void)invitedCustomer
{
    UniversalInteractWebViewController *webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:[_LOGIC getWebUrlWithBaseUrl:@"/pages/guide/clientInvitation.html"] requestMethod:@"GET"];
    [webCtrl setNewWebView:YES];
    [webCtrl setTitleName:@""];
    [webCtrl setNeedNewSwitchViewAnimation:YES];
    [webCtrl.navigationItem addRightBarItemWithTitle:@"邀请理财师" titleColor:[UIColor whiteColor] target:self action:@selector(invitedCfg)];
    
    [_UI pushViewControllerFromRoot:webCtrl animated:YES];
}

//邀请理财师
- (void)invitedCfg
{
    [_UI popViewControllerFromRoot:YES];
}

#pragma mark - 全部喜报
- (IBAction)allSaleNewsAction:(id)sender
{
    SaleGoodNewsListViewController *viewController = [[SaleGoodNewsListViewController alloc] initWithNibName:@"SaleGoodNewsListViewController" bundle:nil];
    [_UI pushViewControllerFromRoot:viewController animated:YES];
}

#pragma mark - 分享
- (IBAction)sharedAction:(id)sender
{
    [self.sharedCtrl show];
}

#pragma mark - 剪切图片
- (UIImage *)cutPicture
{
    UIImage * image = [self.bgSupView screenSnapWithRect:self.bgSupView.frame.size captureSize:self.bgSupView.bounds];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    return image;
}

//////////////////////////////
#pragma mark - protocol methods
//////////////////////////////

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

#pragma mark - 出单喜报
- (void)XNLeiCaiModuleSaleGoodNewsDetailDidSuccess:(XNLeiCaiModule *)module
{
    [self.view hideLoading];
    XNLCSaleGoodNewsItemMode *mode = module.saleGoodNewsItemMode;
    //展示数据
    [self showDatas:mode];
}

- (void)XNLeiCaiModuleSaleGoodNewsDetailDidFailed:(XNLeiCaiModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic)
    {
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

///////////////////////////////
#pragma mark - setter/getter
///////////////////////////////

#pragma mark－ 分享view
- (SharedViewController *)sharedCtrl
{
    if (!_sharedCtrl) {
    
        _sharedCtrl = [[SharedViewController alloc] initWithNibName:@"SharedViewController" bundle:nil isFondPaper:YES];
        _sharedCtrl.delegate = self;
        
        
    }
    return _sharedCtrl;
}

@end
