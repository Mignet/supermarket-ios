#import "HomeViewController.h"
#import "UniversalInteractWebViewController.h"
#import "NewUserGuildController.h"
#import "FinancialManager-Swift.h"
#import "MIMessageContainerController.h"
#import "CouponContainerViewController.h"
#import "NetworkUnReachStatusView.h"
#import "CustomCouponPopView.h"
#import "CustomDoubleElevenPopView.h"
#import "CustomPopViewContainer.h"

#import "MJRefresh.h"
#import "CustomPopAdvView.h"
#import "UIImageView+WebCache.h"
#import "UINavigationBar+Background.h"
#import "UINavigationItem+Extension.h"
#import "UIView+Common.h"
#import "PXAlertView+XNExtenstion.h"
#import "WeChatManager.h"

#import "CustomRemindView.h"
#import "CalendarManager.h"
#import "SelectProductListViewController.h"
#import "AgentContainerController.h"
#import "MIAddBankCardController.h"
#import "CustomerServiceController.h"
#import "SignViewController.h"   //签到

#import "HomeHeaderCell.h"
#import "SafeFooterCell.h"
#import "HomeSectionCell.h"
#import "ManagerFinancialProgressCell.h"
#import "HomeCfgSaleCell.h"
#import "HomeBrandIntroduceCell.h"
#import "HotBundCell.h"
#import "NewUserAwardCell.h"
#import "LCClassRoomCell.h"
#import "HotCfgMsgCell.h"

#import "XNNewComissionCouponMode.h"
#import "XNComissionNewRecordMode.h"
#import "XNNewLevelCouponMode.h"
#import "XNCommonModule.h"
#import "XNInsuranceItem.h"
#import "XNInsuranceDetailMode.h"
#import "XNGrowthManualCategoryItemMode.h"
#import "XNInsuranceModule.h"
#import "XNInsuranceModuleObserver.h"
#import "XNClassRoomListMode.h"
#import "XNCSHomePageMode.h"
#import "XNHomeBannerMode.h"
#import "XNHomeModule.h"
#import "XNHomeModuleObserver.h"
#import "XNConfigMode.h"
#import "XNRemindPopMode.h"
#import "XNCommonModule.h"
#import "XNHomeCommissionMode.h"
#import "XNFMProductCategoryListMode.h"
#import "XNFMProductListItemMode.h"
#import "XNCfgMsgListMode.h"
#import "XNCfgMsgItemMode.h"
#import "XNBundModule.h"
#import "XNBundModuleObserver.h"
#import "XNBundListMode.h"
#import "XNBundItemMode.h"
#import "XNBundThirdPageMode.h"
#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"
#import "MIMySetMode.h"
#import "XNHomeAchievementModel.h"

#import "XNActivityModule.h"
#import "XNActivityModuleObserver.h"

#import "InsuranceListCell.h"

#define HEADERHEIGHT (SCREEN_FRAME.size.width * 8 / 15 + 75.f + 78.f + 14.5 + 79.f)
#define NEWUSERAWARDHEIGHT 85.f
#define CLASSROOMLISTHEIGHT 44.f
#define SECTIONHEIGHT 55.f
#define PRODUCTHEIGHT 144.f
#define BUNDHEIGHT 187.f
#define INSURANCEHEIGHT ((SCREEN_FRAME.size.width / 375.f) * 125.f + 110.f)
#define CFGMSGHEIGHT 185.f * (SCREEN_FRAME.size.width / 375.f)
#define CFGSALEHEIGHT 97.f
#define BRANDINTRODUCEHEIGHT 58.f
#define FOOTERHEIGHT 33.f

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,XNHomeModuleObserver,UniversalInteractWebViewControllerDelegate,UIScrollViewDelegate, CustomPopAdvViewDelegate,HomeHeaderCellDelelgate, XNBundModuleObserver, XNMyInformationModuleObserver,XNInsuranceModuleObserver,XNActivityModuleObserver>

@property (nonatomic, assign) BOOL  requestFailed;//判断所有请求是否请求成功
@property (nonatomic, assign) float alphaValue;
@property (nonatomic, strong) NSMutableDictionary * requestCountDictionary;
@property (nonatomic, strong) NSArray *hotProductArray;
@property (nonatomic, strong) NSMutableArray *hotBundArray;
@property (nonatomic, strong) NSArray *hotCfgMsgArray;
@property (nonatomic, strong) NSMutableArray *cellStatusArray;

@property (nonatomic, strong) XNInsuranceModule * insuranceModuleObj;
@property (nonatomic, strong) XNBundModule     * bundModuleObj;
@property (nonatomic, strong) XNMyInformationModule * myInfomationModuleRequest;
@property (nonatomic, strong) XNCommonModule   * homeCommonModuleObj;
@property (nonatomic, strong) CustomPopAdvView *customPopAdvView;
@property (nonatomic, strong) CustomRemindView *remindView;
@property (nonatomic, strong) CustomPopViewContainer * customPopContainer;

@property (nonatomic, strong) id  selectedMode;//任意选中的类型
@property (nonatomic, strong) UniversalInteractWebViewController * interactWebViewController;
@property (nonatomic, strong) NetworkUnReachStatusView * networkErrorView;

@property (nonatomic, strong) CustomerServiceController *phoneCtrl;

@property (nonatomic, weak)   IBOutlet UIView         * msgView;
@property (nonatomic, weak)   IBOutlet UIImageView    * msgImageView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint * msgTopIntervelConstraint;
@property (nonatomic, weak)   IBOutlet UITableView    * contentTableView;
@property (strong,nonatomic) UIWindow *homeWindow;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [XNUMengHelper umengEvent:@"S_0_1"];
    
    self.contentTableView.dataSource = self;
    self.contentTableView.delegate = self;
    
    //显示本地缓存benner
    [self updateStatusArray];
    
    _homeWindow.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController.navigationBar setNavigationBarBgColor:self.newNavigationBarColor];
    
    [self showPopView];
    
    //根据相关接口是否拉取成功调对应的接口
    [self loadNetwork];
    
    //[self signGuide];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[AppFramework getGlobalHandler] removePopupView];
    [self hide];
    
    self.contentTableView.dataSource = nil;
    self.contentTableView.delegate = nil;
    
    _homeWindow.hidden = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (@available(iOS 11.0, *)) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.contentTableView.contentInset = UIEdgeInsetsMake(0, 0,safeAreaInsets(self.view).bottom, 0);
        }];
        
        if (Device_Is_iPhoneX) {
            
            self.msgTopIntervelConstraint.constant = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
    }
}

- (void)dealloc
{
    [self.bundModuleObj removeObserver:self];
    [self.myInfomationModuleRequest removeObserver:self];
    [[XNHomeModule defaultModule] removeObserver:self];
    [self.insuranceModuleObj removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[XNCommonModule defaultModule] removeObserver:self];
    [[XNActivityModule defaultModule] removeObserver:self];
}

////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////

