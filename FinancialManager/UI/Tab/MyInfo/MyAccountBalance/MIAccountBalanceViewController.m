//
//  MIAccountBalanceViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 11/22/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "MIAccountBalanceViewController.h"
#import "MIAccountBalanceHeaderCell.h"
#import "MIAccountBalanceCell.h"
#import "MIMonthIncomeViewController.h"
#import "MIAddBankCardController.h"
#import "MIDeportMoneyController.h"
#import "MIInitPayPwdViewController.h"
#import "MIDeportDetailController.h"
#import "MIAccountBalanceSectionCell.h"
#import "MIAccountBalanceDetailViewController.h"

#import "MIAccountBalanceCommonMode.h"
#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"
#import "MIAccountBalanceMode.h"
#import "MIAccountBalanceCommonMode.h"
#import "MIAccountBalanceProfixItemMode.h"
#import "XNMyInformationModule.h"
#import "MIMySetMode.h"
#import "XNPasswordManagerModule.h"
#import "XNPasswordManagerObserver.h"
#import "XNUserVerifyPayPwdStatusMode.h"

#define HEADER_CELL_HEIGHT (81.0f + 58.0f + 10.0f)
#define SECTION_CELL_DEFAULT_HEIGHT 40.0f
#define CELL_DEFAULT_HEIGHT 63.0f

#define PAGEINDEX @"1"
#define PAGESIZE @"10"

@interface MIAccountBalanceViewController ()<MIAccountBalanceHeaderCellDelegate, XNMyInformationModuleObserver, XNPasswordManagerObserver>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArray;
@property (nonatomic, strong) NSMutableArray *cellDatasArray;

@property (nonatomic, assign) NSInteger nCurrentYear;
@property (nonatomic, assign) NSInteger nLastYear; //上一个年份

@property (nonatomic, strong) MIAccountBalanceMode *accountBalanceMode;
@property (nonatomic, strong) MIAccountBalanceCommonMode *monthProfitTotalListMode;

@end

@implementation MIAccountBalanceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    
    [self loadAccountBalanceDatas];
    [[XNMyInformationModule defaultModule] requestMonthProfitTotalList:PAGEINDEX pageSize:PAGESIZE];
    
    [self.view showGifLoading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[XNMyInformationModule defaultModule] removeObserver:self];
}

////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.title = @"猎财余额";
    [[XNMyInformationModule defaultModule] addObserver:self];
    
    // 获取公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [NSDate date];
    //获取不同时间字段的信息
    NSDateComponents *comp = [gregorian components:NSCalendarUnitYear fromDate:date];
    _nCurrentYear = comp.year;
    
    weakSelf(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadAccountBalanceDatas];
        [[XNMyInformationModule defaultModule] requestMonthProfitTotalList:PAGEINDEX pageSize:PAGESIZE];
        [weakSelf.view showGifLoading];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [[XNMyInformationModule defaultModule] requestMonthProfitTotalList:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:([[[XNMyInformationModule defaultModule] monthProfitTotalListMode] pageIndex] + 1)]] pageSize:PAGESIZE];
    }];
    
    [self.tableView.mj_footer setHidden:YES];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MIAccountBalanceHeaderCell" bundle:nil] forCellReuseIdentifier:@"MIAccountBalanceHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MIAccountBalanceSectionCell" bundle:nil] forCellReuseIdentifier:@"MIAccountBalanceSectionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MIAccountBalanceCell" bundle:nil] forCellReuseIdentifier:@"MIAccountBalanceCell"];
}

#pragma mark - 加载账户余额数据
- (void)loadAccountBalanceDatas
{
    [[XNMyInformationModule defaultModule] requestAccountBalance];
}

//////////////////////////////
#pragma mark - protocol Methods
//////////////////////////////////////////

#pragma mark - MIAccountBalanceHeaderCellDelegate

#pragma mark - 猎财余额说明
- (void)accountExplain
{
    NSString *reasonString = @"猎财余额可以提现，但不能直接用于入驻平台的投资。";
    [self showCustomAlertViewWithTitle:reasonString okTitle:@"我知道了" okTitleColor:UIColorFromHex(0x4E8CEF) okCompleteBlock:^{
        
    } topPadding:23 textAlignment:NSTextAlignmentCenter];
}

#pragma mark -资金明细
- (void)accountBalanceDetail
{
    MIAccountBalanceDetailViewController *viewController = [[MIAccountBalanceDetailViewController alloc] initWithNibName:@"MIAccountBalanceDetailViewController" bundle:nil];
    [_UI pushViewControllerFromRoot:viewController hideNavigationBar:NO animated:YES];
}

#pragma mark - 提现
- (void)withdrawDeposit
{
    if (![[[XNMyInformationModule defaultModule] settingMode] bundBankCard]) {
        
        MIAddBankCardController * addBankCardCtrl = [[MIAddBankCardController alloc]initWithNibName:@"MIAddBankCardController" bundle:nil];
        
        [_UI pushViewControllerFromRoot:addBankCardCtrl animated:YES];
        
        return;
    }
    
    [[XNPasswordManagerModule defaultModule] addObserver:self];
    [[XNPasswordManagerModule defaultModule] userVerifyExistPayPassword];
    [self.view showGifLoading];
}

