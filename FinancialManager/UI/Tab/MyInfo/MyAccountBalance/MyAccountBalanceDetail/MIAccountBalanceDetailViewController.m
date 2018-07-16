//
//  MIAccountBalanceDetailViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 2/8/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MIAccountBalanceDetailViewController.h"
#import "MIAccountBalanceDetailListViewController.h"

#import "MIAccountBalanceCommonMode.h"
#import "XNMyProfitModule.h"
#import "XNMyProfitModuleObserver.h"
#import "MIAccountBalanceDetailMode.h"
#import "MIAccountBalanceDetailItemMode.h"

#define HEADER_CELL_DEFAULT_HEIGHT 159.0f
#define SECTION_DEFAULT_HEIGHT 46.0f
#define LITTLE_CELL_DEFAULT_HEIGHT 100.0f

#define NEWWIDTH (SCREEN_FRAME.size.width / self.titleArray.count)
#define DEFAULTTITLEWIDTH (self.titleArray.count>=4?80 * (SCREEN_FRAME.size.width / 320):NEWWIDTH)
#define DEFAULTTITLEHEIGHT 40.0f
#define DEFAULTTAG 0x111111

#define TITLE_SELECTED_COLOR UIColorFromHex(0x02a0f2)
#define TITLE_NORMAL_COLOR UIColorFromHex(0x6c6e6d)

@interface MIAccountBalanceDetailViewController ()<XNMyProfitModuleObserver, MIAccountBalanceDetailListViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *headerCellView;
@property (nonatomic, strong) IBOutlet UILabel *accountBalanceLabel; //账户余额
@property (nonatomic, strong) IBOutlet UILabel *totalIncomeLabel; //累计收入
@property (nonatomic, strong) IBOutlet UILabel *totalSpendingLabel; //累计支出

@property (nonatomic, strong) IBOutlet UIScrollView * headContainerScrollView;
@property (nonatomic, strong) IBOutlet UIScrollView * titleContainerScrollView;
@property (nonatomic, strong) UIScrollView * contentContainerScrollView;

@property (nonatomic, strong) UIView              * cursorView;

@property (nonatomic, strong) NSMutableArray      * titleArray;
@property (nonatomic, strong) NSMutableArray      * contentCtrlArray;
@property (nonatomic, strong) NSMutableArray      * titleObjArray;

@property (nonatomic, assign) NSInteger           selectedIndex;

@property (nonatomic, strong) MIAccountBalanceCommonMode *mode;

@property (nonatomic, assign) NSInteger nPageIndex; //当前页码
@property (nonatomic, assign) NSInteger nPageSize; //每页显示数
@property (nonatomic, assign) NSInteger nPageCount; //总页数

@property (nonatomic, strong) NSMutableArray *totalDetailArray; //全部明细数组
@property (nonatomic, strong) NSMutableArray *incomeDetailArray; //收入明细数组
@property (nonatomic, strong) NSMutableArray *outDetailArray; //支出明细数组
@property (nonatomic, strong) NSMutableArray *commonDatasArray; //用于临时存储 全部／收入／支出数据

@property (nonatomic, assign) float fTotalDetailHeight; //全部明细
@property (nonatomic, assign) float fIncomeDetailHeight; //收入明细
@property (nonatomic, assign) float fOutDetailHeight; //支出明细

@property (nonatomic, assign) float fCellTotalHeight;
@property (nonatomic, strong) NSIndexPath *updateIndexPath;

@end

@implementation MIAccountBalanceDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (BOOL)willDealloc
{
    return NO;
}

- (void)dealloc
{
    [[XNMyProfitModule defaultModule] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//////////////////////////////////
#pragma mark - Custom Method
//////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.title = @"资金明细";
    _nPageIndex = 1;
    _nPageSize = 10;
    [[XNMyProfitModule defaultModule] addObserver:self];
    [self loadDatas];
    
    weakSelf(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _nPageIndex = 1;
        [weakSelf loadListDatas];
        [self.view showGifLoading];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        switch (weakSelf.selectedIndex) {
            case 0: //全部明细
                _nPageIndex = [[[XNMyProfitModule defaultModule] totalDetailListMode] pageIndex];
                
                break;
            case 1: //收入明细
                _nPageIndex = [[[XNMyProfitModule defaultModule] incomeDetailListMode] pageIndex];
                
                break;
            case 2: //支出明细
                _nPageIndex = [[[XNMyProfitModule defaultModule] outDetailListMode] pageIndex];
                
                break;
            default:
                break;
        }
        _nPageIndex ++;
        [weakSelf loadListDatas];
    }];
    
    [self.tableView.mj_footer setHidden:YES];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)loadDatas
{
    [[XNMyProfitModule defaultModule] getAccountBalanceDetail];
    [self.view showGifLoading];
}

