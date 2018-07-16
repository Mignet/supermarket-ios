//
//  ProductViewController.m
//  FinancialManager
//
//  Created by xnkj on 7/7/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "ProductViewController.h"

#import "ManagerFinancialProgressCell.h"
#import "MFProductListEmptyCell.h"

#import "MJRefresh.h"
#import "UniversalInteractWebViewController.h"
#import "AgentDetailViewController.h"

#import "XNFMProductListItemMode.h"
#import "XNFMProductCategoryListMode.h"
#import "NetworkUnReachStatusView.h"

#import "XNFMProductDetailMode.h"
#import "XNFMProductCategoryStatisticMode.h"
#import "XNFinancialProductModule.h"
#import "XNFinancialProductModuleObserver.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

#define DEFAULTPROGRESSCELLHEIGHT 144.0f
#define DEFAULTPAGEINDEX @"1"
#define DEFAULTPAGESIZE @"10"

@interface ProductViewController ()<XNFinancialProductModuleObserver,UniversalInteractWebViewControllerDelegate,UIScrollViewDelegate,CustomSelectOptionViewDelegate>

@property (nonatomic, assign) BOOL                 isFinishedLoading;
@property (nonatomic, assign) NSInteger            currentSelectedIndex;
@property (nonatomic, strong) NSString           * currentSortTypeStr;  //1表示年化收益，2表示产品期限
@property (nonatomic, strong) NSMutableDictionary* sortTypeValueDic; //年华率、期限、用户类型对应的值
@property (nonatomic, strong) NSMutableDictionary* sortTypeOrderDic;//排序类型顺序
@property (nonatomic, strong) NSArray            * sortLabelArray;
@property (nonatomic, strong) NSArray            * sortButtonArray;
@property (nonatomic, strong) NSArray            * sortImageViewArray;

@property (nonatomic, strong) NSMutableArray     * productMutaArray;

@property (nonatomic, strong) CustomSelectOptionView * selectOptionView;
@property (nonatomic, strong) UIView                 * selectOptionShadowView;

@property (nonatomic, strong) XNFMProductCategoryStatisticMode * staticsMode;
@property (nonatomic, strong) XNFMProductListItemMode *selectedMode;
@property (nonatomic, strong) XNFinancialProductModule * productRequestModule;
@property (nonatomic, strong) UniversalInteractWebViewController * interactWebViewController;
@property (nonatomic, strong) NetworkUnReachStatusView * networkErrorView;

@property (nonatomic, weak) IBOutlet UILabel     * profitSortLabel;
@property (nonatomic, weak) IBOutlet UIImageView * profitSortImageView;
@property (nonatomic, weak) IBOutlet UIButton    * profitSortButton;
@property (nonatomic, weak) IBOutlet UILabel     * timeSortLabel;
@property (nonatomic, weak) IBOutlet UIImageView * timeSortImageView;
@property (nonatomic, weak) IBOutlet UIButton    * timeSortButton;
@property (nonatomic, weak) IBOutlet UILabel     * selectSortLabel;
@property (nonatomic, weak) IBOutlet UIImageView * selectSortImageView;
@property (nonatomic, weak) IBOutlet UIButton    * selectSortButton;

@property (nonatomic, weak) IBOutlet UIButton    * scrollTopButton;
@property (nonatomic, weak) IBOutlet UITableView * productTableView;

@property (nonatomic, assign) BOOL isFirstLoad;

@end

@implementation ProductViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _isFirstLoad = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [_KEYWINDOW addSubview:self.selectOptionShadowView];
    [_KEYWINDOW addSubview:self.selectOptionView];
    self.selectOptionShadowView.hidden = YES;
    self.selectOptionShadowView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.0];
    
    __weak UIWindow * tmpWindow = _KEYWINDOW;
    [self.selectOptionShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpWindow.mas_leading);
        make.top.mas_equalTo(tmpWindow.mas_top);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(SCREEN_FRAME.size.height);
    }];
    
    [self.selectOptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpWindow.mas_trailing);
        make.top.mas_equalTo(tmpWindow.mas_top);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(SCREEN_FRAME.size.height);
    }];
    
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.selectOptionShadowView removeFromSuperview];
    [self.selectOptionView removeFromSuperview];
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [self.productRequestModule removeObserver:self];
    self.productRequestModule = nil;
}

