//
//  LeiCaiViewController.m
//  FinancialManager
//
//  Created by xnkj on 28/02/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "LeiCaiViewController.h"

#import "NewUserGuildController.h"
#import "CfgLevelCalcViewController.h"
#import "UINavigationBar+Background.h"
#import "UINavigationItem+Extension.h"
#import "PersonalCardViewController.h"
#import "BrandPromotionViewController.h"
#import "SaleGoodNewsDetailViewController.h"
#import "GrowthManualViewController.h"
#import "NetworkUnReachStatusView.h"

#import "XNCSHomePageMode.h"
#import "XNCustomerServerModule.h"
#import "XNCustomerServerModuleObserver.h"

#import "XNLCLevelPrivilegeMode.h"
#import "XNRemindPopMode.h"
#import "XNLeiCaiModule.h"
#import "XNLeiCaiModuleObserver.h"
#import "XNCommonModule.h"
#import "XNConfigMode.h"

#define HEADERHEIGHT 318.0f

@interface LeiCaiViewController ()<XNCustomerServerModuleObserver,XNLeiCaiModuleObserver,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *cellStatusArray;
@property (nonatomic, assign) BOOL  customerMoneySecurityStatus;
@property (nonatomic, assign) BOOL  cfgMoneySecurityStatus;
@property (nonatomic, strong) UIImageView * headerRefrshBgImageView;
@property (nonatomic, strong) NetworkUnReachStatusView  * networkErrorView;

@end

@implementation LeiCaiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
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
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:self.newNavigationTitleColor}];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/////////////////
#pragma mark - 自定义
/////////////////////////////////

//初始化
- (void)initView
{
    self.customerMoneySecurityStatus = NO;
    self.cfgMoneySecurityStatus = NO;
    
    self.newNavigationTitleColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    self.navigationSeperatorLineStatus = YES;
    
    [[XNCustomerServerModule defaultModule] addObserver:self];
    [[XNLeiCaiModule defaultModule] addObserver:self];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LieCaiHeaderCell" bundle:nil] forCellReuseIdentifier:@"LieCaiHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomerProfitCell" bundle:nil] forCellReuseIdentifier:@"CustomerProfitCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomerInvitedCell" bundle:nil] forCellReuseIdentifier:@"CustomerInvitedCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomerServiceCell" bundle:nil] forCellReuseIdentifier:@"CustomerServiceCell"];
    
    weakSelf(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadDatas];
    }];
    
    self.headerRefrshBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width, 100)];
    self.headerRefrshBgImageView.image = [UIImage imageNamed:@"menu_bar_bg.png"];
    [self.tableView insertSubview:self.headerRefrshBgImageView atIndex:0];
    
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

    
    [[XNLeiCaiModule defaultModule] requestLevelPrivilege];
    [[XNCustomerServerModule defaultModule] getCSHomePageData];
    [[XNLeiCaiModule defaultModule] requestUnReadSaleGoodNews];
}

#pragma mark - 更新状态数组
- (void)updateStatusArray
{
    [self.cellStatusArray removeAllObjects];
    
    XNLCLevelPrivilegeMode *levelMode = [[XNLeiCaiModule defaultModule] levelPrivilegeMode];
    if (levelMode)
    {
        [self.cellStatusArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"LieCaiHeaderCell",@"cell", [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:HEADERHEIGHT]], @"cellHeight", [NSDictionary dictionaryWithObjectsAndKeys:levelMode, @"levelMode", nil], @"params", nil]];
        
    }
    
    XNCSHomePageMode * mode = [[XNCustomerServerModule defaultModule] homePageMode];
    if (mode)
    {
        //理财师
        [self.cellStatusArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"CustomerProfitCell",@"cell",@"128",@"cellHeight",[NSDictionary dictionaryWithObjectsAndKeys:@"我的理财师团队",@"title",mode.thisMonthTeamSaleAmount,@"sale",mode.thisMonthAllowance,@"award",[NSNumber numberWithBool:self.cfgMoneySecurityStatus],@"moneySecurityStatus", nil],@"params",@"2",@"ProfitType", nil]];
        
        if ([mode.hasTeamMembers isEqualToString:@"0"])
        {
            [self.cellStatusArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"CustomerInvitedCell",@"cell",@"91",@"cellHeight",[NSDictionary dictionaryWithObjectsAndKeys:@"推荐理财师",@"btnTitle",@"推荐小伙伴们加入猎财大师，一起赚取佣金",@"remindStr", nil],@"params",@"2",@"InvitedType",nil]];
        }
        
        //客户
        [self.cellStatusArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"CustomerProfitCell",@"cell",@"143",@"cellHeight",[NSDictionary dictionaryWithObjectsAndKeys:@"我的客户",@"title",mode.monthInvestAmt,@"investMoney",mode.thisMonthFee,@"profitMoney",[NSNumber numberWithBool:self.customerMoneySecurityStatus],@"moneySecurityStatus", nil],@"params",@"1",@"ProfitType", nil]];
        
        if ([mode.hasCustomer isEqualToString:@"0"])
        {
            [self.cellStatusArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"CustomerInvitedCell",@"cell",@"91",@"cellHeight",[NSDictionary dictionaryWithObjectsAndKeys:@"邀请客户",@"btnTitle",@"邀请客户加入T呗理财",@"remindStr", nil],@"params",@"1",@"InvitedType", nil]];
        }
        else
        {
            [self.cellStatusArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"CustomerServiceCell",@"cell",@"63",@"cellHeight",mode,@"params", nil]];
        }
    }
    
    //如果有内容，则进行刷新
    if ([self.cellStatusArray count] > 0) {
        
        [self.tableView reloadData];
    }
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

