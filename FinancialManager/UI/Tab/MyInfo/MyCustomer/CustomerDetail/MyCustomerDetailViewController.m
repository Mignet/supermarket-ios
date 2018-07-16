//
//  MyCustomerDetailViewController.m
//  FinancialManager
//
//  Created by xnkj on 17/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyCustomerDetailViewController.h"
#import "MyCustomerHeaderCell.h"
#import "MyCustomerStatisticsCell.h"
#import "MyCustomerRegisteredPlatformCell.h"
#import "MyCustomerInvestHeaderCell.h"
#import "MyCustomerInvestRecordCell.h"
#import "XNRedPacketEmptyCell.h"

#import "MJRefresh.h"

#import "XNCSMyCustomerInvestRecordItemMode.h"
#import "XNCSMyCustomerInvestRecordListMode.h"
#import "XNCSCustomerDetailMode.h"
#import "XNCSMyCustomerTradeListMode.h"
#import "XNCustomerServerModule.h"
#import "XNCustomerServerModuleObserver.h"


#define HEADERHEIGHT 76.0f
#define STATISTICDEFAULTHEIGHT 206.0f
#define STATISTICEXPANDHEIGHT 350.0f
#define REGISTEDPLATFORMDEFAULTHEIGHT 75.0f
#define INVESTHEADERHEIGHT 60.0f
#define INVESTRECORDDEFAULTCELLHEIGHT 108.0f
#define INVESTRECORDTIMERHEADERCELLHEIGHT 142.0f

#define DEFAULTPAGEINDEX @"1"
#define DEFAULTPAGESIE @"30"

@interface MyCustomerDetailViewController ()<XNCustomerServerModuleObserver>

@property (nonatomic, assign) BOOL             expandRegistedPlatformViewStatus;
@property (nonatomic, assign) BOOL             expandStatisticViewStatus;
@property (nonatomic, assign) CGFloat          expandInvestPlatformHeight;
@property (nonatomic, strong) NSString       * lastInvestTime;
@property (nonatomic, strong) NSString       * userId;
@property (nonatomic, strong) NSMutableArray * customerDataArray;

@property (nonatomic, weak) IBOutlet UITableView * containerTableView;
@end

@implementation MyCustomerDetailViewController

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
}

//////////////////
#pragma mark - 自定义方法
////////////////////////////////////

//初始化
- (void)initView
{
    self.title = @"客户详情";
    self.expandRegistedPlatformViewStatus = NO;
    self.expandStatisticViewStatus = NO;
    self.expandInvestPlatformHeight = 0.0f;
    self.lastInvestTime = @"";
    
    [[XNCustomerServerModule defaultModule] addObserver:self];
    [[XNCustomerServerModule defaultModule] setCustomerDetailMode:nil];
    
    [self.containerTableView registerNib:[UINib nibWithNibName:@"MyCustomerHeaderCell" bundle:nil] forCellReuseIdentifier:@"MyCustomerHeaderCell"];
    [self.containerTableView registerNib:[UINib nibWithNibName:@"MyCustomerStatisticsCell" bundle:nil] forCellReuseIdentifier:@"MyCustomerStatisticsCell"];
    [self.containerTableView registerNib:[UINib nibWithNibName:@"MyCustomerRegisteredPlatformCell" bundle:nil] forCellReuseIdentifier:@"MyCustomerRegisteredPlatformCell"];
    [self.containerTableView registerNib:[UINib nibWithNibName:@"MyCustomerInvestHeaderCell" bundle:nil] forCellReuseIdentifier:@"MyCustomerInvestHeaderCell"];
    [self.containerTableView registerNib:[UINib nibWithNibName:@"MyCustomerInvestRecordCell" bundle:nil] forCellReuseIdentifier:@"MyCustomerInvestRecordCell"];
    [self.containerTableView registerNib:[UINib nibWithNibName:@"XNRedPacketEmptyCell" bundle:nil] forCellReuseIdentifier:@"XNRedPacketEmptyCell"];
    [self.containerTableView setSeparatorColor:[UIColor clearColor]];
    
    weakSelf(weakSelf)
    self.containerTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadRequest];
    }];
    self.containerTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [[XNCustomerServerModule defaultModule] getCustomerInvestRecordListForUserId:weakSelf.userId type:@"2" pageIndex:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[[[XNCustomerServerModule defaultModule] customerInvestRecordListMode] pageIndex] integerValue] + 1]] pageSize:DEFAULTPAGESIE];
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
    [[XNCustomerServerModule defaultModule] getCustomerDetailForCustomer:self.userId];
    [[XNCustomerServerModule defaultModule] getCustomerInvestRecordListForUserId:self.userId type:@"2" pageIndex:DEFAULTPAGEINDEX pageSize:DEFAULTPAGESIE];
    
    [self.view showGifLoading];
}

//////////////////
#pragma mark - 组件回调
////////////////////////////////////