////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////

#pragma mark - 初始化
- (void)initView
{
    self.title = @"网贷";
    
    self.currentSortTypeStr = @"1";
    self.currentSelectedIndex = 0;
    self.isFinishedLoading = NO;
    
    [self.productTableView registerNib:[UINib nibWithNibName:@"ManagerFinancialProgressCell" bundle:nil] forCellReuseIdentifier:@"ManagerFinancialProgressCell"];
    [self.productTableView registerNib:[UINib nibWithNibName:@"MFProductListEmptyCell" bundle:nil] forCellReuseIdentifier:@"MFProductListEmptyCell"];
    [self.productTableView setSeparatorColor:[UIColor clearColor]];
    
    weakSelf(weakSelf)
    self.productTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf.networkErrorView removeFromSuperview];
        if ([_ASSIST getNetworkStatus] == Network_NotReachable) {
        
            [weakSelf.productTableView.mj_header endRefreshing];
            [weakSelf.view addSubview:weakSelf.networkErrorView];
            
            [weakSelf.networkErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.edges.equalTo(weakSelf.view);
            }];
            
            return;
        }

        weakSelf.isFinishedLoading = NO;
        [weakSelf.productRequestModule fmProductListWithYearFlowRate:[weakSelf.sortTypeValueDic objectForKey:@"1"] deadLine:[weakSelf.sortTypeValueDic objectForKey:@"2"]
                                                            userType:[weakSelf.sortTypeValueDic objectForKey:@"ifRookie"] sort:weakSelf.currentSortTypeStr
                                                               order:[weakSelf.sortTypeOrderDic objectForKey:weakSelf.currentSortTypeStr]
                                                           pageIndex:@"1"
                                                            pageSize:DEFAULTPAGESIZE];
    }];
    
    self.productTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf.networkErrorView removeFromSuperview];
        if ([_ASSIST getNetworkStatus] == Network_NotReachable) {
            
            [weakSelf.productTableView.mj_header endRefreshing];
            [weakSelf.view addSubview:weakSelf.networkErrorView];
            
            [weakSelf.networkErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.edges.equalTo(weakSelf.view);
            }];
            
            return;
        }
        
        [weakSelf.productRequestModule fmProductListWithYearFlowRate:[weakSelf.sortTypeValueDic objectForKey:@"1"] deadLine:[weakSelf.sortTypeValueDic objectForKey:@"2"]
                                                            userType:[weakSelf.sortTypeValueDic objectForKey:@"ifRookie"] sort:weakSelf.currentSortTypeStr
                                                               order:[weakSelf.sortTypeOrderDic objectForKey:weakSelf.currentSortTypeStr]
                                                           pageIndex:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[[weakSelf.productRequestModule productListMode] pageIndex] integerValue] + 1]]
                                                            pageSize:DEFAULTPAGESIZE];
    }];
    [self.productTableView.mj_footer setHidden:YES];
    
    [self clickSort:self.profitSortButton];
    
    self.selectOptionView = [[[NSBundle mainBundle] loadNibNamed:@"CustomSelectOptionView" owner:nil options:nil] lastObject];
    self.selectOptionView.conditionOptions = self;
    self.selectOptionShadowView = [[UIView alloc]init];
    self.selectOptionShadowView.hidden = YES;
    self.selectOptionShadowView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.0];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 置顶
- (IBAction)clickToTop:(id)sender
{
    weakSelf(weakSelf)
    [UIView animateWithDuration:0.1 animations:^{
        
        [weakSelf.productTableView setContentOffset:CGPointMake(0, 0)];
    }];
}

