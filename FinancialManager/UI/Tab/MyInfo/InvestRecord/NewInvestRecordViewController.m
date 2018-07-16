//
//  NewInvestRecordViewController.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/28.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "NewInvestRecordViewController.h"
#import "InvestRecordViewController.h"

#import "BackStatisticalCell.h"
#import "ZJRebackCell.h"
#import "BackClassifyCell.h"
#import "InvestRecordHeaderView.h"
#import "InvestRecordCell.h"
#import "InvestClassifyCell.h"
#import "CalendarFooterView.h"

#import "SignCalendarModule.h"
#import "XNMyProfitModule.h"
#import "MIInvestRecordListMode.h"
#import "MIInvestRecordItemMode.h"
#import "NSDate+Extension.h"

#import "ZJCalendarManager.h"
#import "ZJCalendarModel.h"
#import "InvestStatisticsModel.h"
#import "ZJCalendarItemModel.h"


#define INVEST_VC_CALENDAR_CELL_HEIGHT (47.f + 25.f + (SCREEN_FRAME.size.width / 7.f * 0.85) * 6)

@interface NewInvestRecordViewController () <UITableViewDataSource, UITableViewDelegate, InvestClassifyCellDelegate, BackStatisticalCellDelegate>

/*** 网贷数据源 **/
@property (nonatomic, strong) NSMutableArray *loansArr;

/*** 保险数据源 **/
@property (nonatomic, strong) NSMutableArray *insuranceArr;

/*** 统计数据源 **/
@property (nonatomic, strong) NSMutableArray *investStatisticsArr;

///*** 标记是否显示网贷 **/
//@property (nonatomic, assign) BOOL isLoans;

/*** 加载页 **/
@property (nonatomic, assign) NSInteger loansPageIndex;

@property (nonatomic, assign) NSInteger insurancePageIndex;

/*** 年月日记录字段 **/
@property (nonatomic, copy) NSString *year_month_day;

/*** 年月记录字段 **/
@property (nonatomic, copy) NSString *year_month;

/*** 标记记录 **/
@property (nonatomic, assign) BOOL isShowLoans;

@property (nonatomic, strong) InvestClassifyCell *headerInvestClassifyCell;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) CalendarFooterView *footerView;

@end

@implementation NewInvestRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

- (void)dealloc
{
    [[SignCalendarModule defaultModule] removeObserver:self];
    [[XNMyProfitModule defaultModule] removeObserver:self];
}

/////////////////////////
#pragma mark - custom mothod
/////////////////////////////

- (void)initView
{
    self.navigationItem.title = @"投资记录";
    self.isShowLoans = YES;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //右侧日历按钮
    [self.navigationItem addRightBarItemWithImage:@"no_calender_list_icon@2x" frame:CGRectMake(SCREEN_FRAME.size.width - 20 - 5, 0, 20, 20) target:self action:@selector(rightCalendarClick)];
    
    [self.view addSubview:self.tableView];
    
    
    [[SignCalendarModule defaultModule] addObserver:self];
    [[XNMyProfitModule defaultModule] addObserver:self];
    
    // 获取当前月份投资统计数据
    NSString *investMonth = [NSString stringWithFormat:@"%ld-%02ld", [NSDate year:[NSDate new]], [NSDate month:[NSDate new]]];
    [[SignCalendarModule defaultModule] investCalendarStatisticsInvestMonth:investMonth];
    
    
    // 初始化当前年月日
    NSDate *date = [NSDate new];
    self.year_month_day = [NSString stringWithFormat:@"%ld-%02ld-%02ld", [NSDate year:date], [NSDate month:date], [NSDate day:date]];
    self.year_month = [NSString stringWithFormat:@"%ld-%02ld", [NSDate year:date], [NSDate month:date]];
    
    self.loansPageIndex = 1;
    self.insurancePageIndex = 1;
    
    // 获取具体月份的投资统计数据
    [self loadMonthInvestStatistics];
    
    // 具体天的保险记录
    [self loadDayInsuranceRecordList];
    
    // 具体天的投资记录
    [self loadDayInvestRecordList];
    
    // 初始化刷新控件
    [self setUpRefreshUI];
}

// 获取具体月份的投资统计数据
- (void)loadMonthInvestStatistics
{
    [self.view showGifLoading];
    
    [[SignCalendarModule defaultModule] investCalendarStatisticsInvestMonth:self.year_month];
}

