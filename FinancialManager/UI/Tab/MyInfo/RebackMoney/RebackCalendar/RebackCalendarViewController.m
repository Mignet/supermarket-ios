//
//  RebackCalendarViewController.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/15.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "RebackCalendarViewController.h"

#import "BackStatisticalCell.h"
#import "BackClassifyCell.h"
#import "ReturnMoneyCell.h"
#import "InvestRecordHeaderView.h"

#import "XNCustomerServerModule.h"
#import "ReturnMoneyListModel.h"
#import "ReturnMoneyItemModel.h"

#import "SignCalendarModule.h"
#import "NSDate+Extension.h"
#import "XNRedPacketEmptyCell.h"

#define reback_money_header_height 34.f
#define reback_income_cell_height 80.f
#define reback_money_cell_height 108.f

@interface RebackCalendarViewController () <UITableViewDataSource, UITableViewDelegate, BackClassifyCellDelegate>

@property (nonatomic, assign) BOOL isShowYet;

@property (nonatomic, assign) NSInteger yetPageIndex;
@property (nonatomic, assign) NSInteger waitPageIndex;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *yetArr;

@property (nonatomic, strong) NSMutableArray *waitArr;

@property (nonatomic, strong) BackClassifyCell *headerClassifyCell;

@property (nonatomic, assign) BOOL isShowEm;

@end

@implementation RebackCalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

////////////////////////
#pragma mark - custom method
///////////////////////////

- (void)initView
{
    self.isShowYet = YES; // 默认加载已回款数据
    self.isShowEm = NO;
    self.navigationItem.title = @"回款日历";
    
    //右侧日历按钮
    [self.navigationItem addRightBarItemWithImage:@"return_back_list_calender.png" frame:CGRectMake(SCREEN_FRAME.size.width - 20 - 5, 0, 20, 20) target:self action:@selector(rightCalendarClick)];
    
    [[XNCustomerServerModule defaultModule] addObserver:self];
    [[SignCalendarModule defaultModule] addObserver:self];
    
    [self.view addSubview:self.tableView];
    
    [self initRefreshUI];
    
    // 请求当前月份回款统计数据
    NSString *rePaymentMonth = [NSString stringWithFormat:@"%ld-%ld", [NSDate year:[NSDate new]], [NSDate month:[NSDate new]]];
    [[SignCalendarModule defaultModule] personcenterRepamentCalendarStatistics:rePaymentMonth];
    
    // 获取已回款数据
    self.yetPageIndex = 1;
    [self loadYetReturnMoneyDatas];
    
    // 获取待回款数据
    self.waitPageIndex = 1;
    [self loadWaitReturnMoneyDatas];
}

- (void)rightCalendarClick
{
    [_UI popViewControllerFromRoot:YES];
}

- (void)dealloc
{
    [[XNCustomerServerModule defaultModule] removeObserver:self];
    [[SignCalendarModule defaultModule] removeObserver:self];
}

- (void)initRefreshUI
{
    //刷新加载
    weakSelf(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (weakSelf.isShowYet == YES) {
            
            weakSelf.yetPageIndex = 1;
            [weakSelf loadYetReturnMoneyDatas];
        }
        
        else {
            weakSelf.waitPageIndex = 1;
            [weakSelf loadWaitReturnMoneyDatas];
            
        }
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (weakSelf.isShowYet == YES) {
            
            weakSelf.yetPageIndex = [[[[XNCustomerServerModule defaultModule] yetReturnMoneyListModel] pageIndex] integerValue] + 1;
            [weakSelf loadYetReturnMoneyDatas];
        }
        
        else {
            
            weakSelf.waitPageIndex = [[[[XNCustomerServerModule defaultModule] waitReturnMoneyListModel] pageIndex] integerValue] + 1;
            [weakSelf loadWaitReturnMoneyDatas];
        }
    }];
    
    [self.tableView.mj_footer setHidden:YES];
}

// 获取已回款数据
- (void)loadYetReturnMoneyDatas
{
    [self.view showGifLoading];
    
    ////0-待回款 1-已回款 非必需 默认查所有
    NSString *pageIndex = [NSString stringWithFormat:@"%ld", self.yetPageIndex];
    [[XNCustomerServerModule defaultModule] loadYetReturnMoneyListRepamentType:@"1" pageIndex:pageIndex pageSize:@"10" repamentTime:nil];
}

// 获取已回款数据
- (void)loadWaitReturnMoneyDatas
{
    [self.view showGifLoading];
    
    //0-待回款 1-已回款 非必需 默认查所有
    NSString *pageIndex = [NSString stringWithFormat:@"%ld", self.waitPageIndex];
    [[XNCustomerServerModule defaultModule] loadWaitReturnMoneyListRepamentType:@"0" pageIndex:pageIndex pageSize:@"10" repamentTime:nil];
}

//////////////////////////////////
#pragma mark - 自定义视图回调方法
/////////////////////////////////////