#pragma mark - 排序
- (IBAction)clickSort:(id)sender
{
    [XNUMengHelper umengEvent:@"T_2_5"];
    UILabel * tmpLabel = nil;
    UIImageView * tmpImageView = nil;
    for (int i = 0 ; i < self.sortButtonArray.count; i ++ ) {
        
        if ([[self.sortButtonArray objectAtIndex:i] isEqual:sender]) {
            
            self.currentSortTypeStr = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:(i + 1)]];
            tmpLabel = [self.sortLabelArray objectAtIndex:i];
            [tmpLabel setTextColor:UIColorFromHex(0x4e8cef)];
            
            if (i == 1) {
                
                tmpImageView = [self.sortImageViewArray objectAtIndex:i];
                if ([[self.sortTypeOrderDic objectForKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:(i + 1)]]] isEqualToString:@"1"] || [[self.sortTypeOrderDic objectForKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:(i + 1)]]] isEqualToString:@"2"]) {
                    
                    [tmpImageView setImage:[UIImage imageNamed:@"XN_CS_MyCustomer_icon_up.png"]];
                    [self.sortTypeOrderDic setObject:@"0" forKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:(i + 1)]]];
                }else if([[self.sortTypeOrderDic objectForKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:(i + 1)]]] isEqualToString:@"0"])
                {
                    [tmpImageView setImage:[UIImage imageNamed:@"XN_CS_MyCustomer_icon_down.png"]];
                    [self.sortTypeOrderDic setObject:@"1" forKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:(i + 1)]]];
                }
            }
        }else
        {
            tmpLabel = [self.sortLabelArray objectAtIndex:i];
            [tmpLabel setTextColor:UIColorFromHex(0x323232)];
            
            tmpImageView = [self.sortImageViewArray objectAtIndex:i];
            if (i == 1) {
                
                [self.sortTypeOrderDic setObject:@"2" forKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:(i + 1)]]];
                
                [tmpImageView setImage:[UIImage imageNamed:@"XN_CS_MyCustomer_icon_normal.png"]];
            }else if(i == 0)
            {
                [self.sortTypeOrderDic setObject:@"1" forKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:(i + 1)]]];
            }else
            {
                [tmpImageView setImage:[UIImage imageNamed:@"XN_Product_Selected_icon.png"]];
            }
            
        }
    }
    
    //开始进行网络请求
    [self.productTableView.mj_header beginRefreshing];
}

#pragma mark - 筛选
- (IBAction)clickSelectOptions:(id)sender
{
    [XNUMengHelper umengEvent:@"T_2_3"];
    self.selectOptionShadowView.hidden = NO;
    
    __weak UIWindow * tmpWindow = _KEYWINDOW;
    [self.selectOptionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpWindow.mas_leading);
        make.top.mas_equalTo(tmpWindow.mas_top);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(SCREEN_FRAME.size.height);
    }];
    
    weakSelf(weakSelf)
    [UIView animateWithDuration:0.3f animations:^{
        
        [_KEYWINDOW layoutIfNeeded];
        weakSelf.selectOptionShadowView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    }];
}

//////////////////////////////
#pragma mark - protocol Methods
//////////////////////////////////////////

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isFinishedLoading && self.productMutaArray.count <= 0) {
        
        return 1;
    }
    
    return self.productMutaArray.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isFinishedLoading && self.productMutaArray.count <= 0) {
        
        return SCREEN_FRAME.size.height - 64 - 40;
    }
    
    return DEFAULTPROGRESSCELLHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isFinishedLoading && self.productMutaArray.count <= 0) {
        
        MFProductListEmptyCell * emptyCell = [tableView dequeueReusableCellWithIdentifier:@"MFProductListEmptyCell"];
        
        [emptyCell refreshTitle:@"暂无产品"];
        
        return emptyCell;
    }
    
    if ([self.productMutaArray count] > indexPath.row) {
        
        XNFMProductListItemMode * productItemMode = [self.productMutaArray objectAtIndex:(indexPath.row)];
        
        ManagerFinancialProgressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ManagerFinancialProgressCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell refreshDataWithParams:productItemMode section:indexPath.section index:(indexPath.row)];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.productMutaArray.count > 0 && self.productMutaArray.count > indexPath.row && self.isFinishedLoading && indexPath.row >= 0) {
        
        [XNUMengHelper umengEvent:@"T_2_2"];
        
        self.currentSelectedIndex = indexPath.row;
        _selectedMode = [self.productMutaArray objectAtIndex:(indexPath.row)];
        
        NSString * url = [_LOGIC getComposeUrlWithBaseUrl:_selectedMode.openLinkUrl compose:[NSString stringWithFormat:@"productId=%@",_selectedMode.productId]];
        
        UniversalInteractWebViewController * interactWebViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"GET"];
        interactWebViewController.needNewUserGuilder = YES;
        interactWebViewController.delegate = self;
        [interactWebViewController setProductDetailRecommend:_selectedMode];
        [interactWebViewController setNewWebView:YES];
        
        [_UI pushViewControllerFromRoot:interactWebViewController animated:YES];
        
        return;
    }
}

