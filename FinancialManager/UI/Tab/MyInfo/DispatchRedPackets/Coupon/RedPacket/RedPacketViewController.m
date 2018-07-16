//
//  RedPacketViewController.m
//  FinancialManager
//
//  Created by xnkj on 6/20/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "RedPacketViewController.h"
#import "RedPacketCell.h"
#import "XNRedPacketEmptyCell.h"
#import "DispatchRedPacketContainerViewController.h"
#import "AgentContainerController.h"

#import "MJRefresh.h"

#import "RedPacketInfoMode.h"
#import "RedPacketListMode.h"
#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"

#define CELLHEIGHT (15 + (140 / 375.0) * SCREEN_FRAME.size.width)
#define DEFAULTPAGEINDEX @"1"
#define DEFAULTPAGESIZE @"30"

@interface RedPacketViewController ()<XNMyInformationModuleObserver>

@property (nonatomic, assign) BOOL                 finishRequest;
@property (nonatomic, strong) NSMutableArray     * redPacketListArray;

@property (nonatomic, weak) IBOutlet UITableView * redPacketTableView;
@end

@implementation RedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[XNMyInformationModule defaultModule] removeObserver:self];
}

//////////////////
#pragma mark - 自定义方法
////////////////////////////////////

//初始化
- (void)initView
{
    self.finishRequest = NO;
    [[XNMyInformationModule defaultModule] addObserver:self];
    
    [self.redPacketTableView registerNib:[UINib nibWithNibName:@"RedPacketCell" bundle:nil] forCellReuseIdentifier:@"RedPacketCell"];
    [self.redPacketTableView registerNib:[UINib nibWithNibName:@"XNRedPacketEmptyCell" bundle:nil] forCellReuseIdentifier:@"XNRedPacketEmptyCell"];
    [self.redPacketTableView setSeparatorColor:[UIColor clearColor]];
    
    weakSelf(weakSelf)
    self.redPacketTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.finishRequest = NO;
        [[XNMyInformationModule defaultModule] requestInvestRedPacketInfoWithPageIndex:DEFAULTPAGEINDEX pageSize:DEFAULTPAGESIZE];
    }];
    self.redPacketTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [[XNMyInformationModule defaultModule] requestInvestRedPacketInfoWithPageIndex:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[[[XNMyInformationModule defaultModule] investRedPacketListMode] pageIndex] integerValue] + 1]] pageSize:DEFAULTPAGESIZE];
    }];
    [self.redPacketTableView.mj_footer setAutomaticallyHidden:YES];
    [self.redPacketTableView.mj_header beginRefreshing];
    
    if ([self.view respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

//刷新红包
- (void)loadDatas
{
    [self.redPacketTableView.mj_header beginRefreshing];
}

//////////////////
#pragma mark - 组件回调
////////////////////////////////////

//UITableView 回调
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.finishRequest && self.redPacketListArray.count <= 0) return 1;
    return self.redPacketListArray.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.redPacketListArray.count <=0 )return SCREEN_FRAME.size.height;
    return CELLHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.redPacketListArray.count <= 0) {
        
        XNRedPacketEmptyCell * cell = (XNRedPacketEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"XNRedPacketEmptyCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell showTitle:@"当前没有红包" subTitle:@""];
        
        return cell;
    }
    
    RedPacketCell * cell = (RedPacketCell *)[tableView dequeueReusableCellWithIdentifier:@"RedPacketCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    weakSelf(weakSelf)
    [cell setClickUseRedPacketBlock:^{
       
        UINavigationController * platformCtrl = [_UI getRootNavigationControllerAtIndex:1];
        AgentContainerController * agentCtrl = platformCtrl.viewControllers[0];
        [agentCtrl selectedAtIndex:0];
        
        [_UI currentViewController:weakSelf popToRootViewController:YES AndSwitchToTabbarIndex:1 comlite:^{
        }];
    }];
    [cell setClickSendRedPacketBlock:^(NSString *redPacketId, NSString * redPacketMoney) {
        
        DispatchRedPacketContainerViewController * ctrl = [[DispatchRedPacketContainerViewController alloc]initWithNibName:@"DispatchRedPacketContainerViewController" bundle:nil redPacketMoney:redPacketMoney redPacketId:redPacketId];
        
        [_UI pushViewControllerFromRoot:ctrl animated:YES];
    }];
    
    RedPacketInfoMode * mode = [self.redPacketListArray objectAtIndex:indexPath.row];
    [cell refreshRedPacketInfoWithRedPacketInfoMode:mode];
    
    return cell;
}

//////////////////
#pragma mark - 网络请求回调
////////////////////////////////////

//红包列表
- (void)XNMyInfoModuleInvestRedPacketInfoDidReceive:(XNMyInformationModule *)module
{
    self.finishRequest = YES;
    [self.redPacketTableView.mj_header endRefreshing];
    [self.redPacketTableView.mj_footer endRefreshing];
    
    if (module.investRedPacketListMode.pageIndex.integerValue == 1) {
        
        [self.redPacketListArray removeAllObjects];
    }
    [self.redPacketListArray addObjectsFromArray:module.investRedPacketListMode.redPacketArray];
    
    if (module.investRedPacketListMode.pageIndex >= module.investRedPacketListMode.pageCount) {
        
        [self.redPacketTableView.mj_footer endRefreshingWithNoMoreData];
    }else
    {
        [self.redPacketTableView.mj_footer resetNoMoreData];
    }
    
    [self.redPacketTableView reloadData];
}

- (void)XNMyInfoModuleInvestRedPacketInfoDidFailed:(XNMyInformationModule *)module
{
    self.finishRequest = YES;
    [self.redPacketTableView.mj_header endRefreshing];
    [self.redPacketTableView.mj_footer endRefreshing];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//////////////////
#pragma mark - 懒加载
////////////////////////////////////

//redPacketListArray
- (NSMutableArray *)redPacketListArray
{
    if (!_redPacketListArray) {
        
        _redPacketListArray = [[NSMutableArray alloc]init];
    }
    return _redPacketListArray;
}

@end
