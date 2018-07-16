//
//  SignRecordViewController.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/17.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SignRecordViewController.h"
#import "SignRecordHeaderView.h"
#import "SignRecordCell.h"
#import "RollOutSucceedViewController.h"

#import "SignCalendarModule.h"
#import "SignStatisticsModel.h"
#import "SignRecordListModel.h"
#import "SignBounsTransferModel.h"

#define Sign_Record_Header_Height (((374.f * SCREEN_FRAME.size.width) / 375) + 45.f)

#define Sign_Record_Cell_Height 58.f;

@interface SignRecordViewController () <UITableViewDataSource, UITableViewDelegate, SignRecordHeaderViewDelegate>

@property (nonatomic, strong) SignRecordHeaderView *headerView;

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *recordArr;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SignRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

- (void)dealloc
{
    [[SignCalendarModule defaultModule] removeObserver:self];
}

////////////////////////
#pragma mark - custom method
/////////////////////////

- (void)initView
{
    self.navigationItem.title = @"收益记录";
    
    // 转出说明
    [self.navigationItem addRightBarItemWithTitle:@"转出说明" titleColor:[UIColor whiteColor] target:self action:@selector(rollOutExplain)];
    
    self.tableView.rowHeight = Sign_Record_Cell_Height;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SignRecordCell class]) bundle:nil] forCellReuseIdentifier:@"SignRecordCell"];
    
    [[SignCalendarModule defaultModule] addObserver:self];
    
    // 初始化刷新控件
    [self setRefreshUI];
    
    // 签到统计
    self.pageIndex = 1;
    [self loadRecordDatas];
    
    [[SignCalendarModule defaultModule] signStatistics];
}

// 转出说明
- (void)rollOutExplain
{
    // https://preliecai.toobei.com/pages/message/signTransfer.html
     NSString * url = [_LOGIC getWebUrlWithBaseUrl:@"/pages/message/signTransfer.html"];
     UniversalInteractWebViewController *webViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"GET"];
     [_UI pushViewControllerFromRoot:webViewController animated:YES];
}

- (void)setRefreshUI
{
    weakSelf(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [[SignCalendarModule defaultModule] signStatistics];
        weakSelf.pageIndex = 1;
        [[SignCalendarModule defaultModule] signRecordsPageIndex:[NSString stringWithFormat:@"%ld", weakSelf.pageIndex] pageSize:@"10"];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        NSString *pageIndex = [NSString stringWithFormat:@"%ld", [[SignCalendarModule defaultModule].signRecordListModel.pageIndex integerValue] + 1];
        [[SignCalendarModule defaultModule] signRecordsPageIndex:pageIndex pageSize:@"10"];
    }];
}

//请求数据
- (void)loadRecordDatas
{
    [self.view showGifLoading];
    
    [[SignCalendarModule defaultModule] signRecordsPageIndex:[NSString stringWithFormat:@"%ld", self.pageIndex] pageSize:@"10"];
}


////////////////////////
#pragma mark - protocol method
/////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recordArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SignRecordCell *recordCell = [tableView dequeueReusableCellWithIdentifier:@"SignRecordCell"];
    recordCell.itemModel = self.recordArr[indexPath.row];
    return recordCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Sign_Record_Header_Height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

// 奖励金转出
- (void)signRecordHeaderViewDid:(SignRecordHeaderView *)recordHeaderView
{
    if ([self.headerView.signStatisticsModel.transferBouns floatValue] < 10.f) {
        [self showCustomWarnViewWithContent:@"最低转出金额10元"];
        return;
    }
    
    // 请求转出接口
    [[SignCalendarModule defaultModule] signBounsTransfer];
}

// 奖励金转账户
- (void)userSignBounsTransferReceive:(SignCalendarModule *)module
{
    [self.view hideLoading];
    
    RollOutSucceedViewController *rollOutSucceedVC = [[RollOutSucceedViewController alloc] init];
    rollOutSucceedVC.transferBouns = module.signBounsTransferModel.transferBouns;
    
    [_UI pushViewControllerFromRoot:rollOutSucceedVC animated:YES];
    
    // 转出成功之后再调用一次 （统计数据）
    [[SignCalendarModule defaultModule] signStatistics];
    
}

- (void)userSignBounsTransferDidFailed:(SignCalendarModule *)module
{
    [self.view hideLoading];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];

}

///////////////////////////////
#pragma mark - 网络请求回调
/////////////////////////////////

// 签到统计
- (void)userSignStatisticsReceive:(SignCalendarModule *)module
{
    [self.view hideLoading];
    
    // 赋值
    self.headerView.signStatisticsModel = module.signStatisticsModel;
    
    [self.tableView reloadData];
}

- (void)userSignStatisticsDidFailed:(SignCalendarModule *)module
{
    [self.view hideLoading];
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];

}

// 用户签到记录
- (void)userSignRecordsReceive:(SignCalendarModule *)module
{
    [self.view hideLoading];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (module.signRecordListModel.pageIndex.integerValue == 1) {
        
        [self.recordArr removeAllObjects];
    }
    
    // 倒序数组
//    NSArray *carryArr = module.signRecordListModel.recordArr;
//    NSArray *reversedArray = [[carryArr reverseObjectEnumerator] allObjects];
    
    [self.recordArr addObjectsFromArray:module.signRecordListModel.recordArr];
    
    if (module.signRecordListModel.pageIndex >= module.signRecordListModel.pageCount) {
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_footer setHidden:YES];
        
    }else
    {
        [self.tableView.mj_footer resetNoMoreData];
        [self.tableView.mj_footer setHidden:NO];
    }
    
    [self.tableView reloadData];
}

- (void)userSignRecordsDidFailed:(SignCalendarModule *)module
{
    [self.view hideLoading];
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//////////////////////////////////
#pragma mark - setter / getter
/////////////////////////////////////

- (SignRecordHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [SignRecordHeaderView signRecordHeaderView];
        _headerView.delegate = self;
    }
    
    return _headerView;
}

- (NSMutableArray *)recordArr
{
    if (!_recordArr) {
        _recordArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _recordArr;
}


@end