//初始化操作
- (void)initView
{
    [[XNHomeModule defaultModule] addObserver:self];
    [self.insuranceModuleObj addObserver:self];
    [self.bundModuleObj addObserver:self];
    [self.myInfomationModuleRequest addObserver:self];
    [[XNCommonModule defaultModule]  addObserver:self];
    [[XNActivityModule defaultModule] addObserver:self];
    self.needNewSwitchViewAnimation = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUnreadMsgCount:) name:XN_HOME_UNREAD_MESSAGE_COUNT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitOperation) name:XN_USER_EXIT_SUCCESS_NOTIFICATION object:nil];
    
    [self.msgView setHidden:YES];
    [self.contentTableView setContentInset:UIEdgeInsetsMake(-64, 0.f, 0.f, 0.f)];
    self.newNavigationBarColor = UIColorFromHex(0x4e8cef);
    self.newNavigationTitleColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    self.navigationSeperatorLineStatus = YES;
    
    
    [self.contentTableView registerNib:[UINib nibWithNibName:@"HomeHeaderCell" bundle:nil] forCellReuseIdentifier:@"HomeHeaderCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"NewUserAwardCell" bundle:nil] forCellReuseIdentifier:@"NewUserAwardCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"LCClassRoomCell" bundle:nil] forCellReuseIdentifier:@"LCClassRoomCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"HomeSectionCell" bundle:nil] forCellReuseIdentifier:@"HomeSectionCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"ManagerFinancialProgressCell" bundle:nil] forCellReuseIdentifier:@"ManagerFinancialProgressCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"HotBundCell" bundle:nil] forCellReuseIdentifier:@"HotBundCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"HotCfgMsgCell" bundle:nil] forCellReuseIdentifier:@"HotCfgMsgCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"HomeCfgSaleCell" bundle:nil] forCellReuseIdentifier:@"HomeCfgSaleCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"HomeBrandIntroduceCell" bundle:nil] forCellReuseIdentifier:@"HomeBrandIntroduceCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"SafeFooterCell" bundle:nil] forCellReuseIdentifier:@"SafeFooterCell"];
    
    
    [self.contentTableView registerNib:[UINib nibWithNibName:@"InsuranceListCell" bundle:nil] forCellReuseIdentifier:@"InsuranceListCell"];
    
    [self.contentTableView setSeparatorColor:[UIColor clearColor]];
    
    weakSelf(weakSelf)
    self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf.requestCountDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"HOMEPAGEBANNERLISTMETHOD"];
        [weakSelf.requestCountDictionary setValue:[NSNumber numberWithBool:NO]  forKey:@"HOME_PAGE_COMMISSION_METHOD"];
        [weakSelf.requestCountDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"HOME_PAGE_LIECAI_CALSSROOM_METHOD"];
        [weakSelf.requestCountDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"HOME_PAGE_HOT_PRODUCTS_LIST_METHOD"];
        [weakSelf.requestCountDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"XNBUND_MODULE_FUND_SIFT_METHOD"];
        [weakSelf.requestCountDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"XN_INSURANCE_MODULE_SELECTED_INSURANCE_METHOD"];
        [weakSelf.requestCountDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"HOME_PAGE_HOT_CFG_MSG_METHOD"];
        
        [weakSelf loadNetwork];
    }];
    
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"HOMEPAGEBANNERLISTMETHOD"];
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:NO]  forKey:@"HOME_PAGE_COMMISSION_METHOD"];
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"HOME_PAGE_LIECAI_CALSSROOM_METHOD"];
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"HOME_PAGE_HOT_PRODUCTS_LIST_METHOD"];
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"XNBUND_MODULE_FUND_SIFT_METHOD"];
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"XN_INSURANCE_MODULE_SELECTED_INSURANCE_METHOD"];
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"HOME_PAGE_HOT_CFG_MSG_METHOD"];

    [self loadNetwork];
}

#pragma mark - 请求网络请求
- (void)loadNetwork
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
    
    NSInteger requestCount = 0;
    if (![[self.requestCountDictionary objectForKey:@"HOMEPAGEBANNERLISTMETHOD"] boolValue]) {
        
        requestCount = requestCount + 1;
        [[XNHomeModule defaultModule] requestHomePageBannerList];
    }
    
    if (![[self.requestCountDictionary objectForKey:@"HOME_PAGE_COMMISSION_METHOD"] boolValue]) {
        
        requestCount = requestCount + 1;
        [[XNHomeModule defaultModule] requestHomePageCommission];
    }
    
    if (![[self.requestCountDictionary objectForKey:@"HOME_PAGE_LIECAI_CALSSROOM_METHOD"] boolValue]) {
        
        requestCount = requestCount + 1;
        [[XNHomeModule defaultModule] requestLcClassRoomList];
    }
    
    if (![[self.requestCountDictionary objectForKey:@"HOME_PAGE_HOT_PRODUCTS_LIST_METHOD"] boolValue]) {
        
        requestCount = requestCount + 1;
        [[XNHomeModule defaultModule] requestHomePageHotProductsList];
    }
    
    if (![[self.requestCountDictionary objectForKey:@"XNBUND_MODULE_FUND_SIFT_METHOD"] boolValue]) {
        
        requestCount = requestCount + 1;
        [self.bundModuleObj requestHotBundList];
    }
    
    if (![[self.requestCountDictionary objectForKey:@"XN_INSURANCE_MODULE_SELECTED_INSURANCE_METHOD"] boolValue]) {
        
        requestCount = requestCount + 1;
        [self.insuranceModuleObj requestSelectedInsurance];
    }
   
    if (![[self.requestCountDictionary objectForKey:@"HOME_PAGE_HOT_CFG_MSG_METHOD"] boolValue]) {
        
        requestCount = requestCount + 1;
        [[XNHomeModule defaultModule] requestHomePageHotCfgMsgList];
    }
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if ([NSObject isValidateInitString:token]) {
        
        //查看是否存在双十一活动
        [[XNCommonModule defaultModule]  requestHomeNewRedPacket];
        [[XNCommonModule defaultModule]  requestNewLeveCoupon];
        [[XNCommonModule defaultModule]  requestHomeNewComissionCoupon];
        [[XNCommonModule defaultModule]  requestHomeComissionHasNewRecord];
        [[XNActivityModule defaultModule] requestDoubleEleventActivity];
    }
    
    // 获取猎财大师平台业绩
    [[XNHomeModule defaultModule] requestLcsAchievement];
    
    if (requestCount != 0) {
        
        [self.view showGifLoading];
    }
}

//登录成功
- (void)loginSuccessRfreshData
{
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:NO]  forKey:@"HOME_PAGE_COMMISSION_METHOD"];
    [self loadNetwork];
}

//更新状态数组
- (void)updateStatusArray
{
    [self.cellStatusArray removeAllObjects];
    
    //首页banner
    if ([[XNHomeModule defaultModule] bannerListArray])
    {
        [self.cellStatusArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"HomeHeaderCell",@"cell",[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:HEADERHEIGHT]],@"cellHeight", nil]];
    }
    
//    //新手福利
//    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
//    if (([NSObject isValidateObj:[[XNHomeModule defaultModule] homeCommissionMode]] && [[[XNHomeModule defaultModule] homeCommissionMode] newcomerTaskStatus] == 1) || ![NSObject isValidateInitString:token]) {
//        [self.cellStatusArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"NewUserAwardCell",@"cell",[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:NEWUSERAWARDHEIGHT]],@"cellHeight", nil]];
//    }
    
    //猎财课堂
    if ([[XNHomeModule defaultModule] classRoomListMode] && [[[XNHomeModule defaultModule] classRoomListMode] classRoomItemNameList].count > 0) {
        
         [self.cellStatusArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"LCClassRoomCell",@"cell",[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:CLASSROOMLISTHEIGHT]],@"cellHeight", nil]];
    }
    
    //网贷
    if (self.hotProductArray.count > 0)
    {
        [self.cellStatusArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"HomeSectionCell",@"cell", [NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:SECTIONHEIGHT]],@"cellHeight",[NSDictionary dictionaryWithObjectsAndKeys:@"网贷",@"title",@"稳健安全",@"subTitle",@"查看",@"footerTitle",@"0",@"hiddenIcon", nil],@"params", nil]];
        
        for (XNFMProductListItemMode *mode in self.hotProductArray)
        {
            [self.cellStatusArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"ManagerFinancialProgressCell",@"cell",[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:PRODUCTHEIGHT]],@"cellHeight",[NSDictionary dictionaryWithObjectsAndKeys:mode,@"productItemMode", nil],@"params", nil]];
        }
    }
    
    //精选基金
    if (self.hotBundArray.count > 0)
    {
         [self.cellStatusArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"HomeSectionCell",@"cell", [NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:SECTIONHEIGHT]],@"cellHeight",[NSDictionary dictionaryWithObjectsAndKeys:@"基金",@"title",@"活期余额+",@"subTitle",@"查看",@"footerTitle",@"0",@"hiddenIcon", nil],@"params", nil]];
        
        for (XNBundItemMode *mode in self.hotBundArray)
        {
            [self.cellStatusArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"HotBundCell",@"cell",[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:BUNDHEIGHT]],@"cellHeight",[NSDictionary dictionaryWithObjectsAndKeys:mode,@"bundItemMode", nil],@"params", nil]];
        }
    }
    
    //保险
    if ([self.insuranceModuleObj selectedInsuranceItem]) {
        
        [self.cellStatusArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"HomeSectionCell",@"cell", [NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:SECTIONHEIGHT]],@"cellHeight",[NSDictionary dictionaryWithObjectsAndKeys:@"保险",@"title",@"保障人生",@"subTitle",@"查看",@"footerTitle",@"0",@"hiddenIcon", nil],@"params", nil]];
        
        [self.cellStatusArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"InsuranceListCell",@"cell",[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:INSURANCEHEIGHT]],@"cellHeight", nil]];
    }
    
    //热门动态
    if (self.hotCfgMsgArray.count > 0)
    {
        [self.cellStatusArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"HomeSectionCell",@"cell", [NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:SECTIONHEIGHT]],@"cellHeight",[NSDictionary dictionaryWithObjectsAndKeys:@"热门",@"title",@"猎财动态",@"subTitle",@"",@"footerTitle",@"1",@"hiddenIcon", nil],@"params", nil]];
        
        for (XNCfgMsgItemMode *mode in self.hotCfgMsgArray)
        {
            [self.cellStatusArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"HotCfgMsgCell",@"cell",[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:CFGMSGHEIGHT]],@"cellHeight",[NSDictionary dictionaryWithObjectsAndKeys:mode,@"cfgMsgItem", nil],@"params", nil]];
        }
    }
    
    //理财师出单
    if ([NSObject isValidateObj:[[XNHomeModule defaultModule] homeCommissionMode]] &&[[[XNHomeModule defaultModule] homeCommissionMode] orderListDesc].count > 0) {
        
       [self.cellStatusArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"HomeCfgSaleCell",@"cell",[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:CFGSALEHEIGHT]],@"cellHeight", nil]];
    }
    
    //公司背书
    [self.cellStatusArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"HomeBrandIntroduceCell",@"cell", [NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:BRANDINTRODUCEHEIGHT]],@"cellHeight", nil]];
    
    //底部内容
    [self.cellStatusArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"SafeFooterCell",@"cell", [NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:FOOTERHEIGHT]],@"cellHeight", nil]];
    
    //如果有内容，则进行刷新
    if ([self.cellStatusArray count] > 0) {
        
        [self.contentTableView reloadData];
    }
}

