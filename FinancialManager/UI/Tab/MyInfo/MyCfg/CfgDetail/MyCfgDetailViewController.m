//
//  MyCustomerDetailViewController.m
//  FinancialManager
//
//  Created by xnkj on 17/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyCfgDetailViewController.h"
#import "MyCfgHeaderCell.h"
#import "MyCustomerStatisticsCell.h"
#import "MyCustomerRegisteredPlatformCell.h"
#import "MyCustomerInvestHeaderCell.h"
#import "MyCfgInvestRecordCell.h"
#import "XNRedPacketEmptyCell.h"

#import "MJRefresh.h"

#import "XNCSMyCustomerInvestRecordItemMode.h"
#import "XNCSMyCustomerInvestRecordListMode.h"
#import "XNCSCfgDetailMode.h"
#import "XNLCLevelPrivilegeMode.h"
#import "XNCustomerServerModule.h"
#import "XNCustomerServerModuleObserver.h"

#import "XNLeiCaiModule.h"
#import "XNLeiCaiModuleObserver.h"


#define HEADERHEIGHT 234.0f
#define STATISTICDEFAULTHEIGHT 206.0f
#define STATISTICEXPANDHEIGHT 350.0f
#define REGISTEDPLATFORMDEFAULTHEIGHT 75.0f
#define INVESTHEADERHEIGHT 60.0f
#define INVESTRECORDDEFAULTCELLHEIGHT 108.0f
#define INVESTRECORDTIMERHEADERCELLHEIGHT 142.0f

#define DEFAULTPAGEINDEX @"1"
#define DEFAULTPAGESIE @"30"

@interface MyCfgDetailViewController ()<XNCustomerServerModuleObserver,XNLeiCaiModuleObserver>

@property (nonatomic, assign) BOOL             expandRegistedPlatformViewStatus;
@property (nonatomic, assign) BOOL             expandStatisticViewStatus;
@property (nonatomic, assign) CGFloat          expandInvestPlatformHeight;
@property (nonatomic, strong) NSString       * lastInvestTime;
@property (nonatomic, strong) NSString       * userId;
@property (nonatomic, strong) NSMutableArray * customerDataArray;

@property (nonatomic, weak) IBOutlet UITableView * containerTableView;
@end

@implementation MyCfgDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userId:(NSString *)userId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.userId = userId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[XNCustomerServerModule defaultModule] removeObserver:self];
    [[XNLeiCaiModule defaultModule] removeObserver:self];
}

//////////////////
#pragma mark - 自定义方法
////////////////////////////////////

