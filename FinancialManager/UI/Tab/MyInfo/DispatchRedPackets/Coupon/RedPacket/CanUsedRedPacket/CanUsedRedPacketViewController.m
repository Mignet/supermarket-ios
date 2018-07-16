//
//  RedPacketViewController.m
//  FinancialManager
//
//  Created by xnkj on 6/20/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "CanUsedRedPacketViewController.h"
#import "CanUsedRedPacketCell.h"
#import "XNRedPacketEmptyCell.h"

#import "MJRefresh.h"

#import "RedPacketInfoMode.h"
#import "RedPacketListMode.h"
#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"

#define CELLHEIGHT (15 + (140 / 375.0) * SCREEN_FRAME.size.width)
#define DEFAULTPAGEINDEX @"1"
#define DEFAULTPAGESIZE @"30"

@interface CanUsedRedPacketViewController ()<XNMyInformationModuleObserver>

@property (nonatomic, strong) NSString           * deadLine;
@property (nonatomic, strong) NSString           * model;
@property (nonatomic, strong) NSString           * platform;
@property (nonatomic, strong) NSString           * productId;
@property (nonatomic, strong) NSString           * type;//红包类型 1-平台，2-产品
@property (nonatomic, strong) NSMutableArray     * redPacketListArray;

@property (nonatomic, weak) IBOutlet UITableView * redPacketTableView;
@end

@implementation CanUsedRedPacketViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil deadLine:(NSString *)deadLine model:(NSString *)model platform:(NSString *)platform productId:(NSString *)productId type:(NSString *)type
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.deadLine = deadLine;
        self.model = model;
        self.platform = platform;
        self.productId = productId;
        self.type = type;
    }
    return self;
}

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
    self.title = @"可用红包";
    [self.navigationItem addRightBarItemWithTitle:@"使用说明" titleColor:[UIColor whiteColor] target:self action:@selector(redPacketExpain)];
    [[XNMyInformationModule defaultModule] addObserver:self];
    
    [self.redPacketTableView registerNib:[UINib nibWithNibName:@"CanUsedRedPacketCell" bundle:nil] forCellReuseIdentifier:@"CanUsedRedPacketCell"];
    [self.redPacketTableView registerNib:[UINib nibWithNibName:@"XNRedPacketEmptyCell" bundle:nil] forCellReuseIdentifier:@"XNRedPacketEmptyCell"];
    [self.redPacketTableView setSeparatorColor:[UIColor clearColor]];
    
    weakSelf(weakSelf)
    self.redPacketTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [[XNMyInformationModule defaultModule] requestCanUsedRedPacketWithDeadLine:weakSelf.deadLine model:weakSelf.model platform:weakSelf.platform productId:weakSelf.productId type:weakSelf.type PageIndex:DEFAULTPAGEINDEX pageSize:DEFAULTPAGESIZE];
    }];
    self.redPacketTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [[XNMyInformationModule defaultModule] requestCanUsedRedPacketWithDeadLine:weakSelf.deadLine model:weakSelf.model platform:weakSelf.platform productId:weakSelf.productId type:weakSelf.type PageIndex:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[[[XNMyInformationModule defaultModule] canUsedRedPacketListMode] pageIndex] integerValue] + 1]] pageSize:DEFAULTPAGESIZE];
    }];
    [self.redPacketTableView.mj_header beginRefreshing];
    
    if ([self.view respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

//使用说明
- (void)redPacketExpain
{
    UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc]initRequestUrl:[_LOGIC getWebUrlWithBaseUrl:@"/pages/message/redPacketUserManual.html"] requestMethod:@"Get"];
    
    [_UI pushViewControllerFromRoot:webCtrl animated:YES];
}

//////////////////
#pragma mark - 组件回调
////////////////////////////////////

//UITableView 回调
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.redPacketListArray.count <= 0) return 1;
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
        [cell showTitle:@"当前没有可用红包" subTitle:@""];
        
        return cell;
    }
    
    CanUsedRedPacketCell * cell = (CanUsedRedPacketCell *)[tableView dequeueReusableCellWithIdentifier:@"CanUsedRedPacketCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    RedPacketInfoMode * mode = [self.redPacketListArray objectAtIndex:indexPath.row];
    [cell refreshRedPacketInfoWithRedPacketInfoMode:mode];
    
    return cell;
}

//////////////////
#pragma mark - 网络请求回调
////////////////////////////////////

//红包列表
- (void)XNMyInfoModuleCanUsedRedPacketInfoDidReceive:(XNMyInformationModule *)module
{
    [self.redPacketTableView.mj_header endRefreshing];
    [self.redPacketTableView.mj_footer endRefreshing];
    
    if (module.canUsedRedPacketListMode.pageIndex.integerValue == 1) {
        
        [self.redPacketListArray removeAllObjects];
    }
    [self.redPacketListArray addObjectsFromArray:module.canUsedRedPacketListMode.redPacketArray];
    
    if (module.canUsedRedPacketListMode.pageIndex >= module.canUsedRedPacketListMode.pageCount) {
        
        [self.redPacketTableView.mj_footer endRefreshingWithNoMoreData];
    }else
    {
        [self.redPacketTableView.mj_footer resetNoMoreData];
    }
    
    [self.redPacketTableView reloadData];
}

- (void)XNMyInfoModuleCanUsedRedPacketInfoDidFailed:(XNMyInformationModule *)module
{
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
