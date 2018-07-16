//
//  RedPacketViewController.m
//  FinancialManager
//
//  Created by xnkj on 6/20/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "ComissionCouponViewController.h"
#import "ComissionCouponCell.h"
#import "XNRedPacketEmptyCell.h"

#import "MJRefresh.h"

#import "ComissionCouponItemMode.h"
#import "ComissionCouponListMode.h"
#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"

#define CELLHEIGHT (15 + (140 / 375.0) * SCREEN_FRAME.size.width)
#define DEFAULTPAGEINDEX @"1"
#define DEFAULTPAGESIZE @"30"

@interface ComissionCouponViewController ()<XNMyInformationModuleObserver>

@property (nonatomic, assign) BOOL                 finishRequest;
@property (nonatomic, strong) NSMutableArray     * comissionCouponListArray;

@property (nonatomic, weak) IBOutlet UITableView * comissionCouponTableView;
@end

@implementation ComissionCouponViewController

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
    
    [self.comissionCouponTableView registerNib:[UINib nibWithNibName:@"ComissionCouponCell" bundle:nil] forCellReuseIdentifier:@"ComissionCouponCell"];
    [self.comissionCouponTableView registerNib:[UINib nibWithNibName:@"XNRedPacketEmptyCell" bundle:nil] forCellReuseIdentifier:@"XNRedPacketEmptyCell"];
    [self.comissionCouponTableView setSeparatorColor:[UIColor clearColor]];
    
    weakSelf(weakSelf)
    self.comissionCouponTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.finishRequest = NO;
        [[XNMyInformationModule defaultModule] requestComissionCouponInfoWithPageIndex:DEFAULTPAGEINDEX pageSize:DEFAULTPAGESIZE];
    }];
    self.comissionCouponTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [[XNMyInformationModule defaultModule] requestComissionCouponInfoWithPageIndex:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[[[XNMyInformationModule defaultModule] comissionCouponListMode] pageIndex] integerValue] + 1]] pageSize:DEFAULTPAGESIZE];
    }];
    [self.comissionCouponTableView.mj_footer setAutomaticallyHidden:YES];
    [self.comissionCouponTableView.mj_header beginRefreshing];
    
    if ([self.view respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

//////////////////
#pragma mark - 组件回调
////////////////////////////////////

//UITableView 回调
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.finishRequest && self.comissionCouponListArray.count <= 0) return 1;
    return self.comissionCouponListArray.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.comissionCouponListArray.count <=0 )return SCREEN_FRAME.size.height;
    return CELLHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.comissionCouponListArray.count <= 0) {
        
        XNRedPacketEmptyCell * cell = (XNRedPacketEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"XNRedPacketEmptyCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell showTitle:@"当前没有加佣券" subTitle:@""];
        
        return cell;
    }
    
    ComissionCouponCell * cell = (ComissionCouponCell *)[tableView dequeueReusableCellWithIdentifier:@"ComissionCouponCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    ComissionCouponItemMode * mode = [self.comissionCouponListArray objectAtIndex:indexPath.row];
    [cell refreshComissionCouponInfoWithComissionCouponInfoMode:mode];
    
    return cell;
}

//////////////////
#pragma mark - 网络请求回调
////////////////////////////////////

//红包列表
- (void)XNMyInfoModuleCouponCountDidReceive:(XNMyInformationModule *)module
{
    self.finishRequest = YES;
    [self.comissionCouponTableView.mj_header endRefreshing];
    [self.comissionCouponTableView.mj_footer endRefreshing];
    
    if (module.comissionCouponListMode.pageIndex.integerValue == 1) {
        
        [self.comissionCouponListArray removeAllObjects];
    }
    [self.comissionCouponListArray addObjectsFromArray:module.comissionCouponListMode.dataArray];
    
    if (module.comissionCouponListMode.pageIndex >= module.comissionCouponListMode.pageCount) {
        
        [self.comissionCouponTableView.mj_footer endRefreshingWithNoMoreData];
    }else
    {
        [self.comissionCouponTableView.mj_footer resetNoMoreData];
    }
    
    [self.comissionCouponTableView reloadData];
}

- (void)XNMyInfoModuleCouponCountDidFailed:(XNMyInformationModule *)module
{
    self.finishRequest = YES;
    [self.comissionCouponTableView.mj_header endRefreshing];
    [self.comissionCouponTableView.mj_footer endRefreshing];
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
- (NSMutableArray *)comissionCouponListArray
{
    if (!_comissionCouponListArray) {
        
        _comissionCouponListArray = [[NSMutableArray alloc]init];
    }
    return _comissionCouponListArray;
}

@end