//初始化
- (void)initView
{  
    self.title = @"直推理财师详情";
    self.expandRegistedPlatformViewStatus = NO;
    self.expandStatisticViewStatus = NO;
    self.expandInvestPlatformHeight = 0.0f;
    self.lastInvestTime = @"";
    
    [[XNCustomerServerModule defaultModule] addObserver:self];
    [[XNLeiCaiModule defaultModule] addObserver:self];
    [[XNCustomerServerModule defaultModule] setCfgDetailMode:nil];
    
    [self.containerTableView registerNib:[UINib nibWithNibName:@"MyCfgHeaderCell" bundle:nil] forCellReuseIdentifier:@"MyCfgHeaderCell"];
    [self.containerTableView registerNib:[UINib nibWithNibName:@"MyCustomerStatisticsCell" bundle:nil] forCellReuseIdentifier:@"MyCustomerStatisticsCell"];
    [self.containerTableView registerNib:[UINib nibWithNibName:@"MyCustomerRegisteredPlatformCell" bundle:nil] forCellReuseIdentifier:@"MyCustomerRegisteredPlatformCell"];
    [self.containerTableView registerNib:[UINib nibWithNibName:@"MyCustomerInvestHeaderCell" bundle:nil] forCellReuseIdentifier:@"MyCustomerInvestHeaderCell"];
    [self.containerTableView registerNib:[UINib nibWithNibName:@"MyCfgInvestRecordCell" bundle:nil] forCellReuseIdentifier:@"MyCfgInvestRecordCell"];
    [self.containerTableView registerNib:[UINib nibWithNibName:@"XNRedPacketEmptyCell" bundle:nil] forCellReuseIdentifier:@"XNRedPacketEmptyCell"];
    [self.containerTableView setSeparatorColor:[UIColor clearColor]];
    
    weakSelf(weakSelf)
    self.containerTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadRequest];
    }];
    self.containerTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [[XNCustomerServerModule defaultModule] getCustomerInvestRecordListForUserId:weakSelf.userId type:@"1" pageIndex:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[[[XNCustomerServerModule defaultModule] customerInvestRecordListMode] pageIndex] integerValue] + 1]] pageSize:DEFAULTPAGESIE];
    }];
    
    [self.containerTableView.mj_footer setHidden:YES];
    [self loadRequest];
    
    if ([self.view respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

//启动加载请求
- (void)loadRequest
{
    [[XNCustomerServerModule defaultModule] getCfgDetailForCfg:self.userId];
    [[XNLeiCaiModule defaultModule] requestLevelPrivilegeWithUserId:self.userId];
    [[XNCustomerServerModule defaultModule] getCustomerInvestRecordListForUserId:self.userId type:@"1" pageIndex:DEFAULTPAGEINDEX pageSize:DEFAULTPAGESIE];
    
    [self.view showGifLoading];
}

//////////////////
#pragma mark - 组件回调
////////////////////////////////////

//UITableView 回调用
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[XNCustomerServerModule defaultModule] cfgDetailMode]) {
        
        if (self.customerDataArray.count == 0) {
            
            return self.customerDataArray.count + 5;
        }
        
        return self.customerDataArray.count + 4;
    }
    
    return 0;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        if ([[[XNLeiCaiModule defaultModule] levelPrivilegeMode].lowerLevelCfpMaxNew integerValue] == 0) {
            
            return HEADERHEIGHT;
        }
        
        return HEADERHEIGHT + 24;
    }
    
    if (indexPath.row == 1) return self.expandStatisticViewStatus?STATISTICEXPANDHEIGHT:STATISTICDEFAULTHEIGHT;
   
    if (indexPath.row == 2) return !self.expandRegistedPlatformViewStatus?REGISTEDPLATFORMDEFAULTHEIGHT:(self.expandInvestPlatformHeight + REGISTEDPLATFORMDEFAULTHEIGHT);
    
    if (indexPath.row == 3) return INVESTHEADERHEIGHT;
    
    if (self.customerDataArray.count == 0) {
        
        if (SCREEN_FRAME.size.height - 428 > 140) {
            
            return SCREEN_FRAME.size.height - 428;
        }
        
        return 140;
    }
    
    XNCSMyCustomerInvestRecordItemMode * item = [self.customerDataArray objectAtIndex:indexPath.row - 4];
    
    if (indexPath.row == 4) {
        
        self.lastInvestTime = item.startTime;
        
        return INVESTRECORDTIMERHEADERCELLHEIGHT;
    }
    
    self.lastInvestTime = ((XNCSMyCustomerInvestRecordItemMode *)[self.customerDataArray objectAtIndex:indexPath.row - 5]).startTime;
    if ([self.lastInvestTime isEqualToString:item.startTime]) {
        
        return INVESTRECORDDEFAULTCELLHEIGHT;
    }
    
    return INVESTRECORDTIMERHEADERCELLHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        MyCfgHeaderCell * cell = (MyCfgHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"MyCfgHeaderCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell setClickCustomerPhone:^(NSString *phoneNumber) {
            
            NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",phoneNumber];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        
        weakSelf(weakSelf)
        [cell setClickCustomerCared:^{
            
            [[XNCustomerServerModule defaultModule] careCfg:weakSelf.userId];
            [weakSelf.view showGifLoading];
        }];
        [cell setClickCustomerCancelCared:^{
            
            [[XNCustomerServerModule defaultModule] cancelCaredCfg:weakSelf.userId];
            [weakSelf.view showGifLoading];
        }];
        
        [cell refreshCustomHeaderImage:[[[XNCustomerServerModule defaultModule] cfgDetailMode] headImage] customName:[[[XNCustomerServerModule defaultModule] cfgDetailMode] userName] phoneNumber:[[[XNCustomerServerModule defaultModule] cfgDetailMode] mobile] level: [[[XNCustomerServerModule defaultModule] cfgDetailMode] grade] caredStatus:[[[XNCustomerServerModule defaultModule] cfgDetailMode] follow]    directRecommandCfgCount:[[[XNCustomerServerModule defaultModule] cfgDetailMode] directRecomCfp] secondRecommandCfgCount:[[[XNCustomerServerModule defaultModule] cfgDetailMode] secondLevelCfp] levelMode:[[XNLeiCaiModule defaultModule] levelPrivilegeMode]];
        
        return cell;
    }
    
    if (indexPath.row == 1) {
        
        MyCustomerStatisticsCell * cell = (MyCustomerStatisticsCell *)[tableView dequeueReusableCellWithIdentifier:@"MyCustomerStatisticsCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        weakSelf(weakSelf)
        [cell setClickExpandOperation:^(BOOL expandStatus) {
            
            weakSelf.expandStatisticViewStatus = expandStatus;
            NSIndexPath * path = [NSIndexPath indexPathForRow:1 inSection:0];
            [weakSelf.containerTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        [cell refreshCellWithExpandStatus:self.expandStatisticViewStatus];
        [cell refreshDataForCfg:[[XNCustomerServerModule defaultModule] cfgDetailMode]];
        
        return cell;
    }
    
    if (indexPath.row == 2) {
        
        MyCustomerRegisteredPlatformCell * cell = (MyCustomerRegisteredPlatformCell *)[tableView dequeueReusableCellWithIdentifier:@"MyCustomerRegisteredPlatformCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        weakSelf(weakSelf)
        [cell setClickExpandRegisteredPlatformOperation:^(BOOL expandStatus, CGFloat platformHeight) {
           
            weakSelf.expandInvestPlatformHeight = platformHeight;
            weakSelf.expandRegistedPlatformViewStatus = expandStatus;
            NSIndexPath * path = [NSIndexPath indexPathForRow:2 inSection:0];
            [weakSelf.containerTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        [cell setRegistedPlatform:[[[XNCustomerServerModule defaultModule] cfgDetailMode] registeredOrgList] expandStatus:self.expandRegistedPlatformViewStatus];
        
        return cell;
    }
    
    if (indexPath.row == 3) {
        
        MyCustomerInvestHeaderCell * cell = (MyCustomerInvestHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"MyCustomerInvestHeaderCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell refreshTitle:@"出单记录 (0笔)"];
        if ([[XNCustomerServerModule defaultModule] customerInvestRecordListMode]) {
            
            [cell refreshTitle:[NSString stringWithFormat:@"出单记录 (%@笔)",[[[XNCustomerServerModule defaultModule] customerInvestRecordListMode] totalCount]]];
        }
        
        return cell;
    }
    
    if (self.customerDataArray.count == 0) {
        
        XNRedPacketEmptyCell * cell = (XNRedPacketEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"XNRedPacketEmptyCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell showTitle:@"当前没有投资记录" subTitle:@""];
        
        return cell;
    }
    
    MyCfgInvestRecordCell * cell = (MyCfgInvestRecordCell *)[tableView dequeueReusableCellWithIdentifier:@"MyCfgInvestRecordCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    XNCSMyCustomerInvestRecordItemMode * item = [self.customerDataArray objectAtIndex:indexPath.row - 4];
    
    [cell refreshInvestRecordCellWithParams:item];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= 3 || self.customerDataArray.count == 0) {
        
        return;
    }
    
    XNCSMyCustomerInvestRecordItemMode * item = [self.customerDataArray objectAtIndex:indexPath.row - 4];
     NSString * url = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"%@?investId=%@&canJumpNative=%@",@"/pages/message/buyDetail.html",item.investId,@"0"]];
     UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"Get"];
     [_UI pushViewControllerFromRoot:webCtrl animated:YES];
}

//////////////////
#pragma mark - 网络请求回调
////////////////////////////////////

//客户详情-基础信息
- (void)XNCustomerServerModuleCfgDetailDidReceive:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    [self.containerTableView.mj_header endRefreshing];
    [self.containerTableView.mj_footer endRefreshing];
    
    [self.containerTableView reloadData];
}

- (void)XNCustomerServerModuleCfgDetailDidFailed:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    [self.containerTableView.mj_header endRefreshing];
    [self.containerTableView.mj_footer endRefreshing];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//客户交易记录
- (void)XNCustomerServerModuleCustomerInvestRecordListDidReceive:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    [self.containerTableView.mj_header endRefreshing];
    [self.containerTableView.mj_footer endRefreshing];
    [self.containerTableView.mj_footer setHidden:NO];
    
    if ([module.customerInvestRecordListMode.pageIndex integerValue] == 1)
        [self.customerDataArray removeAllObjects];

    [self.customerDataArray addObjectsFromArray:module.customerInvestRecordListMode.datas];
    
    if ([module.customerInvestRecordListMode.pageIndex integerValue] >= [module.customerInvestRecordListMode.pageCount integerValue]) {
        
        [self.containerTableView.mj_footer endRefreshingWithNoMoreData];
        [self.containerTableView.mj_footer setHidden:YES];
    }else
    {
        [self.containerTableView.mj_footer resetNoMoreData];
        [self.containerTableView.mj_footer setHidden:NO];
    }

    [self.containerTableView reloadData];
}

- (void)XNCustomerServerModuleCustomerInvestRecordListDidFailed:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    [self.containerTableView.mj_header endRefreshing];
    [self.containerTableView.mj_footer endRefreshing];
    [self.containerTableView.mj_footer setHidden:NO];
    
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//职级特权
- (void)XNLeiCaiModuleLevelPrivilegeDidSuccess:(XNLeiCaiModule *)module
{
    [self.containerTableView.mj_header endRefreshing];
    [self.containerTableView.mj_footer endRefreshing];
    
    //更新状态数组
    [self.containerTableView reloadData];
}

- (void)XNLeiCaiModuleLevelPrivilegeDidFailed:(XNLeiCaiModule *)module
{
    [self.view hideLoading];
    [self.containerTableView.mj_header endRefreshing];
   
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//邀请重要客户
- (void)XNCustomerServerModuleCaredCfgDidReceive:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    
    [[[XNCustomerServerModule defaultModule] cfgDetailMode] setFollow:YES];
    [self.containerTableView reloadData];
}

- (void)XNCustomerServerModuleCaredCfgDidFailed:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//移除重要客户
- (void)XNCustomerServerModuleCancelCaredCfgDidReceive:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    
    [[[XNCustomerServerModule defaultModule] cfgDetailMode] setFollow:NO];
    [self.containerTableView reloadData];
}

- (void)XNCustomerServerModuleCancelCaredCfgDidFailed:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//////////////////
#pragma mark - 懒加载
////////////////////////////////////

//customerDataArray
- (NSMutableArray *)customerDataArray
{
    if (!_customerDataArray) {
        
        _customerDataArray = [[NSMutableArray alloc]init];
    }
    return _customerDataArray;
}
@end
