#import "MyInfoViewController.h"
#import "MyInvestCell.h"
#import "XNInvestPlatformsEmptyCell.h"
#import "MJRefresh.h"

#import "NSString+common.h"
#import "UINavigationItem+Extension.h"

#import "AccountCenterController.h"
#import "MIMyAccountControllerContainer.h"
#import "MIDeportMoneyController.h"
#import "MIMoreViewController.h"
#import "UseLoginViewController.h"
#import "MIMessageContainerController.h"
#import "CouponContainerViewController.h"
#import "MIMyAccountController.h"
#import "NewUserGuildController.h"
#import "ProductViewController.h"
#import "CustomLoginViewController.h"
#import "NetworkUnReachStatusView.h"
#import "MyCustomerViewController.h"
#import "MyCfgViewController.h"
#import "MyAccountBookViewController.h"
#import "UserForgetPasswordController.h"

#import "MIAddBankCardController.h"
#import "MIAuthenticateViewController.h"
#import "MIAddBankCardSuccessController.h"
#import "MIInitPayPwdViewController.h"
#import "CustomerChatManager.h"
#import "ImagePickerViewController.h"
#import "MIAccountBalanceViewController.h"
#import "FeedBackController.h"
#import "ActivityGuilderController.h"
#import "CSMyCustomerServiceController.h"

#import "NewInvestRecordViewController.h"  //交易记录
#import "ZJCalendarManager.h"
#import "RebackCalendarViewController.h"
#import "NewBackCalendarViewController.h"

#import "MyBundViewController.h"
#import "P2pInvestRecordViewController.h"

#import "UniversalInteractWebViewController.h"

#import "XNInsuranceListLinkMode.h"
#import "XNInsuranceModule.h"
#import "MIMySetMode.h"
#import "XNMIHomePageInfoMode.h"
#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"
#import "XNCommonModule.h"
#import "XNConfigMode.h"
#import "XNUserModule.h"
#import "XNUserInfo.h"
#import "XNInvestPlatformMode.h"
#import "XNInvestPlatformDetailMode.h"

#define CELLHEIGHT 58.0f
#define DEFAULTEMPTYCELLHEIGHT 100.0f

@interface MyInfoViewController ()<XNMyInformationModuleObserver, UniversalInteractWebViewControllerDelegate,UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isNeedRefresh;
@property (nonatomic, assign) NSInteger  loginStatus; //0 表示登录，1表示注册，2表示默认操作
@property (nonatomic, strong) NSDictionary   * levelImageDictionary;
@property (nonatomic, strong) UIImageView    * headerRefrshBgImageView;
@property (nonatomic, assign) CGFloat          contentOffY;

@property (nonatomic, strong) CustomLoginViewController * loginCtrl;
@property (nonatomic, strong) NetworkUnReachStatusView * networkErrorView;

@property (nonatomic, weak)   IBOutlet UIImageView * headerImageView;
@property (nonatomic, weak)   IBOutlet UILabel     * phoneLabel;
@property (nonatomic, weak)   IBOutlet UILabel     * levelNameLabel;
@property (nonatomic, weak)   IBOutlet UILabel     * packetMoneyLabel;
@property (nonatomic, weak)   IBOutlet UILabel     * monthMoneyLabel;
@property (nonatomic, weak)   IBOutlet UILabel     * totalMoneyLabel;
@property (nonatomic, strong) IBOutlet UIView      * headerView;

@property (nonatomic, weak)   IBOutlet UILabel * bindCardRemindLabel;
@property (nonatomic, strong) IBOutlet UIView * bindCardView;
@property (nonatomic, strong) IBOutlet UIButton *bindCardButton;

@property (nonatomic, weak)   IBOutlet UILabel * tradeRecordTimeLabel;
@property (nonatomic, weak)   IBOutlet UIImageView * tradeRecordTagImageView;
@property (nonatomic, weak)   IBOutlet UILabel * rebackRecordTimeLabel;
@property (nonatomic, weak)   IBOutlet UIImageView * rebackRecordTagImageView;
@property (nonatomic, weak)   IBOutlet UILabel * cfgCountLabel;
@property (nonatomic, weak)   IBOutlet UILabel * customerCountLabel;
@property (nonatomic, weak)   IBOutlet UILabel * levelLabel;
@property (nonatomic, weak)   IBOutlet UILabel * p2pLabel;
@property (nonatomic, weak)   IBOutlet UILabel * bundLabel;
@property (nonatomic, weak)   IBOutlet UILabel * redPacketLabel;
@property (nonatomic, weak)   IBOutlet UILabel * bookLabel;
@property (nonatomic, strong) IBOutlet UIView * investView;