#pragma mark - 提现记录
- (void)withdrawDepositRecord
{
    MIDeportDetailController *deportDetailCtrl = [[MIDeportDetailController alloc]initWithNibName:@"MIDeportDetailController" bundle:nil];
    
    [_UI pushViewControllerFromRoot:deportDetailCtrl animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellDatasArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = [indexPath row];
    if (nRow == 0)
    {
        static NSString *cellIdentifierString = @"MIAccountBalanceHeaderCell";
        MIAccountBalanceHeaderCell *cell = (MIAccountBalanceHeaderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
        if (cell == nil)
        {
            cell = [[MIAccountBalanceHeaderCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifierString];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.backgroundColor = UIColorFromHex(0x4f8cef);
        [cell showDatas:self.accountBalanceMode];
        return cell;
    }
    
    if ([[self.cellDatasArray objectAtIndex:nRow - 1] isKindOfClass:[NSString class]])
    {
        static NSString *sectionCellIdentifierString = @"MIAccountBalanceSectionCell";
        MIAccountBalanceSectionCell *cell = (MIAccountBalanceSectionCell *)[tableView dequeueReusableCellWithIdentifier:sectionCellIdentifierString];
        if (cell == nil)
        {
            cell = [[MIAccountBalanceSectionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sectionCellIdentifierString];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showDatas:[[self.cellDatasArray objectAtIndex:nRow - 1] integerValue]];
        return cell;
    }
    
    static NSString *cellIdentifierString = @"MIAccountBalanceCell";
    MIAccountBalanceCell *cell = (MIAccountBalanceCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
    if (cell == nil)
    {
        cell = [[MIAccountBalanceCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifierString];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showDatas:[self.cellDatasArray objectAtIndex:nRow - 1]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = [indexPath row];
    if (nRow == 0)
    {
        return HEADER_CELL_HEIGHT;
    }
    
    if (self.datasArray.count < 1)
    {
        return SCREEN_FRAME.size.height - HEADER_CELL_HEIGHT;
    }
    
    if ([[self.cellDatasArray objectAtIndex:nRow - 1] isKindOfClass:[NSString class]])
    {
        return SECTION_CELL_DEFAULT_HEIGHT;
    }
    
    return CELL_DEFAULT_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger nRow = [indexPath row];
    
    if (nRow != 0 && self.cellDatasArray.count > 0)
    {
        MIAccountBalanceProfixItemMode *itemMode = [self.cellDatasArray objectAtIndex:nRow - 1];
        if (![itemMode isKindOfClass:[NSString class]])
        {
            NSString *title = [[itemMode.monthDesc componentsSeparatedByString:@"("] firstObject];
            MIMonthIncomeViewController *viewController = [[MIMonthIncomeViewController alloc] initWithNibName:@"MIMonthIncomeViewController" bundle:nil title:title month:itemMode.month];
            [_UI pushViewControllerFromRoot:viewController animated:YES];
        }
    }
}

#pragma mark - XNMyInformationModuleObserver

#pragma mark - 账户余额
- (void)XNMyInfoModuleAccountBalanceDidReceive:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    
    self.accountBalanceMode = module.accountBalanceMode;
    [self.tableView reloadData];
}

- (void)XNMyInfoModuleAccountBalanceDidFailed:(XNMyInformationModule *)module
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

#pragma mark - 账户余额月份收益总计列表
- (void)XNMyInfoModuleMonthProfitTotalListDidReceive:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (module.monthProfitTotalListMode.pageIndex == 1)
    {
        [self.datasArray removeAllObjects];
    }
    
    _monthProfitTotalListMode = module.monthProfitTotalListMode;
    
    if (_monthProfitTotalListMode.datas.count > 0)
    {
        [self.datasArray addObjectsFromArray:_monthProfitTotalListMode.datas];
    }
    [self.cellDatasArray removeAllObjects];
    
    _nLastYear = _nCurrentYear;
    for (MIAccountBalanceProfixItemMode *itemMode in self.datasArray)
    {
        NSString *yearString = [[itemMode.month componentsSeparatedByString:@"-"] firstObject];
        if ([yearString integerValue] != _nCurrentYear && [yearString integerValue] != _nLastYear)
        {
            [self.cellDatasArray addObject:yearString];
            _nLastYear = [yearString integerValue];
        }
        [self.cellDatasArray addObject:itemMode];
        
    }
    
    if (module.monthProfitTotalListMode.pageIndex >= module.monthProfitTotalListMode.pageCount)
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

- (void)XNMyInfoModuleMonthProfitTotalListDidFailed:(XNMyInformationModule *)module
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

#pragma mark - XNPasswordManagerObserver
#pragma mark - 检查是否设置了支付密码
- (void)XNUserModulePayPasswordStatusDidReceive:(XNPasswordManagerModule *)module
{
    [[XNPasswordManagerModule defaultModule] removeObserver:self];
    [self.view hideLoading];
    if (module.userVerifyPayPwdStatusMode.result)
    {
        MIDeportMoneyController * myAccountCtrl = [[MIDeportMoneyController alloc] initWithNibName:@"MIDeportMoneyController" bundle:nil];
        [_UI pushViewControllerFromRoot:myAccountCtrl animated:YES];
    }
    else
    {
        MIInitPayPwdViewController * initPayPasswordCtrl = [[MIInitPayPwdViewController alloc]init];
        [_LOGIC saveValueForKey:XN_USER_INIT_PAY_PASSWORD_CONTROLLER Value:@"MIAccountBalanceViewController"];
        
        [_UI pushViewControllerFromRoot:initPayPasswordCtrl animated:YES];
    }
}

- (void)XNUserModulePayPasswordStatusDidFailed:(XNPasswordManagerModule *)module
{
    [[XNPasswordManagerModule defaultModule] removeObserver:self];
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

#pragma mark - cellDatasArray
- (NSMutableArray *)cellDatasArray
{
    if (!_cellDatasArray)
    {
        _cellDatasArray = [[NSMutableArray alloc] init];
    }
    return _cellDatasArray;
}

@end