//是否显示提示视图
- (BOOL)isShowRemindViewAtDate:(NSString *)date
{
    NSString * remindKey = @"";
    
    NSDateComponents * components = [[CalendarManager defaultManager] dateComponentsWithDate:[NSString dateFromString:date formater:@"yyyy-MM-dd HH:mm:ss"]];
    if (components.day >= 20 && components.day < 25) {
        
        remindKey = [NSString stringWithFormat:@"%@_%@_%@_1",[NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]],[NSNumber numberWithInteger:components.year],[NSNumber numberWithInteger:components.month]];
    }else if(components.day >= 25 && components.day < 31)
    {
        remindKey = [NSString stringWithFormat:@"%@_%@_%@_2",[NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]],[NSNumber numberWithInteger:components.year],[NSNumber numberWithInteger:components.month]];
    }
    
    if ([NSObject isValidateInitString:remindKey] && ![_LOGIC getValueForKey:remindKey]) {
        
        weakSelf(weakSelf)
        [self.remindView setClickCustomRemindViewBlock:^{
            
            weakSelf.remindView = nil;
            [_LOGIC saveValueForKey:remindKey Value:@"1"];
            [weakSelf showPopView];
        }];
        
        return YES;
    }
    
    return NO;
}

//显示弹出框
- (void)showPopView
{
    if ([_LOGIC canShowViewAt:self] && ![AppFramework getGlobalHandler].currentPopup) {
        
        NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
        if ([NSObject isValidateObj:[[XNCommonModule defaultModule] remindPopMode]] && [self isShowRemindViewAtDate:[[XNCommonModule defaultModule] remindPopMode].systemTime] && [NSObject isValidateInitString:token]) {
            
            [self.remindView showInView:nil];
            [AppFramework getGlobalHandler].currentPopup = self.remindView;
            
        }else if([[_LOGIC getValueForKey:XN_IS_SHOW_HOME_POP_ADV_TAG] isEqualToString:@"1"]){
            
            //弹出窗
            [self.customPopAdvView showInView:nil];
            [AppFramework getGlobalHandler].currentPopup = self.customPopAdvView;
        }else if([[_LOGIC getValueForKey:XN_IS_SHOW_HOME_NEW_LEVELCOUPON_TAG] isEqualToString:@"1"] && [NSObject isValidateInitString:token])
        {
            NSString * imageName = [[[[[XNCommonModule defaultModule] levelCouponMode] jobGrade] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"总监"]?@"xn_pop_coupon_zongjian_level_icon.png":@"xn_pop_coupon_jingli_level_icon.png";
            
            [self.customPopContainer.couponPopView initImage:imageName titleName:[NSString stringWithFormat:@"恭喜您获得%@职级体验券",[[[XNCommonModule defaultModule] levelCouponMode] jobGrade]] CouponType:LevelType];
            [self.customPopContainer showCouponPopViewInView:nil];
            [AppFramework getGlobalHandler].currentPopup = self.customPopContainer.couponPopView;
            
        } else if([[_LOGIC getValueForKey:XN_IS_SHOW_HOME_NEW_COMISSIONCOUPON_TAG] isEqualToString:@"1"] && [NSObject isValidateInitString:token])
        {
            [self.customPopContainer.couponPopView initImage:[[[[XNCommonModule defaultModule] hasNewcomissionCouponMode] type] isEqualToString:@"1"]?@"xn_pop_coupon_comission_icon.png":@"xn_pop_coupon_comission_award_icon.png" titleName:[NSString stringWithFormat:@"恭喜您获得%@%@%@",[[[XNCommonModule defaultModule] hasNewcomissionCouponMode] comissionRate],@"%",[[[[XNCommonModule defaultModule] hasNewcomissionCouponMode] type] isEqualToString:@"1"]?@"加佣券":@"奖励券"] CouponType:ComissionType];
            [self.customPopContainer showCouponPopViewInView:nil];
            [AppFramework getGlobalHandler].currentPopup = self.customPopContainer.couponPopView;
            
        }else if([[_LOGIC getValueForKey:XN_IS_SHOW_HOME_NEW_COMISSIONCOUPON_RECORD_TAG] isEqualToString:@"1"] && [NSObject isValidateInitString:token])
        {
            [self.customPopContainer.couponRecordPopView initImageName:[[[[XNCommonModule defaultModule] hasNewComissionCouponRecordMode] couponType] isEqualToString:@"1"]?@"xn_pop_coupon_comission_icon.png":@"xn_pop_coupon_comission_award_icon.png" titleName:[NSString stringWithFormat:@"恭喜您获得%@%@%@收益%@元",[[[XNCommonModule defaultModule] hasNewComissionCouponRecordMode] feeRate],@"%",[[[[XNCommonModule defaultModule] hasNewComissionCouponRecordMode] couponType] isEqualToString:@"1"]?@"加佣":@"奖励",[[[XNCommonModule defaultModule] hasNewComissionCouponRecordMode] feeAmount]] subTitleName:[[[[XNCommonModule defaultModule] hasNewComissionCouponRecordMode] couponType] isEqualToString:@"1"]?@"加佣总收益将于次月15日统一发放":@"奖励总收益将于次月15日统一发放"];
            [self.customPopContainer showCouponRecordPopViewInView:nil];
            [AppFramework getGlobalHandler].currentPopup = self.customPopContainer.couponRecordPopView;
            
        }else if([[_LOGIC getValueForKey:XN_IS_SHOW_HOME_NEW_REDPACKET_TAG] isEqualToString:@"1"] && [NSObject isValidateInitString:token]){
            
            [self.customPopContainer.couponPopView initImage:@"xn_pop_coupon_redpacket_icon.png" titleName:@"主人，您有新红包可以使用，快快点击我查看吧!" CouponType:RedPacketType];
            [self.customPopContainer showCouponPopViewInView:nil];
            [AppFramework getGlobalHandler].currentPopup = self.customPopContainer.couponPopView;
            
        }else if([[_LOGIC getValueForKey:XN_IS_SHOW_HOME_DOUBLEELEVEN_ACTIVITY_TAG] isEqualToString:@"1"] && [NSObject isValidateInitString:token]){
            
            [self.customPopContainer showDoubleElevenPopViewInView:nil];
            [AppFramework getGlobalHandler].currentPopup = self.customPopContainer.doubleElevenPopView;
        }
    }
}

//进入消息中心
- (IBAction)enterMsgAction:(id)sender
{
    [XNUMengHelper umengEvent:@"S_0_3"];
    MIMessageContainerController * messageContainerController = [[MIMessageContainerController alloc] initWithMessageType:NotificationMessage];
    [messageContainerController setNeedNewSwitchViewAnimation:YES];
    
    [_UI pushViewControllerFromRoot:messageContainerController animated:YES];
}

//消息未读
- (void)updateUnreadMsgCount:(NSNotification *)notification
{
    NSString *msgCount = [notification.userInfo valueForKey:@"msgCount"];

    if (![NSObject isValidateObj:[notification.userInfo valueForKey:@"msgCount"]] || ![NSObject isValidateInitString:[notification.userInfo valueForKey:@"msgCount"]] || [msgCount isEqualToString:@"0"])
    {
        [self.msgImageView setImage:[UIImage imageNamed:@"messagecenter_mail_white_icon@2x.png"]];
        [self.msgImageView removeShakeAnimation];
        [self.msgView setHidden:YES];

       UIImageView * tmpMsgImageView = (UIImageView *)[self.navigationController.navigationItem getItemViewWithTag:@"MESSAGEREMINDVIEW" forTarget:self];
        [tmpMsgImageView setHidden:YES];
    }
    else
    {
        [self.msgView setHidden:NO];
        [self.msgImageView setImage:[UIImage imageNamed:@"messagecenter_mail_white_unread_icon@2x.png"]];
        [self.msgImageView shakeAnimationForDuration:3];

        UIImageView * tmpMsgImageView = (UIImageView *)[self.navigationController.navigationItem getItemViewWithTag:@"MESSAGEREMINDVIEW" forTarget:self];
        if (!tmpMsgImageView) {

            [self.navigationItem addMessageRemindItemWithTarget:self action:@selector(clickMessageRemind:)];
            tmpMsgImageView = (UIImageView *)[self.navigationController.navigationItem getItemViewWithTag:@"MESSAGEREMINDVIEW" forTarget:self];
        }
        [tmpMsgImageView setHidden:NO];

        //设置alpha
        self.msgView.alpha = 1- self.alphaValue;
        tmpMsgImageView.alpha = self.alphaValue;
    }
}

//点击消息中心
- (void)clickMessageRemind:(id)sender
{
    MIMessageContainerController * messageContainerController = [[MIMessageContainerController alloc] initWithMessageType:NotificationMessage];
    [messageContainerController setNeedNewSwitchViewAnimation:YES];
    
    [_UI pushViewControllerFromRoot:messageContainerController animated:YES];
}

//退出成功
- (void)exitOperation
{
    [self.msgView setHidden:YES];
    [self.msgImageView removeShakeAnimation];
    
    UIImageView * tmpMsgImageView = (UIImageView *)[self.navigationController.navigationItem getItemViewWithTag:@"MESSAGEREMINDVIEW" forTarget:self];
    if (tmpMsgImageView) {
        
        [tmpMsgImageView setHidden:YES];
    }
}

//////////////////////////////
#pragma mark - 控件回调方法
//////////////////////////////////////////

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellStatusArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellStr = [[self.cellStatusArray objectAtIndex:indexPath.row] objectForKey:@"cell"];
    
    NSDictionary * params = [[self.cellStatusArray objectAtIndex:indexPath.row] objectForKey:@"params"];
    if ([cellStr isEqualToString:@"HomeHeaderCell"])
    {
        HomeHeaderCell * cell = (HomeHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"HomeHeaderCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        [cell refreshAdScrollViewWithAdObjectArray:[[XNHomeModule defaultModule] bannerLinkUrlListArray] urlArray:[[XNHomeModule defaultModule] bannerImgUrlListArray] commissionAmount:[[[XNHomeModule defaultModule] homeCommissionMode] commissionAmount]];
        
        NSString *safeOperationTime = [[XNHomeModule defaultModule] achievementModel].safeOperationTime;
        if (safeOperationTime.length > 0) {
            cell.safeOperationTime = safeOperationTime;
        }
    
        return cell;
    }
    
    if ([cellStr isEqualToString:@"NewUserAwardCell"]) {
        
        NewUserAwardCell * cell = (NewUserAwardCell *)[tableView dequeueReusableCellWithIdentifier:@"NewUserAwardCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    if ([cellStr isEqualToString:@"LCClassRoomCell"]) {
        
        LCClassRoomCell * cell = (LCClassRoomCell *)[tableView dequeueReusableCellWithIdentifier:@"LCClassRoomCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setClickClassRoomItemBlock:^(NSInteger selectedIndex, NSString *linkUrl) {
            
            [XNUMengHelper umengEvent:@"S_2_4"];
            
            XNGrowthManualCategoryItemMode *mode = [[[XNHomeModule defaultModule] classRoomListMode].classRoomItemModeList objectAtIndex:selectedIndex];
            NSString *url = linkUrl;
            UniversalInteractWebViewController * interactWebViewController = [[UniversalInteractWebViewController alloc] initRequestUrl:url requestMethod:@"GET"];
            [interactWebViewController setNeedNewSwitchViewAnimation:YES];
            
            [interactWebViewController setSharedOpertionWithParams:[NSDictionary dictionaryWithObjectsAndKeys:mode.title,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_TITLE,
                                                                    mode.summary,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_DESC,
                                                                    url,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_URL,
                                                                    [_LOGIC getImagePathUrlWithBaseUrl:mode.shareIcon],XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_IMGURL, nil]];
            
            [_UI pushViewControllerFromRoot:interactWebViewController animated:YES];
        }];
        
        [cell refreshLcClassRoomContentItemName:[[XNHomeModule defaultModule] classRoomListMode].classRoomItemNameList urlItemList:[[XNHomeModule defaultModule] classRoomListMode].classRoomUrlItemList];
        
        return cell;
    }
    
    if ([cellStr isEqualToString:@"HomeSectionCell"])
    {
        HomeSectionCell *cell = (HomeSectionCell*)[tableView dequeueReusableCellWithIdentifier:@"HomeSectionCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell showTitle:[params objectForKey:@"title"] subTitle:[params objectForKey:@"subTitle"] footerTitle:[params objectForKey:@"footerTitle"] hiddenIcon:[[params objectForKey:@"hiddenIcon"] boolValue]];
        
        return cell;
    }
    
    if ([cellStr isEqualToString:@"ManagerFinancialProgressCell"])
    {
        ManagerFinancialProgressCell *cell = (ManagerFinancialProgressCell*)[tableView dequeueReusableCellWithIdentifier:@"ManagerFinancialProgressCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshDataWithParams:[params objectForKey:@"productItemMode"] section:indexPath.section index:indexPath.row];
        return cell;
    }
    
    if ([cellStr isEqualToString:@"HotBundCell"])
    {
        HotBundCell *cell = (HotBundCell *)[tableView dequeueReusableCellWithIdentifier:@"HotBundCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showDatas:[params objectForKey:@"bundItemMode"]];
        return cell;
    }
    
    if ([cellStr isEqualToString:@"InsuranceListCell"]) {
        
        InsuranceListCell *insuranceListCell = [tableView dequeueReusableCellWithIdentifier:@"InsuranceListCell"];
        insuranceListCell.insuranceItemModel = [self.insuranceModuleObj selectedInsuranceItem];
        insuranceListCell.footer_view_hight.constant = 0.f;
        return insuranceListCell;
    }
    
    if ([cellStr isEqualToString:@"HotCfgMsgCell"]) {
       
        HotCfgMsgCell * cell = (HotCfgMsgCell *)[tableView dequeueReusableCellWithIdentifier:@"HotCfgMsgCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        XNCfgMsgItemMode * mode = [params objectForKey:@"cfgMsgItem"];
        [cell refreshImageWithUrl:mode.img linkUrl:mode.sharedLink];
        
        return cell;
    }
    
    //理财师出单
    if ([cellStr isEqualToString:@"HomeCfgSaleCell"])
    {
        HomeCfgSaleCell *cell = (HomeCfgSaleCell *)[tableView dequeueReusableCellWithIdentifier:@"HomeCfgSaleCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell showDatas:[[[XNHomeModule defaultModule] homeCommissionMode] orderListDesc]];
        
        return cell;
    }
    
    //HomeBrandIntroduceCell
    if ([cellStr isEqualToString:@"HomeBrandIntroduceCell"])
    {
        HomeBrandIntroduceCell *cell = (HomeBrandIntroduceCell *)[tableView dequeueReusableCellWithIdentifier:@"HomeBrandIntroduceCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    //SafeFooterCell
    if ([cellStr isEqualToString:@"SafeFooterCell"])
    {
        SafeFooterCell *cell = (SafeFooterCell *)[tableView dequeueReusableCellWithIdentifier:@"SafeFooterCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.contentTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString * cellStr = [[self.cellStatusArray objectAtIndex:indexPath.row] objectForKey:@"cell"];
    NSDictionary * params = [[self.cellStatusArray objectAtIndex:indexPath.row] objectForKey:@"params"];
    
    //点击新手福利
    if ([cellStr isEqualToString:@"NewUserAwardCell"]) {
        [XNUMengHelper umengEvent:@"S_2_3"];
       
        UniversalInteractWebViewController * interactWebViewController = [[UniversalInteractWebViewController alloc] initRequestUrl:[_LOGIC getWebUrlWithBaseUrl:@"/pages/strategy/newerWelfare.html"] requestMethod:@"GET"];
        [interactWebViewController setNeedNewSwitchViewAnimation:YES];
        [interactWebViewController setReRefreshPage:YES];
        
        [_UI pushViewControllerFromRoot:interactWebViewController animated:YES];
        
        return;
    }
    
    //精选产品-查看更多
    if ([cellStr isEqualToString:@"HomeSectionCell"] && [[params objectForKey:@"title"] isEqualToString:@"网贷"])
    {
        [XNUMengHelper umengEvent:@"S_3_1"];
        SelectProductListViewController *viewController = [[SelectProductListViewController alloc] initWithNibName:@"SelectProductListViewController" bundle:nil];
        viewController.needNewSwitchViewAnimation = YES;
        
        [_UI pushViewControllerFromRoot:viewController hideNavigationBar:NO animated:YES];
        
        return;
    }
    
    //进入产品详情
    if ([cellStr isEqualToString:@"ManagerFinancialProgressCell"])
    {
        [XNUMengHelper umengEvent:@"S_3_2"];
        XNFMProductListItemMode *mode = [params objectForKey:@"productItemMode"];
        self.selectedMode = mode;
        NSString *url = [_LOGIC getComposeUrlWithBaseUrl:mode.openLinkUrl compose:[NSString stringWithFormat:@"productId=%@",mode.productId]];
        
        UniversalInteractWebViewController *webViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"GET"];
        webViewController.needNewUserGuilder = YES;
        webViewController.delegate = self;
        [webViewController setNeedNewSwitchViewAnimation:YES];
        
        [webViewController setProductDetailRecommend:mode];
        [webViewController setNewWebView:YES];
        
        [_UI pushViewControllerFromRoot:webViewController animated:YES];
        return;
    }
    
    //精选基金-查看更多
    if ([cellStr isEqualToString:@"HomeSectionCell"] && [[params objectForKey:@"title"] isEqualToString:@"基金"])
    {
        [XNUMengHelper umengEvent:@"S_4_2"];
        UINavigationController * platformCtrl = [_UI getRootNavigationControllerAtIndex:1];
        AgentContainerController * agentCtrl = platformCtrl.viewControllers[0];
        [agentCtrl selectedAtIndex:2];
        
        [_UI currentViewController:self popToRootViewController:YES AndSwitchToTabbarIndex:1 comlite:^{
            
        }];
        
        return;
    }
    
    //进入基金详情
    if ([cellStr isEqualToString:@"HotBundCell"])
    {
        [XNUMengHelper umengEvent:@"S_4_1"];
        self.selectedMode = [params objectForKey:@"bundItemMode"];
        //是否登陆
        NSString *token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
        BOOL isExpired = [[_LOGIC getValueForKey:XN_USER_USER_TOKEN_EXPIRED] isEqualToString:@"1"];
        if (token == nil || [token isKindOfClass:[NSNull class]] || [token isEqual:[NSNull null]] || token.length < 1 || isExpired)
        {
            //弹框
            [self showCustomAlertViewWithTitle:@"基金详情需登录后才可查看" titleColor:[UIColor blackColor] titleFont:14 okTitle:@"立即登录" okTitleColor:[UIColor blackColor] okCompleteBlock:^{
                
                //跳转到登录页面
                [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
                [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
                
                
            } cancelTitle:@"取消" cancelCompleteBlock:^{
                
            } topPadding:20 textAlignment:NSTextAlignmentCenter];
            
            return;
        }
        
        //判断是否绑卡
        [self.myInfomationModuleRequest requestMySettingInfo];
        [self.view showGifLoading];

        return;
    }
    
    //保险-查看更多
    if ([cellStr isEqualToString:@"HomeSectionCell"] && [[params objectForKey:@"title"] isEqualToString:@"保险"])
    {
        [XNUMengHelper umengEvent:@"S_5_2"];
        UINavigationController * platformCtrl = [_UI getRootNavigationControllerAtIndex:1];
        AgentContainerController * agentCtrl = platformCtrl.viewControllers[0];
        [agentCtrl selectedAtIndex:3];
        
        [_UI currentViewController:self popToRootViewController:YES AndSwitchToTabbarIndex:1 comlite:^{
            
        }];
        
        return;
    }
    
    //进入保险详情
    if ([cellStr isEqualToString:@"InsuranceListCell"])
    {
        [XNUMengHelper umengEvent:@"S_5_1"];
        NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
        if (![NSObject isValidateInitString:token]) {
            
            [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
            [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
            return;
        }
        
        [self.insuranceModuleObj requestInsuranceDetaiParamsWithCaseCode:[[self.insuranceModuleObj selectedInsuranceItem] caseCode]];
        [self.view showGifLoading];
        return;
    }
    
    //热点
    if ([cellStr isEqualToString:@"HotCfgMsgCell"])
    {
        [XNUMengHelper umengEvent:@"S_6_1"];
        
        XNCfgMsgItemMode *mode = [params objectForKey:@"cfgMsgItem"];
        NSString *url = mode.sharedLink;
        if (![NSObject isValidateInitString:mode.sharedLink])
        {
            NSString *lcNewsDetalUrl = [[[XNCommonModule defaultModule] configMode] informationDetailUrl];
            url = [_LOGIC getComposeUrlWithBaseUrl:lcNewsDetalUrl compose:[NSString stringWithFormat:@"type=2&id=%@&t=%@",[NSNumber numberWithInteger:mode.newsId],[NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]]]];
        }
        UniversalInteractWebViewController * interactWebViewController = [[UniversalInteractWebViewController alloc] initRequestUrl:url requestMethod:@"GET"];
         [interactWebViewController setNeedNewSwitchViewAnimation:YES];
        
        [interactWebViewController setSharedOpertionWithParams:[NSDictionary dictionaryWithObjectsAndKeys:mode.sharedTitle,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_TITLE,
                                                                mode.sharedDesc,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_DESC,
                                                                url,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_URL,
                                                                [_LOGIC getImagePathUrlWithBaseUrl:mode.sharedIcon],XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_IMGURL, nil]];
        
        [_UI pushViewControllerFromRoot:interactWebViewController animated:YES];
    }
    
    //咨询客服
    if ([cellStr isEqualToString:@"SafeFooterCell"])
    {
        /***
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",[[[XNCommonModule defaultModule] configMode] serviceTelephone]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
         **/
        
        [self.view addSubview:self.phoneCtrl.view];
        
        weakSelf(weakSelf)
        [self.phoneCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakSelf.view);
        }];
    }
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[self.cellStatusArray objectAtIndex:indexPath.row] objectForKeyedSubscript:@"cellHeight"] floatValue];
}

// 滑动滑块变更导航条
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat alpha = scrollView.contentOffset.y / 200;
    if (alpha >= 1)
    {
        alpha = 1;
    }
    else if (alpha <= 0)
    {
        alpha = 0;
    }
    self.alphaValue = alpha;
    
    UIImageView * tmpMsgImageView = (UIImageView *)[self.navigationController.navigationItem getItemViewWithTag:@"MESSAGEREMINDVIEW" forTarget:self];
    self.newNavigationBarColor = [UIColorFromHex(0x4e8cef) colorWithAlphaComponent:alpha];
    self.newNavigationTitleColor = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
    [self.navigationController.navigationBar setNavigationBarBgColor:[UIColorFromHex(0x4e8cef) colorWithAlphaComponent:alpha]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[[UIColor whiteColor] colorWithAlphaComponent:alpha]}];

    self.msgView.alpha = 1 - alpha;
    
    if (tmpMsgImageView) {
        [tmpMsgImageView setAlpha:alpha];
    }
    
}

//////////////////////////////
#pragma mark - 组件内部回调
//////////////////////////////////////////

//佣金计算
- (void)getAppLhlcsCommissionCalc:(NSDictionary *)params
{
    FMComissionCaculateVController * comissionCaculateCtrl = [[FMComissionCaculateVController alloc]initWithNibName:@"FMComissionCaculateViewController" bundle:nil detailMode:self.selectedMode];
    
    [_UI pushViewControllerFromRoot:comissionCaculateCtrl animated:YES];
}

//广告弹出框点击进入广告详情
- (void)gotoDetailViewController:(NSString *)linkUrl
{
    [self.customPopAdvView hiddenPopAdvView];
   
    UniversalInteractWebViewController *webViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:linkUrl requestMethod:@"GET"];
    [webViewController setNeedNewSwitchViewAnimation:YES];
    [webViewController setNewWebView:YES];
    XNHomeBannerMode *mode = [[XNCommonModule defaultModule] homePopAdvMode];
    
    [webViewController setSharedOpertionWithParams:[NSDictionary dictionaryWithObjectsAndKeys:mode.title,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_TITLE,
                                          mode.desc,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_DESC,mode.link,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_URL,
                                          [_LOGIC getImagePathUrlWithBaseUrl:mode.icon],XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_IMGURL, nil]];
    
    [_UI pushViewControllerFromRoot:webViewController animated:YES];
}

//点击banner
- (void)XNHomeHeaderCellDidClickWithUrl:(NSString *)url
{
    NSInteger nSelectBannerIndex = [[[XNHomeModule defaultModule] bannerLinkUrlListArray] indexOfObject:url];
    
    UniversalInteractWebViewController *webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:url requestMethod:@"GET"];
    [webCtrl setNeedNewSwitchViewAnimation:YES];
    
    XNHomeBannerMode *bannerMode = [[[XNHomeModule defaultModule] bannerListArray] objectAtIndex:nSelectBannerIndex];
    
    //umeng统计点击次数_具体banner标题
    NSDictionary *dic = @{@"type":[NSString stringWithFormat:@"banner标题_%@", bannerMode.title]};
    [XNUMengHelper umengEvent:@"S_0_4" attributes:dic];

    // bannerMode.title  bannerMode.desc
    [webCtrl setSharedOpertionWithParams:[NSDictionary dictionaryWithObjectsAndKeys:bannerMode.title,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_TITLE,
                                          bannerMode.desc,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_DESC,bannerMode.link,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_URL,
                                          [_LOGIC getImagePathUrlWithBaseUrl:bannerMode.icon],XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_IMGURL, nil]];
    
    [_UI pushViewControllerFromRoot:webCtrl animated:YES];
}

//点击首页头部几个产品选项
- (void)XNHomeHeaderCellDidClickAction:(NSInteger)index
{
    NSString *tagString = @"";
    
    switch (index) {
        case P2pProductType:
        {
            tagString = @"S_1_1";
            UINavigationController * platformCtrl = [_UI getRootNavigationControllerAtIndex:1];
            AgentContainerController * agentCtrl = platformCtrl.viewControllers[0];
            [agentCtrl selectedAtIndex:1];
            
            [_UI currentViewController:self popToRootViewController:YES AndSwitchToTabbarIndex:1 comlite:^{
                
            }];

        }
            break;
        case BundProductType:
        {
            tagString = @"S_1_2";
            UINavigationController * platformCtrl = [_UI getRootNavigationControllerAtIndex:1];
            AgentContainerController * agentCtrl = platformCtrl.viewControllers[0];
            [agentCtrl selectedAtIndex:2];
            
            [_UI currentViewController:self popToRootViewController:YES AndSwitchToTabbarIndex:1 comlite:^{
                
            }];
        }
            break;
        case InsureProductType:
        {
            tagString = @"S_1_3";
            UINavigationController * platformCtrl = [_UI getRootNavigationControllerAtIndex:1];
            AgentContainerController * agentCtrl = platformCtrl.viewControllers[0];
            [agentCtrl selectedAtIndex:3];
            
            [_UI currentViewController:self popToRootViewController:YES AndSwitchToTabbarIndex:1 comlite:^{
                
            }];
        }
            break;
        case LoveProductTYpe: //公益
        {
            tagString = @"S_1_4";
            //https://preliecai.toobei.com/pages/commonweal/list.html /pages/activities/vFund.html  /pages/commonweal/list.html
            UniversalInteractWebViewController *webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:[_LOGIC getWebUrlWithBaseUrl:@"/pages/commonweal/list.html"] requestMethod:@"GET"];
            [webCtrl setNeedNewSwitchViewAnimation:YES];
        
            /***
            [webCtrl setSharedOpertionWithParams:[NSDictionary dictionaryWithObjectsAndKeys:@"大爱公益",XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_TITLE,
                                                  @"猎财大师携手芒果V基金 共筑中国少年梦",XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_DESC,
                                                  @"https://liecai.toobei.com/pages/activities/vFund.html",XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_URL,
                                                  [_LOGIC getImagePathUrlWithBaseUrl:@"a3fce851ea0b0687b0366f2c123abeea"],XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_IMGURL, nil]];
            **/
            
            [_UI pushViewControllerFromRoot:webCtrl animated:YES];
    
        }
            break;
        case SignPrize:  //签到有礼
        {
    
            //1.判断是非登录
            NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
            if (![NSObject isValidateInitString:token])
            {
                [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
                [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
                return;
            }
            
            tagString = @"S_7_1";
            
            SignViewController *signVC = [[SignViewController alloc] initWithNibName:@"SignViewController" bundle:nil];
            [signVC setNeedNewSwitchViewAnimation:YES];
            [_UI pushViewControllerFromRoot:signVC hideNavigationBar:YES animated:YES];
    
        }
            break;
        case InviteHomeCfpType: //邀请理财师
        {
            
            tagString = @"S_2_2";
            UniversalInteractWebViewController *webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:[_LOGIC getWebUrlWithBaseUrl:@"/pages/guide/plannerInvitation.html"] requestMethod:@"GET"];
            [webCtrl setNewWebView:YES];
            [webCtrl setTitleName:@""];
            [webCtrl setNeedNewSwitchViewAnimation:YES];
            [webCtrl.handleBridgeEventManager addRightInvitedCustomer];
            
            [_UI pushViewControllerFromRoot:webCtrl animated:YES];
            
        }
            break;
            
        case AboutUsType: // 了解我们
        {
            tagString = @"S_2_1";
            NSString * url = [_LOGIC getWebUrlWithBaseUrl:@"/pages/frame/children/understand.html"];
            
            UniversalInteractWebViewController *webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:url requestMethod:@"GET"];
            [webCtrl setNewWebView:YES];
            [webCtrl setNeedNewSwitchViewAnimation:YES];
            
            [_UI pushViewControllerFromRoot:webCtrl animated:YES];
        }
            break;
            
        default:
            break;
    }

    [XNUMengHelper umengEvent:tagString];
}

//////////////////////////////
#pragma mark - 网络请求回调
//////////////////////////////////////////

//获取banner
- (void)XNHomeModuleBannerListDidReceive:(XNHomeModule *)module
{
    [self.view hideLoading];
    [self.contentTableView.mj_header endRefreshing];
    
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:YES] forKey:@"HOMEPAGEBANNERLISTMETHOD"];

    [self updateStatusArray];
}

- (void)XNHomeModuleBannerListDidFailed:(XNHomeModule *)module
{
    [self.view hideLoading];
    [self.contentTableView.mj_header endRefreshing];
    
    //重新进行请求
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"HOMEPAGEBANNERLISTMETHOD"];
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//获取佣金列表和出单列表
- (void)XNHomeModuleCommissionDidReceive:(XNHomeModule *)module
{
    [self.view hideLoading];
    [self.contentTableView.mj_header endRefreshing];
    
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:YES]  forKey:@"HOME_PAGE_COMMISSION_METHOD"];
    
    //更新状态数组
    [self updateStatusArray];
}

