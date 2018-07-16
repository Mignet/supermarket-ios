//
//  MyAccountBookViewController.m
//  FinancialManager
//
//  Created by xnkj on 18/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyAccountBookViewController.h"
#import "AccountBookInvestCell.h"
#import "MyAccountBookAddItemViewController.h"
#import "MyAccountBookDetailViewController.h"
#import "XNRedPacketEmptyCell.h"

#import "MJRefresh.h"

#import "MyAccountBookInvestListMode.h"
#import "MyAccountBookDetailMode.h"
#import "MyAccountBookInvestItemMode.h"
#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"

#define DEFAULTCELLHEIGHT 92.0f
#define DEFAULTPAGEINDEX @"1"
#define DEFAULTPAGESIZE @"10"
@interface MyAccountBookViewController ()<XNMyInformationModuleObserver>

@property (nonatomic, strong) NSMutableArray * investArray;

@property (nonatomic, weak) IBOutlet UILabel * investMoneyLabel;
@property (nonatomic, weak) IBOutlet UILabel * investProfitLabel;
@property (nonatomic, weak) IBOutlet UILabel * totalProfitLabel;
@property (nonatomic, weak) IBOutlet UITableView * investTableView;
@end

@implementation MyAccountBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[XNMyInformationModule defaultModule] addObserver:self];
    [[XNMyInformationModule defaultModule] requestAccountBookStatistics];
    [[XNMyInformationModule defaultModule] requestAccountBookInvestListWithPageIndex:DEFAULTPAGEINDEX pageSize:DEFAULTPAGESIZE];
    [self.view showGifLoading];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[XNMyInformationModule defaultModule] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////
#pragma mark - 自定义方法
////////////////////////////////////

//初始化
- (void)initView
{
    self.title = @"记账本";
    [self.navigationItem addRightBarItemWithImage:@"XN_AccountBook_add_new_icon.png" frame:CGRectMake(SCREEN_FRAME.size.width - 17 - 4, 0, 17, 17) target:self action:@selector(addAccountBookItem)];
    
    [self.investTableView registerNib:[UINib nibWithNibName:@"AccountBookInvestCell" bundle:nil
                                       ] forCellReuseIdentifier:@"AccountBookInvestCell"];
    [self.investTableView registerNib:[UINib nibWithNibName:@"XNRedPacketEmptyCell" bundle:nil] forCellReuseIdentifier:@"XNRedPacketEmptyCell"];
    [self.investTableView setSeparatorColor:[UIColor clearColor]];
    
    self.investTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [[XNMyInformationModule defaultModule] requestAccountBookInvestListWithPageIndex:DEFAULTPAGEINDEX pageSize:DEFAULTPAGESIZE];
    }];
    self.investTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [[XNMyInformationModule defaultModule] requestAccountBookInvestListWithPageIndex:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[[[XNMyInformationModule defaultModule] accountBookInvestListMode] pageIndex]integerValue] + 1]] pageSize:DEFAULTPAGESIZE];
    }];
    [self.investTableView.mj_footer setAutomaticallyHidden:YES];
    
    if ([self.view respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

//更新账户统计信息
- (void)updateAccountBookStatistic
{
    self.investMoneyLabel.text = [[[XNMyInformationModule defaultModule] accountBookDetailMode] investAmount];
    self.investProfitLabel.text = [[[XNMyInformationModule defaultModule] accountBookDetailMode] investProfit];
    self.totalProfitLabel.text = [[[XNMyInformationModule defaultModule] accountBookDetailMode] investTotal];
}

//添加账本条
- (void)addAccountBookItem
{
    MyAccountBookAddItemViewController * ctrl = [[MyAccountBookAddItemViewController alloc]initWithNibName:@"MyAccountBookAddItemViewController" bundle:nil];
    
    [_UI pushViewControllerFromRoot:ctrl animated:YES];
}

//////////////////
#pragma mark - 组件回调
////////////////////////////////////

//UITableView 回调用
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.investArray.count <= 0) {
        
        return 1;
    }
    
    return self.investArray.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.investArray.count <= 0) {
        
        return SCREEN_FRAME.size.height - 252.0;
    }
    
    return DEFAULTCELLHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.investArray.count <= 0) {
        
        XNRedPacketEmptyCell * cell = (XNRedPacketEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"XNRedPacketEmptyCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell showTitle:@"暂无在投项目" subTitle:@""];
        
        return cell;
    }
    
    AccountBookInvestCell * cell = (AccountBookInvestCell *)[tableView dequeueReusableCellWithIdentifier:@"AccountBookInvestCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    MyAccountBookInvestItemMode * mode = [self.investArray objectAtIndex:indexPath.row];
    [cell refreshWithTitleName:mode.direction investMoney:mode.investAmt investProfit:mode.investProfit];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.investArray.count <= 0) {
        
        return;
    }
    
    MyAccountBookInvestItemMode * mode = [self.investArray objectAtIndex:indexPath.row];
    
    MyAccountBookDetailViewController * ctrl = [[MyAccountBookDetailViewController alloc]initWithNibName:@"MyAccountBookDetailViewController" bundle:nil titleName:mode.direction detailId:mode.investId];
    
    [_UI pushViewControllerFromRoot:ctrl animated:YES];
}
//////////////////
#pragma mark - 网络请求回调
////////////////////////////////////

//记账本统计
- (void)XNMyInfoModuleAccountBookDetailDidReceive:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    
    [self updateAccountBookStatistic];
}

- (void)XNMyInfoModuleAccountBookDetailDidFailed:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//记账本投资列表
- (void)XNMyInfoModuleAccountBookInvestListDidReceive:(XNMyInformationModule *)module
{
    [self.investTableView.mj_header endRefreshing];
    [self.investTableView.mj_footer endRefreshing];
    
    if (module.accountBookInvestListMode.pageIndex.integerValue == 1) {
        
        [self.investArray removeAllObjects];
    }
    
    [self.investArray addObjectsFromArray:module.accountBookInvestListMode.datas];
    
    if (module.accountBookInvestListMode.pageIndex.integerValue >= module.accountBookInvestListMode.pageCount.integerValue) {
        
        [self.investTableView.mj_footer endRefreshingWithNoMoreData];
    }else
    {
        [self.investTableView.mj_footer resetNoMoreData];
    }
    
    [self.investTableView reloadData];
}

- (void)XNMyInfoModuleAccountBookInvestListDidFailed:(XNMyInformationModule *)module
{
    [self.investTableView.mj_header endRefreshing];
    [self.investTableView.mj_footer endRefreshing];
    
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}


//////////////////
#pragma mark - 懒加载
////////////////////////////////////

//investArray
- (NSMutableArray *)investArray
{
    if (!_investArray) {
        
        _investArray = [[NSMutableArray alloc]init];
    }
    return _investArray;
}
@end