- (void)loadListDatas
{
    if (_nPageIndex < 1)
    {
        _nPageIndex = 1;
    }
    
    [[XNMyProfitModule defaultModule] getAccountBalanceDetailList:[NSString stringWithFormat:@"%ld", _nPageIndex] pageSize:[NSString stringWithFormat:@"%ld", _nPageSize] typeValue:[NSString stringWithFormat:@"%ld", _selectedIndex]];
}

#pragma mark - 构建视图
- (void)buildView
{
    [self.headContainerScrollView addSubview:self.cursorView];
    [self.titleContainerScrollView setContentSize:CGSizeMake(DEFAULTTITLEWIDTH * self.titleArray.count, 0)];
    
    weakSelf(weakSelf)
    //构建title
    UIButton * titleButton = nil;
    UIButton * lastTitleButton = nil;
    for (NSInteger i = 0; i < self.titleArray.count; i++ )
    {
        titleButton = [[UIButton alloc]initWithFrame:CGRectMake(i *  DEFAULTTITLEWIDTH, 0, DEFAULTTITLEWIDTH, DEFAULTTITLEHEIGHT)];
        [titleButton setTag:i+DEFAULTTAG];
        [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
        [titleButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleButton setTitle:[self.titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [titleButton setTitleColor:i==self.selectedIndex? TITLE_SELECTED_COLOR :TITLE_NORMAL_COLOR forState:UIControlStateNormal];
        [titleButton addTarget:self action:@selector(selectedOption:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleContainerScrollView addSubview:titleButton];
        [self.titleObjArray addObject:titleButton];
        
        __weak UIScrollView * tmpTitleScrollView = self.titleContainerScrollView;
        __weak UIButton     * tmpLastButton = lastTitleButton;
        [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (i == 0)
            {
                make.leading.mas_equalTo(tmpTitleScrollView.mas_leading);
            }else if(i == [weakSelf.titleArray count] - 1)
            {
                make.leading.mas_equalTo(tmpLastButton.mas_trailing);
                make.trailing.mas_equalTo(tmpTitleScrollView.mas_trailing);
            }else
            {
                make.leading.mas_equalTo(tmpLastButton.mas_trailing);
            }
            
            make.top.mas_equalTo(tmpTitleScrollView.mas_top);
            make.bottom.mas_equalTo(tmpTitleScrollView.mas_bottom);
            make.width.mas_equalTo(DEFAULTTITLEWIDTH);
        }];
        lastTitleButton = titleButton;
        
        if (i == self.selectedIndex)
        {
            tmpLastButton = lastTitleButton;
            __weak UIScrollView * tmpScrollView = self.headContainerScrollView;
            [self.cursorView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.mas_equalTo(tmpLastButton.mas_centerX);
                make.bottom.mas_equalTo(tmpScrollView.mas_bottom);
                make.width.mas_equalTo(DEFAULTTITLEWIDTH * 0.8);
                make.height.mas_equalTo(@(2));
            }];
        }
        
    }
    
    //构建内容视图
    UIViewController * lastCtrl = nil;
    for (NSInteger i = 0 ; i < self.contentCtrlArray.count ; i ++ ) {
        
        UIViewController * ctrl = [self.contentCtrlArray objectAtIndex:i];
        ctrl.view.frame = CGRectMake(i * SCREEN_FRAME.size.width , 0, SCREEN_FRAME.size.width, self.contentContainerScrollView.frame.size.height);
        [self.contentContainerScrollView addSubview:ctrl.view];
        [self addChildViewController:ctrl];
        
        __weak UIViewController * tmpLastCtrl = lastCtrl;
        __weak UIScrollView     * tmpCtrlContainerScrollView = self.contentContainerScrollView;
        [ctrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (i == 0)
                make.leading.mas_equalTo(tmpCtrlContainerScrollView.mas_leading);
            else if(i == weakSelf.contentCtrlArray.count - 1)
            {
                make.leading.mas_equalTo(tmpLastCtrl.view.mas_trailing);
                make.trailing.mas_equalTo(tmpCtrlContainerScrollView.mas_trailing);
            }
            else
                make.leading.mas_equalTo(tmpLastCtrl.view.mas_trailing);
            
            make.top.mas_equalTo(tmpCtrlContainerScrollView.mas_top);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.equalTo(tmpCtrlContainerScrollView);
            make.bottom.mas_equalTo(tmpCtrlContainerScrollView.mas_bottom);
        }];
        lastCtrl = ctrl;
    }
    
    [self.view layoutIfNeeded];
    
    //默认跳转到指定的位置
    [self.contentContainerScrollView setContentOffset:CGPointMake(SCREEN_FRAME.size.width * self.selectedIndex, 0)];
}

#pragma mark - 选中操作
- (void)selectedOption:(UIButton *)sender
{
    NSInteger index = [self.titleObjArray indexOfObject:sender];
    _selectedIndex = index;
    switch (index) {
        case 0: //全部明细
            _fCellTotalHeight = _fTotalDetailHeight;
            if (self.totalDetailArray.count <= 0)
            {
                _nPageIndex = 1;
                [self loadListDatas];
            }
            break;
        case 1: //收入明细
            _fCellTotalHeight = _fIncomeDetailHeight;
            if (self.incomeDetailArray.count <= 0)
            {
                _nPageIndex = 1;
                [self loadListDatas];
            }
            
            break;
        case 2: //支出明细
            _fCellTotalHeight = _fOutDetailHeight;
            if (self.outDetailArray.count <= 0)
            {
                _nPageIndex = 1;
                [self loadListDatas];
            }
            break;
            
        default:
            break;
    }
    [self.tableView reloadRowsAtIndexPaths:@[self.updateIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    for (UIButton * titleButton in self.titleObjArray)
    {
        if ([titleButton isEqual:sender])
        {
            [titleButton setTitleColor:TITLE_SELECTED_COLOR forState:UIControlStateNormal];
        }
        else
        {
            [titleButton setTitleColor:TITLE_NORMAL_COLOR forState:UIControlStateNormal];
        }
    }
    
    __weak UIScrollView * tmpScrollView = self.headContainerScrollView;
    __weak UIButton * titleButtonTmp = sender;
    [self.cursorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(titleButtonTmp.mas_centerX);
        make.bottom.mas_equalTo(tmpScrollView.mas_bottom);
        make.width.mas_equalTo(DEFAULTTITLEWIDTH * 0.8);
        make.height.mas_equalTo(@(2));
    }];
    
    [UIView animateWithDuration:VIEWANIMATIONDURATION animations:^{
        
        [self.view layoutIfNeeded];
        [self.contentContainerScrollView setContentOffset:CGPointMake(index*SCREEN_FRAME.size.width, 0)];
        
    }];
}

#pragma mark - 计算cell高度
- (void)calcCellTotalHeight
{
    float fTmpHeight = 0.0f;
    _fCellTotalHeight = 0.0f;
    
    for (MIAccountBalanceDetailItemMode *mode in self.commonDatasArray)
    {
        //计算字的高度
        CGFloat fHeight = [mode.remark getSpaceLabelHeightWithFont:12 withWidth:SCREEN_FRAME.size.width - 24 lineSpacing:5] + 5;
        
        fTmpHeight = LITTLE_CELL_DEFAULT_HEIGHT - 25 + fHeight;
        _fCellTotalHeight += fTmpHeight;
    }
    
    if (self.commonDatasArray.count * 87 + 10 < SCREEN_FRAME.size.height - 201)
    {
        _fCellTotalHeight = SCREEN_FRAME.size.height - 201;
    }
    
    switch (_selectedIndex) {
        case 0: //全部明细
            _fTotalDetailHeight = _fCellTotalHeight;
            break;
        case 1: //收入明细
            _fIncomeDetailHeight = _fCellTotalHeight;
            break;
        case 2: //支出明细
            _fOutDetailHeight = _fCellTotalHeight;
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[self.updateIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

//////////////////////////////
#pragma mark - protocol Methods
//////////////////////////////////////////

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nSection = indexPath.section;
    if (nSection == 0)
    {
        static NSString *cellIdentifierString = @"UITableViewHeaderCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifierString];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:self.headerCellView];
        
        __weak UITableViewCell *weakCell = cell;
        self.headerCellView.backgroundColor = JFZ_COLOR_BLUE;
        [self.headerCellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakCell);
        }];
        return cell;
    }
    
    static NSString *cellIdentifierString = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifierString];
    }
    [self.contentContainerScrollView removeFromSuperview];
    [cell addSubview:self.contentContainerScrollView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentContainerScrollView.delegate = self;
    __weak UITableViewCell *weakCell = cell;
    [self.contentContainerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakCell);
    }];
    
    self.updateIndexPath = indexPath;
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float fHeight = HEADER_CELL_DEFAULT_HEIGHT;
    if ([indexPath section] == 0)
    {
        return fHeight;
    }
    
    if (_fCellTotalHeight <= 0)
    {
        _fCellTotalHeight = SCREEN_FRAME.size.height - fHeight;
    }
    
    return _fCellTotalHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    return SECTION_DEFAULT_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    if (section == 0)
    {
        return nil;
    }
    [view addSubview:self.headContainerScrollView];
    __weak UIView *weakView = view;
    [self.headContainerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakView);
    }];
    return view;
}