//从邀请客户进入
- (void)invitedNewCfg
{
    NSString * tagString = @"S_2_2";
    [XNUMengHelper umengEvent:tagString];
    
    UniversalInteractWebViewController *webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:[_LOGIC getWebUrlWithBaseUrl:@"/pages/guide/plannerInvitation.html"] requestMethod:@"GET"];
    [webCtrl setTitleName:@""];
    [webCtrl setNewWebView:YES];
    [webCtrl setNeedNewSwitchViewAnimation:YES];
    [webCtrl.navigationItem addRightBarItemWithTitle:@"邀请客户" titleColor:[UIColor whiteColor] target:self action:@selector(invitedNewCustomer)];
    
    [_UI pushViewControllerFromRoot:webCtrl animated:YES];
}

//从邀请客户进入
- (void)invitedNewCustomer
{
    [_UI popViewControllerFromRoot:YES];
}

//////////////////////////////
#pragma mark - protocol Methods
//////////////////////////////////////////

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellStatusArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNLCLevelPrivilegeMode *mode = [[XNLeiCaiModule defaultModule] levelPrivilegeMode];
    if (indexPath.row == 0 && mode && [mode.lowerLevelCfpMaxNew integerValue] == 0)
    {
        return HEADERHEIGHT - 55;
    }
    
    return [[[self.cellStatusArray objectAtIndex:indexPath.row] objectForKeyedSubscript:@"cellHeight"] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellStr = [[self.cellStatusArray objectAtIndex:indexPath.row] objectForKey:@"cell"];
    NSDictionary *params = [[self.cellStatusArray objectAtIndex:indexPath.row] objectForKey:@"params"];
//    
//    if ([cellStr isEqualToString:@"LieCaiHeaderCell"])
//    {
//        LieCaiHeaderCell *cell = (LieCaiHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"LieCaiHeaderCell"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.delegate = self;
//        
//        XNLCLevelPrivilegeMode *mode = [[XNLeiCaiModule defaultModule] levelPrivilegeMode];
//        if (mode != nil && mode.cfpLevelTitleNew != nil)
//        {
//            [cell showDatas:[[XNLeiCaiModule defaultModule] levelPrivilegeMode] unreadSaleGoodNews:[[XNLeiCaiModule defaultModule] isHaveNewSaleGoodNews]];
//        }
//        
//        return cell;
//    }
//    
//    if ([cellStr isEqualToString:@"CustomerInvitedCell"])
//    {
//        CustomerInvitedCell * cell = (CustomerInvitedCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomerInvitedCell"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        [cell refreshDataWithRemindStr:[params objectForKey:@"remindStr"] btnTitle:[params objectForKey:@"btnTitle"]];
//        
//        weakSelf(weakSelf)
//        [cell setInvitedBlock:^{
//            
//            //邀请客户
//            if ([[[weakSelf.cellStatusArray objectAtIndex:indexPath.row] objectForKey:@"InvitedType"] isEqualToString:@"1"])
//            {
//                
//                NSString * tagString = @"S_2_2";
//                [XNUMengHelper umengEvent:tagString];
//                
//                UniversalInteractWebViewController *webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:[_LOGIC getWebUrlWithBaseUrl:@"/pages/guide/clientInvitation.html"] requestMethod:@"GET"];
//                [webCtrl setNewWebView:YES];
//                [webCtrl setTitleName:@""];
//                [webCtrl setNeedNewSwitchViewAnimation:YES];
//                [webCtrl.navigationItem addRightBarItemWithTitle:@"邀请理财师" titleColor:[UIColor whiteColor] target:self action:@selector(invitedNewCfg)];
//                
//                [_UI pushViewControllerFromRoot:webCtrl animated:YES];
//            }
//            else
//            {
//                NSString * tagString = @"S_2_2";
//                [XNUMengHelper umengEvent:tagString];
//                
//                UniversalInteractWebViewController *webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:[_LOGIC getWebUrlWithBaseUrl:@"/pages/guide/plannerInvitation.html"] requestMethod:@"GET"];
//                [webCtrl setNewWebView:YES];
//                [webCtrl setTitleName:@""];
//                [webCtrl setNeedNewSwitchViewAnimation:YES];
//                [webCtrl.navigationItem addRightBarItemWithTitle:@"邀请客户" titleColor:[UIColor whiteColor] target:self action:@selector(invitedCustomer)];
//                
//                [_UI pushViewControllerFromRoot:webCtrl animated:YES];
//            }
//        }];
//        
//        return cell;
//    }
//    
//    NSString *currentTime = [NSString stringFromDate:[NSDate date] formater:@"YYYY-MM"];
//    NSString *minTime = currentTime;
//    if ([NSObject isValidateInitString:[[[XNCustomerServerModule defaultModule] homePageMode] minTime]])
//    {
//        minTime = [[[[[XNCustomerServerModule defaultModule] homePageMode] minTime] componentsSeparatedByString:@" "]objectAtIndex:0];
//    }
//    
//    if ([cellStr isEqualToString:@"CustomerProfitCell"])
//    {
//        CustomerProfitCell * cell = (CustomerProfitCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomerProfitCell"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        //客户收益详情
//        if ([[[self.cellStatusArray objectAtIndex:indexPath.row] objectForKey:@"ProfitType"] isEqualToString:@"1"])
//        {
//            weakSelf(weakSelf)
//            [cell setMoneySecurityStatusBlock:^(BOOL status) {
//                
//                weakSelf.customerMoneySecurityStatus = status;
//                [weakSelf updateStatusArray];
//            }];
//            
//            [cell refreshCustomerDataWithInvest:[params objectForKey:@"investMoney"] profit:[params objectForKey:@"profitMoney"] moneySecurityStatus:[[params objectForKey:@"moneySecurityStatus"] boolValue]];
//            
//            [cell setMyCustomerListBlock:^{
//                
////                CSMyCustomerViewController *customerListCtrl = [[CSMyCustomerViewController alloc]initWithNibName:@"CSMyCustomerViewController" bundle:nil];
////                
////                [_UI pushViewControllerFromRoot:customerListCtrl animated:YES];
//            }];
//            
//            [cell setDetailBlock:^{
//                
//                CSCustomerInvestViewController *viewController = [[CSCustomerInvestViewController alloc] initWithNibName:@"CSCustomerInvestViewController" bundle:nil investMinTime:minTime];
//                [_UI pushViewControllerFromRoot:viewController animated:YES];
//            }];
//        }
//        else
//        {
//            weakSelf(weakSelf)
//            [cell setMoneySecurityStatusBlock:^(BOOL status) {
//                
//                weakSelf.cfgMoneySecurityStatus = status;
//                [weakSelf updateStatusArray];
//            }];
//            
//            [cell refreshCfgDataWithSale:[params objectForKey:@"sale"]  award:[params objectForKey:@"award"] moneySecurityStatus:[[params objectForKey:@"moneySecurityStatus"] boolValue]];
//            
//            
//            [cell setMyCustomerListBlock:^{
//                
//                MIMyTeamController *myTeamCtrl = [[MIMyTeamController alloc]initWithNibName:@"MIMyTeamController" bundle:nil];
//                [_UI pushViewControllerFromRoot:myTeamCtrl animated:YES];
//                
//            }];
//            
//            [cell setDetailBlock:^{
//                
//                CSCfgSaleViewController *viewController = [[CSCfgSaleViewController alloc] initWithNibName:@"CSCfgSaleViewController" bundle:nil saleMinTime:minTime];
//                [_UI pushViewControllerFromRoot:viewController animated:YES];
//                
//            }];
//        }
//        
//        return cell;
//    }
//    
//    if ([cellStr isEqualToString:@"CustomerServiceCell"])
//    {
//        CustomerServiceCell * cell = (CustomerServiceCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomerServiceCell"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        [cell refreshData:params];
//        
//        [cell setClickTradeDynamicBlock:^{
//            
//            CSTradeContainerController *tradeListCtrl = [[CSTradeContainerController alloc]initWithNibName:@"CSTradeContainerController" bundle:nil purchaseCount:[[[XNCustomerServerModule defaultModule] homePageMode] buytradeCount]  redomeCount:[[[XNCustomerServerModule defaultModule] homePageMode] backtradeCount]];
//            
//            [_UI pushViewControllerFromRoot:tradeListCtrl hideNavigationBar:NO animated:YES];
//        }];
//        
//        [cell setClickRebackMoneyBlock:^{
//            
//            CSRebackMoneyController *rebackMoneyController = [[CSRebackMoneyController alloc]initWithNibName:@"CSRebackMoneyController" bundle:nil];
//            
//            [_UI pushViewControllerFromRoot:rebackMoneyController animated:YES];
//            
//        }];
//        
//        return cell;
//    }
    
    return nil;
}

