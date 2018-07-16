//
//  InvestRecordViewController.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/19.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "InvestRecordViewController.h"
#import "InvestRecordCell.h"
#import "InvestRecordHeaderView.h"
#import "XNMyProfitModule.h"
#import "MIInvestRecordListMode.h"
#import "MIInvestRecordItemMode.h"
#import "XNRedPacketEmptyCell.h"

#import "BackStatisticalCell.h"
#import "InvestClassifyCell.h"

#import "SignCalendarModule.h"
#import "NSDate+Extension.h"

#define RECORD_CELL_FOOTER_HEIGHT 15.f

@interface InvestRecordViewController () <UITableViewDataSource, UITableViewDelegate, InvestClassifyCellDelegate, BackStatisticalCellDelegate>

@property (nonatomic, assign) NSInteger investPageIndex;
@property (nonatomic, assign) NSInteger insurancePageIndex;

@property (nonatomic, strong) NSMutableArray *loansArr;
@property (nonatomic, strong) NSMutableArray *insuranceArr;

@property (nonatomic, assign) BOOL finishRequest;

@property (nonatomic, assign) BOOL isLoans;

@property (nonatomic, strong) InvestClassifyCell *headerInvestClassifyCell;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) BOOL isShowEm;

@end

@implementation InvestRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

- (void)dealloc
{
    [[XNMyProfitModule defaultModule] removeObserver:self];
    [[SignCalendarModule defaultModule] removeObserver:self];
}

//////////////////////
#pragma mark -  Custom Method
////////////////
- (void)initView
{
    self.navigationItem.title = @"投资记录";
    
    //右侧日历按钮
    // return_back_list_calender.png  no_calender_list_icon@2x
    [self.navigationItem addRightBarItemWithImage:@"return_back_list_calender.png"  frame:CGRectMake(SCREEN_FRAME.size.width - 20 - 5, 0, 20, 20) target:self action:@selector(rightCalendarClick)];
    
    self.investPageIndex = 1;
    self.insurancePageIndex = 1;
    
    self.isLoans = YES;
    self.isShowEm = NO;
    
    [[XNMyProfitModule defaultModule] addObserver:self];
    [[SignCalendarModule defaultModule] addObserver:self];
    
    //tableView属性
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromHex(0XEFF0F1);
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InvestRecordCell class]) bundle:nil] forCellReuseIdentifier:@"InvestRecordCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XNRedPacketEmptyCell class]) bundle:nil] forCellReuseIdentifier:@"XNRedPacketEmptyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InvestRecordHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"InvestRecordHeaderView"];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BackStatisticalCell class]) bundle:nil] forCellReuseIdentifier:@"BackStatisticalCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InvestClassifyCell class]) bundle:nil] forCellReuseIdentifier:@"InvestClassifyCell"];
    
    // 初始化刷新控件
    [self setUpRefreshUI];

    if ([self.view respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // 请求数据
    self.investPageIndex = 1;
    
    self.insurancePageIndex = 1;
    
    // 获取网贷数据
    [self loadInvestDatas];
    
    // 请求保险数据
    [self loadInsuranceDatas];
    
    // 获取当前月份投资统计数据
    NSString *investMonth = [NSString stringWithFormat:@"%ld-%ld", [NSDate year:[NSDate new]], [NSDate month:[NSDate new]]];
    [[SignCalendarModule defaultModule] investCalendarStatisticsInvestMonth:investMonth];
    
}

- (void)rightCalendarClick
{
    [_UI popViewControllerFromRoot:YES];
}

- (void)setUpRefreshUI
{
    //刷新加载
    weakSelf(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (weakSelf.isLoans) {
            weakSelf.finishRequest = YES;
            weakSelf.investPageIndex = 1;
            [weakSelf loadInvestDatas];
        } else {
            weakSelf.finishRequest = YES;
            weakSelf.insurancePageIndex = 1;
            [weakSelf loadInsuranceDatas];
        }
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.investPageIndex = [[[[XNMyProfitModule defaultModule] investRecordListMode] pageIndex] integerValue] + 1;
        [weakSelf loadInvestDatas];
        
        if (weakSelf.isLoans) {
            weakSelf.investPageIndex = [[[[XNMyProfitModule defaultModule] investRecordListMode] pageIndex] integerValue] + 1;
            [weakSelf loadInvestDatas];
        } else {
            weakSelf.insurancePageIndex = [[[[XNMyProfitModule defaultModule] insuranceRecordListMode] pageIndex] integerValue] + 1;
            [weakSelf loadInsuranceDatas];
        }
    }];
    
}

