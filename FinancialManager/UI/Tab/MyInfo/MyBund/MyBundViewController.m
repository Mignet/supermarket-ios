//
//  MyBundViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/21/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyBundViewController.h"
#import "MyBundHeaderCell.h"
#import "MyBundCell.h"
#import "MFSystemInvitedEmptyCell.h"
#import "MIAddBankCardController.h"
#import "PXAlertView+XNExtenstion.h"
#import "MyBundRecordingViewController.h"
#import "AgentContainerController.h"

#import "XNBundModule.h"
#import "XNBundModuleObserver.h"
#import "XNMyBundHoldingStatisticMode.h"
#import "XNMyBundHoldingDetailMode.h"
#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"
#import "MIMySetMode.h"
#import "XNBundThirdPageMode.h"

#define HEADERHEIGHT 250.5
#define CELLHEIGHT 149.0

@interface MyBundViewController ()<UniversalInteractWebViewControllerDelegate, XNBundModuleObserver, XNMyInformationModuleObserver, MyBundHeaderCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) XNMyBundHoldingStatisticMode *myBundHoldingStatisticMode;
@property (nonatomic, strong) NSMutableArray *datasArray;
@property (nonatomic, assign) BOOL isAbnormalStatus;
@property (nonatomic, strong) XNBundModule *bundModule;
@property (nonatomic, strong) XNMyInformationModule *myInformationModule;

@end

@implementation MyBundViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.bundModule removeObserver:self];
    [self.myInformationModule removeObserver:self];
}

/////////////////
#pragma mark - 自定义
/////////////////////////////////

//初始化
- (void)initView
{
    self.title = @"我的基金";
    self.isAbnormalStatus = NO;
   
    [self.bundModule addObserver:self];
    [self.myInformationModule addObserver:self];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MyBundHeaderCell" bundle:nil] forCellReuseIdentifier:@"MyBundHeaderCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MFSystemInvitedEmptyCell" bundle:nil] forCellReuseIdentifier:@"MFSystemInvitedEmptyCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MyBundCell" bundle:nil] forCellReuseIdentifier:@"MyBundCell"];
    
    weakSelf(weakSelf)
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadDatas];
        
    }];
    
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
    //持有资产
    [self.bundModule requestMyBundHoldingStatistic];
    //持有明细
    [self.bundModule requestMyFundHoldingDetail:@"" portfolioId:@""];
    
}

