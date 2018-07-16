//
//  NewBackCalendarViewController.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/27.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "NewBackCalendarViewController.h"
#import "ZJRebackCell.h"
#import "RebackCalendarViewController.h"

#import "BackStatisticalCell.h"

#import "InvestRecordHeaderView.h"
#import "ReturnMoneyCell.h"

#import "BackClassifyCell.h"
#import "CalendarFooterView.h"

#import "NSDate+Extension.h"
#import "SignCalendarModule.h"
#import "XNCustomerServerModule.h"
#import "InvestStatisticsModel.h"

#import "ZJCalendarManager.h"
#import "ZJCalendarModel.h"
#import "ZJCalendarItemModel.h"
#import "ReturnMoneyListModel.h"
#import "ReturnMoneyItemModel.h"

#define VC_CALENDAR_CELL_HEIGHT (47.f + 25.f + (SCREEN_FRAME.size.width / 7.f * 0.85) * 6)

@interface NewBackCalendarViewController () <UITableViewDataSource, UITableViewDelegate, BackClassifyCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

/*** 年月日记录字段 **/
@property (nonatomic, copy) NSString *year_month_day;

/*** 年月记录字段 **/
@property (nonatomic, copy) NSString *year_month;

/*** 已回款页码 **/
@property (nonatomic, assign) NSInteger yetPageIndex;
@property (nonatomic, assign) NSInteger waitPageIndex;

/*** 请求回款数据源 **/
@property (nonatomic, strong) NSMutableArray *rebackStatisticsArr;

@property (nonatomic, strong) NSMutableArray *yetArr;

@property (nonatomic, strong) NSMutableArray *waitArr;

@property (nonatomic, strong) BackClassifyCell *headerClassifyCell;

@property (nonatomic, assign) BOOL isShowYet;

@property (nonatomic, strong) CalendarFooterView *footerView;

@end

@implementation NewBackCalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

- (void)dealloc
{
    [[SignCalendarModule defaultModule] removeObserver:self];
    [[XNCustomerServerModule defaultModule] removeObserver:self];
}

////////////////////////////////
#pragma mark - custom mothod
//////////////////////////////////

- (void)initView
{
    self.navigationItem.title = @"回款日历";
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //右侧日历按钮
    // no_calender_list_icon.png  return_back_list_calender.png
    [self.navigationItem addRightBarItemWithImage:@"no_calender_list_icon.png" frame:CGRectMake(SCREEN_FRAME.size.width - 20 - 5, 0, 20, 20) target:self action:@selector(rightCalendarClick)];
    
    [self.view addSubview:self.tableView];
    
    [[SignCalendarModule defaultModule] addObserver:self];
    [[XNCustomerServerModule defaultModule] addObserver:self];
    
    
    // 初始化当前年月日
    NSDate *date = [NSDate new];
    self.year_month_day = [NSString stringWithFormat:@"%ld-%02ld-%02ld", [NSDate year:date], [NSDate month:date], [NSDate day:date]];
    self.year_month = [NSString stringWithFormat:@"%ld-%02ld", [NSDate year:date], [NSDate month:date]];
    
    // 默认显示已回款
    self.isShowYet = YES;
    
    
    //刷新加载
    weakSelf(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    
        weakSelf.yetPageIndex = 1;
        [weakSelf loadDayYetRepamentCalendarList];
        
    }];
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (weakSelf.isShowYet) {

            weakSelf.yetPageIndex = [[[[XNCustomerServerModule defaultModule] dayYetReturnMoneyListModel] pageIndex] integerValue] + 1;
            [weakSelf loadDayYetRepamentCalendarList];
        }
    }];

    
    // 请求当前月份回款统计数据
    [self loadRepamentCalendarStatistics];
    
    // 请求确定日期的已回款列表数据
    self.yetPageIndex = 1;
    [self loadDayYetRepamentCalendarList];
        
        
    
    // 请求确定日期的未回款数据
//    self.waitPageIndex = 1;
//    [self loadDayWaitRepamentCalendarList];
        
    
}