// 请求网贷数据
- (void)loadInvestDatas
{
    [self.view showGifLoading];
    
    [[XNMyProfitModule defaultModule] requestInvestRecordListPageIndex:[NSString stringWithFormat:@"%ld", self.investPageIndex] pageSize:@"10" investTime:nil];
}

// 获取保险数据
- (void)loadInsuranceDatas
{
    [self.view showGifLoading];
    
    [[XNMyProfitModule defaultModule] requestInsuranceRecordListPageIndex:[NSString stringWithFormat:@"%ld", self.insurancePageIndex] pageSize:@"10" investTime:nil];
}

//////////////////////////////
#pragma mark - protocol Methods
//////////////////////////////////////////

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    if (self.isLoans == YES) {
        
        if (self.isShowEm == YES && self.loansArr.count == 0) {
            
            return 1;
        } else {
            
            return self.loansArr.count;
        }
    
    } else {
        
        if (self.isShowEm == YES && self.insuranceArr.count == 0) {
            
            return 1;
        } else {
            
            return self.insuranceArr.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        BackStatisticalCell *statisticalCell = [tableView dequeueReusableCellWithIdentifier:@"BackStatisticalCell"];
        statisticalCell.investStatisticsModel = [SignCalendarModule defaultModule].investStatisticsModel;
        statisticalCell.delegate = self;
        return statisticalCell;
    }
    
    
    if (self.isLoans == YES) {
        
        if (self.loansArr.count == 0 && self.isShowEm == YES) {
            
            XNRedPacketEmptyCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:@"XNRedPacketEmptyCell"];
            [emptyCell showTitle:@"当前没有网贷投资记录" subTitle:nil];
            return emptyCell;
        }
        
    } else {
        
        if (self.insuranceArr.count == 0 && self.isShowEm == YES) {
            
            XNRedPacketEmptyCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:@"XNRedPacketEmptyCell"];
            [emptyCell showTitle:@"当前没有保险购买记录" subTitle:nil];
            return emptyCell;
        }
    }
    
    
    InvestRecordCell *recordCell = [tableView dequeueReusableCellWithIdentifier:@"InvestRecordCell"];
    
    recordCell.itemModel = self.loansArr[indexPath.row];
    
    if (indexPath.row == 0) {
        recordCell.startTimeStr = nil;
    } else {
        MIInvestRecordItemMode *upModel = self.isLoans ? self.loansArr[indexPath.row - 1] : self.insuranceArr[indexPath.row - 1];
        recordCell.startTimeStr = upModel.startTimeStr;
    }
    
    if (self.isLoans) {
        recordCell.settle_accounts_ImgView.hidden = YES;
    } else {
        recordCell.settle_accounts_ImgView.hidden = YES;
    }
    
    recordCell.itemModel = self.isLoans ? self.loansArr[indexPath.row] : self.insuranceArr[indexPath.row];
    
    return recordCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    
    else {
        return 75.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [[UIView alloc] init];
    }
    
    return self.headerInvestClassifyCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    
    else if (section == 1) {
        return 0.1;
    }
    
    return RECORD_CELL_FOOTER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    
    return footerView;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 90.f;
    }
    
    if (self.isShowEm == YES) { //请求结束
        
        if (self.isLoans == YES) { // 显示网贷
            
            if (self.loansArr.count == 0) {
                return SCREEN_FRAME.size.height - 90.f - 64.f - 70.f;
            } else {
                
                if (indexPath.row == 0) {
                    return 147.f;
                } else {
                    MIInvestRecordItemMode *upModel = (self.isLoans) ? self.loansArr[indexPath.row - 1] : self.insuranceArr[indexPath.row - 1];
                    MIInvestRecordItemMode *belowModel = (self.isLoans) ? self.loansArr[indexPath.row] : self.insuranceArr[indexPath.row];
                    if ([belowModel.startTimeStr isEqualToString:upModel.startTimeStr]) {
                        return 117.f;
                    } else {
                        return 147.f;
                    }
                }
            }
            
        }  else { //显示保险
            
            if (self.insuranceArr.count == 0) {
                return SCREEN_FRAME.size.height - 90.f - 64.f - 70.f;
            } else {
                
                if (indexPath.row == 0) {
                    return 147.f;
                } else {
                    MIInvestRecordItemMode *upModel = (self.isLoans) ? self.loansArr[indexPath.row - 1] : self.insuranceArr[indexPath.row - 1];
                    MIInvestRecordItemMode *belowModel = (self.isLoans) ? self.loansArr[indexPath.row] : self.insuranceArr[indexPath.row];
                    if ([belowModel.startTimeStr isEqualToString:upModel.startTimeStr]) {
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isLoans) {
        
        if (indexPath.section == 1) {
            
            if (self.loansArr.count == 0) {
                return;
            }
            
            [XNUMengHelper umengEvent:@"W_3_1_1"];
            
            MIInvestRecordItemMode * item = [self.loansArr objectAtIndex:indexPath.row] ;
            NSString * url = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"%@?investId=%@&canJumpNative=%@",@"/pages/message/buyDetail.html",item.investId,@"1"]];
            UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"Get"];
            [_UI pushViewControllerFromRoot:webCtrl animated:YES];
        }
        
    } else {
        
        if (indexPath.section == 1) {
            
            if (self.insuranceArr.count == 0) {
                return;
            }
            
            [XNUMengHelper umengEvent:@"W_3_1_1"];
            
            MIInvestRecordItemMode * item = [self.insuranceArr objectAtIndex:indexPath.row] ;
            NSString * url = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"%@?investId=%@&canJumpNative=%@&message=insurance",@"/pages/message/buyDetail.html",item.investId,@"1"]];
            UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"Get"];
            [_UI pushViewControllerFromRoot:webCtrl animated:YES];
        }
    }
    
}