#pragma mark - LieCaiHeaderCellDelegate
- (void)levelExplainAction
{
    [XNUMengHelper umengEvent:@"L_1_1_V430"];
    UniversalInteractWebViewController * interactWebViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:[[[XNCommonModule defaultModule] configMode] showLevelUrl] requestMethod:@"GET"];
    [interactWebViewController setNewWebView:YES];
    [_UI pushViewControllerFromRoot:interactWebViewController animated:YES];
    /*
    //职级特权说明
    UniversalInteractWebViewController * ctrl = [[UniversalInteractWebViewController alloc]initRequestUrl:[_LOGIC getComposeUrlWithBaseUrl:[[AppFramework getConfig].XN_REQUEST_H5_BASE_URL stringByAppendingString:@"/pages/rank/rankPrivilege.html"] compose:@""] requestMethod:@"GET"];
    [ctrl setNewWebView:YES];
    
    [_UI pushViewControllerFromRoot:ctrl animated:YES];
     */
}

- (void)jumpToPageAction:(NSInteger)tag
{
    switch (tag) {
        case 1: //个人名片
        {
            [XNUMengHelper umengEvent:@"L_1_2"];
            PersonalCardViewController *viewController = [[PersonalCardViewController alloc] initWithNibName:@"PersonalCardViewController" bundle:nil];
            [_UI pushViewControllerFromRoot:viewController animated:YES];
        }
            break;
        case 2: //推广海报
        {
            [XNUMengHelper umengEvent:@"L_1_3"];
            BrandPromotionViewController *viewController = [[BrandPromotionViewController alloc] initWithNibName:@"BrandPromotionViewController" bundle:nil];
            [_UI pushViewControllerFromRoot:viewController animated:YES];
        }
            break;
        case 3: //成长手册
        {
            [XNUMengHelper umengEvent:@"L_1_4"];
            GrowthManualViewController *viewController = [[GrowthManualViewController alloc] initWithNibName:@"GrowthManualViewController" bundle:nil];
            [_UI pushViewControllerFromRoot:viewController animated:YES];
        }
            break;
        case 4: //出单喜报
        {
            [XNUMengHelper umengEvent:@"L_1_5"];
            [[XNLeiCaiModule defaultModule] setIsHaveNewSaleGoodNews:NO];
            SaleGoodNewsDetailViewController *viewController = [[SaleGoodNewsDetailViewController alloc] initWithNibName:@"SaleGoodNewsDetailViewController" bundle:nil billId:@""];
            [_UI pushViewControllerFromRoot:viewController animated:YES];
        }
            break;
        case 5: //职级计算器
        {
            [XNUMengHelper umengEvent:@"L_1_6"];
            CfgLevelCalcViewController *viewController = [[CfgLevelCalcViewController alloc] initWithNibName:@"CfgLevelCalcViewController" bundle:nil];
            [_UI pushViewControllerFromRoot:viewController animated:YES];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - 职级提醒
- (void)XNLeiCaiModuleLevelPrivilegeDidSuccess:(XNLeiCaiModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    
    //更新状态数组
    [self updateStatusArray];
    [self.tableView reloadData];
}

- (void)XNLeiCaiModuleLevelPrivilegeDidFailed:(XNLeiCaiModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

#pragma mark - 加载首页数据
- (void)XNCustomerServerModuleGetHomePageDataDidReceive:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    
    //更新状态数组
    [self updateStatusArray];
    [self.tableView reloadData];
}

- (void)XNCustomerServermoduleGetHomePageDataDidFailed:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

#pragma mark - 未读喜报
- (void)XNLeiCaiModuleUnReadSaleGoodNewsDidSuccess:(XNLeiCaiModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

- (void)XNLeiCaiModuleUnReadSaleGoodNewsDidFailed:(XNLeiCaiModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    
    if (module.retCode.detailErrorDic)
    {
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat width = 0;
    if (offset <= 0) {
        
        width = - offset;
    }
    
    CGFloat alpha = offset / 200;
    if (alpha >= 1)
    {
        alpha = 1;
    }
    else if (alpha <= 0)
    {
        alpha = 0;
    }
    
    self.headerRefrshBgImageView.frame = CGRectMake(0 , offset, SCREEN_FRAME.size.width, width);
    
    self.newNavigationTitleColor = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:self.newNavigationTitleColor}];
}

/////////////////
#pragma mark - setter/getter
/////////////////////////////////

#pragma mark - cellStatusArray
- (NSMutableArray *)cellStatusArray
{
    if (!_cellStatusArray)
    {
        _cellStatusArray = [[NSMutableArray alloc]init];
    }
    return _cellStatusArray;
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
