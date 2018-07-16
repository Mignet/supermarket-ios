//
//  GrowthManualCategoryViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/31/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "GrowthManualCategoryViewController.h"
#import "MFSystemInvitedEmptyCell.h"
#import "GrowthManualCategoryCell.h"
#import "GrowthManualCategoryBannerCell.h"

#import "XNGrowthManualCategoryMode.h"
#import "XNLeiCaiModule.h"
#import "XNLeiCaiModuleObserver.h"
#import "XNGrowthManualListMode.h"
#import "XNGrowthManualCategoryItemMode.h"

#define BANNER_HEIGHT 90.0f

@interface GrowthManualCategoryViewController ()<XNLeiCaiModuleObserver, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) XNGrowthManualCategoryMode *cateMode;
@property (nonatomic, strong) NSMutableArray *datasArray;
@property (nonatomic, assign) NSInteger nPageIndex;
@property (nonatomic, strong) NSString *bannerString;

@end

@implementation GrowthManualCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil cateMode:(XNGrowthManualCategoryMode *)cateMode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.cateMode = cateMode;
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
    self.title = @"成长手册";
    self.nPageIndex = 1;
    [[XNLeiCaiModule defaultModule] addObserver:self];
    [_tableView registerNib:[UINib nibWithNibName:@"GrowthManualCategoryBannerCell" bundle:nil] forCellReuseIdentifier:@"GrowthManualCategoryBannerCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MFSystemInvitedEmptyCell" bundle:nil] forCellReuseIdentifier:@"MFSystemInvitedEmptyCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"GrowthManualCategoryCell" bundle:nil] forCellReuseIdentifier:@"GrowthManualCategoryCell"];
    
    weakSelf(weakSelf)
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.nPageIndex --;
        [weakSelf loadDatas];
        
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.nPageIndex ++;
        [weakSelf loadDatas];
    }];
    
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
    [[XNLeiCaiModule defaultModule] requestGrowthManualCategoryListWithPageIndex:[NSString stringWithFormat:@"%ld", self.nPageIndex] pageSize:@"10" typeCode:self.cateMode.cateId];
    
}

////////////////////
#pragma mark - Protocol Method
////////////////////////////////////////////

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.datasArray.count <= 0)
    {
        return 2;
    }
    
    return self.datasArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = indexPath.row;
    
    if (nRow == 0)
    {
        static NSString *cellIdentifierString = @"GrowthManualCategoryBannerCell";
        GrowthManualCategoryBannerCell *cell = (GrowthManualCategoryBannerCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
        [cell showBanner:self.bannerString];
        
        return cell;
    }
    
    if (self.datasArray.count <= 0)
    {
        MFSystemInvitedEmptyCell *emptyCell = (MFSystemInvitedEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"MFSystemInvitedEmptyCell"];
        [emptyCell refreshTitle:@"暂无内容"];
        
        [emptyCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return emptyCell;
    }
    
    static NSString *cellIdentifierString = @"GrowthManualCategoryCell";
    GrowthManualCategoryCell *cell = (GrowthManualCategoryCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
    
    [cell showDatas:[self.datasArray objectAtIndex:nRow - 1]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = indexPath.row;
    if (nRow == 0)
    {
        return BANNER_HEIGHT;
    }
    
    if (self.datasArray.count <= 0)
    {
        return SCREEN_FRAME.size.height - BANNER_HEIGHT;
    }
    
    XNGrowthManualCategoryItemMode *mode = [self.datasArray objectAtIndex:nRow - 1];
    //计算字的高度
    CGFloat fHeight = [mode.title getSpaceLabelHeightWithFont:16 withWidth:(SCREEN_FRAME.size.width - 35 - 93) lineSpacing:5] + 20;
    
    return fHeight + 42;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = [indexPath row];
    if (nRow == 0)
    {
        return;
    }
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XNGrowthManualCategoryItemMode *mode = [self.datasArray objectAtIndex:nRow - 1];
    NSString *urlString = [NSString stringWithFormat:@"%@/pages/guide/handbook.html?id=%@",[AppFramework getConfig].XN_REQUEST_H5_BASE_URL, mode.nId];
    UniversalInteractWebViewController *viewController = [[UniversalInteractWebViewController alloc] initRequestUrl:urlString requestMethod:@"GET"];

    [viewController setNewWebView:YES];
    
    [viewController setSharedOpertionWithParams:[NSDictionary dictionaryWithObjectsAndKeys:mode.title,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_TITLE,
                                                    mode.summary,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_DESC,
                                                    urlString,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_URL,
                                                    [_LOGIC getImagePathUrlWithBaseUrl:mode.shareIcon],XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_IMGURL, nil]];
    
    [_UI pushViewControllerFromRoot:viewController animated:YES];
    
}



#pragma mark - 分类列表
- (void)XNLeiCaiModuleGrowthManualCategoryListDidSuccess:(XNLeiCaiModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    XNGrowthManualListMode *mode = module.growthManualCategoryListMode;
    self.bannerString = mode.bannerImg;
    self.nPageIndex = [mode.pageIndex integerValue];
    if (self.nPageIndex == 1)
    {
        [self.datasArray removeAllObjects];
    }
    
    if (mode.datas.count > 0)
    {
        [self.datasArray addObjectsFromArray:mode.datas];
    }
    
    if (self.nPageIndex >= [mode.pageCount integerValue])
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        self.tableView.mj_footer.hidden = YES;
    }
    else
    {
        [self.tableView.mj_footer resetNoMoreData];
        self.tableView.mj_footer.hidden = NO;
    }
    
    [self.tableView reloadData];
    
}

- (void)XNLeiCaiModuleGrowthManualCategoryListDidFailed:(XNLeiCaiModule *)module
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

@end