////////////////////////////////////
#pragma mark - 自定义视图回调
////////////////////////////////////

- (void)investClassifyCellDid:(InvestClassifyCell *)investClassifyCell clickType:(InvestClassifyCellClickType)clickType
{
    if (clickType == Invest_Classify_Cell_Loans) {
        
        if (self.isLoans == NO) {
            
            self.isLoans = YES;
            
            [self updateFooterRefresh];
            
            if (self.loansArr.count == 0) {
                self.investPageIndex = 1;
                [self loadInvestDatas];
            } else {
                [self.tableView reloadData];
            }
        }
        
        
    } else {
        
        if (self.isLoans == YES) {
            
            self.isLoans = NO;
            
            [self updateFooterRefresh];
            
            if (self.insuranceArr.count == 0) {
                self.insurancePageIndex = 1;
                [self loadInsuranceDatas];
            } else {
                [self.tableView reloadData];
            }
        }
    }
}

// BackStatisticalCellDelegate
- (void)backStatisticalCellDid:(BackStatisticalCell *)backStatisticalCell
{
    [self showFMRecommandViewWithTitle:@"团队累积业绩" subTitle:@"指你的所有理财师团队成员(包括：直推、二级、三级)的出单金额 + 所有客户投资金额。" otherSubTitle:nil okTitle:@"我知道了" okCompleteBlock:^{
    } cancelTitle:nil cancelCompleteBlock:^{
    }];
}