- (void)clickBack:(UIButton *)sender
{
    [_UI popToRootViewController:YES];
}

// 请求回款统计数据
- (void)loadRepamentCalendarStatistics
{
    [self.view showGifLoading];
    [[SignCalendarModule defaultModule] personcenterRepamentCalendarStatistics:self.year_month];
}

- (void)loadDayYetRepamentCalendarList
{
    [[XNCustomerServerModule defaultModule] loadDayYetReturnMoneyListRepamentType:nil pageIndex:[NSString stringWithFormat:@"%ld", self.yetPageIndex] pageSize:@"10" repamentTime:self.year_month_day];
}

//- (void)loadDayWaitRepamentCalendarList
//{
//    [[XNCustomerServerModule defaultModule] loadDayWaitReturnMoneyListRepamentType:@"0" pageIndex:[NSString stringWithFormat:@"%ld", self.waitPageIndex] pageSize:@"10" repamentTime:self.year_month_day];
//}

- (void)rightCalendarClick
{
    [XNUMengHelper umengEvent:@"W_3_3_1"];
    
    RebackCalendarViewController *backCalendarVC = [[RebackCalendarViewController alloc] init];
    [_UI pushViewControllerFromRoot:backCalendarVC animated:YES];
}

////////////////////////////////
#pragma mark - protocol mothod
//////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    else if (section == 1) {
        return 1;
    }
    
    else {
        
        //return self.isShowYet ? self.yetArr.count : self.waitArr.count;
        return self.yetArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.section == 0) { //回款统计
            
            BackStatisticalCell *statisticalCell = [tableView dequeueReusableCellWithIdentifier:@"BackStatisticalCell"];
            statisticalCell.investStatisticsModel = [SignCalendarModule defaultModule].rebackStatisticsModel;
            return statisticalCell;
        }
    
    
        else if (indexPath.section == 1) { // 回款日历
            
            ZJRebackCell *rebackCalendarCell = [tableView dequeueReusableCellWithIdentifier:@"ZJRebackCell"];
            
            weakSelf(weakSelf);
            rebackCalendarCell.block = ^(NSInteger index) {
                ZJCalendarModel *model = [[ZJCalendarManager shareInstance] getSelectedMonthModel];
                
                weakSelf.year_month = [NSString stringWithFormat:@"%ld-%02ld", model.year, model.month];
                [weakSelf loadRepamentCalendarStatistics];
                
            };
            
            rebackCalendarCell.dayBlock = ^ (ZJCalendarItemModel *itemModel) {
                
                weakSelf.year_month_day = [NSString stringWithFormat:@"%ld-%02ld-%02ld", [itemModel.date year], [itemModel.date month], [itemModel.date day]];

                weakSelf.yetPageIndex = 1;
                [weakSelf loadDayYetRepamentCalendarList];
//                weakSelf.waitPageIndex = 1;
//                [weakSelf loadDayWaitRepamentCalendarList];
                
            };

            rebackCalendarCell.statisticsArr = self.rebackStatisticsArr;
            return rebackCalendarCell;
        }

    ReturnMoneyCell *returnCell = [tableView dequeueReusableCellWithIdentifier:@"ReturnMoneyCell"];
        // 数据处理
    
    
    if (indexPath.row == 0) {
        returnCell.endTimeStr = nil;
    } else {
        
//        ReturnMoneyItemModel *upModel = self.isShowYet ? self.yetArr[indexPath.row - 1] : self.waitArr[indexPath.row - 1];
        
        ReturnMoneyItemModel *upModel = self.yetArr[indexPath.row - 1];
        returnCell.endTimeStr = upModel.endTimeStr;
        
    }

    
//    returnCell.itemModel = self.isShowYet ? self.yetArr[indexPath.row] : self.waitArr[indexPath.row];
    
    returnCell.itemModel = self.yetArr[indexPath.row];
    
    return returnCell;
}