- (void)XNHomeModuleCommissionDidFailed:(XNHomeModule *)module
{
    [self.view hideLoading];
    [self.contentTableView.mj_header endRefreshing];
    
    //重新进行请求
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:NO]  forKey:@"HOME_PAGE_COMMISSION_METHOD"];
    
    if (module.retCode.detailErrorDic)
    {
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

//获取猎财课堂
- (void)XNHomeModuleLCClassRoomListDidReceive:(XNHomeModule *)module
{
    [self.view hideLoading];
    [self.contentTableView.mj_header endRefreshing];
    
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:YES] forKey:@"HOME_PAGE_LIECAI_CALSSROOM_METHOD"];
    
    //更新状态数组
    [self updateStatusArray];
}

- (void)XNHomeModuleLCClassRoomListDidFailed:(XNHomeModule *)module
{
    [self.view hideLoading];
    [self.contentTableView.mj_header endRefreshing];
    
    //重新进行请求
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"HOME_PAGE_LIECAI_CALSSROOM_METHOD"];
    
    if (module.retCode.detailErrorDic)
    {
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

//首页了解我们猎财大师平台业绩
- (void)RequestLcsAchievementDidReceive:(XNHomeModule *)module
{
    [self.view hideLoading];
    
    //更新状态数组
    [self.contentTableView reloadData];
    
}

- (void)RequestLcsAchievementDidFailed:(XNHomeModule *)module
{
    [self.view hideLoading];
    [self.contentTableView.mj_header endRefreshing];
    
    //重新进行请求
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"HOME_PAGE_LIECAI_CALSSROOM_METHOD"];
    
    if (module.retCode.detailErrorDic)
    {
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

//获取精选产品
- (void)XNHomeModuleHotProductsListDidReceive:(XNHomeModule *)module
{
    [self.view hideLoading];
    [self.contentTableView.mj_header endRefreshing];
    
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:YES] forKey:@"HOME_PAGE_HOT_PRODUCTS_LIST_METHOD"];
    
    self.hotProductArray = module.homeHotProductsListMode.dataArray;
    
    //更新状态数组
    [self updateStatusArray];
}