- (void)backClassifyCellDid:(BackClassifyCell *)BackClassifyCell clickType:(BackClassifyCellClickType)clickType
{
    if (clickType == Back_Classify_Yet_Click) {
        
        if (!self.isShowYet) {
            self.isShowYet = YES;
        }
        
        [self updateFooterRefresh];
        
        if (self.yetArr.count == 0) {
            self.yetPageIndex = 1;
            [self loadYetReturnMoneyDatas];
        } else {
            [self.tableView reloadData];
        }
        
        
    } else if (clickType == Back_Classify_Wait_Click) {
        
        if (self.isShowYet) {
            self.isShowYet = NO;
        }
        
        [self updateFooterRefresh];
        
        if (self.waitArr.count == 0) {
            self.waitPageIndex = 1;
            [self loadWaitReturnMoneyDatas];
        } else {
            [self.tableView reloadData];
        }
    }
}

- (void)updateFooterRefresh
{
    if (self.isShowYet) { //
        
        ReturnMoneyListModel *yetModel = [XNCustomerServerModule defaultModule].yetReturnMoneyListModel;
        
        if (yetModel.pageIndex.integerValue >= yetModel.pageCount.integerValue) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView.mj_footer setHidden:YES];
        }
        else
        {
            [self.tableView.mj_footer resetNoMoreData];
            [self.tableView.mj_footer setHidden:NO];
        }
        
    } else {
        
        ReturnMoneyListModel *waitModel = [XNCustomerServerModule defaultModule].waitReturnMoneyListModel;
        
        if (waitModel.pageIndex.integerValue >= waitModel.pageCount.integerValue) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView.mj_footer setHidden:YES];
        }
        else
        {
            [self.tableView.mj_footer resetNoMoreData];
            [self.tableView.mj_footer setHidden:NO];
        }
    }
    
    
}

////////////////////////////////
#pragma mark - protocol mothod
//////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    if (self.isShowYet) {
        
        if (self.yetArr.count > 0) {
            
            return self.yetArr.count;
        } else {
            
            if (self.isShowEm) {
                return 1;
            } else {
                return 0;
            }
        }
        
    } else {
        
        if (self.waitArr.count > 0) {
            return self.waitArr.count;
        } else {
            if (self.isShowEm) {
                return 1;
            } else {
                return 0;
            }
        }
        
    }
    
    
    //return self.isShowYet ? [self.yetArr count] : [self.waitArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { //回款统计
        
        BackStatisticalCell *statisticalCell = [tableView dequeueReusableCellWithIdentifier:@"BackStatisticalCell"];
        statisticalCell.investStatisticsModel = [SignCalendarModule defaultModule].rebackStatisticsModel;
        return statisticalCell;
    }
    

    if (self.isShowYet == YES && self.yetArr.count == 0 && self.isShowEm == YES) {
        
        XNRedPacketEmptyCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:@"XNRedPacketEmptyCell"];
        [emptyCell showTitle:@"当前没有已回款" subTitle:nil];
        return emptyCell;
    }
    
    if (self.isShowYet == NO && self.waitArr.count == 0 && self.isShowEm == YES) {
        
        XNRedPacketEmptyCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:@"XNRedPacketEmptyCell"];
        [emptyCell showTitle:@"当前没有待回款" subTitle:nil];
        return emptyCell;
    }
    
    
    ReturnMoneyCell *returnMoneyCell = [tableView dequeueReusableCellWithIdentifier:@"ReturnMoneyCell"];
    // 数据处理
    if (indexPath.row == 0) {
        returnMoneyCell.endTimeStr = nil;
    } else {
        ReturnMoneyItemModel *upModel = self.isShowYet ? self.yetArr[indexPath.row - 1] : self.waitArr[indexPath.row - 1];
        returnMoneyCell.endTimeStr = upModel.endTimeStr;
    }
    returnMoneyCell.itemModel = self.isShowYet ? self.yetArr[indexPath.row] : self.waitArr[indexPath.row];
    return returnMoneyCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 90.f;
    }
    
    if (self.isShowEm == YES) { //请求结束
        
        if (self.isShowYet == YES) { // 显示已回款
            
            if (self.yetArr.count == 0) {
                
                return SCREEN_FRAME.size.height - 90.f - 64.f - 70.f;
                
            } else {
                
                if (indexPath.row == 0) {
                    return 147.f;
                } else {
                    
                    if (self.yetArr.count == 1) {
                        return 147;
                    }
                    
                    ReturnMoneyItemModel *upModel = (self.isShowYet) ? self.yetArr[indexPath.row - 1] : self.waitArr[indexPath.row - 1];
                    ReturnMoneyItemModel *belowModel = (self.isShowYet) ? self.yetArr[indexPath.row] : self.waitArr[indexPath.row];
                    if ([belowModel.endTimeStr isEqualToString:upModel.endTimeStr]) {
                        return 117.f;
                    } else {
                        return 147.f;
                    }
                }
            }
            
        } else { // 显示待回款
            
            if (self.waitArr.count == 0) {
                
                return SCREEN_FRAME.size.height - 90.f - 64.f - 70.f;
                
            } else {
                
                if (indexPath.row == 0) {
                    return 147.f;
                } else {
                    
                    
                    
                    ReturnMoneyItemModel *upModel = (self.isShowYet) ? self.yetArr[indexPath.row - 1] : self.waitArr[indexPath.row - 1];
                    ReturnMoneyItemModel *belowModel = (self.isShowYet) ? self.yetArr[indexPath.row] : self.waitArr[indexPath.row];
                    if ([belowModel.endTimeStr isEqualToString:upModel.endTimeStr]) {
                        return 117.f;
                    } else {
                        return 147.f;
                    }
                }

            }
            
        }
        
    } else {
        
        return 0.f;
    }
    
    return 0.f;
}