@property (nonatomic, strong) IBOutlet UIView * footerView;
@property (nonatomic, weak) IBOutlet UIScrollView  * containerScrollView;

@end

@implementation MyInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if ([NSObject isValidateInitString:token]) {
        
        [self loadDatas];
    }else
    {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"myInfo" ofType:@"json"];
        NSData * data = [[NSData alloc]initWithContentsOfFile:path];
        
        NSError * error = nil;
        NSDictionary * homeInfoJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        path = [[NSBundle mainBundle] pathForResource:@"myBund" ofType:@"json"];
        data = [[NSData alloc]initWithContentsOfFile:path];
        NSDictionary * liecaiInfoJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        [[XNMyInformationModule defaultModule] setHomePageMode:[XNMIHomePageInfoMode initHomePageWithObject:homeInfoJson]];
        [[XNMyInformationModule defaultModule] setBundAmount:[liecaiInfoJson objectForKey:XN_MYINFO_MY_BUND]];
        
        [self updateData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [XNUMengHelper umengEvent:@"W_0_0"];
    
    self.loginStatus = 2;
    
    //取消特殊登录的相关逻辑处理
    if ([[_UI topController] isEqual:self]) {
        
        [self.loginCtrl.view setHidden:NO];
        [self setNeedNewSwitchViewAnimation:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.loginStatus == 1) {
        
        [self.loginCtrl.view setHidden:YES];
    }else if(self.loginStatus == 0)
    {
        [self.loginCtrl.view setHidden:NO];
        ((UIViewController *)_UI.rootTabBarCtrl).snaptView = [[[UIApplication sharedApplication] keyWindow] snapshotViewAfterScreenUpdates:NO];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[XNInsuranceModule defaultModule] removeObserver:self];
    [[AppFramework getGlobalHandler] removePopupView];
    [super viewDidDisappear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (@available(iOS 11.0, *)) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.containerScrollView.contentInset = UIEdgeInsetsMake(0, 0,safeAreaInsets(self.view).bottom, 0);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[XNMyInformationModule defaultModule] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.isNeedRefresh = NO;
    [[XNMyInformationModule defaultModule] addObserver:self];
    self.navigationSeperatorLineStatus = YES;
    self.contentOffY = 0.0f;
    self.loginStatus = 2;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedBindCard) name:XNUSERBINDCARDSUCCESSNOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitOperation) name:XN_USER_EXIT_SUCCESS_NOTIFICATION object:nil];
    [self.navigationItem addMessageRemindItemWithTarget:self action:@selector(clickMessageRemind:)];
    
    [self createView];
    
    //未登录设置登录界面
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        UIImageView * tmpMsgImageView = (UIImageView *)[self.navigationController.navigationItem getItemViewWithTag:@"MESSAGEREMINDVIEW" forTarget:self];
        if (tmpMsgImageView) {
            
            [tmpMsgImageView setHidden:YES];
        }
        
        //显示登录
        [self.parentViewController.view addSubview:self.loginCtrl.view];
        __weak UIView * tmpView = self.parentViewController.view;
        [self.loginCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(tmpView);
        }];
    }
    
    if ([self.view respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 添加视图
- (void)createView
{
    //添加试图
    [self.containerScrollView addSubview:self.headerView];
    [self.containerScrollView addSubview:self.bindCardView];
    [self.containerScrollView addSubview:self.investView];
    [self.containerScrollView addSubview:self.footerView];
    
    //判断是否之前绑卡过
    if ([[XNMyInformationModule defaultModule] settingMode].onceMoreBindCard) {
        
        self.bindCardRemindLabel.text = @"为了您的资金安全，请先绑定银行卡";
    }else
    {
        self.bindCardRemindLabel.text = @"绑定银行卡送20元理财红包";
    }
    
    self.bindCardButton.layer.masksToBounds = YES;
    self.bindCardButton.layer.cornerRadius = 3;
    self.bindCardButton.layer.borderWidth = 1;
    self.bindCardButton.layer.borderColor = UIColorFromHex(0x4e8cef).CGColor;
    
    __weak UIScrollView * tmpContainerScrollView = self.containerScrollView;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.mas_equalTo(tmpContainerScrollView.mas_leading);
        make.top.mas_equalTo(tmpContainerScrollView.mas_top);
        make.trailing.mas_equalTo(tmpContainerScrollView.mas_trailing);
        make.width.mas_equalTo(tmpContainerScrollView.mas_width);
        make.height.mas_equalTo(@(125));
    }];
    
    __weak UIView * tmpView = self.headerView;
    [self.bindCardView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.mas_equalTo(tmpContainerScrollView.mas_leading);
        make.top.mas_equalTo(tmpView.mas_bottom);
        make.trailing.mas_equalTo(tmpContainerScrollView.mas_trailing);
        make.width.mas_equalTo(tmpContainerScrollView.mas_width);
        make.height.mas_equalTo(@(0));
    }];
    [self.bindCardView setHidden:YES];
    
    tmpView = self.bindCardView;
    [self.investView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.mas_equalTo(tmpContainerScrollView.mas_leading);
        make.top.mas_equalTo(tmpView.mas_bottom).offset(0);
        make.trailing.mas_equalTo(tmpContainerScrollView.mas_trailing);
        make.width.mas_equalTo(tmpContainerScrollView.mas_width);
        make.height.mas_equalTo(@(605));
    }];
    
    tmpView = self.investView;
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.mas_equalTo(tmpContainerScrollView.mas_leading);
        make.top.mas_equalTo(tmpView.mas_bottom).offset(0);
        make.trailing.mas_equalTo(tmpContainerScrollView.mas_trailing);
        make.height.mas_equalTo(@(142));
        make.width.mas_equalTo(tmpContainerScrollView.mas_width);
        make.bottom.mas_equalTo(tmpContainerScrollView.mas_bottom);
    }];
    
    weakSelf(weakSelf)
    self.containerScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadDatas];
    }];
    
    self.headerRefrshBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width, 100)];
    self.headerRefrshBgImageView.image = [UIImage imageNamed:@"menu_bar_bg.png"];
    [self.containerScrollView insertSubview:self.headerRefrshBgImageView atIndex:0];
    
    [self.containerScrollView layoutIfNeeded];
}