- (void)XNHomeModuleHotProductsListDidFailed:(XNHomeModule *)module
{
    [self.view hideLoading];
    [self.contentTableView.mj_header endRefreshing];
    
    //重新进行请求
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"HOME_PAGE_HOT_PRODUCTS_LIST_METHOD"];
    
    if (module.retCode.detailErrorDic)
    {
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

//获取精选基金
- (void)XNBundModuleHotBundListDidReceive:(XNBundModule *)module
{
    [self.view hideLoading];
    [self.contentTableView.mj_header endRefreshing];
    
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:YES] forKey:@"XNBUND_MODULE_FUND_SIFT_METHOD"];
    
    [self.hotBundArray removeAllObjects];
    [self.hotBundArray addObjectsFromArray:module.hotBundListMode.datas];
    [self updateStatusArray];
}

- (void)XNBundModuleHotBundListDidFailed:(XNBundModule *)module
{
    [self.view hideLoading];
    [self.contentTableView.mj_header endRefreshing];
    
    //重新进行请求
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"XNBUND_MODULE_FUND_SIFT_METHOD"];
}

//获取精选保险
- (void)XNFinancialManagerModuleSelectedInsuranceItemDidReceive:(XNInsuranceModule *)module
{
    [self.view hideLoading];
    [self.contentTableView.mj_header endRefreshing];
    
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:YES] forKey:@"XN_INSURANCE_MODULE_SELECTED_INSURANCE_METHOD"];
    
    [self updateStatusArray];
}