#pragma mark - 单元格点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isShowYet) {
        
        if (indexPath.section == 1) {
            
            if (self.yetArr.count == 0) {
                return;
            }
            
            ReturnMoneyItemModel * item = [self.yetArr objectAtIndex:indexPath.row];
            NSString * url = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"%@?investId=%@&canJumpNative=%@",@"/pages/message/buyDetail.html",item.investId,@"1"]];
            UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"Get"];
            [_UI pushViewControllerFromRoot:webCtrl animated:YES];
        }
        
    } else {
        
        if (indexPath.section == 1) {
            
            if (self.waitArr.count == 0) {
                return;
            }
            
            ReturnMoneyItemModel * item = [self.waitArr objectAtIndex:indexPath.row];
            NSString * url = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"%@?investId=%@&canJumpNative=%@",@"/pages/message/buyDetail.html",item.investId,@"1"]];
            UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"Get"];
            [_UI pushViewControllerFromRoot:webCtrl animated:YES];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        
        return self.headerClassifyCell;
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 75.f;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section >= 2) {
        return 10.f;
    } else {
        return 0.1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    if (section >= 2) {
        footerView.backgroundColor = UIColorFromHex(0XEFF0F1);
    } else {
        footerView.backgroundColor = [UIColor clearColor];
    }
    return footerView;
}

//////////////////////////////
#pragma mark - 网络请求回调
///////////////////////////////////

- (void)loadYetReturnMoneyListDidReceive:(XNCustomerServerModule *)module
{
    self.isShowEm = YES;
    [self.tableView.mj_footer setHidden:NO];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.view hideLoading];
    
    if (module.yetReturnMoneyListModel.pageIndex.integerValue == 1) {
        [self.yetArr removeAllObjects];
    }

    [self.yetArr addObjectsFromArray:module.yetReturnMoneyListModel.dataArray];
    
    if (module.yetReturnMoneyListModel.pageIndex.integerValue >= module.yetReturnMoneyListModel.pageCount.integerValue) {
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_footer setHidden:YES];
    }
    else
    {
        [self.tableView.mj_footer resetNoMoreData];
        [self.tableView.mj_footer setHidden:NO];
    }
    
    [self.headerClassifyCell.yetBtn setTitle:[NSString stringWithFormat:@"已回款(%@)", module.yetReturnMoneyListModel.totalCount] forState:UIControlStateNormal];
    
    [self.tableView reloadData];
}

//请求回款失败
- (void)loadYetReturnMoneyListDidFailed:(XNCustomerServerModule *)module
{
    self.isShowEm = YES;
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

//请求回款成功
- (void)loadWaitReturnMoneyListDidReceive:(XNCustomerServerModule *)module
{
    self.isShowEm = YES;
    [self.tableView.mj_footer setHidden:NO];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.view hideLoading];
    
    if (module.waitReturnMoneyListModel.pageIndex.integerValue == 1) {
        [self.waitArr removeAllObjects];
    }

    [self.waitArr addObjectsFromArray:module.waitReturnMoneyListModel.dataArray];
    
    if (module.waitReturnMoneyListModel.pageIndex.integerValue >= module.waitReturnMoneyListModel.pageCount.integerValue) {
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_footer setHidden:YES];
    }
    else
    {
        [self.tableView.mj_footer resetNoMoreData];
        [self.tableView.mj_footer setHidden:NO];
    }
    
    [self.headerClassifyCell.waitBtn setTitle:[NSString stringWithFormat:@"待回款(%@)", module.waitReturnMoneyListModel.totalCount] forState:UIControlStateNormal];
    
    [self.tableView reloadData];
}

//请求回款失败
- (void)loadWaitReturnMoneyListDidFailed:(XNCustomerServerModule *)module
{
    self.isShowEm = YES;
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

// 4.5.1 回款日历统计
- (void)personcenterRepamentCalendarStatisticsReceive:(SignCalendarModule *)module
{
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


/////////////////////////////////
#pragma mark - setter / getter
/////////////////////////////////

- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height- 64.f) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorFromHex(0XEFF0F1);
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BackStatisticalCell class]) bundle:nil] forCellReuseIdentifier:@"BackStatisticalCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReturnMoneyCell class]) bundle:nil] forCellReuseIdentifier:@"ReturnMoneyCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InvestRecordHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"InvestRecordHeaderView"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BackClassifyCell class]) bundle:nil] forCellReuseIdentifier:@"BackClassifyCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:@"XNRedPacketEmptyCell" bundle:nil] forCellReuseIdentifier:@"XNRedPacketEmptyCell"];
    }

    return _tableView;
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

@end