- (void)updateFooterRefresh
{
    if (self.isLoans) { //
        
        MIInvestRecordListMode *investModel = [XNMyProfitModule defaultModule].investRecordListMode;
        
        if (investModel.pageIndex.integerValue >= investModel.pageCount.integerValue) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView.mj_footer setHidden:YES];
        }
        else
        {
            [self.tableView.mj_footer resetNoMoreData];
            [self.tableView.mj_footer setHidden:NO];
        }
        
    } else {
        
        MIInvestRecordListMode *insuranceModel = [XNMyProfitModule defaultModule].insuranceRecordListMode;
        
        if (insuranceModel.pageIndex.integerValue >= insuranceModel.pageCount.integerValue) {
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

///////////////////
#pragma mark - 网络请求回调
/////////////////////////////

- (void)requestInvestRecordListDidReceive:(XNMyProfitModule *)module
{
    self.isShowEm = YES;
    [self.tableView.mj_footer setHidden:NO];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.view hideLoading];
    
    if (module.investRecordListMode.pageIndex.integerValue == 1) {
        [self.loansArr removeAllObjects];
    }
    
    [self.loansArr addObjectsFromArray:module.investRecordListMode.datas];
    
    
    if (module.investRecordListMode.pageIndex.integerValue >= module.investRecordListMode.pageCount.integerValue) {
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_footer setHidden:YES];
    }
    else
    {
        [self.tableView.mj_footer resetNoMoreData];
        [self.tableView.mj_footer setHidden:NO];
    }
    
    [self.headerInvestClassifyCell.loansBtn setTitle:[NSString stringWithFormat:@"网贷(%@)", module.investRecordListMode.totalCount] forState:UIControlStateNormal];
    
    [self.tableView reloadData];
}

- (void)requestInvestRecordListDidFailed:(XNMyProfitModule *)module
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

// 保险记录
- (void)requestInsuranceRecordListDidReceive:(XNMyProfitModule *)module
{
    [self.view hideLoading];
    
    self.isShowEm = YES;
    [self.tableView.mj_footer setHidden:NO];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (module.insuranceRecordListMode.pageIndex.integerValue == 1) {
        [self.insuranceArr removeAllObjects];
    }
    
    [self.insuranceArr addObjectsFromArray:module.insuranceRecordListMode.datas];
    
    
    if (module.insuranceRecordListMode.pageIndex.integerValue >= module.insuranceRecordListMode.pageCount.integerValue) {
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_footer setHidden:YES];
    }
    else
    {
        [self.tableView.mj_footer resetNoMoreData];
        [self.tableView.mj_footer setHidden:NO];
    }
    
    [self.headerInvestClassifyCell.insuranceBtn setTitle:[NSString stringWithFormat:@"保险(%@)", module.insuranceRecordListMode.totalCount] forState:UIControlStateNormal];
    
    [self.tableView reloadData];
}

- (void)requestInsuranceRecordListDidFailed:(XNMyProfitModule *)module
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

// 4.5.1 交易日历统计
- (void)investCalendarStatisticsReceive:(SignCalendarModule *)module
{
    [self.view hideLoading];
    
    [self.tableView reloadData];
}

- (void)investCalendarStatisticsDidFailed:(SignCalendarModule *)module
{
    [self.view hideLoading];
    self.isShowEm = YES;
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
#pragma mark - setter / getter
//////////////////////////////////////////

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

- (InvestClassifyCell *)headerInvestClassifyCell
{
    if (!_headerInvestClassifyCell) {
        _headerInvestClassifyCell = [self.tableView dequeueReusableCellWithIdentifier:@"InvestClassifyCell"];
        _headerInvestClassifyCell.delegate = self;
    }
    return _headerInvestClassifyCell;
}


@end
