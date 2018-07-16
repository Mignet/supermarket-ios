//
//  AgentViewController.m
//  FinancialManager
//
//  Created by xnkj on 7/7/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "AgentViewController.h"
#import "MJRefresh.h"
#import "UniversalInteractWebViewController.h"
#import "AgentDetailViewController.h"
#import "AgentInfoCell.h"
#import "MFSystemInvitedEmptyCell.h"
#import "ProductHomeHeaderCell.h"
#import "NewUserGuildController.h"
#import "NetworkUnReachStatusView.h"

#import "XNFinancialManagerModule.h"
#import "XNFinancialManagerModuleObserver.h"
#import "XNFMAgentListMode.h"
#import "XNFMAgentListItemMode.h"
#import "XNCommonModule.h"
#import "XNHomeBannerMode.h"
#import "XNCommonModuleObserver.h"

#define HEADER_HEIGHT ((125 * SCREEN_FRAME.size.width) / 375.0)
#define CELL_HEIGHT 165.0f

@interface AgentViewController ()<UITableViewDelegate, UITableViewDataSource, XNFinancialManagerModuleObserver,UIScrollViewDelegate, XNCommonModuleObserver, UniversalInteractWebViewControllerDelegate, ProductHomeHeaderCellDelegate>

@property (nonatomic, strong) UIButton *topButton;

@property (nonatomic, strong) NSMutableArray *datasArray;
@property (nonatomic, assign) NSInteger nPageIndex; //当前页码
@property (nonatomic, assign) NSInteger nPageSize; //每页显示数
@property (nonatomic, assign) NSInteger nPageCount; //总页数

@property (nonatomic, strong) XNFMAgentListMode *agentListMode;
@property (nonatomic, strong) NetworkUnReachStatusView * networkErrorView;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation AgentViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
}

