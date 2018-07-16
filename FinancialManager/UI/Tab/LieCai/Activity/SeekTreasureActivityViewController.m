//
//  SeekTreasureActivityViewController.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SeekTreasureActivityViewController.h"
#import "SeekActivityListCell.h"
#import "XNRedPacketEmptyCell.h"

#import "XNLeiCaiModule.h"
#import "SeekActivityListModel.h"
#import "SeekActivityItemModel.h"

#import "XNHomeBannerMode.h"
#import "XNCommonModule.h"

@interface SeekTreasureActivityViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray     * activityArr;
@property (nonatomic, assign) NSInteger            pageIndex;
@property (nonatomic, assign) BOOL                 finishRequest;

@property (weak, nonatomic) IBOutlet UITableView * tableView;

@end

#define seek_cell_height (260.f * SCREEN_FRAME.size.width / 375)

@implementation SeekTreasureActivityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    
    [self setRefreshUI];
    
    //[self requestHotActivityDatas];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)dealloc
{
    [[XNLeiCaiModule defaultModule] removeObserver:self];
}

///////////////////
#pragma mark - 自定义方法
////////////////////////

//初始化
- (void)initView
{
    self.navigationItem.title = @"活动中心";
    self.view.backgroundColor = UIColorFromHex(0xEEEFF3);
    self.finishRequest = NO;
    self.pageIndex = 1;
    
    [[XNLeiCaiModule defaultModule] addObserver:self];
    
    //tableView
    self.tableView.rowHeight = 260.f * SCREEN_FRAME.size.width / 375.f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SeekActivityListCell class]) bundle:nil] forCellReuseIdentifier:@"SeekActivityListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XNRedPacketEmptyCell" bundle:nil] forCellReuseIdentifier:@"XNRedPacketEmptyCell"];
    
}

//初始化刷新控件
- (void)setRefreshUI
{
    //刷新加载
    weakSelf(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.finishRequest = NO;
        weakSelf.pageIndex     = 1;
        [weakSelf requestHotActivityDatas];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageIndex = [[[[XNLeiCaiModule defaultModule] seekActivityListModel] pageIndex] integerValue] + 1;
        [weakSelf requestHotActivityDatas];
    }];
    
    //设置自动隐藏加载尾部视图
    [self.tableView.mj_footer setAutomaticallyHidden:YES];
    
    if ([self.view respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

//请求数据
- (void)requestHotActivityDatas
{
    NSString *pageIndex = [NSString stringWithFormat:@"%ld", self.pageIndex];
    [[XNLeiCaiModule defaultModule] requestSeekTreasureActivityListPageIndex:pageIndex pageSize:@"10" AppType:nil];
    
    //[self.view showGifLoading];
}

///////////////////
#pragma mark - 协议方法
////////////////////////

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.finishRequest && self.activityArr.count <= 0) {
        return 1;
    }
    
    return self.activityArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.finishRequest && self.activityArr.count <= 0) {
        XNRedPacketEmptyCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:@"XNRedPacketEmptyCell"];
        [emptyCell showTitle:@"当前没有活动" subTitle:nil];
        return emptyCell;
    }
    
    
    SeekActivityListCell *activityListCell = [tableView dequeueReusableCellWithIdentifier:@"SeekActivityListCell"];
    activityListCell.itemModel = self.activityArr[indexPath.row];
    return activityListCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.activityArr.count <= 0) return SCREEN_FRAME.size.height;
    
    return seek_cell_height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.activityArr.count == 0) {
        return;
    }
    
    SeekActivityItemModel *itemModel = self.activityArr[indexPath.row];
    
    /***
    if ([itemModel.status isEqualToString:@"1"]) {
        return;
    }
     **/
    
    NSDictionary *dic = itemModel.shareContent;
    UniversalInteractWebViewController *webViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:itemModel.linkUrl requestMethod:@"GET"];
    
    NSDictionary *params = @{
                             @"shareTitle" : dic[@"shareTitle"],
                             @"shareDesc"  : dic[@"shareDesc"],
                             @"shareImgurl": [_LOGIC getImagePathUrlWithBaseUrl:[NSObject isValidateObj:dic[@"shareLink"]] ? dic[@"shareLink"] : @""],
                             @"shareLink"  : dic[@"shareLink"]
                             };
    
    
    [webViewController setSharedOpertionWithParams:params];
    
    
    [_UI pushViewControllerFromRoot:webViewController animated:YES];
}

// 4.5.0 获取猎才活动专区（）活动列表
- (void)SeekActivityListModelDidSuccess:(XNLeiCaiModule *)module
{
    //[self.view hideLoading];
    
    self.finishRequest = YES;
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (module.seekActivityListModel.pageIndex.integerValue == 1) {
        [self.activityArr removeAllObjects];
    }
    
    [self.activityArr addObjectsFromArray:module.seekActivityListModel.datas];
    
    if (module.seekActivityListModel.pageIndex.integerValue >= module.seekActivityListModel.pageCount.integerValue) {
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        [self.tableView.mj_footer setHidden:YES];
    }
    
    else
    {
        [self.tableView.mj_footer resetNoMoreData];
//        [self.tableView.mj_footer setHidden:YES];
    }
    
    [self.tableView reloadData];

}

- (void)SeekActivityListModelDidFailed:(XNLeiCaiModule *)module
{
    self.finishRequest = YES;
    
    //[self.view endEditing:YES];
    
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

///////////////////
#pragma mark - setter / getter
////////////////////////

- (NSMutableArray *)activityArr
{
    if (!_activityArr) {
        _activityArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _activityArr;
}


@end