//加载数据
- (void)loadDatas
{
    //判断网络是否可达
    [self.networkErrorView removeFromSuperview];
    if ([_ASSIST getNetworkStatus] == Network_NotReachable) {
        
        [self.view addSubview:self.networkErrorView];
        weakSelf(weakSelf)
        [self.networkErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.view);
        }];
        return;
    }
    
    [[XNMyInformationModule defaultModule] requestMySettingInfo];
    [[XNMyInformationModule defaultModule] getMyInfoHomePageInfo];
    [[XNMyInformationModule defaultModule] getMyBundInfo];
}

#pragma mark - 登入成功刷新
- (void)loginSuccessRfreshData
{
    [self hideLoadingTarget:self];
    
    [self.loginCtrl.view removeFromSuperview];
    
    UIImageView * tmpMsgImageView = (UIImageView *)[self.navigationController.navigationItem getItemViewWithTag:@"MESSAGEREMINDVIEW" forTarget:self];
    [tmpMsgImageView setHidden:NO];
    
    self.isNeedRefresh = YES;
}

//退出
- (void)exitOperation
{
    //显示登录
    [self.parentViewController.view addSubview:self.loginCtrl.view];
    __weak UIView * tmpView = self.parentViewController.view;
    [self.loginCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpView);
    }];
}

