//
//  MIDeportDetailController.m
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "MIDeportDetailController.h"

#import "MIDeportDetailCell.h"
#import "MFSystemInvitedEmptyCell.h"

#import "MJRefresh.h"

#import "XNMyAccountTotalDeportMode.h"
#import "XNMyAccountWithDrawRecordItemMode.h"
#import "XNMyAccountDeportRecordListMode.h"
#import "XNAccountModule.h"
#import "XNAccountModuleObserver.h"


#import "XNMyAccountTotalDeportMode.h"
#import "DeportMoneyModule.h"
#import "DeportMoneyModuleObserver.h"

#define HEADERHEIGHT 75.0f
#define DEFAULTCELLHEIGHT 75.0f + 10.0f

#define DEFAULTPAGEINDEX @"1"
#define DEFAULTPAGESIZE  @"30"

@interface MIDeportDetailController ()<DeportMoneyModuleObserver, MIDeportDetailCellDelegate>

@property (nonatomic, assign) BOOL                 finishedRequest;
@property (nonatomic, strong) NSMutableArray     * contentMutableArray;

@property (nonatomic, weak) IBOutlet   UILabel   * totalDeportLabel;
@property (nonatomic, strong) IBOutlet UIView      * headerView;
@property (nonatomic, weak) IBOutlet UITableView * conentListTableView;
@end

@implementation MIDeportDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.view hideLoading];
    [self.conentListTableView.mj_header endRefreshing];
    [self.conentListTableView.mj_footer endRefreshing];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[DeportMoneyModule defaultModule] removeObserver:self];
}

////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.title = @"提现记录";
    self.finishedRequest = NO;
    self.totalDeportLabel.textColor = MONEYCOLOR;
    
    [self.conentListTableView setSeparatorColor:[UIColor clearColor]];
    [self.conentListTableView registerNib:[UINib nibWithNibName:@"MIDeportDetailCell" bundle:nil] forCellReuseIdentifier:@"MIDeportDetailCell"];
    [self.conentListTableView registerNib:[UINib nibWithNibName:@"MFSystemInvitedEmptyCell" bundle:nil] forCellReuseIdentifier:@"MFSystemInvitedEmptyCell"];
    
    weakSelf(weakSelf)
    self.conentListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [weakSelf initLoadNetwork];
    }];
    self.conentListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [[DeportMoneyModule defaultModule] getmyAccountDeportRecordListAtIndex:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[[[DeportMoneyModule defaultModule] myAccountDeportRecordListMode] pageIndex] integerValue]+ 1]] PageSize:DEFAULTPAGESIZE];
    }];
    
    [[DeportMoneyModule defaultModule] addObserver:self];
    [self initLoadNetwork];
    [self.view showGifLoading];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 初始化网络加载
- (void)initLoadNetwork
{
    self.finishedRequest = NO;
    
    [[DeportMoneyModule defaultModule] getMyAccountTotalDeportMoney];
    [[DeportMoneyModule defaultModule] getmyAccountDeportRecordListAtIndex:DEFAULTPAGEINDEX PageSize:DEFAULTPAGESIZE];
}

#pragma mark - 重新加载
- (void)reload
{
    [self hideLoadingTarget:self];
    
    [self initLoadNetwork];
    [self.view showGifLoading];
}

//////////////////////////////
#pragma mark - protocol Methods
//////////////////////////////////////////

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.finishedRequest && self.contentMutableArray.count <= 0) {
        
        return 1;
    }
    
    return self.contentMutableArray.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADERHEIGHT;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.finishedRequest && self.contentMutableArray.count <= 0) {
        
        return self.view.frame.size.height - 87;
    }
    
    return DEFAULTCELLHEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.finishedRequest && self.contentMutableArray.count <= 0) {
        
        MFSystemInvitedEmptyCell * cell = (MFSystemInvitedEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"MFSystemInvitedEmptyCell"];
        
        [cell refreshTitle:@"暂无记录"];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    MIDeportDetailCell * cell = (MIDeportDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"MIDeportDetailCell"];
    cell.delegate = self;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell showDatas:[self.contentMutableArray objectAtIndex:indexPath.row] ];
    
    return cell;
}

#pragma mark - MIDeportDetailCellDelegate
- (void)showExplain:(XNMyAccountWithDrawRecordItemMode *)mode
{
    //提现失败弹框
    NSString *reasonString = mode.failureCause;
    [self showCustomAlertViewWithTitle:reasonString okTitle:@"关闭" okTitleColor:UIColorFromHex(0x3e4446) okCompleteBlock:^{
        
    } topPadding:23 textAlignment:NSTextAlignmentLeft];
}

#pragma mark - 累计提现
- (void)XNAccountModuleMyAccountTotalDeportDidReceive:(DeportMoneyModule *)module
{
    [self.view hideLoading];
    [self.totalDeportLabel setText:[NSString convertUnits:module.myAccountTotalDeportMode.outTotalAmount]];
}

- (void)XNAccountModuleMyAccountTotalDeportDidFailed:(DeportMoneyModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    [self showNetworkLoadingFailedDidReloadTarget:self Action:@selector(reload)];
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

#pragma mark - 记录
- (void)XNAccountModuleMyAccountDeportListDidReceive:(DeportMoneyModule *)module
{
    self.finishedRequest = YES;
    [self.view hideLoading];
    [self.conentListTableView.mj_header endRefreshing];
    [self.conentListTableView.mj_footer endRefreshing];
    
    if ([module.myAccountDeportRecordListMode.pageIndex integerValue] == 1)
        [self.contentMutableArray removeAllObjects];
    
    [self.contentMutableArray addObjectsFromArray:module.myAccountDeportRecordListMode.dataArray];
    
    if ([module.myAccountDeportRecordListMode.pageIndex integerValue] >= [module.myAccountDeportRecordListMode.pageCount integerValue]) {
        
        [self.conentListTableView.mj_footer endRefreshingWithNoMoreData];
    }else
        [self.conentListTableView.mj_footer resetNoMoreData];
    
    [self.conentListTableView reloadData];
}

- (void)XNAccountModuleMyAccountDeportListDidFailed:(DeportMoneyModule *)module
{
    self.finishedRequest = YES;
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
 
    [self.view hideLoading];
    [self.conentListTableView.mj_header endRefreshing];
    [self.conentListTableView.mj_footer endRefreshing];
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

#pragma mark - contentMutableArray
- (NSMutableArray *)contentMutableArray
{
    if (!_contentMutableArray) {
        
        _contentMutableArray = [[NSMutableArray alloc]init];
    }
    return _contentMutableArray;
}

@end
