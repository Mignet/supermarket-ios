//
//  SPLongTermProductListViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/4/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "SPLongTermProductListViewController.h"
#import "MJRefresh.h"
#import "ManagerFinancialProgressCell.h"
#import "MFSystemInvitedEmptyCell.h"
#import "GrowthManualCategoryBannerCell.h"
#import "AgentDetailViewController.h"

#import "XNFinancialProductModule.h"
#import "XNFinancialProductModuleObserver.h"
#import "XNFMProductCategoryListMode.h"
#import "XNFMProductListItemMode.h"
#import "XNCommonModule.h"
#import "XNCommonModuleObserver.h"

#define DEFAULTPROGRESSCELLHEIGHT 144.0f
#define BANNER_HEIGHT 90.0f

@interface SPLongTermProductListViewController ()<XNFinancialProductModuleObserver, XNCommonModuleObserver,UniversalInteractWebViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) XNFMProductListItemMode *selectedMode;
@property (nonatomic, strong) NSMutableArray *datasArray;
@property (nonatomic, assign) NSInteger nPageIndex; //当前页码
@property (nonatomic, strong) NSString *bannerString;

@end

@implementation SPLongTermProductListViewController

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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [[XNCommonModule defaultModule] removeObserver:self];
    [[XNFinancialProductModule defaultModule] removeObserver:self];
    
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
}

/////////////////
#pragma mark - 自定义
/////////////////////////////////

//初始化
- (void)initView
{
    self.nPageIndex = 1;
    [[XNCommonModule defaultModule] addObserver:self];
    [[XNFinancialProductModule defaultModule] addObserver:self];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GrowthManualCategoryBannerCell" bundle:nil] forCellReuseIdentifier:@"GrowthManualCategoryBannerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ManagerFinancialProgressCell" bundle:nil] forCellReuseIdentifier:@"ManagerFinancialProgressCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MFSystemInvitedEmptyCell" bundle:nil] forCellReuseIdentifier:@"MFSystemInvitedEmptyCell"];
    
    weakSelf(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.nPageIndex = 1;
        [weakSelf loadDatas];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.nPageIndex ++;
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
    if (_nPageIndex <= 1)
    {
        _nPageIndex = 1;
        [[XNCommonModule defaultModule] requestBannerWithAdvPlacement:@"product_year"];
    }
    
    [[XNFinancialProductModule defaultModule] fmRequestSelectProductListWithCateId:@"2" pageIndex:[NSString stringWithFormat:@"%ld", _nPageIndex] pageSize:@"10"];
}

////////////////////
#pragma mark - UITableView Delegate
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
    NSInteger nRow = [indexPath row];
    if (nRow == 0)
    {
        static NSString *cellIdentifierString = @"GrowthManualCategoryBannerCell";
        GrowthManualCategoryBannerCell *cell = (GrowthManualCategoryBannerCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell showBanner:self.bannerString];
        
        return cell;
    }
    
    if (self.datasArray.count <= 0)
    {
        MFSystemInvitedEmptyCell *emptyCell = (MFSystemInvitedEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"MFSystemInvitedEmptyCell"];
        [emptyCell refreshTitle:@"暂无产品"];
        
        [emptyCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return emptyCell;
    }
    
    
    XNFMProductListItemMode *productItemMode = [self.datasArray objectAtIndex:nRow - 1];
    ManagerFinancialProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ManagerFinancialProgressCell"];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell refreshDataWithParams:productItemMode section:indexPath.section index:nRow - 1];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = indexPath.row;
    if (nRow == 0)
    {
        return BANNER_HEIGHT;
    }
    
    if (self.datasArray.count <= 0)
    {
        return SCREEN_FRAME.size.height - BANNER_HEIGHT;
    }
    
    return DEFAULTPROGRESSCELLHEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = [indexPath row];
    if (nRow == 0 || self.datasArray.count <= 0)
    {
        return;
    }
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectedMode = [self.datasArray objectAtIndex:nRow - 1];
    
    NSString * url = [_LOGIC getComposeUrlWithBaseUrl:_selectedMode.openLinkUrl compose:[NSString stringWithFormat:@"productId=%@",_selectedMode.productId]];
    UniversalInteractWebViewController *webViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"GET"];
    webViewController.delegate = self;
    //        [webViewController setSharedProductId:_selectedMode.productId];
    [webViewController setProductDetailRecommend:_selectedMode];
    [webViewController setNewWebView:YES];
    [_UI pushViewControllerFromRoot:webViewController animated:YES];
    
}

#pragma mark - XNCommonModuleObserver
//广告查询
- (void)XNCommonModuleBannerDidReceive:(XNCommonModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    self.bannerString = module.longTermProductImageUrl;
    [self.tableView reloadData];
}

- (void)XNCommonModuleBannerDidFailed:(XNCommonModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
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

#pragma mark - XNFinancialProductModuleObserver
//精选产品分类列表
- (void)XNFinancialProductModuleSelectProductListDidReceive:(XNFinancialProductModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    XNFMProductCategoryListMode *mode = module.longTermSelectProductsListMode;
    if (mode == nil)
    {
        return;
    }
    
    self.nPageIndex = [mode.pageIndex integerValue];
    if (self.nPageIndex == 1)
    {
        [self.datasArray removeAllObjects];
    }
    
    if (mode.dataArray.count > 0)
    {
        [self.datasArray addObjectsFromArray:mode.dataArray];
    }
    
    if (self.nPageIndex >= [mode.pageCount integerValue])
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

- (void)XNFinancialProductModuleSelectProductListDidFailed:(XNFinancialProductModule *)module
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

#pragma mark - 佣金计算
- (void)getAppLhlcsCommissionCalc:(NSDictionary *)params
{
    FMComissionCaculateVController * comissionCaculateCtrl = [[FMComissionCaculateVController alloc]initWithNibName:@"FMComissionCaculateViewController" bundle:nil detailMode:_selectedMode];
    
    [_UI pushViewControllerFromRoot:comissionCaculateCtrl animated:YES];
}

#pragma mark - 进入机构详情
- (void)agentDetailSwitch:(NSString *)agentOrgNumber
{
    NSString *agentNoString = _selectedMode.orgNumber;
    if ([NSObject isValidateInitString:agentOrgNumber]) {
        agentNoString = agentOrgNumber;
        AgentDetailViewController *viewController = [[AgentDetailViewController alloc] initWithNibName:@"AgentDetailViewController" bundle:nil platNo:agentNoString];
        [_UI pushViewControllerFromRoot:viewController animated:YES];
    }
}

///////////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

#pragma mark - NSMutableArray
- (NSMutableArray *)datasArray
{
    if (_datasArray == nil)
    {
        _datasArray = [[NSMutableArray alloc] init];
    }
    return _datasArray;
}

@end