//更新数据
- (void)updateData
{
    NSString *urlString = [NSString stringWithFormat:@"%@?f=png", [_LOGIC getImagePathUrlWithBaseUrl:[[[XNMyInformationModule defaultModule] homePageMode] headImage]]];
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"XN_MyInfo_header_icon.png"]];
    [self.headerImageView.layer setCornerRadius:23.5];
    [self.headerImageView.layer setMasksToBounds:YES];
    
    self.phoneLabel.text = [[[[XNMyInformationModule defaultModule] homePageMode] mobile] convertToSecurityPhoneNumber];
    self.levelNameLabel.text = [NSString stringWithFormat:@"职级：%@",[[[XNMyInformationModule defaultModule] homePageMode] cfgLevelName]];
    
    self.packetMoneyLabel.text = [[[XNMyInformationModule defaultModule] homePageMode] packetMoneyIncome];
    self.monthMoneyLabel.text = [[[XNMyInformationModule defaultModule] homePageMode] monthIncome];
    self.totalMoneyLabel.text = [[[XNMyInformationModule defaultModule] homePageMode] totalIncome];
    
    
    CGFloat topHeight = 125;
    __weak UIScrollView * tmpContainerScrollView = self.containerScrollView;
    __weak UIView * tmpView = self.headerView;

    if ([NSObject isValidateObj:[[XNMyInformationModule defaultModule] settingMode]] && ![[[XNMyInformationModule defaultModule] settingMode] bundBankCard]) {
        
        [self.bindCardView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpContainerScrollView.mas_leading);
            make.top.mas_equalTo(tmpView.mas_bottom);
            make.trailing.mas_equalTo(tmpContainerScrollView.mas_trailing);
            make.height.mas_equalTo(@(45));
        }];
        
        [self.bindCardView setHidden:NO];
        topHeight = 170;
    }
    
    else {
        
        [self.bindCardView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpContainerScrollView.mas_leading);
            make.top.mas_equalTo(tmpView.mas_bottom);
            make.trailing.mas_equalTo(tmpContainerScrollView.mas_trailing);
            make.height.mas_equalTo(@(0));
        }];
        
        [self.bindCardView setHidden:YES];
    }
    
    //判断是否有新的交易记录和回款记录
    [self.tradeRecordTagImageView setHidden:YES];
    if ([[[XNMyInformationModule defaultModule] homePageMode] newTranRecordStatus]) {
        
        [self.tradeRecordTagImageView setHidden:NO];
    }
    
    [self.rebackRecordTagImageView setHidden:YES];
    if ([[[XNMyInformationModule defaultModule] homePageMode] newPaymentRecordStatus]) {
        
        [self.rebackRecordTagImageView setHidden:NO];
    }
    
    //设置相关投资信息
    self.tradeRecordTimeLabel.text = [[[XNMyInformationModule defaultModule] homePageMode] tranRecordDate];
    self.rebackRecordTimeLabel.text = [[[XNMyInformationModule defaultModule] homePageMode] paymentDate];
    self.cfgCountLabel.text = [[[XNMyInformationModule defaultModule] homePageMode] teamMember];
    self.customerCountLabel.text = [[[XNMyInformationModule defaultModule] homePageMode] customerMember];
    self.levelLabel.text = [[[XNMyInformationModule defaultModule] homePageMode] gradePrivi];
    self.p2pLabel.text = [[[XNMyInformationModule defaultModule] homePageMode] p2p];
    self.redPacketLabel.text = [[[XNMyInformationModule defaultModule] homePageMode] coupon];
    self.bookLabel.text = [[[XNMyInformationModule defaultModule] homePageMode] accountBook];
    
    [self.containerScrollView layoutIfNeeded];
}

//个人中心
- (IBAction)clickSetting:(id)sender
{
    //umeng统计点击次数－设置
    [XNUMengHelper umengEvent:@"W_6_3"];
    
    NSString *levelName = [[[XNMyInformationModule defaultModule] homePageMode] grade];
    AccountCenterController * ctrl = [[AccountCenterController alloc] initWithNibName:@"AccountCenterController" bundle:nil levelName:levelName];

    [_UI pushViewControllerFromRoot:ctrl animated:YES];
}

//绑卡
- (IBAction)clickBindCard:(id)sender
{
    MIAddBankCardController * bankCardInfoCtrl = [[MIAddBankCardController alloc]initWithNibName:@"MIAddBankCardController" bundle:nil];
    
    [_LOGIC saveValueForKey:XN_USER_INIT_PAY_PASSWORD_CONTROLLER Value:@"MyInfoViewController"];
    
    [_UI pushViewControllerFromRoot:bankCardInfoCtrl animated:YES];
}

//账户余额
- (IBAction)clickAccount:(id)sender
{
    [XNUMengHelper umengEvent:@"W_2_1"];
    MIAccountBalanceViewController * ctrl = [[MIAccountBalanceViewController alloc]initWithNibName:@"MIAccountBalanceViewController" bundle:nil];
    
    [_UI pushViewControllerFromRoot:ctrl animated:YES];
}

// 投资记录
- (IBAction)clickMyInvestHistory:(id)sender
{
    [XNUMengHelper umengEvent:@"W_3_2"];
    
    // 对单例选中数据赋空
    [[ZJCalendarManager shareInstance] setRebackDateArrWithNil];
    [ZJCalendarManager shareInstance].selectedItemModel = nil;
    [ZJCalendarManager shareInstance].investOrReback = Manager_Invest_Type;
    
    NewInvestRecordViewController *newInvestRecordVC = [[NewInvestRecordViewController alloc] init];
    [_UI pushViewControllerFromRoot:newInvestRecordVC animated:YES];
}

