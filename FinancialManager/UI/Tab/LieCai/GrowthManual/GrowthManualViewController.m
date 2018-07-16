//
//  GrowthManualViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/31/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "GrowthManualViewController.h"
#import "GrowthManualCategoryViewController.h"
#import "MFSystemInvitedEmptyCell.h"
#import "GrowthManualHeaderCell.h"
#import "GrowthManualCategoryCell.h"

#import "XNLeiCaiModule.h"
#import "XNLeiCaiModuleObserver.h"
#import "XNGrowthManualListMode.h"
#import "XNGrowthManualCategoryItemMode.h"

#define HEADER_CELL_HEIGHT 233.0f
#define SECTION_VIEW_HEIGHT 46.0f

@interface GrowthManualViewController ()<XNLeiCaiModuleObserver, GrowthManualHeaderCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *sectionView;

@property (nonatomic, strong) NSMutableArray *datasArray;
@property (nonatomic, strong) XNGrowthManualListMode *categoryMode;

@end

@implementation GrowthManualViewController

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
    
    [[XNLeiCaiModule defaultModule] addObserver:self];
    
    [_tableView registerNib:[UINib nibWithNibName:@"GrowthManualHeaderCell" bundle:nil] forCellReuseIdentifier:@"GrowthManualHeaderCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MFSystemInvitedEmptyCell" bundle:nil] forCellReuseIdentifier:@"MFSystemInvitedEmptyCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"GrowthManualCategoryCell" bundle:nil] forCellReuseIdentifier:@"GrowthManualCategoryCell"];
    
    weakSelf(weakSelf)
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
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
    [[XNLeiCaiModule defaultModule] requestGrowthManualCategory];
    [[XNLeiCaiModule defaultModule] requestPersonalCustomList];
    
}

////////////////////
#pragma mark - Protocol Method
////////////////////////////////////////////

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || self.datasArray.count <= 0)
    {
        return 1;
    }
    
    return self.datasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0)
    {
        static NSString *cellIdentifierString = @"GrowthManualHeaderCell";
        GrowthManualHeaderCell *cell = (GrowthManualHeaderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
        cell.delegate = self;
        if (self.categoryMode && self.categoryMode.datas.count > 0)
        {
            [cell showDatas:self.categoryMode.datas];
        }
        
        return cell;
    }
    
    if (self.datasArray.count <= 0)
    {
        MFSystemInvitedEmptyCell *emptyCell = (MFSystemInvitedEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"MFSystemInvitedEmptyCell"];
        [emptyCell refreshTitle:@"暂无推荐内容"];
        
        [emptyCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return emptyCell;
    }
    
    static NSString *cellIdentifierString = @"GrowthManualCategoryCell";
    GrowthManualCategoryCell *cell = (GrowthManualCategoryCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
 
    [cell showDatas:[self.datasArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0)
    {
        return HEADER_CELL_HEIGHT;
    }
    
    if (self.datasArray.count <= 0)
    {
        return SCREEN_FRAME.size.height - HEADER_CELL_HEIGHT - SECTION_VIEW_HEIGHT;
    }
    
    XNGrowthManualCategoryItemMode *mode = [self.datasArray objectAtIndex:[indexPath row]];
    //计算字的高度
    CGFloat fHeight = [mode.title getSpaceLabelHeightWithFont:16 withWidth:(SCREEN_FRAME.size.width - 35 - 93) lineSpacing:5] + 20;
    
    return fHeight + 42;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    return SECTION_VIEW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    
    UIView *view = [[UIView alloc] init];
    [view addSubview:self.sectionView];
    __weak UIView *weakView = view;
    [self.sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakView);
    }];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0)
    {
        return;
    }
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger nRow = [indexPath row];
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XNGrowthManualCategoryItemMode *mode = [self.datasArray objectAtIndex:nRow];
    NSString *urlString = [NSString stringWithFormat:@"%@/pages/guide/handbook.html?id=%@",[AppFramework getConfig].XN_REQUEST_H5_BASE_URL, mode.nId];
    UniversalInteractWebViewController *viewController = [[UniversalInteractWebViewController alloc] initRequestUrl:urlString requestMethod:@"GET"];

    [viewController setNewWebView:YES];
    
    [viewController setSharedOpertionWithParams:[NSDictionary dictionaryWithObjectsAndKeys:mode.title,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_TITLE,
                                                 mode.summary,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_DESC,
                                                 urlString,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_URL,
                                                 [_LOGIC getImagePathUrlWithBaseUrl:mode.shareIcon],XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_IMGURL, nil]];
    
    [_UI pushViewControllerFromRoot:viewController animated:YES];
    
    
}

#pragma mark - GrowthManualHeaderCellDelegate
- (void)growthManualHeaderCellDidClick:(XNGrowthManualCategoryMode *)mode
{
    //跳转到分类页面
    GrowthManualCategoryViewController *viewController = [[GrowthManualCategoryViewController alloc] initWithNibName:@"GrowthManualCategoryViewController" bundle:nil cateMode:mode];
    [_UI pushViewControllerFromRoot:viewController animated:YES];
}

#pragma mark - 成长手册分类
- (void)XNLeiCaiModuleGrowthManualCategoryDidSuccess:(XNLeiCaiModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    self.categoryMode = module.growthManualCategoryMode;
    
    
    [self.tableView reloadData];
}

- (void)XNLeiCaiModuleGrowthManualCategoryDidFailed:(XNLeiCaiModule *)module
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

#pragma mark - 个人定制列表
- (void)XNLeiCaiModulePersonalCustomListDidSuccess:(XNLeiCaiModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    XNGrowthManualListMode *mode = module.personalCustomListMode;
    if (mode)
    {
        [self.datasArray removeAllObjects];
    }
    
    [self.datasArray addObjectsFromArray:mode.datas];
    [self.tableView reloadData];
}

- (void)XNLeiCaiModulePersonalCustomListDidFailed:(XNLeiCaiModule *)module
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