#pragma mark - 单元格点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /***
    if (self.isShowYet) {
        if (indexPath.section == 2) {
            ReturnMoneyItemModel * item = [self.yetArr objectAtIndex:indexPath.row];
            NSString * url = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"%@?investId=%@&canJumpNative=%@",@"/pages/message/buyDetail.html",item.investId,@"1"]];
            UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"Get"];
            [_UI pushViewControllerFromRoot:webCtrl animated:YES];
        }
    } else {
        if (indexPath.section == 2) {
            ReturnMoneyItemModel * item = [self.waitArr objectAtIndex:indexPath.row];
            NSString * url = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"%@?investId=%@&canJumpNative=%@",@"/pages/message/buyDetail.html",item.investId,@"1"]];
            UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"Get"];
            [_UI pushViewControllerFromRoot:webCtrl animated:YES];
        }
    }
     ***/
    
    
    if (indexPath.section == 2) {
        
        ReturnMoneyItemModel * item = [self.yetArr objectAtIndex:indexPath.row];
        NSString * url = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"%@?investId=%@&canJumpNative=%@",@"/pages/message/buyDetail.html",item.investId,@"1"]];
        UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"Get"];
        [_UI pushViewControllerFromRoot:webCtrl animated:YES];
    }
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 90.f;
    }
        
    else if (indexPath.section == 1) {
        return VC_CALENDAR_CELL_HEIGHT;
    }
    
    else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            return 147.f;
        } else {
            

            if (self.yetArr.count == 1) {
                return 147.f;
            }
            
            ReturnMoneyItemModel *upModel = self.yetArr[indexPath.row - 1];
            ReturnMoneyItemModel *belowModel = self.yetArr[indexPath.row];
            
            if ([belowModel.endTimeStr isEqualToString:upModel.endTimeStr]) {
                return 117.f;
            } else {
                return 147.f;
            }
        }
    }
        
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        
        self.footerView.showLabel.hidden = self.yetArr.count == 0 ? NO : YES;
        return self.footerView;
    }
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return self.yetArr.count == 0 ? 80.f : 15.f;
    }
    
    return 0.1;
}

#pragma mark - BackClassifyCellDelegate
- (void)backClassifyCellDid:(BackClassifyCell *)BackClassifyCell clickType:(BackClassifyCellClickType)clickType
{
    /****
    if (clickType == Back_Classify_Yet_Click) { // 点击已回款
        
        if (!self.isShowYet) {
            
            self.isShowYet = YES;
            
            self.yetPageIndex = 1;
            [self loadDayYetRepamentCalendarList];
            
        }
        
    } else if (clickType == Back_Classify_Wait_Click) {
        
        if (self.isShowYet) {
            
            self.isShowYet = NO;
            
            self.waitPageIndex = 1;
            /[self loadDayWaitRepamentCalendarList];
        }
    }
    
    [self.tableView reloadData];
    ***/
     
}


////////////////////////////////
#pragma mark - 网络请求回调
//////////////////////////////////

// 4.5.1 回款日历统计
- (void)personcenterRepamentCalendarStatisticsReceive:(SignCalendarModule *)module
{
    [self.view hideLoading];
    
    // 数据处理
    InvestStatisticsModel *rebackStatisticsModel  = module.rebackStatisticsModel;
    
    [self.rebackStatisticsArr removeAllObjects];
    
    [self.rebackStatisticsArr addObjectsFromArray:rebackStatisticsModel.calendarStatisticsResponseList];
    
    [self.tableView reloadData];
}