//回款日历
- (IBAction)clickRebackHistory:(id)sender
{
    [XNUMengHelper umengEvent:@"W_3_3"];

    // 对单例选中数据赋空
    [[ZJCalendarManager shareInstance] setRebackDateArrWithNil];
    [ZJCalendarManager shareInstance].selectedItemModel = nil;
    [ZJCalendarManager shareInstance].investOrReback = Manager_Reback_Type;
    
    NewBackCalendarViewController *vc = [[NewBackCalendarViewController alloc] init];
    [_UI pushViewControllerFromRoot:vc animated:YES];
}

//理财师团队成员
- (IBAction)clickCfgTeam:(id)sender
{
    [XNUMengHelper umengEvent:@"W_8_1"];
    MyCfgViewController * ctrl = [[MyCfgViewController alloc]initWithNibName:@"MyCfgViewController" bundle:nil];
    
    [_UI pushViewControllerFromRoot:ctrl animated:YES];
}

//客户成员
- (IBAction)clickCustomerTeam:(id)sender
{
    [XNUMengHelper umengEvent:@"W_9_1"];
    MyCustomerViewController * ctrl = [[MyCustomerViewController alloc]initWithNibName:@"MyCustomerViewController" bundle:nil];
    
    [_UI pushViewControllerFromRoot:ctrl animated:YES];
}

//职级特权
- (IBAction)clickLevel:(id)sender
{
    [XNUMengHelper umengEvent:@"W_6_5"];
    
    //https://preliecai.toobei.com/pages/rank/my_rank.html
    NSString *urlStr = [_LOGIC getWebUrlWithBaseUrl:@"/pages/rank/my_rank.html"];
    UniversalInteractWebViewController *webViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:urlStr requestMethod:@"GET"];
    
    [_UI pushViewControllerFromRoot:webViewController animated:YES];
}

//邀请理财师
- (IBAction)clickInvestCfg:(id)sender
{
    [XNUMengHelper umengEvent:@"W_6_6"];
    
    UniversalInteractWebViewController *webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:[_LOGIC getWebUrlWithBaseUrl:@"/pages/guide/plannerInvitation.html"] requestMethod:@"GET"];
    [webCtrl setTitleName:@""];
    [webCtrl.handleBridgeEventManager addRightInvitedCustomer];
    
    [_UI pushViewControllerFromRoot:webCtrl animated:YES];
}

//网贷
- (IBAction)clickP2p:(id)sender
{
    [XNUMengHelper umengEvent:@"W_7_1"];
    P2pInvestRecordViewController * ctrl = [[P2pInvestRecordViewController alloc]initWithNibName:@"P2pInvestRecordViewController" bundle:nil];
    
    [_UI pushViewControllerFromRoot:ctrl animated:YES];
}

//基金
- (IBAction)clickBundle:(id)sender
{
    [XNUMengHelper umengEvent:@"W_4_1"];
    MyBundViewController *viewController = [[MyBundViewController alloc] initWithNibName:@"MyBundViewController" bundle:nil];
    [_UI pushViewControllerFromRoot:viewController animated:YES];
}

//保险
- (IBAction)clickInsurance:(id)sender
{
    [XNUMengHelper umengEvent:@"W_5_1"];
    if ([[XNInsuranceModule defaultModule] insuranceListLinkMode]) {
        
        UniversalInteractWebViewController * interactWebViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:[[XNInsuranceModule defaultModule] insuranceListLinkMode].jumpInsuranceUrl requestMethod:@"GET"];
        [interactWebViewController setHidenThirdAgentHeaderElement:YES];
        
        [interactWebViewController setIsEnterThirdPlatform:YES platformName:@"慧择"];
        [interactWebViewController.view setBackgroundColor:[UIColor whiteColor]];
        
        [_UI pushViewControllerFromRoot:interactWebViewController animated:YES];
    }else
    {
        [[XNInsuranceModule defaultModule] requestInsuranceOrderListLink];
        [[XNInsuranceModule defaultModule] addObserver:self];
        [self.view showGifLoading];
    }
}

//优惠券
- (IBAction)clickRedPacket:(id)sender
{
    [XNUMengHelper umengEvent:@"W_6_1"];
    CouponContainerViewController * ctrl = [[CouponContainerViewController alloc]initWithNibName:@"CouponContainerViewController" bundle:nil];
    
    [_UI pushViewControllerFromRoot:ctrl animated:YES];
}

