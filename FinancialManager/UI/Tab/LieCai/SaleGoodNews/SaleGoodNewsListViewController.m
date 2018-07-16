//
//  SaleGoodNewsListViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/26/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "SaleGoodNewsListViewController.h"
#import "SaleGoodNewsDetailViewController.h"
#import "XNInvitedPopViewController.h"
#import "UINavigationItem+Extension.h"
#import "MFSystemInvitedEmptyCell.h"
#import "SaleGoodNewsCell.h"
#import "XNLeiCaiModule.h"
#import "XNLeiCaiModuleObserver.h"
#import "XNLCSaleGoodNewsListMode.h"
#import "XNLCSaleGoodNewsItemMode.h"

#define fLeftPadding 15.0f
#define fTopPadding 15.0f

@interface SaleGoodNewsListViewController ()<SaleGoodNewsCellDelegate, XNLeiCaiModuleObserver,XNInvitedPopViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger nPageIndex;
@property (nonatomic, strong) NSMutableArray *datasArray;
@property (nonatomic, strong) NSString *sort; //排序
@property (nonatomic, strong) XNLCSaleGoodNewsItemMode *selectdItemMode;
@property (nonatomic, strong) XNInvitedPopViewController *invitedPopViewController;
@property (nonatomic, assign) BOOL havedShowPopView;

@end

@implementation SaleGoodNewsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.invitedPopViewController.view setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
}

/////////////////
#pragma mark - 自定义
/////////////////////////////////

//初始化
- (void)initView
{
    self.title = @"全部";
    [self.navigationItem addRightBarItemWithTitle:@"排序" titleColor:[UIColor whiteColor] target:self action:@selector(sortAction)];
    self.nPageIndex = 1;
    self.sort = @"2"; //默认时间排序
    [[XNLeiCaiModule defaultModule] addObserver:self];
    self.havedShowPopView = NO;
    [self.view addSubview:self.invitedPopViewController.view];
     weakSelf(weakSelf)
    [self.invitedPopViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MFSystemInvitedEmptyCell" bundle:nil] forCellReuseIdentifier:@"MFSystemInvitedEmptyCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SaleGoodNewsCell" bundle:nil] forCellReuseIdentifier:@"SaleGoodNewsCell"];
    
   
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.nPageIndex --;
        [weakSelf loadDatas];
        
    }];
    
//    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        weakSelf.nPageIndex ++;
//        [weakSelf loadDatas];
//    }];
    
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.nPageIndex ++;
        [weakSelf loadDatas];
    }];
    
    [footer setTitle:@"仅展示最近半年的出单喜报" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    footer.stateLabel.textColor = UIColorFromHex(0x999999);
    
    _tableView.mj_footer = footer;
    
    
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
    [[XNLeiCaiModule defaultModule] requestSaleGoodNewsListWithPageIndex:[NSString stringWithFormat:@"%ld", self.nPageIndex] pageSize:@"10" sort:self.sort];
}

#pragma mark - 排序
- (void)sortAction
{
    if (!self.havedShowPopView)
    {
        self.havedShowPopView = YES;
        [self.invitedPopViewController show];
    }
    else
    {
        self.havedShowPopView = NO;
        [self.invitedPopViewController hide];
    }
}

#pragma mark - 生成喜报
- (IBAction)gotoDetailAction:(id)sender
{
    if (self.selectdItemMode == nil)
    {
        [self.view showCustomWarnViewWithContent:@"请选择一张喜报"];
        return;
    }
    SaleGoodNewsDetailViewController *viewController = [[SaleGoodNewsDetailViewController alloc] initWithNibName:@"SaleGoodNewsDetailViewController" bundle:nil billId:self.selectdItemMode.billId];
    [_UI pushViewControllerFromRoot:viewController animated:YES];
}

////////////////////
#pragma mark - UITableView Delegate
////////////////////////////////////////////

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datasArray.count <= 0)
    {
        MFSystemInvitedEmptyCell *emptyCell = (MFSystemInvitedEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"MFSystemInvitedEmptyCell"];
        [emptyCell refreshTitle:@"暂无出单喜报"];
        
        [emptyCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return emptyCell;
    }
    
    static NSString *cellIdentifierString = @"SaleGoodNewsCell";
    SaleGoodNewsCell *cell = (SaleGoodNewsCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
    cell.delegate = self;
    [cell showDatas:self.datasArray selectedMode:self.selectdItemMode];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datasArray.count <= 0)
    {
        return SCREEN_FRAME.size.height - 50 - 30;
    }
    
    float fTopBottomPadding = fTopPadding; //上下间距
//    float fPicWidth = (SCREEN_FRAME.size.width - fLeftPadding * 3) / 2;
    float fPicHeight = 97;//fPicWidth * 130 / 207;
    //总行数
    NSInteger nRow = self.datasArray.count % 2 == 0 ? self.datasArray.count / 2 : self.datasArray.count / 2 + 1;
    //总高度
    float fTotalHeight = fPicHeight * nRow + fTopBottomPadding * (nRow - 1) + 30;
    
    if (fTotalHeight < SCREEN_FRAME.size.height - 50 - 30)
    {
        return SCREEN_FRAME.size.height - 50 - 30;
    }
    
    return fTotalHeight;
}

#pragma mark - SaleGoodNewsCellDelegate
- (void)saleGoodNewsCellDidClick:(XNLCSaleGoodNewsItemMode *)itemMode
{
    self.selectdItemMode = itemMode;
}

#pragma mark - XNInvitedPopViewDelegate
- (void)XNInvitedPopViewDidSelectedAtIndex:(NSInteger)index
{
    self.sort = [NSString stringWithFormat:@"%ld", (index + 1)];
    self.nPageIndex = 1;
    [self loadDatas];
    [self.view showGifLoading];
}

#pragma mark -往期喜报
- (void)XNLeiCaiModuleSaleGoodNewsListDidSuccess:(XNLeiCaiModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    XNLCSaleGoodNewsListMode *mode = module.saleGoodNewsListMode;
    self.nPageIndex = [mode.pageIndex integerValue];
    if (self.nPageIndex == 1)
    {
        [self.datasArray removeAllObjects];
    }
    
    if (mode.datas.count > 0)
    {
        [self.datasArray addObjectsFromArray:mode.datas];
        if (self.nPageIndex == 1)
        {
            self.selectdItemMode = [self.datasArray firstObject];
        }
    }
    
    if (self.nPageIndex >= [mode.pageCount integerValue])
    {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
    else
    {
        [_tableView.mj_footer resetNoMoreData];
    }
    
    [self.tableView reloadData];
    
}

- (void)XNLeiCaiModuleSaleGoodNewsListDidFailed:(XNLeiCaiModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
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
    if (_datasArray == nil)
    {
        _datasArray = [[NSMutableArray alloc] init];
    }
    return _datasArray;
}

#pragma mark - invitedPopViewController
- (XNInvitedPopViewController *)invitedPopViewController
{
    if (!_invitedPopViewController)
    {
        _invitedPopViewController = [[XNInvitedPopViewController alloc]initWithDelegate:self titlesArray:@[@"出单金额排序",@"出单时间排序"] AndIconsArray:@[@"",@""]];
    }
    return _invitedPopViewController;
}

@end