- (void)ipersoncenterRepamentCalendarStatisticsDidFailed:(SignCalendarModule *)module
{
    [self.view hideLoading];
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

//////////////////////////////
#pragma mark - 网络请求回调
///////////////////////////////////

- (void)loadDayYetReturnMoneyListDidReceive:(XNCustomerServerModule *)module
{
    [self.tableView.mj_footer setHidden:NO];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.view hideLoading];
    
    if (module.dayYetReturnMoneyListModel.pageIndex.integerValue == 1) {
        [self.yetArr removeAllObjects];
    }
    
    /***  数据处理 **/
    [self.yetArr addObjectsFromArray:module.dayYetReturnMoneyListModel.dataArray];

    
        
        if (module.dayYetReturnMoneyListModel.pageIndex.integerValue >= module.dayYetReturnMoneyListModel.pageCount.integerValue) {
        
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView.mj_footer setHidden:YES];
        }
        else
        {
            [self.tableView.mj_footer resetNoMoreData];
            [self.tableView.mj_footer setHidden:NO];
        }
    
    
//    [self.headerClassifyCell.yetBtn setTitle:[NSString stringWithFormat:@"已回款(%@)", module.dayYetReturnMoneyListModel.totalCount] forState:UIControlStateNormal];
    
    [self.tableView reloadData];
}

- (void)loadDayYetReturnMoneyListDidFailed:(XNCustomerServerModule *)module
{
    [self.tableView.mj_footer setHidden:NO];
    [self.view hideLoading];
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

- (void)loadDayWaitReturnMoneyListDidReceive:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    
    [self.tableView.mj_footer setHidden:NO];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (module.dayWaitReturnMoneyListModel.pageIndex.integerValue == 1) {
        [self.waitArr removeAllObjects];
    }
    
    /***  数据处理 **/
    [self.waitArr addObjectsFromArray:module.dayWaitReturnMoneyListModel.dataArray];
    
        if (module.dayWaitReturnMoneyListModel.pageIndex.integerValue >= module.dayWaitReturnMoneyListModel.pageCount.integerValue) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView.mj_footer setHidden:YES];
        }
        else
        {
            [self.tableView.mj_footer resetNoMoreData];
            [self.tableView.mj_footer setHidden:NO];
        }
    
    
    [self.headerClassifyCell.waitBtn setTitle:[NSString stringWithFormat:@"待回款(%@)", module.dayWaitReturnMoneyListModel.totalCount] forState:UIControlStateNormal];
    
    [self.tableView reloadData];
}

- (void)loadDayWaitReturnMoneyListDidFailed:(XNCustomerServerModule *)module
{
    [self.tableView.mj_footer setHidden:NO];
    [self.view hideLoading];
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

////////////////////////////////
#pragma mark - setter / getter
//////////////////////////////////

- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height - 64.f) style:UITableViewStylePlain];
    
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        //注册单元格
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BackStatisticalCell class]) bundle:nil] forCellReuseIdentifier:@"BackStatisticalCell"];
        _tableView.backgroundColor = UIColorFromHex(0XEFF0F1);
        //[_tableView registerClass:[BackCalendarCell class] forCellReuseIdentifier:@"BackCalendarCell"];
        
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZJRebackCell class]) bundle:nil] forCellReuseIdentifier:@"ZJRebackCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReturnMoneyCell class]) bundle:nil] forCellReuseIdentifier:@"ReturnMoneyCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InvestRecordHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"InvestRecordHeaderView"];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BackClassifyCell class]) bundle:nil] forCellReuseIdentifier:@"BackClassifyCell"];
    }
    return _tableView;
}

- (NSMutableArray *)rebackStatisticsArr
{
    if (!_rebackStatisticsArr) {
        _rebackStatisticsArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _rebackStatisticsArr;
}

- (NSMutableArray *)yetArr
{
    if (!_yetArr) {
        _yetArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _yetArr;
}

- (NSMutableArray *)waitArr
{
    if (!_waitArr) {
        _waitArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _waitArr;
}

- (BackClassifyCell *)headerClassifyCell
{
    if (!_headerClassifyCell) {
        _headerClassifyCell = [self.tableView dequeueReusableCellWithIdentifier:@"BackClassifyCell"];
        _headerClassifyCell.delegate = self;
    }
    return _headerClassifyCell;
}

- (CalendarFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [CalendarFooterView calendarFooterView];
        _footerView.showLabel.text = @"当前没有回款记录";
    }
    return _footerView;
}

@end