//记账本
- (IBAction)clickBook:(id)sender
{
    [XNUMengHelper umengEvent:@"W_6_4"];
    MyAccountBookViewController * ctrl = [[MyAccountBookViewController alloc]initWithNibName:@"MyAccountBookViewController" bundle:nil];
    
    [_UI pushViewControllerFromRoot:ctrl animated:YES];
}

//帮助中心
- (IBAction)clickHelpCenter:(id)sender
{
    [XNUMengHelper umengEvent:@"W_6_2"];
    CSMyCustomerServiceController * ctrl = [[CSMyCustomerServiceController alloc]initWithNibName:@"CSMyCustomerServiceController" bundle:nil title:@"帮助中心"];
    
    [_UI pushViewControllerFromRoot:ctrl animated:YES];
}

//绑卡成功
- (void)finishedBindCard
{
    self.isNeedRefresh = YES;
}

//点击消息中心
- (void)clickMessageRemind:(id)sender
{
    [XNUMengHelper umengEvent:@"W_1_1"];
    MIMessageContainerController * messageContainerController = [[MIMessageContainerController alloc] initWithMessageType:NotificationMessage];
    
    [_UI pushViewControllerFromRoot:messageContainerController animated:YES];
}

///////////////////////////////////
#pragma mark - protocol Methods
///////////////////////////////////

#pragma mark -获取首页数据
- (void)XNMyInfoModuleGetHomePageDidReceive:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    [self.containerScrollView.mj_header endRefreshing];
    
    [self updateData];
}

- (void)XNMyInfoModuleGetHomePageDidFailed:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    [self.containerScrollView.mj_header endRefreshing];
    
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

- (void)XNMyInfoModuleGetMyBundDidReceive:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    
    self.bundLabel.text = module.bundAmount;
}

- (void)XNMyInfoModuleGetMyBundDidFailed:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//保险订单
- (void)XNFinancialManagerModuleInsuranceOrderLinkDidReceive:(XNInsuranceModule *)module
{
    [self.view hideLoading];
    [[XNInsuranceModule defaultModule] removeObserver:self];
    
    UniversalInteractWebViewController * interactWebViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:[module insuranceListLinkMode].jumpInsuranceUrl requestMethod:@"GET"];
    [interactWebViewController setHidenThirdAgentHeaderElement:YES];
    
    [interactWebViewController setIsEnterThirdPlatform:YES platformName:@"慧择"];
    [interactWebViewController.view setBackgroundColor:[UIColor whiteColor]];
    
    [_UI pushViewControllerFromRoot:interactWebViewController animated:YES];
}

- (void)XNFinancialManagerModuleInsuranceOrderLinkDidFailed:(XNInsuranceModule *)module
{
    [self.view hideLoading];
    [[XNInsuranceModule defaultModule] removeObserver:self];
    
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

- (void)XNMyInfoModulePeopleSettingDidReceive:(XNMyInformationModule *)module
{

    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat width = 0;
    if (offset <= 0) {
        
        width = - offset;
    }
    
    self.headerRefrshBgImageView.frame = CGRectMake(0 , offset, SCREEN_FRAME.size.width, width);
}

////////////////////
#pragma mark - setter/getter
/////////////////////////////////

#pragma mark - levelImageArray
- (NSDictionary *)levelImageDictionary
{
    if (!_levelImageDictionary) {
        
        _levelImageDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"XN_MyInfo_jx_Level_icon.png",@"见习",@"XN_MyInfo_gw_Level_icon.png",@"顾问",@"XN_MyInfo_jl_Level_icon.png",@"经理",@"XN_MyInfo_zj_Level_icon.png",@"总监", nil];
    }
    return _levelImageDictionary;
}

//loginCtrl
- (CustomLoginViewController *)loginCtrl
{
    if (!_loginCtrl) {
        
        _loginCtrl = [[CustomLoginViewController alloc]initWithNibName:@"CustomLoginViewController" bundle:nil];
        weakSelf(weakSelf)
        [_loginCtrl setLoginOperationBlock:^(NSInteger status) {
            
            weakSelf.loginStatus = status;
        }];
    }
    return _loginCtrl;
}

//无网络视图
- (NetworkUnReachStatusView *)networkErrorView
{
    if (!_networkErrorView) {
        
        _networkErrorView = [[NetworkUnReachStatusView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
        weakSelf(weakSelf)
        [_networkErrorView setNetworkRetryOperation:^{
            
            [weakSelf loadDatas];
        }];
    }
    return _networkErrorView;
}


@end
