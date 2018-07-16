//
//  MyBundRecordingViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/22/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyBundRecordingViewController.h"
#import "MyFundRecordingCell.h"
#import "MFSystemInvitedEmptyCell.h"
#import "AgentContainerController.h"

#import "XNBundModule.h"
#import "XNBundModuleObserver.h"
#import "XNBundListMode.h"

#define CELLHEIGHT 149.0
@interface MyBundRecordingViewController ()<XNBundModuleObserver>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArray;
@property (nonatomic, assign) NSInteger nPageIndex;
@property (nonatomic, assign) BOOL isAbnormalStatus;
@property (nonatomic, assign) BOOL finishedRequest;

@end

@implementation MyBundRecordingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
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
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[XNBundModule defaultModule] removeObserver:self];
}

/////////////////
#pragma mark - 自定义
/////////////////////////////////

//初始化
- (void)initView
{
    self.title = @"基金交易明细";
    self.nPageIndex = 1;
    self.isAbnormalStatus = NO;
    self.finishedRequest = NO;
    [[XNBundModule defaultModule] addObserver:self];
    
    weakSelf(weakSelf)
    [_tableView registerNib:[UINib nibWithNibName:@"MyFundRecordingCell" bundle:nil] forCellReuseIdentifier:@"MyFundRecordingCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MFSystemInvitedEmptyCell" bundle:nil] forCellReuseIdentifier:@"MFSystemInvitedEmptyCell"];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.nPageIndex --;
        [weakSelf loadDatas];
        
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.nPageIndex ++;
        [weakSelf loadDatas];
    }];
    [_tableView.mj_footer setAutomaticallyHidden:YES];
    
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
    if (self.nPageIndex < 1)
    {
        self.nPageIndex = 1;
    }
    self.finishedRequest = NO;
    
    //基金交易明细
    [[XNBundModule defaultModule] requestMyFundRecordingWithFundCodes:@"" merchantNumber:@"" orderDateEnd:@"" orderDateStart:@"" pageIndex:[NSString stringWithFormat:@"%ld", self.nPageIndex] pageSize:@"10" portfolioId:@"" rspId:@"" transactionStatus:@"" transactionType:@""];
    
}

////////////////////
#pragma mark - Protocol Method
////////////////////////////////////////////

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.datasArray.count <= 0 && self.finishedRequest)
    {
        return 1;
    }
    
    return self.datasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = indexPath.row;
    
    if (self.datasArray.count <= 0)
    {
        MFSystemInvitedEmptyCell *emptyCell = (MFSystemInvitedEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"MFSystemInvitedEmptyCell"];
        //报异常
        if (self.isAbnormalStatus)
        {
            [emptyCell refreshTitle:@"该页面已经飞到了外太空，\n请稍后再试" imageView:@"XN_My_Fund_Error_icon"];
        }
        else
        {
            [emptyCell refreshTitle:@"暂无基金交易明细，\n赶紧去看看！" buttonTitle:@"购买基金"];
            weakSelf(weakSelf)
            [emptyCell setButtonClick:^{
              
                UINavigationController * platformCtrl = [_UI getRootNavigationControllerAtIndex:1];
                AgentContainerController * agentCtrl = platformCtrl.viewControllers[0];
                [agentCtrl selectedAtIndex:2];
                
                [_UI currentViewController:weakSelf popToRootViewController:YES AndSwitchToTabbarIndex:1 comlite:^{
                    
                }];

            }];
        }
        
        [emptyCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return emptyCell;
    }
    
    static NSString *cellIdentifierString = @"MyFundRecordingCell";
    MyFundRecordingCell *cell = (MyFundRecordingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
    
    [cell showDatas:[self.datasArray objectAtIndex:nRow]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datasArray.count <= 0)
    {
        return SCREEN_FRAME.size.height;
    }
    
    return CELLHEIGHT;
    
}


//基金投资记录
- (void)XNBundModuleMyFundRecordingDidReceive:(XNBundModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    self.finishedRequest = YES;
    
    XNBundListMode *mode = module.myBundRecordingMode;
    _nPageIndex = [mode.pageIndex integerValue];
    
    if (_nPageIndex == 1)
    {
        [self.datasArray removeAllObjects];
    }
    
    if (mode.datas.count > 0)
    {
        [self.datasArray addObjectsFromArray:mode.datas];
    }
    
    if (_nPageIndex >= [mode.pageCount integerValue])
    {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
    else
    {
        [_tableView.mj_footer resetNoMoreData];
    }
    
    [self.tableView reloadData];
}

- (void)XNBundModuleMyFundRecordingDidFailed:(XNBundModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    self.finishedRequest = YES;
    
    //系统异常
    if ([module.retCode.ret isEqualToString:@"-999999"])
    {
        self.isAbnormalStatus = YES;
        [self.tableView reloadData];
        return;
    }
    
    if (module.retCode.detailErrorDic)
    {
        if (![module.retCode.ret isEqualToString:@"100006"] && ![module.retCode.ret isEqualToString:@"-999999"])
        {
            [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
        }
        else
        {
            self.isAbnormalStatus = NO;
            [self.tableView reloadData];
            return;
        }
        
    }
    else
    {
        
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

#pragma mark - datasArray
- (NSMutableArray *)datasArray
{
    if (!_datasArray)
    {
        _datasArray = [[NSMutableArray alloc] init];
    }
    return _datasArray;
}

@end