- (void)XNFinancialManagerModuleSelectedInsuranceItemDidFailed:(XNInsuranceModule *)module
{
    [self.view hideLoading];
    [self.contentTableView.mj_header endRefreshing];
    
    //重新进行请求
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"XN_INSURANCE_MODULE_SELECTED_INSURANCE_METHOD"];
    
    if (module.retCode.detailErrorDic)
    {
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

//获取保险详情
- (void)XNFinancialManagerModuleInsuranceDetailDidReceive:(XNInsuranceModule *)module
{
    [self.view hideLoading];
    
    UniversalInteractWebViewController * interactWebViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:module.insuranceDetailMode.jumpInsuranceUrl requestMethod:@"GET"];
    
    [interactWebViewController setIsEnterThirdPlatform:YES platformName:@"慧择"];
    [interactWebViewController.view setBackgroundColor:[UIColor whiteColor]];
    [interactWebViewController setNeedNewSwitchViewAnimation:YES];
    
    [_UI pushViewControllerFromRoot:interactWebViewController animated:YES];
}

- (void)XNFinancialManagerModuleInsuranceDetailDidFailed:(XNInsuranceModule *)module
{
    [self.view hideLoading];
    
    if (module.retCode.detailErrorDic)
    {
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

//获取热门资讯
- (void)XNHomeModuleCfgMsgListDidReceive:(XNHomeModule *)module
{
    [self.view hideLoading];
    [self.contentTableView.mj_header endRefreshing];
    
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:YES] forKey:@"HOME_PAGE_HOT_CFG_MSG_METHOD"];
    
    self.hotCfgMsgArray = module.homeHotCfgMsgListMode.datasArray;
    //更新状态数组
    [self updateStatusArray];
}

