//
//  RedPacketViewController.m
//  FinancialManager
//
//  Created by xnkj on 6/20/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "LevelCouponViewController.h"
#import "LevelCouponCell.h"
#import "XNRedPacketEmptyCell.h"

#import "MJRefresh.h"

#import "LevelCouponItemMode.h"
#import "LevelCouponListMode.h"
#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"

#define CELLHEIGHT 200.0
#define DEFAULTPAGEINDEX @"1"
#define DEFAULTPAGESIZE @"30"

@interface LevelCouponViewController ()<XNMyInformationModuleObserver>

@property (nonatomic, assign) BOOL                 finishRequest;
@property (nonatomic, strong) NSMutableArray     * levelCouponListArray;

@property (nonatomic, weak) IBOutlet UITableView * levelCouponTableView;
@end

@implementation LevelCouponViewController

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
    
    [self.levelCouponTableView registerNib:[UINib nibWithNibName:@"LevelCouponCell" bundle:nil] forCellReuseIdentifier:@"LevelCouponCell"];
    [self.levelCouponTableView registerNib:[UINib nibWithNibName:@"XNRedPacketEmptyCell" bundle:nil] forCellReuseIdentifier:@"XNRedPacketEmptyCell"];
    [self.levelCouponTableView setSeparatorColor:[UIColor clearColor]];
    
    weakSelf(weakSelf)
    self.levelCouponTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.finishRequest = NO;
        [[XNMyInformationModule defaultModule] requestLevelCouponInfoWithPageIndex:DEFAULTPAGEINDEX pageSize:DEFAULTPAGESIZE];
    }];
    self.levelCouponTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [[XNMyInformationModule defaultModule] requestLevelCouponInfoWithPageIndex:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[[[XNMyInformationModule defaultModule] levelCouponListMode] pageIndex] integerValue] + 1]] pageSize:DEFAULTPAGESIZE];
    }];
    [self.levelCouponTableView.mj_footer setAutomaticallyHidden:YES];
    [self.levelCouponTableView.mj_header beginRefreshing];
    
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
    if (self.finishRequest && self.levelCouponListArray.count <= 0) return 1;
    return self.levelCouponListArray.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.levelCouponListArray.count <=0 )return SCREEN_FRAME.size.height;
    return CELLHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.levelCouponListArray.count <= 0) {
        
        XNRedPacketEmptyCell * cell = (XNRedPacketEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"XNRedPacketEmptyCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell showTitle:@"当前没有职级券" subTitle:@""];
        
        return cell;
    }
    
    LevelCouponCell * cell = (LevelCouponCell *)[tableView dequeueReusableCellWithIdentifier:@"LevelCouponCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    LevelCouponItemMode * mode = [self.levelCouponListArray objectAtIndex:indexPath.row];
    [cell refreshLevelCouponInfoWithLevelCouponInfoMode:mode];
    
    return cell;
}

//////////////////
#pragma mark - 网络请求回调
////////////////////////////////////

//红包列表
- (void)XNMyInfoModuleLevelCouponDidReceive:(XNMyInformationModule *)module
{
    self.finishRequest = YES;
    [self.levelCouponTableView.mj_header endRefreshing];
    [self.levelCouponTableView.mj_footer endRefreshing];
    
    if (module.levelCouponListMode.pageIndex.integerValue == 1) {
        
        [self.levelCouponListArray removeAllObjects];
    }
    [self.levelCouponListArray addObjectsFromArray:module.levelCouponListMode.dataArray];
    
    if (module.levelCouponListMode.pageIndex >= module.levelCouponListMode.pageCount) {
        
        [self.levelCouponTableView.mj_footer endRefreshingWithNoMoreData];
    }else
    {
        [self.levelCouponTableView.mj_footer resetNoMoreData];
    }
    
    [self.levelCouponTableView reloadData];
}

- (void)XNMyInfoModuleLevelCouponDidFailed:(XNMyInformationModule *)module
{
    self.finishRequest = YES;
    [self.levelCouponTableView.mj_header endRefreshing];
    [self.levelCouponTableView.mj_footer endRefreshing];
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
- (NSMutableArray *)levelCouponListArray
{
    if (!_levelCouponListArray) {
        
        _levelCouponListArray = [[NSMutableArray alloc]init];
    }
    return _levelCouponListArray;
}

@end