////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.title = @"机构";
    
    _nPageIndex = 1;
    _nPageSize = 10;
    [[XNCommonModule defaultModule] addObserver:self];
    [[XNFinancialManagerModule defaultModule] addObserver:self];

    _tableView.scrollsToTop = YES;
    
    _topButton = [[UIButton alloc] init];
    [_topButton setImage:[UIImage imageNamed:@"XN_FinancialManager_Institutions_top_icon"] forState:UIControlStateNormal];
    [_topButton setImage:[UIImage imageNamed:@"XN_FinancialManager_Institutions_top_icon"] forState:UIControlStateHighlighted];
    [_topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topButton setHidden:YES];
    
    [self.view addSubview:_topButton];
    
    weakSelf(weakSelf)
    
    [_topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view.mas_right).offset(-12);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-12);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadBanners];
        weakSelf.nPageIndex --;
        [weakSelf loadDatas];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.nPageIndex ++;
        [weakSelf loadDatas];
    }];
    
    [_tableView.mj_footer setHidden:YES];
    [_tableView setShowsVerticalScrollIndicator:NO];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductHomeHeaderCell" bundle:nil] forCellReuseIdentifier:@"ProductHomeHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MFSystemInvitedEmptyCell" bundle:nil] forCellReuseIdentifier:@"MFSystemInvitedEmptyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AgentInfoCell" bundle:nil] forCellReuseIdentifier:@"AgentInfoCell"];
    
    [self loadBanners];
    [self loadDatas];
    
    if ([self.view respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

//返回顶部
- (void)topButtonClick:(id)sender
{
    [_tableView setContentOffset:CGPointZero];
}

#pragma mark - 加载banner页
- (void)loadBanners
{
    [[XNCommonModule defaultModule] requestBannerWithAdvPlacement:@"platform_banner"];
}

#pragma mark - 加载数据
- (void)loadDatas
{
    [self.networkErrorView removeFromSuperview];
    if ([_ASSIST getNetworkStatus] == Network_NotReachable) {
        
        [self.view addSubview:self.networkErrorView];
        
        weakSelf(weakSelf)
        [self.networkErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakSelf.view);
        }];
        
        return;
    }
    
    if (_nPageIndex < 1)
    {
        _nPageIndex = 1;
    }
    
    //获取机构列表
    [[XNFinancialManagerModule defaultModule] fmAgentListAtPageIndex:[NSString stringWithFormat:@"%ld", (long)_nPageIndex] pageSize:[NSString stringWithFormat:@"%ld", (long)_nPageSize]];
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
     return self.datasArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        return HEADER_HEIGHT;
    }
    
    if (self.datasArray.count <= 0)
    {
        return SCREEN_FRAME.size.height - HEADER_HEIGHT - 64;
    }
    
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        ProductHomeHeaderCell *cell = (ProductHomeHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"ProductHomeHeaderCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate = self;
        
        [cell refreshAdScrollViewWithAdObjectArray:[[XNCommonModule defaultModule] platformBannerLinkUrlListArray] urlArray:[[XNCommonModule defaultModule] platformBannerImgUrlListArray]];
        
        return cell;
    }
    
    if (self.datasArray.count <= 0)
    {
        MFSystemInvitedEmptyCell *emptyCell = (MFSystemInvitedEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"MFSystemInvitedEmptyCell"];
        if (emptyCell == nil)
        {
            emptyCell = [[MFSystemInvitedEmptyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MFSystemInvitedEmptyCell"];
        }
        [emptyCell refreshTitle:@"暂无数据"];
        
        [emptyCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return emptyCell;
    }
    
    static NSString *cellIdentifierString = @"AgentInfoCell";
    AgentInfoCell *cell = (AgentInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
    if (cell == nil)
    {
        cell = [[AgentInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifierString];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell showDatas:[self.datasArray objectAtIndex:indexPath.row - 1]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        return;
    }
    
    if (self.datasArray.count > 0) {
        [XNUMengHelper umengEvent:@"T_1_3"];
        XNFMAgentListItemMode *mode = [self.datasArray objectAtIndex:indexPath.row - 1];
        AgentDetailViewController *viewController = [[AgentDetailViewController alloc] initWithNibName:@"AgentDetailViewController" bundle:nil platNo:mode.orgNumber];
        [_UI pushViewControllerFromRoot:viewController animated:YES];
    }
}

#pragma mark - scrollViewDeleate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_topButton setHidden:YES];
    if (scrollView.contentOffset.y > 187)
    {
        [_topButton setHidden:NO];
    }
}

#pragma mark - ProductHomeHeaderCellDelegate

#pragma mark - banner点击事件
- (void)XNProductHeaderCellDidClickWithUrl:(NSString *)url
{
    NSInteger nSelectBannerIndex = [[[XNCommonModule defaultModule] platformBannerLinkUrlListArray] indexOfObject:url];
    
    UniversalInteractWebViewController *webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:url requestMethod:@"GET"];
    
    XNHomeBannerMode *bannerMode = [[[XNCommonModule defaultModule] platformBannerListArray] objectAtIndex:nSelectBannerIndex];
    
    //umeng统计点击次数_具体banner标题
    NSDictionary *dic = @{@"type":[NSString stringWithFormat:@"banner标题_%@", bannerMode.title]};
    [XNUMengHelper umengEvent:@"T_1_2" attributes:dic];
    
    [webCtrl setSharedOpertionWithParams:[NSDictionary dictionaryWithObjectsAndKeys:bannerMode.title,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_TITLE,
                                          bannerMode.desc,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_DESC,bannerMode.link,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_URL,
                                          [_LOGIC getImagePathUrlWithBaseUrl:bannerMode.icon],XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_IMGURL, nil]];
    
    [_UI pushViewControllerFromRoot:webCtrl animated:YES];
}

#pragma mark - XNFinancialManagerModuleObserver
#pragma mark - 机构列表
- (void)XNFinancialManagerModuleAgentListDidReceive:(XNFinancialManagerModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (_nPageIndex == 1)
    {
        [self.datasArray removeAllObjects];
    }
    
    _agentListMode = module.agentListMode;
    _nPageIndex = [_agentListMode.pageIndex integerValue];
    _nPageCount = [_agentListMode.pageCount integerValue];
    
    if (_agentListMode.datas.count > 0)
    {
        [self.datasArray addObjectsFromArray:_agentListMode.datas];
    }
    
    if (_nPageIndex >= _nPageCount)
    {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
        [_tableView.mj_footer setHidden:YES];
    }
    else
    {
        [_tableView.mj_footer resetNoMoreData];
        [_tableView.mj_footer setHidden:NO];
    }
    
    [self.tableView reloadData];
}

- (void)XNFinancialManagerModuleAgentListDidFailed:(XNFinancialManagerModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [_tableView.mj_footer setHidden:NO];
    
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



///////////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

#pragma mark - NSMutableArray
- (NSMutableArray *)datasArray
{
    if (!_datasArray)
    {
        _datasArray = [[NSMutableArray alloc] init];
    }
    return _datasArray;
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