// 具体天的投资记录
- (void)loadDayInvestRecordList
{
    [[XNMyProfitModule defaultModule] requestDayInvestRecordListPageIndex:[NSString stringWithFormat:@"%ld", self.loansPageIndex] pageSize:@"10" investTime:self.year_month_day];
}

// 具体天的保险记录
- (void)loadDayInsuranceRecordList
{
    [[XNMyProfitModule defaultModule] requestDayInsuranceRecordListPageIndex:[NSString stringWithFormat:@"%ld", self.insurancePageIndex] pageSize:@"10" investTime:self.year_month_day];
}

// 初始化刷新控件
- (void)setUpRefreshUI
{
    //刷新加载
    weakSelf(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (weakSelf.isShowLoans) {
            
            weakSelf.loansPageIndex = 1;
            [weakSelf loadDayInvestRecordList];
        } else {
            
            weakSelf.insurancePageIndex = 1;
            [weakSelf loadDayInsuranceRecordList];
        }
        
        
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (weakSelf.isShowLoans) {
            
            weakSelf.loansPageIndex = [[[[XNMyProfitModule defaultModule] dayInvestRecordListMode] pageIndex] integerValue] + 1;
            [weakSelf loadDayInvestRecordList];
        
        } else {
            
            weakSelf.loansPageIndex = [[[[XNMyProfitModule defaultModule] dayInsuranceRecordListMode] pageIndex] integerValue] + 1;
            [weakSelf loadDayInsuranceRecordList];
        }
    }];
}

// 日历按钮点击
- (void)rightCalendarClick
{
    [XNUMengHelper umengEvent:@"W_3_2_1"];
    
    InvestRecordViewController *investVC = [[InvestRecordViewController alloc] init];
    [_UI pushViewControllerFromRoot:investVC animated:YES];
}

- (void)clickBack:(UIButton *)sender
{
    [_UI popToRootViewController:YES];
}

/////////////////////////
#pragma mark - protocol mothod
/////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 1;
    }
    
    return self.isShowLoans ? self.loansArr.count : self.insuranceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.section == 0) { // 投资统计
            
            BackStatisticalCell *statisticalCell = [tableView dequeueReusableCellWithIdentifier:@"BackStatisticalCell"];
            statisticalCell.investStatisticsModel = [SignCalendarModule defaultModule].investStatisticsModel;
            statisticalCell.delegate = self;
            return statisticalCell;
        }
        
        else if (indexPath.section == 1) { // 投资日历
            
            ZJRebackCell *rebackCell = [tableView dequeueReusableCellWithIdentifier:@"ZJRebackCell"];
            
            weakSelf(weakSelf);
            rebackCell.block = ^(NSInteger index) {
                
                ZJCalendarModel *model = [[ZJCalendarManager shareInstance] getSelectedMonthModel];
                
                weakSelf.year_month = [NSString stringWithFormat:@"%ld-%02ld", model.year, model.month];
                [weakSelf loadMonthInvestStatistics];
            };
            
            rebackCell.dayBlock = ^ (ZJCalendarItemModel *itemModel) {
                weakSelf.year_month_day = [NSString stringWithFormat:@"%ld-%02ld-%02ld", [itemModel.date year], [itemModel.date month], [itemModel.date day]];
                
                weakSelf.loansPageIndex = 1;
                weakSelf.insurancePageIndex = 1;
                [weakSelf loadDayInvestRecordList];
                [weakSelf loadDayInsuranceRecordList];
            };
            
            rebackCell.statisticsArr = self.investStatisticsArr;
            
            return rebackCell;
        }
    
    InvestRecordCell *investCell = [tableView dequeueReusableCellWithIdentifier:@"InvestRecordCell"];
    
    if (indexPath.row == 0) {
        investCell.startTimeStr = nil;
    } else {
        MIInvestRecordItemMode *upModel = self.isShowLoans ? self.loansArr[indexPath.row - 1] : self.insuranceArr[indexPath.row - 1];
        investCell.startTimeStr = upModel.startTimeStr;
    }
    
    if (self.isShowLoans) {
        investCell.settle_accounts_ImgView.hidden = YES;
    }
    
    investCell.itemModel = self.isShowLoans ? self.loansArr[indexPath.row] : self.insuranceArr[indexPath.row];
    
    return investCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isShowLoans) {
        
        if (indexPath.section == 2) {
            
            [XNUMengHelper umengEvent:@"W_3_1_1"];
            
            MIInvestRecordItemMode * item = [self.loansArr objectAtIndex:indexPath.row] ;
            NSString * url = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"%@?investId=%@&canJumpNative=%@",@"/pages/message/buyDetail.html",item.investId,@"1"]];
            UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"Get"];
            [_UI pushViewControllerFromRoot:webCtrl animated:YES];
        }
        
    } else {
        
        if (indexPath.section == 2) {
            
            [XNUMengHelper umengEvent:@"W_3_1_1"];
            
            MIInvestRecordItemMode * item = [self.insuranceArr objectAtIndex:indexPath.row] ;
            NSString * url = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"%@?investId=%@&canJumpNative=%@&message=insurance",@"/pages/message/buyDetail.html",item.investId,@"1"]];
            UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"Get"];
            [_UI pushViewControllerFromRoot:webCtrl animated:YES];
        }
    }
    
}