#pragma mark - 产品列表回调
- (void)XNFinancialManagerModuleProductStatisticCategoryListDidReceive:(XNFinancialProductModule *)module
{
    self.isFinishedLoading = YES;
    [self.productTableView.mj_header endRefreshing];
    [self.view hideLoading];
    
    if ([module.productListMode.pageIndex integerValue] == 1) {
        
        [self.productMutaArray removeAllObjects];
    }
    
    [self.productMutaArray addObjectsFromArray:module.productListMode.dataArray];
    
    if ([module.productListMode.pageIndex integerValue] >= [module.productListMode.pageCount integerValue]) {
        
        [self.productTableView.mj_footer endRefreshingWithNoMoreData];
        [self.productTableView.mj_footer setHidden:YES];
    }else
    {
        [self.productTableView.mj_footer resetNoMoreData];
        [self.productTableView.mj_footer setHidden:NO];
    }
    
    [self.productTableView reloadData];
}

- (void)XNFinancialManagerModuleProductStatisticCategoryListDidFailed:(XNFinancialProductModule *)module
{
    self.isFinishedLoading = YES;
    
    [self.productTableView.mj_header endRefreshing];
    [self.view hideLoading];
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

#pragma mark - 请求分享内容
- (void)getProductSharedContentWithProductId:(NSString *)productId
{
    [self.productRequestModule fmGetSharedProductInfoWithProductId:productId];
}

#pragma mark - 佣金计算
- (void)getAppLhlcsCommissionCalc:(NSDictionary *)params
{
    FMComissionCaculateVController * comissionCaculateCtrl = [[FMComissionCaculateVController alloc]initWithNibName:@"FMComissionCaculateViewController" bundle:nil detailMode:_selectedMode];
    
    [_UI pushViewControllerFromRoot:comissionCaculateCtrl animated:YES];
}

#pragma mark - scrollViewDeleate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.scrollTopButton setHidden:YES];
    if (scrollView.contentOffset.y > 187) {
        
        [self.scrollTopButton setHidden:NO];
    }
}

#pragma mark - 进入机构详情
- (void)agentDetailSwitch:(NSString *)agentOrgNumber
{
    NSString *agentNoString = _selectedMode.orgNumber;
    if ([NSObject isValidateInitString:agentOrgNumber]) {
        agentNoString = agentOrgNumber;
        AgentDetailViewController *viewController = [[AgentDetailViewController alloc] initWithNibName:@"AgentDetailViewController" bundle:nil platNo:agentNoString];
        [_UI pushViewControllerFromRoot:viewController animated:YES];
    }
}