////////////////////
#pragma mark - Protocol Method
////////////////////////////////////////////

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.datasArray.count <= 0)
    {
        return 2;
    }
    
    return self.datasArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = indexPath.row;
    
    if (nRow == 0)
    {
        static NSString *cellIdentifierString = @"MyBundHeaderCell";
        MyBundHeaderCell *cell = (MyBundHeaderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
        cell.delegate = self;
        [cell showDatas:self.myBundHoldingStatisticMode isAbnormalStatus:self.isAbnormalStatus];
        
        return cell;
    }
    
    if (self.datasArray.count <= 0)
    {
        MFSystemInvitedEmptyCell *emptyCell = (MFSystemInvitedEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"MFSystemInvitedEmptyCell"];
        //报异常
        if (self.isAbnormalStatus)
        {
            [emptyCell refreshTitle:@"该页面已经飞到了外太空，\n请稍后再试" imageView:@"XN_My_Fund_Error_icon"];
        }
        else
        {
            [emptyCell refreshTitle:@"目前暂未持有基金"];
        }
        
        
        [emptyCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return emptyCell;
    }
    
    static NSString *cellIdentifierString = @"MyBundCell";
    MyBundCell *cell = (MyBundCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
    
    [cell showDatas:[self.datasArray objectAtIndex:nRow - 1]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = indexPath.row;
    if (nRow == 0)
    {
        return HEADERHEIGHT;
    }
    
    if (self.datasArray.count <= 0)
    {
        return SCREEN_FRAME.size.height - HEADERHEIGHT;
    }
    
    return CELLHEIGHT;
    
}

#pragma mark - MyBundHeaderCellDelegate
- (void)MyBundHeaderCellDidClick:(NSInteger)nIndex
{
    switch (nIndex) {
        case 1: //交易明细
        {
            MyBundRecordingViewController *viewController = [[MyBundRecordingViewController alloc] initWithNibName:@"MyBundRecordingViewController" bundle:nil];
            [_UI pushViewControllerFromRoot:viewController animated:YES];
        }
            break;
        case 2: //前往投资
        {
            UINavigationController * platformCtrl = [_UI getRootNavigationControllerAtIndex:1];
            AgentContainerController * agentCtrl = platformCtrl.viewControllers[0];
            [agentCtrl selectedAtIndex:2];
            
            [_UI currentViewController:self popToRootViewController:YES AndSwitchToTabbarIndex:1 comlite:^{
                
            }];

        }
            break;
        case 3: //前往赎回
        {
            //判断是否绑卡
            [self.myInformationModule requestMySettingInfo];
            [self.view showGifLoading];
            
        }
            break;
        default:
            break;
    }

}

#pragma mark - 我的基金-持有资产
- (void)XNBundModuleMyBundHoldingStatisticDidReceive:(XNBundModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    self.isAbnormalStatus = NO;
    
    self.myBundHoldingStatisticMode = [self.bundModule myBundHoldingStatisticMode];
    
    [self.tableView reloadData];
}

- (void)XNBundModuleMyBundHoldingStatisticDidFailed:(XNBundModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    
    //系统异常
    if ([module.retCode.ret isEqualToString:@"-999999"])
    {
        self.isAbnormalStatus = YES;
        [self.tableView reloadData];
        return;
    }
    
    if (module.retCode.detailErrorDic)
    {
        if (![module.retCode.ret isEqualToString:@"100006"] && ![module.retCode.ret isEqualToString:@"-999999"])
        {
            [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
        }
    }
    else
    {
            [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
    
}

#pragma mark - 我的基金-持有明细
- (void)XNBundModuleMyBundHoldingDetailDidReceive:(XNBundModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    self.isAbnormalStatus = NO;
    
    if (module.myBundHoldingArray && module.myBundHoldingArray.count > 0)
    {
        [self.datasArray removeAllObjects];
        [self.datasArray addObjectsFromArray:module.myBundHoldingArray];
    }
    [self.tableView reloadData];
}

- (void)XNBundModuleMyBundHoldingDetailDidFailed:(XNBundModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    
    //系统异常
    if ([module.retCode.ret isEqualToString:@"-999999"])
    {
        self.isAbnormalStatus = YES;
        [self.tableView reloadData];
        return;
    }
    
    if (module.retCode.detailErrorDic)
    {
        if (![module.retCode.ret isEqualToString:@"100006"] && ![module.retCode.ret isEqualToString:@"-999999"])
        {
            [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
        }
    }
    else
    {
        
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
        
    }
}

#pragma mark - 用户绑卡信息
- (void)XNMyInfoModulePeopleSettingDidReceive:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    
    //已绑卡
    if ([[[XNMyInformationModule defaultModule] settingMode] bundBankCard])
    {
        //是否已注册基金账户
        [self.bundModule isRegisterBundResult];
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

#pragma mark - 是否注册过基金
- (void)XNBundModuleIsRegisterBundDidReceive:(XNBundModule *)module
{
    [self.view hideLoading];
    //已注册
    if (module.isRegisterBund)
    {
        //跳转到基金个人资产页
        [self.bundModule gotoFundAccount];
        [self.view showGifLoading];
    }
    else
    {
        //开通注册基金平台
        [self showFMRecommandViewWithTitle:@"一键开通基金账户?" subTitle:@"开通后，将同步个人身份信息和联系方式" subTitleLeftPadding:12 otherSubTitle:@"" okTitle:@"一键开通" okCompleteBlock:^{
            
            //注册基金平台
            [self.bundModule registerBund];
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

#pragma mark - 注册基金
- (void)XNBundModuleRegisterBundDidReceive:(XNBundModule *)module
{
    [self.view hideLoading];
    //跳转到基金个人资产页
    [self.bundModule gotoFundAccount];
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

#pragma mark - 奕丰基金个人资产页跳转
- (void)XNBundModuleGotoBundAccountDidReceive:(XNBundModule *)module
{
    [self.view hideLoading];
    
    XNBundThirdPageMode *mode = module.bundThirdAccountMode;
    NSString *urlString = [NSString stringWithFormat:@"%@?data=%@&integrationMode=%@&referral=%@", mode.requestUrl, mode.data, mode.integrationMode, mode.referral];
    UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:urlString requestMethod:@"POST"];
    [webCtrl setTitleName:@""];
    
    [webCtrl setIsEnterThirdPlatform:YES platformName:@"奕丰金融"];
    [webCtrl.view setBackgroundColor:[UIColor whiteColor]];
    [_UI pushViewControllerFromHomeViewControllerForController:webCtrl hideNavigationBar:NO animated:YES];
    
}

- (void)XNBundModuleGotoBundAccountDidFailed:(XNBundModule *)module
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

////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

#pragma mark - datasArray
- (NSMutableArray *)datasArray
{
    if (!_datasArray)
    {
        _datasArray = [[NSMutableArray alloc] init];
    }
    return _datasArray;
}

#pragma - XNBundModule
- (XNBundModule *)bundModule
{
    if (!_bundModule)
    {
        _bundModule = [[XNBundModule alloc] init];
    }
    return _bundModule;
}

#pragma - XNMyInformationModule
- (XNMyInformationModule *)myInformationModule
{
    if (!_myInformationModule)
    {
        _myInformationModule = [[XNMyInformationModule alloc] init];
    }
    return _myInformationModule;
}

@end