- (void)XNHomeModuleCfgMsgListDidFailed:(XNHomeModule *)module
{
    [self.view hideLoading];
    [self.contentTableView.mj_header endRefreshing];
    
    //重新进行请求
    [self.requestCountDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"HOME_PAGE_HOT_CFG_MSG_METHOD"];
    
    if (module.retCode.detailErrorDic)
    {
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

//获取用户绑卡信息
- (void)XNMyInfoModulePeopleSettingDidReceive:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    
    //已绑卡
    if ([[self.myInfomationModuleRequest settingMode] bundBankCard])
    {
        //是否已注册基金账户
        [self.bundModuleObj isRegisterBundResult];
        [self.view showGifLoading];
    }
    else
    {
        [self showCustomAlertViewWithTitle:@"为了您的资金安全，请先绑定银行卡" titleColor:[UIColor blackColor] titleFont:14 okTitle:@"确认" okTitleColor:[UIColor blackColor] okCompleteBlock:^{
            
            MIAddBankCardController *addBankCardCtrl = [[MIAddBankCardController alloc] initWithNibName:@"MIAddBankCardController" bundle:nil];
            [_UI pushViewControllerFromRoot:addBankCardCtrl animated:YES];
            
        } cancelTitle:@"取消" cancelCompleteBlock:^{
            
        } topPadding:20 textAlignment:NSTextAlignmentCenter];
        
    }
}

- (void)XNMyInfoModulePeopleSettingDidFailed:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    
    if (module.retCode.detailErrorDic)
    {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

//是否注册过基金
- (void)XNBundModuleIsRegisterBundDidReceive:(XNBundModule *)module
{
    [self.view hideLoading];
    //已注册
    if (module.isRegisterBund)
    {
        //跳转到基金平台对应的基金详情
        [self.bundModuleObj gotoFundDetail:((XNBundItemMode *)self.selectedMode).fundCode];
        [self.view showGifLoading];
    }
    else
    {
        [self showFMRecommandViewWithTitle:@"一键开通基金账户?" subTitle:@"开通后，将同步个人身份信息和联系方式" subTitleLeftPadding:12 otherSubTitle:@"" okTitle:@"一键开通" okCompleteBlock:^{
            
            //注册基金平台
            [self.bundModuleObj registerBund];
            [self.view showGifLoading];
            
        } cancelTitle:@"取消" cancelCompleteBlock:^{
            
        }];
        
    }
}

- (void)XNBundModuleIsRegisterBundDidFailed:(XNBundModule *)module
{
    [self.view hideLoading];
    
    if (module.retCode.detailErrorDic)
    {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

//注册基金
- (void)XNBundModuleRegisterBundDidReceive:(XNBundModule *)module
{
    [self.view hideLoading];
    //跳转基金平台
    [self.bundModuleObj gotoFundDetail:((XNBundItemMode *)self.selectedMode).fundCode];
    [self.view showGifLoading];
}

- (void)XNBundModuleRegisterBundDidFailed:(XNBundModule *)module
{
    [self.view hideLoading];
    
    if (module.retCode.detailErrorDic)
    {
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

//奕丰基金详情页跳转
- (void)XNBundModuleRegisterGotoBundDetailDidReceive:(XNBundModule *)module
{
    [self.view hideLoading];
    
    XNBundThirdPageMode *mode = module.bundThirdPageMode;
    
    NSString *urlString = [NSString stringWithFormat:@"%@?data=%@&integrationMode=%@&productCode=%@&referral=%@", mode.requestUrl, mode.data, mode.integrationMode, mode.productCode, mode.referral];
    UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:urlString requestMethod:@"POST"];
    [webCtrl setTitleName:@""];
    
    [webCtrl setIsEnterThirdPlatform:YES platformName:@"奕丰金融"];
    [webCtrl.view setBackgroundColor:[UIColor whiteColor]];
    [_UI pushViewControllerFromHomeViewControllerForController:webCtrl hideNavigationBar:NO animated:YES];
    
}

- (void)XNBundModuleRegisterGotoBundDetailDidFailed:(XNBundModule *)module
{
    [self.view hideLoading];
    
    if (module.retCode.detailErrorDic)
    {
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

//是否有新的加佣券
- (void)XNCommonModuleNewComissionCouponDidReceive:(XNCommonModule *)module
{
    [self showPopView];
}

//是否有新红包
- (void)XNCommonModuleNewRedPacketDidReceive:(XNCommonModule *)module
{
    [self showPopView];
}

//是否有新的加佣券记录
- (void)XNCommonModuleNewCouponRecordDidReceive:(XNCommonModule *)module
{
    [self showPopView];
}

//是否有新的职级体验券
- (void)XNCommonModuleNewLevelCouponRecordDidReceive:(XNCommonModule *)module
{
    [self showPopView];
}

//双十一
- (void)XNActivityModuleDoubleElevenActivityDidReceive:(XNActivityModule *)module
{
    [self showPopView];
}

////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

//自定义弹出广告框
- (CustomPopAdvView *)customPopAdvView
{
    if (!_customPopAdvView)
    {
        _customPopAdvView = [[CustomPopAdvView alloc] initWithImageUrl:[[[XNCommonModule defaultModule] homePopAdvMode] imgUrl] linkUrl:[[[XNCommonModule defaultModule] homePopAdvMode] linkUrl]];
        
        weakSelf(weakSelf)
        [_customPopAdvView setClickPopAdViewBlock:^{
            
            [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_POP_ADV_TAG Value:@"0"];
            [[AppFramework getGlobalHandler] removePopupView];
            
            [weakSelf showPopView];
        }];
    }
    _customPopAdvView.delegate = self;
    return _customPopAdvView;
}

//自定义提示框
- (CustomRemindView *)remindView
{
    if (!_remindView) {
    
        _remindView = [[CustomRemindView alloc]initKeepLevelRemindViewWithTitle:[[XNCommonModule defaultModule] remindPopMode].cfpLevelTitle desContent:[[XNCommonModule defaultModule] remindPopMode].cfpLevelContent detailContent:[[XNCommonModule defaultModule] remindPopMode].cfpLevelDetail];
        [_remindView setClickCheckDetailBlock:^{
            
            UniversalInteractWebViewController * interactWebViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:[[[XNCommonModule defaultModule] configMode] showLevelUrl] requestMethod:@"GET"];
            [interactWebViewController setNewWebView:YES];
            [interactWebViewController setNeedNewSwitchViewAnimation:YES];
            [_UI pushViewControllerFromRoot:interactWebViewController animated:YES];
        }];
        
        weakSelf(weakSelf)
        [_remindView setClickCustomRemindViewBlock:^{
            
            [[AppFramework getGlobalHandler] removePopupView];
            [weakSelf showPopView];
        }];
    }
    
    return _remindView;
}

//优惠券/活动弹出容器
- (CustomPopViewContainer *)customPopContainer
{
    if (!_customPopContainer) {
        
        _customPopContainer = [[CustomPopViewContainer alloc]init];
        
        weakSelf(weakSelf)
        [_customPopContainer.couponPopView setClickCancelBlock:^(CouponPopType type) {
            
            if (type == RedPacketType) {
                
                [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_NEW_REDPACKET_TAG Value:@"0"];
                return;
            }
            
            if (type == ComissionCouponType) {
                
                [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_NEW_COMISSIONCOUPON_TAG Value:@"0"];
                return;
            }
            
            
            if (type == LevelType) {
                
                [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_NEW_LEVELCOUPON_TAG Value:@"0"];
                return;
            }
        }];
        
        [_customPopContainer.couponPopView setClickDetailBlock:^(CouponPopType type) {
            
            if (type == RedPacketType) {
                
                [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_NEW_REDPACKET_TAG Value:@"0"];
                CouponContainerViewController * ctrl = [[CouponContainerViewController alloc]initWithNibName:@"CouponContainerViewController" bundle:nil currentRedPacketType:MyRedPacketType];
                [ctrl setNeedNewSwitchViewAnimation:YES];
                
                [_UI pushViewControllerFromRoot:ctrl animated:YES];
                
                return;
            }
            
            if (type == ComissionCouponType) {
                
                [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_NEW_COMISSIONCOUPON_TAG Value:@"0"];
                
                CouponContainerViewController * ctrl = [[CouponContainerViewController alloc]initWithNibName:@"CouponContainerViewController" bundle:nil currentRedPacketType:ComissionCouponType];
                [ctrl setNeedNewSwitchViewAnimation:YES];
                
                [_UI pushViewControllerFromRoot:ctrl animated:YES];
                
                return;
            }
            
            if (type == LevelType) {
                
                [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_NEW_LEVELCOUPON_TAG Value:@"0"];
                
                CouponContainerViewController * ctrl = [[CouponContainerViewController alloc]initWithNibName:@"CouponContainerViewController" bundle:nil currentRedPacketType:LevelCouponType];
                [ctrl setNeedNewSwitchViewAnimation:YES];
                
                [_UI pushViewControllerFromRoot:ctrl animated:YES];
                
                return;
            }
        }];
        
        [_customPopContainer.couponPopView setOperationFinishedBlock:^{
           
            [[AppFramework getGlobalHandler] removePopupView];
            [weakSelf showPopView];
        }];
        
        //加佣记录
        [_customPopContainer.couponRecordPopView setClickCancelBlock:^{
            
            [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_NEW_COMISSIONCOUPON_RECORD_TAG Value:@"0"];
        }];
        [_customPopContainer.couponRecordPopView setOperationFinishedBlock:^{
            
            [[AppFramework getGlobalHandler] removePopupView];
            
            [weakSelf showPopView];
        }];
        
        //双十一活动
        [_customPopContainer.doubleElevenPopView setClickActivityCancelBlock:^{
            
            [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_DOUBLEELEVEN_ACTIVITY_TAG Value:@"0"];
        }];
        [_customPopContainer.doubleElevenPopView setClickActivityDetailBlock:^{
            
            [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_DOUBLEELEVEN_ACTIVITY_TAG Value:@"0"];
            [[WeChatManager sharedManager] openWXApp];
        }];
        
        [_customPopContainer.doubleElevenPopView setOperationFinishedBlock:^{
            
            [[AppFramework getGlobalHandler] removePopupView];
            [weakSelf showPopView];
        }];
    }
    
    return _customPopContainer;
}

//内容状态信息
- (NSMutableArray *)cellStatusArray
{
    if (!_cellStatusArray) {
        
        _cellStatusArray = [[NSMutableArray alloc]init];
    }
    return _cellStatusArray;
}

//热门产品
- (NSArray *)hotProductArray
{
    if (!_hotProductArray)
    {
        _hotProductArray = [[NSArray alloc] init];
    }
    return _hotProductArray;
}

//热门基金
- (NSMutableArray *)hotBundArray
{
    if (!_hotBundArray)
    {
        _hotBundArray = [[NSMutableArray alloc] init];
    }
    return _hotBundArray;
}

//热门消息
- (NSArray *)hotCfgMsgArray
{
    if (!_hotCfgMsgArray)
    {
        _hotCfgMsgArray = [[NSArray alloc] init];
    }
    return _hotCfgMsgArray;
}

//保险请求对象
- (XNInsuranceModule *)insuranceModuleObj
{
    if (!_insuranceModuleObj) {
        
        _insuranceModuleObj = [[XNInsuranceModule alloc]init];
        [_insuranceModuleObj addObserver:self];
    }
    return _insuranceModuleObj;
}

//基金请求对象
- (XNBundModule *)bundModuleObj
{
    if (!_bundModuleObj) {
        
        _bundModuleObj = [[XNBundModule alloc]init];
    }
    return _bundModuleObj;
}

//信息模块请求对象
- (XNMyInformationModule *)myInfomationModuleRequest
{
    if (!_myInfomationModuleRequest) {
        
        _myInfomationModuleRequest = [[XNMyInformationModule alloc]init];
    }
    return _myInfomationModuleRequest;
}

//公共请求对象
- (XNCommonModule *)homeCommonModuleObj
{
    if (!_homeCommonModuleObj) {
        
        _homeCommonModuleObj = [[XNCommonModule alloc]init];
    }
    return _homeCommonModuleObj;
}

//针对请求次数限制字典
- (NSMutableDictionary *)requestCountDictionary
{
    if (!_requestCountDictionary) {
        
        _requestCountDictionary = [[NSMutableDictionary alloc]init];
    }
    return _requestCountDictionary;
}

//无网络视图
- (NetworkUnReachStatusView *)networkErrorView
{
    if (!_networkErrorView) {
        
        _networkErrorView = [[NetworkUnReachStatusView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
        weakSelf(weakSelf)
        [_networkErrorView setNetworkRetryOperation:^{
            
            [weakSelf loadNetwork];
        }];
    }
    return _networkErrorView;
}

#pragma mark - phoneCtrl
- (CustomerServiceController *)phoneCtrl
{
    if (!_phoneCtrl) {
        
        _phoneCtrl = [[CustomerServiceController alloc]initWithNibName:@"CustomerServiceController" bundle:nil customerServer:YES phoneNumber:[[[XNCommonModule defaultModule] configMode] serviceTelephone] phoneTitle:@"确定拨打客服电话"];
    }
    return _phoneCtrl;
}

@end