// 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 90.f;
    }
    
    else if (indexPath.section == 1) {
        return  INVEST_VC_CALENDAR_CELL_HEIGHT;
    
    }
    
    else if (indexPath.section == 2) {
    
        if (indexPath.row == 0) {
            return 147.f;
        } else {
            
            
            if (self.isShowLoans) {
                if (self.loansArr.count == 1) {
                    return 147.f;
                } else {
                    MIInvestRecordItemMode *upModel = self.loansArr[indexPath.row - 1];
                    MIInvestRecordItemMode *belowModel = self.loansArr[indexPath.row];
                    
                    if ([belowModel.startTimeStr isEqualToString:upModel.startTimeStr]) {
                        return 117.f;
                    } else {
                        return 147.f;
                    }
                }
            } else {
                
                if (self.insuranceArr.count == 1) {
                    return 147.f;
                } else {
                    MIInvestRecordItemMode *upModel = self.insuranceArr[indexPath.row - 1];
                    MIInvestRecordItemMode *belowModel = self.insuranceArr[indexPath.row];
                    
                    if ([belowModel.startTimeStr isEqualToString:upModel.startTimeStr]) {
                        return 117.f;
                    } else {
                        return 147.f;
                    }
                }
                
            }
        }
    }

    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {

        return self.headerInvestClassifyCell;
    }
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 75.f;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        if (self.isShowLoans) {
            return self.loansArr.count == 0 ? 80: 0;
        } else {
            return self.insuranceArr.count == 0 ? 80 : 0;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        
        if (self.isShowLoans) {
            self.footerView.showLabel.hidden = (self.loansArr.count == 0 ? NO : YES);
            self.footerView.showLabel.text = @"当前没有网贷投资记录";
            return self.footerView;
        } else {
            self.footerView.showLabel.hidden = (self.insuranceArr.count == 0 ? NO : YES);
            self.footerView.showLabel.text = @"当前没有保险购买记录";
            return self.footerView;
        }
    }
    
    return nil;
}

//////////////////////////////////
#pragma mark - 视图协议方法回调
//////////////////////////////////

#pragma mark - InvestClassifyCellDelegate
- (void)investClassifyCellDid:(InvestClassifyCell *)investClassifyCell clickType:(InvestClassifyCellClickType)clickType
{
    if (clickType == Invest_Classify_Cell_Loans) {
        
        if (self.isShowLoans == NO) {
            
            self.isShowLoans = YES;
            
            self.loansPageIndex = 1;
            [self loadDayInvestRecordList];
            
        }
        
    } else if (clickType == Invest_Classify_Cell_Insurance) {
    
        if (self.isShowLoans == YES) {
            
            self.isShowLoans = NO;
            
            self.insurancePageIndex = 1;
            [self loadDayInsuranceRecordList];
        }
    }
}

// BackStatisticalCellDelegate
- (void)backStatisticalCellDid:(BackStatisticalCell *)backStatisticalCell
{
    [self showFMRecommandViewWithTitle:@"团队累积业绩" subTitle:@"指你的所有理财师团队成员（包括：直推、二级、三级）的出单金额 + 所有客户投资金额。" otherSubTitle:nil okTitle:@"我知道了" okCompleteBlock:^{
    } cancelTitle:nil cancelCompleteBlock:^{
    }];
}

////////////////////////////////
#pragma mark - 网络请求回调
//////////////////////////////////