#pragma mark - uiscrollview
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.contentContainerScrollView])
    {
        NSInteger index = (int)scrollView.contentOffset.x / SCREEN_FRAME.size.width;
        _selectedIndex = index;
        switch (index) {
            case 0: //全部明细
                _fCellTotalHeight = _fTotalDetailHeight;
                if (self.totalDetailArray.count <= 0)
                {
                    _nPageIndex = 1;
                    [self loadListDatas];
                    [self.view showGifLoading];
                }
                break;
            case 1: //收入明细
                _fCellTotalHeight = _fIncomeDetailHeight;
                if (self.incomeDetailArray.count <= 0)
                {
                    _nPageIndex = 1;
                    [self loadListDatas];
                    [self.view showGifLoading];
                }
                
                break;
            case 2: //支出明细
                _fCellTotalHeight = _fOutDetailHeight;
                if (self.outDetailArray.count <= 0)
                {
                    _nPageIndex = 1;
                    [self loadListDatas];
                    [self.view showGifLoading];
                }
                break;
                
            default:
                break;
        }
        [self.tableView reloadRowsAtIndexPaths:@[self.updateIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        UIButton * sender = [self.titleObjArray objectAtIndex:index];
        for (UIButton * titleButton in self.titleObjArray)
        {
            if ([titleButton isEqual:sender])
            {
                [titleButton setTitleColor:TITLE_SELECTED_COLOR forState:UIControlStateNormal];
            }
            else
            {
                [titleButton setTitleColor:TITLE_NORMAL_COLOR forState:UIControlStateNormal];
            }
        }
        
        [self.view layoutIfNeeded];
        
        __weak UIScrollView * tmpScrollView = self.headContainerScrollView;
        __weak UIButton * btnTmp = sender;
        [self.cursorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(btnTmp.mas_centerX);
            make.bottom.mas_equalTo(tmpScrollView.mas_bottom);
            make.width.mas_equalTo(DEFAULTTITLEWIDTH * 0.8);
            make.height.mas_equalTo(@(2));
        }];
        
        [UIView animateWithDuration:VIEWANIMATIONDURATION animations:^{
            
            [self.view layoutIfNeeded];
        }];
        
    }
}

