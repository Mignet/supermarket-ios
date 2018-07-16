//
//  MyCategoryCustomerViewController.m
//  FinancialManager
//
//  Created by xnkj on 17/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyCategoryCustomerViewController.h"
#import "MyCustomerCategoryCell.h"
#import "XNCustomerServerModule.h"
#import "XNCSNewCustomerModel.h"
#import "NetworkUnReachStatusView.h"
#import "XNRedPacketEmptyCell.h"

#import "XNCSNewCustomerItemModel.h"

#import "MyCustomerDetailViewController.h"

@interface MyCategoryCustomerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger nPageIndex;
@property (nonatomic, copy) NSString *attenInvestType;//1未投资客户 2我关注的客户 3未出单的直推理财师 4我关注的直推理财师

@property (nonatomic, strong) NetworkUnReachStatusView * networkErrorView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *customerArr;

@end

@implementation MyCategoryCustomerViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)title attenInvestType:(NSString *)attenInvestType
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = title;
        self.attenInvestType = attenInvestType;
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
   
    [[XNCustomerServerModule defaultModule] addObserver:self];
    [self loadCustomerDatas];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    [[XNCustomerServerModule defaultModule] removeObserver:self];
}

///////////
#pragma mark - 自定义方法
/////////////

//初始化方法
- (void)initView
{
    self.nPageIndex = 1;
    
    //注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCustomerCategoryCell" bundle:nil] forCellReuseIdentifier:@"MyCustomerCategoryCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XNRedPacketEmptyCell" bundle:nil] forCellReuseIdentifier:@"XNRedPacketEmptyCell"];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    weakSelf(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.nPageIndex = 1;
        [weakSelf loadCustomerDatas];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       
        weakSelf.nPageIndex = [[[[XNCustomerServerModule defaultModule] myNewCustomerModel] pageIndex] integerValue] + 1;
        [weakSelf loadCustomerDatas];
    }];
    
    if ([self.view respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

//请求数据
- (void)loadCustomerDatas
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
    
    [[XNCustomerServerModule defaultModule] getNewCustomerListForCustomerType:@"2" pageIndex:[NSString stringWithFormat:@"%ld", self.nPageIndex] pageSize:@"30" attenInvestType:self.attenInvestType nameOrMobile:@""];
    
    
    [self.view showGifLoading];
    
}

//////////////////
#pragma mark - 协议回掉
///////////////////////////////

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.customerArr.count <= 0) {
        
        return 1;
    }
    
    return self.customerArr.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.customerArr.count <= 0) {
        
        return SCREEN_FRAME.size.height;
    }
    return 65.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.customerArr.count <= 0) {
        
        XNRedPacketEmptyCell *customerCell = [tableView dequeueReusableCellWithIdentifier:@"XNRedPacketEmptyCell"];
        [customerCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [customerCell showTitle:[self.attenInvestType isEqualToString:@"1"]?@"当前没有未投资的客户":@"当前没有我关注的客户" subTitle:@""];
        
        return customerCell;
    }
    
    MyCustomerCategoryCell *customerCell = [tableView dequeueReusableCellWithIdentifier:@"MyCustomerCategoryCell"];
    [customerCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    customerCell.type = self.attenInvestType;
    customerCell.itemModel = self.customerArr[indexPath.row];
    
    return customerCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.customerArr.count <= 0) {
        return;
    }
    
    XNCSNewCustomerItemModel * item = [self.customerArr objectAtIndex:indexPath.row];
    MyCustomerDetailViewController * ctrl = [[MyCustomerDetailViewController alloc]initWithNibName:@"MyCustomerDetailViewController" bundle:nil userId:item.userId];
    [_UI pushViewControllerFromRoot:ctrl animated:YES];
}

//////////////////
#pragma mark - 网络请求回调用
///////////////////////////////

- (void)XNCustomerServerModuleNewCustomerListDidReceive:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_footer setHidden:NO];
    
    if (module.myNewCustomerModel.pageIndex.integerValue == 1) {
        [self.customerArr removeAllObjects];
    }
    
    [self.customerArr addObjectsFromArray:module.myNewCustomerModel.dataArray];
    
    if (module.myNewCustomerModel.pageIndex.integerValue >= module.myNewCustomerModel.pageCount.integerValue) {
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_footer setHidden:YES];
    }
    else
    {
        [self.tableView.mj_footer resetNoMoreData];
        [self.tableView.mj_footer setHidden:NO];
    }
    
    [self.tableView reloadData];
}

- (void)XNCustomerServerModuleNewCustomerListDidFailed:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_footer setHidden:NO];
    
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

- (NSMutableArray *)customerArr
{
    if (!_customerArr) {
        _customerArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _customerArr;
}

//无网络视图
- (NetworkUnReachStatusView *)networkErrorView
{
    if (!_networkErrorView) {
        
        _networkErrorView = [[NetworkUnReachStatusView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
        weakSelf(weakSelf)
        [_networkErrorView setNetworkRetryOperation:^{
            
            [weakSelf loadCustomerDatas];
        }];
    }
    return _networkErrorView;
}

@end