#pragma mark - 条件选择
- (void)customSelectOptionViewDidSelectWithYearRate:(NSString *)yearRate deadLine:(NSString *)deadLine type:(NSString *)type
{
    //设置选中的值
    [self.sortTypeValueDic setValue:yearRate forKey:@"1"];
    [self.sortTypeValueDic setValue:deadLine forKey:@"2"];
    [self.sortTypeValueDic setValue:type forKey:@"ifRookie"];
    
    //    [self.selectOptionView resetAction];
    
    [self.productTableView.mj_header beginRefreshing];
    
    __weak UIWindow * tmpWindow = _KEYWINDOW;
    [self.selectOptionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpWindow.mas_trailing);
        make.top.mas_equalTo(tmpWindow.mas_top);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(SCREEN_FRAME.size.height);
    }];
    
    weakSelf(weakSelf)
    [UIView animateWithDuration:0.3f animations:^{
        
        [_KEYWINDOW layoutIfNeeded];
        weakSelf.selectOptionShadowView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        
        weakSelf.selectOptionShadowView.hidden = YES;
    }];
    
    UILabel * tmpLabel = nil;
    UIImageView * tmpImageView = nil;
    for (NSInteger index = 0; index < self.sortLabelArray.count; index ++) {
        
        tmpLabel = [self.sortLabelArray objectAtIndex:index];
        tmpImageView = [self.sortImageViewArray objectAtIndex:index];
        
        if (index == 2) {
            
            [tmpLabel setTextColor:UIColorFromHex(0x4e8cef)];
            [tmpImageView setImage:[UIImage imageNamed:@"XN_Product_Selected_Press_icon.png"]];
        }else
        {
            [tmpLabel setTextColor:UIColorFromHex(0x323232)];
            if (index != 0)
                [tmpImageView setImage:[UIImage imageNamed:@"XN_CS_MyCustomer_icon_normal.png"]];
        }
    }
}

#pragma mark - 退出
- (void)exitView
{
    __weak UIWindow * tmpWindow = _KEYWINDOW;
    [self.selectOptionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpWindow.mas_trailing);
        make.top.mas_equalTo(tmpWindow.mas_top);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(SCREEN_FRAME.size.height);
    }];
    
    weakSelf(weakSelf)
    [UIView animateWithDuration:0.3f animations:^{
        
        [_KEYWINDOW layoutIfNeeded];
        weakSelf.selectOptionShadowView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        
        weakSelf.selectOptionShadowView.hidden = YES;
    }];
    
}

/////////////////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

#pragma mark - sortUpDownDic
- (NSMutableDictionary *)sortTypeValueDic
{
    if (!_sortTypeValueDic) {
        
        _sortTypeValueDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"dRa",@"1",@"dLa",@"2",@"0",@"ifRookie", nil];
    }
    return _sortTypeValueDic;
}

- (NSMutableDictionary *)sortTypeOrderDic
{
    if (!_sortTypeOrderDic) {
        
        _sortTypeOrderDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"1",@"1",@"0",@"2",@"1",@"ifRookie", nil];
    }
    
    return _sortTypeOrderDic;
}

#pragma mark - sortLabelArray
- (NSArray *)sortLabelArray
{
    if (!_sortLabelArray) {
        
        _sortLabelArray = [[NSArray alloc]initWithObjects:self.profitSortLabel,self.timeSortLabel,self.selectSortLabel, nil];
    }
    return _sortLabelArray;
}

#pragma mark - sortImageViewArray
- (NSArray *)sortImageViewArray
{
    if (!_sortImageViewArray) {
        
        _sortImageViewArray = [[NSArray alloc]initWithObjects:@"",self.timeSortImageView,self.selectSortImageView, nil];
    }
    return _sortImageViewArray;
}

#pragma mark - sortButtonArray
- (NSArray *)sortButtonArray
{
    if (!_sortButtonArray) {
        
        _sortButtonArray = [[NSArray alloc]initWithObjects:self.profitSortButton,self.timeSortButton,self.selectSortButton, nil];
    }
    return _sortButtonArray;
}

#pragma mark - productMutaArray
- (NSMutableArray *)productMutaArray
{
    if (!_productMutaArray) {
        
        _productMutaArray = [[NSMutableArray alloc]init];
    }
    return _productMutaArray;
}

#pragma mark-  productRequestModule
- (XNFinancialProductModule *)productRequestModule
{
    if (!_productRequestModule) {
        
        _productRequestModule = [[XNFinancialProductModule alloc]init];
        [_productRequestModule addObserver:self];
    }
    
    return _productRequestModule;
}

//无网络视图
- (NetworkUnReachStatusView *)networkErrorView
{
    if (!_networkErrorView) {
        
        _networkErrorView = [[NetworkUnReachStatusView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
        weakSelf(weakSelf)
        [_networkErrorView setNetworkRetryOperation:^{
            
            [weakSelf.productTableView.mj_header beginRefreshing];
        }];
    }
    return _networkErrorView;
}

@end