#pragma mark - MIAccountBalanceDetailListViewControllerDelegate
- (void)showExplain:(MIAccountBalanceDetailItemMode *)mode
{
    NSString *reasonString = mode.failureCause;
    [self showCustomAlertViewWithTitle:reasonString okTitle:@"关闭" okTitleColor:UIColorFromHex(0x4E8CEF) okCompleteBlock:^{
        
    } topPadding:23 textAlignment:NSTextAlignmentLeft];
}

#pragma mark - XNMyProfitModuleObserver
#pragma mark - 资金明细－账户余额
- (void)XNMyProfitModuleAccountBalanceDetailDidReceive:(XNMyProfitModule *)module
{
    [self.view hideLoading];
    MIAccountBalanceDetailMode *mode = module.accountBalanceDetailMode;
    self.accountBalanceLabel.text = mode.accountBalance;
    self.totalIncomeLabel.text = mode.incomeSummary;
    self.totalSpendingLabel.text = mode.outSummary;
    [self buildView];
}

- (void)XNMyProfitModuleAccountBalanceDetailDidFailed:(XNMyProfitModule *)module
{
    [self.view hideLoading];
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

#pragma mark - 资金明细列表
- (void)XNMyProfitModuleAccountBalanceDetailListDidReceive:(XNMyProfitModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    _mode = module.accountBalanceDetailListMode;
    if ([_mode.type integerValue] != _selectedIndex || _mode.datas == nil || _mode.datas.count <= 0)
    {
        return;
    }
    
    [self.commonDatasArray removeAllObjects];
    
    if (_nPageIndex == 1)
    {
        switch ([_mode.type integerValue]) {
            case 0: //全部明细
                [self.totalDetailArray removeAllObjects];
                break;
            case 1: //收入明细
                [self.incomeDetailArray removeAllObjects];
                break;
            case 2: //支出明细
                [self.outDetailArray removeAllObjects];
                break;
                
            default:
                break;
        }
    }
    
    _nPageIndex = _mode.pageIndex;
    _nPageCount = _mode.pageCount;
    
    switch ([_mode.type integerValue]) {
        case 0: //全部明细
            [self.totalDetailArray addObjectsFromArray:_mode.datas];
            [self.commonDatasArray addObjectsFromArray:self.totalDetailArray];
            
            break;
        case 1: //收入明细
            [self.incomeDetailArray addObjectsFromArray:_mode.datas];
            [self.commonDatasArray addObjectsFromArray:self.incomeDetailArray];
            
            break;
        case 2: //支出明细
            [self.outDetailArray addObjectsFromArray:_mode.datas];
            [self.commonDatasArray addObjectsFromArray:self.outDetailArray];
            
            break;
            
        default:
            break;
    }
    
    if (_nPageIndex >= _nPageCount)
    {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
        [_tableView.mj_footer setHidden:YES];
    }
    else
    {
        [_tableView.mj_footer resetNoMoreData];
        [_tableView.mj_footer setHidden:NO];
    }
    
    MIAccountBalanceDetailListViewController *ctrl = [self.contentCtrlArray objectAtIndex:_selectedIndex];
    [ctrl reloadList:self.commonDatasArray monthProfitDetailListMode:_mode];
    
    //计算高度
    [self calcCellTotalHeight];
}

- (void)XNMyProfitModuleAccountBalanceDetailListDidFailed:(XNMyProfitModule *)module
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

///////////////////
#pragma mark - setter/getter
//////////////////////////////////////

#pragma mark - commonDatasArray
- (NSMutableArray *)commonDatasArray
{
    if (!_commonDatasArray)
    {
        _commonDatasArray = [[NSMutableArray alloc] init];
    }
    return _commonDatasArray;
}

#pragma mark - totalDetailArray
- (NSMutableArray *)totalDetailArray
{
    if (!_totalDetailArray)
    {
        _totalDetailArray = [[NSMutableArray alloc] init];
    }
    return _totalDetailArray;
}

#pragma mark - incomeDetailArray
- (NSMutableArray *)incomeDetailArray
{
    if (!_incomeDetailArray)
    {
        _incomeDetailArray = [[NSMutableArray alloc] init];
    }
    return _incomeDetailArray;
}

#pragma mark - outDetailArray
- (NSMutableArray *)outDetailArray
{
    if (!_outDetailArray)
    {
        _outDetailArray = [[NSMutableArray alloc] init];
    }
    return _outDetailArray;
}

#pragma mark - titleArray
- (NSMutableArray *)titleArray
{
    if (!_titleArray)
    {
        [self loadListDatas];
        _titleArray = [[NSMutableArray alloc] initWithObjects:@"全部明细", @"收入明细", @"支出明细", nil];
    }
    return _titleArray;
}

#pragma mark - titleObjArray
- (NSMutableArray *)titleObjArray
{
    if (!_titleObjArray)
    {
        _titleObjArray = [[NSMutableArray alloc]init];
    }
    return _titleObjArray;
}

#pragma mark - contentCtrlArray
- (NSMutableArray *)contentCtrlArray
{
    if (!_contentCtrlArray)
    {
        _contentCtrlArray = [[NSMutableArray alloc] init];
        MIAccountBalanceDetailListViewController *ctrl = nil;
        for (NSInteger i = 0; i < self.titleArray.count; i++)
        {
            ctrl = [[MIAccountBalanceDetailListViewController alloc] initWithNibName:@"MIAccountBalanceDetailListViewController" bundle:nil type:[NSString stringWithFormat:@"%ld", i]];
            ctrl.delegate = self;
            [_contentCtrlArray addObject:ctrl];
        }
    }
    return _contentCtrlArray;
}

#pragma mark -cursorView
- (UIView *)cursorView
{
    if (!_cursorView)
    {
        _cursorView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, SCREEN_FRAME.size.width / 3, 2)];
        [_cursorView setBackgroundColor:MONEYCOLOR];
    }
    return _cursorView;
}

#pragma mark - contentContainerScrollView
- (UIScrollView *)contentContainerScrollView
{
    if (!_contentContainerScrollView)
    {
        _contentContainerScrollView = [[UIScrollView alloc] init];
        _contentContainerScrollView.pagingEnabled = YES;
    }
    return _contentContainerScrollView;
}

@end