//UITableView 回调用
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[XNCustomerServerModule defaultModule]customerDetailMode]) {
        
        if (self.customerDataArray.count == 0) {
            
            return self.customerDataArray.count + 5;
        }
        
        return self.customerDataArray.count + 4;
    }
    
    return 0;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return HEADERHEIGHT;
    if (indexPath.row == 1) return self.expandStatisticViewStatus?STATISTICEXPANDHEIGHT:STATISTICDEFAULTHEIGHT;
   
    if (indexPath.row == 2) return !self.expandRegistedPlatformViewStatus?REGISTEDPLATFORMDEFAULTHEIGHT:(self.expandInvestPlatformHeight + REGISTEDPLATFORMDEFAULTHEIGHT);
    
    if (indexPath.row == 3)
    {
        return INVESTHEADERHEIGHT;
    }
    
    if (self.customerDataArray.count == 0) {
        
        if (SCREEN_FRAME.size.height - 428 > 140) {
            
            return SCREEN_FRAME.size.height - 428;
        }
        
        return 140;
    }
    
    if (indexPath.row == 4) {
        
        return INVESTRECORDTIMERHEADERCELLHEIGHT;
    }
    
    XNCSMyCustomerInvestRecordItemMode * item = [self.customerDataArray objectAtIndex:indexPath.row - 4];
    self.lastInvestTime = ((XNCSMyCustomerInvestRecordItemMode *)[self.customerDataArray objectAtIndex:indexPath.row - 5]).startTime;
    
    if ([self.lastInvestTime isEqualToString:item.startTime]) {
        
        return INVESTRECORDDEFAULTCELLHEIGHT;
    }
    
    return INVESTRECORDTIMERHEADERCELLHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        MyCustomerHeaderCell * cell = (MyCustomerHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"MyCustomerHeaderCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell setClickCustomerPhone:^(NSString *phoneNumber) {
            
            NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",phoneNumber];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        
        weakSelf(weakSelf)
        [cell setClickCustomerCared:^{
            
            [[XNCustomerServerModule defaultModule] careCustomer:weakSelf.userId];
            [weakSelf.view showGifLoading];
        }];
        [cell setClickCustomerCancelCared:^{
            
            [[XNCustomerServerModule defaultModule] cancelCaredCustomer:weakSelf.userId];
            [weakSelf.view showGifLoading];
        }];
        
        [cell refreshCustomHeaderImage:[[[XNCustomerServerModule defaultModule]customerDetailMode] headImage] customName:[[[XNCustomerServerModule defaultModule]customerDetailMode] userName] phoneNumber:[[[XNCustomerServerModule defaultModule]customerDetailMode] mobile] caredStatus:[[[XNCustomerServerModule defaultModule]customerDetailMode] follow]];
        
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
        
        [cell refreshData:[[XNCustomerServerModule defaultModule]customerDetailMode]];
        [cell refreshCellWithExpandStatus:self.expandStatisticViewStatus];
        
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
        
        [cell setRegistedPlatform:[[[XNCustomerServerModule defaultModule] customerDetailMode] registeredOrgList] expandStatus:self.expandRegistedPlatformViewStatus];
        
        return cell;
    }
    
    if (indexPath.row == 3) {
        
        MyCustomerInvestHeaderCell * cell = (MyCustomerInvestHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"MyCustomerInvestHeaderCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if ([[XNCustomerServerModule defaultModule] customerInvestRecordListMode]) {
         
            [cell refreshTitle:[NSString stringWithFormat:@"投资记录 (%@笔)",[[[XNCustomerServerModule defaultModule] customerInvestRecordListMode] totalCount]]];
        }else
        {
            [cell refreshTitle:@"投资记录 (0笔)"];
        }
        
        return cell;
    }
    
    if (self.customerDataArray.count == 0) {
        
        XNRedPacketEmptyCell * cell = (XNRedPacketEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"XNRedPacketEmptyCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        [cell showTitle:@"当前没有投资记录" subTitle:@""];
        
        return cell;
    }
    
    MyCustomerInvestRecordCell * cell = (MyCustomerInvestRecordCell *)[tableView dequeueReusableCellWithIdentifier:@"MyCustomerInvestRecordCell"];
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
- (void)XNCustomerServerModuleCustomerDetailDidReceive:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    [self.containerTableView.mj_header endRefreshing];
    [self.containerTableView.mj_footer endRefreshing];
    
    [self.containerTableView reloadData];
}

- (void)XNCustomerServerModuleCustomerDetailDidFailed:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    [self.containerTableView.mj_header endRefreshing];
    [self.containerTableView.mj_footer endRefreshing];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    [self showNetworkLoadingFailedDidReloadTarget:self Action:@selector(reload)];
    
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

//邀请重要客户
- (void)XNCustomerServerModuleAddImprotantCustomerDidReceive:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    
    [[[XNCustomerServerModule defaultModule]customerDetailMode] setFollow:YES];
    [self.containerTableView reloadData];
}

- (void)XNCustomerServerModuleAddImprotantCustomerDidFailed:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//移除重要客户
- (void)XNCustomerServerModuleRemoveImprotantCustomerDidReceive:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    
    [[[XNCustomerServerModule defaultModule]customerDetailMode] setFollow:NO];
    [self.containerTableView reloadData];
}

- (void)XNCustomerServerModuleRemoveImprotantCustomerDidFailed:(XNCustomerServerModule *)module
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