// 4.5.0 获取特定日期投资记录
- (void)requestDayInvestRecordListDidReceive:(XNMyProfitModule *)module
{
    [self.tableView.mj_footer setHidden:NO];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.view hideLoading];
    
    if (module.dayInvestRecordListMode.pageIndex.integerValue == 1) {
        [self.loansArr removeAllObjects];
    }

    [self.loansArr addObjectsFromArray:module.dayInvestRecordListMode.datas];
    
    if (module.dayInvestRecordListMode.pageIndex.integerValue >= module.dayInvestRecordListMode.pageCount.integerValue) {
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_footer setHidden:YES];
    }
    else
    {
        [self.tableView.mj_footer resetNoMoreData];
        [self.tableView.mj_footer setHidden:NO];
    }
    
    [self.headerInvestClassifyCell.loansBtn setTitle:[NSString stringWithFormat:@"网贷(%@)", module.dayInvestRecordListMode.totalCount] forState:UIControlStateNormal];
    
    [self.tableView reloadData];
}

- (void)requestDayInvestRecordListDidFailed:(XNMyProfitModule *)module
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

- (void)requestDayInsuranceRecordListDidReceive:(XNMyProfitModule *)module
{
    [self.tableView.mj_footer setHidden:NO];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.view hideLoading];
    
    if (module.dayInsuranceRecordListMode.pageIndex.integerValue == 1) {
        [self.insuranceArr removeAllObjects];
    }
    
    [self.insuranceArr addObjectsFromArray:module.dayInsuranceRecordListMode.datas];
    
    if (module.dayInsuranceRecordListMode.pageIndex.integerValue >= module.dayInsuranceRecordListMode.pageCount.integerValue) {
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_footer setHidden:YES];
    }
    else
    {
        [self.tableView.mj_footer resetNoMoreData];
        [self.tableView.mj_footer setHidden:NO];
    }
    
    [self.headerInvestClassifyCell.insuranceBtn setTitle:[NSString stringWithFormat:@"保险(%@)", module.dayInsuranceRecordListMode.totalCount] forState:UIControlStateNormal];
    
    [self.tableView reloadData];
}

- (void)requestDayInsuranceRecordListDidFailed:(XNMyProfitModule *)module
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

// 4.5.1 交易日历统计
- (void)investCalendarStatisticsReceive:(SignCalendarModule *)module
{
    [self.view hideLoading];
    
    // 数据处理
    InvestStatisticsModel *investStatisticsModel  = module.investStatisticsModel;
    
    [self.investStatisticsArr removeAllObjects];
    
    [self.investStatisticsArr addObjectsFromArray:investStatisticsModel.calendarStatisticsResponseList];
    
    [self.tableView reloadData];
}

- (void)investCalendarStatisticsDidFailed:(SignCalendarModule *)module
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

/////////////////////////
#pragma mark - getter / setter
/////////////////////////////

- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height - 64.f) style:UITableViewStylePlain];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorFromHex(0XEFF0F1);
        
        //注册单元格
       
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BackStatisticalCell class]) bundle:nil] forCellReuseIdentifier:@"BackStatisticalCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZJRebackCell class]) bundle:nil] forCellReuseIdentifier:@"ZJRebackCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InvestRecordCell class]) bundle:nil] forCellReuseIdentifier:@"InvestRecordCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InvestClassifyCell class]) bundle:nil] forCellReuseIdentifier:@"InvestClassifyCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InvestRecordHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"InvestRecordHeaderView"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BackClassifyCell class]) bundle:nil] forCellReuseIdentifier:@"BackClassifyCell"];
    }
    
    return _tableView;
}

- (NSMutableArray *)loansArr
{
    if (!_loansArr) {
        _loansArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _loansArr;
}

- (NSMutableArray *)insuranceArr
{
    if (!_insuranceArr) {
        _insuranceArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _insuranceArr;
}

- (NSMutableArray *)investStatisticsArr
{
    if (!_investStatisticsArr) {
        _investStatisticsArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _investStatisticsArr;
}

- (InvestClassifyCell *)headerInvestClassifyCell
{
    if (!_headerInvestClassifyCell) {
        _headerInvestClassifyCell = [self.tableView dequeueReusableCellWithIdentifier:@"InvestClassifyCell"];
        _headerInvestClassifyCell.delegate = self;
    }
    return _headerInvestClassifyCell;
}

- (CalendarFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [CalendarFooterView calendarFooterView];
    }
    return _footerView;
}


@end
