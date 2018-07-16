//
//  MonthIncomeViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 2/16/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MIMonthIncomeViewController.h"

#import "MIMonthIncomeViewController.h"
#import "ScrollViewExitView.h"
#import "PieChartView.h"
#import "MIMonthIncomeDetailListViewController.h"

#import "PieChartModel.h"
#import "XNMIMyProfitTypeMode.h"
#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"
#import "MIMonthProfixMode.h"
#import "MIAccountBalanceCommonMode.h"
#import "MIMonthProfixItemMode.h"

#define HEADER_CELL_DEFAULT_HEIGHT 313.0f + 10.0f
#define SECTION_DEFAULT_HEIGHT 40.0f
#define LITTLE_CELL_DEFAULT_HEIGHT 100.0f

#define PIECHART_SIZE 66.0f
#define DEFAULTTAG 0x111111
#define DEFAULTTITLEHEIGHT 35.0f
#define NEWWIDTH (SCREEN_FRAME.size.width / self.titleArray.count)
#define DEFAULTTITLEWIDTH (self.titleArray.count>=4?80 * (SCREEN_FRAME.size.width / 320):NEWWIDTH)

@interface MIMonthIncomeViewController ()<XNMyInformationModuleObserver, MIMonthIncomeDetailListViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *headerCellView;
@property (nonatomic, strong) IBOutlet UIView *descView;
@property (nonatomic, strong) IBOutlet UIView *topView;

@property (nonatomic, strong) IBOutlet UILabel *accountTotalIncomeLabel; //总收益
@property (nonatomic, strong) IBOutlet UIView *pieChartView; //饼状图
@property (nonatomic, strong) IBOutlet UILabel *saleCommissionLabel; //销售佣金
@property (nonatomic, strong) IBOutlet UILabel *recommendRewardLabel; //推荐奖励
@property (nonatomic, strong) IBOutlet UILabel *directManageRewardLabel; //直接管理津贴
@property (nonatomic, strong) IBOutlet UILabel *teamManageRewardLabel; //团队管理津贴
@property (nonatomic, strong) IBOutlet UILabel *activityRewardLabel; //活动奖励
@property (nonatomic, strong) IBOutlet UILabel *investRedPacketLabel; //投资返现红包

@property (nonatomic, strong) IBOutlet UIScrollView * headContainerScrollView;
@property (nonatomic, strong) IBOutlet UIScrollView * titleContainerScrollView;
@property (nonatomic, strong) UIScrollView * contentContainerScrollView;

@property (nonatomic, strong) UIView              * cursorView;

@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *currentMonthString;

@property (nonatomic, strong) NSMutableArray      * titleArray;
@property (nonatomic, strong) NSMutableArray      * titleLengthArray;
@property (nonatomic, strong) NSMutableArray      * contentCtrlArray;
@property (nonatomic, strong) NSMutableArray      * titleObjArray;

@property (nonatomic, strong) NSString            * timeType;
@property (nonatomic, strong) NSString            * time;
@property (nonatomic, assign) NSInteger           selectedIndex;
@property (nonatomic, assign) NSInteger nSelectedType; //选中 2已发放／1未发放

@property (nonatomic, strong) MIMonthProfixMode *monthProfixMode;

@property (nonatomic, strong) NSMutableArray *grantDatasArray; //已发放数组
@property (nonatomic, strong) NSMutableArray *waitGrantDatasArray; //未发放数组
@property (nonatomic, strong) NSMutableArray *commonDatasArray; //用于临时存储 已发放／未发放数据

@property (nonatomic, assign) float fGrantHeight; //已发放页面高度
@property (nonatomic, assign) float fWaitGrantHeigh; //未发放页面高度

@property (nonatomic, assign) NSInteger nPageIndex; //当前页码
@property (nonatomic, assign) NSInteger nPageSize; //每页显示数
@property (nonatomic, assign) NSInteger nPageCount; //总页数
@property (nonatomic, strong) MIAccountBalanceCommonMode *mode;

@property (nonatomic, assign) float fCellTotalHeight;
@property (nonatomic, strong) NSIndexPath *updateIndexPath;

@end

@implementation MIMonthIncomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)title month:(NSString *)month
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.titleString = title;
        self.currentMonthString = month;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)title month:(NSString *)month profitType:(NSString *)profitTypeCode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.titleString = title;
        self.currentMonthString = month;
        _selectedIndex = ([profitTypeCode integerValue] -1);
    }
    return self;
}

- (void)dealloc
{
    [[XNMyInformationModule defaultModule] removeObserver:self];
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

////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.title = _titleString;
    _nPageIndex = 1;
    _nPageSize = 10;
    [[XNMyInformationModule defaultModule] addObserver:self];
    [self loadDatas];
    
    weakSelf(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        switch (weakSelf.nSelectedType) {
            case 1: //未发放
                weakSelf.nPageIndex = [[[XNMyInformationModule defaultModule] waiGrantMonthProfitDetailListMode] pageIndex];
                break;
            case 2: //已发放
                weakSelf.nPageIndex = [[[XNMyInformationModule defaultModule] grantMonthProfitDetailListMode] pageIndex];
                break;
            default:
                break;
        }
        weakSelf.nPageIndex --;
        [weakSelf loadListDatas];
        [weakSelf.view showGifLoading];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        switch (weakSelf.nSelectedType) {
            case 1: //未发放
                weakSelf.nPageIndex = [[[XNMyInformationModule defaultModule] waiGrantMonthProfitDetailListMode] pageIndex];
                break;
            case 2: //已发放
                weakSelf.nPageIndex = [[[XNMyInformationModule defaultModule] grantMonthProfitDetailListMode] pageIndex];
                break;
            default:
                break;
        }
        weakSelf.nPageIndex ++;
        [weakSelf loadListDatas];
    }];
    
    [self.tableView.mj_footer setHidden:YES];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
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
        NSString *title = [self.titleArray objectAtIndex:i];
        titleButton = [[UIButton alloc]initWithFrame:CGRectMake(i *  DEFAULTTITLEWIDTH, 0, DEFAULTTITLEWIDTH, DEFAULTTITLEHEIGHT)];
        [titleButton setTag:i+DEFAULTTAG];
        [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(7, 0, 0, 0)];
        [titleButton addTarget:self action:@selector(selectedOption:) forControlEvents:UIControlEventTouchUpInside];
        
        NSArray *propertyArray = @[@{@"range": [[title componentsSeparatedByString:@" "] firstObject],
                                     @"color": i==_selectedIndex?UIColorFromHex(0x02a0f2):UIColorFromHex(0x6c6e6d),
                                     @"font": [UIFont systemFontOfSize:12]},
                                   @{@"range": [[title componentsSeparatedByString:@" "] lastObject],
                                     @"color": UIColorFromHex(0xa2a2a2),
                                     @"font": [UIFont systemFontOfSize:12]}];
        
        NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
        [titleButton setAttributedTitle:string forState:UIControlStateNormal];
        
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
        
        if (i == self.titleArray.count - 1)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"XN_Explain_Blue_icon"]];
            [self.titleContainerScrollView addSubview:imageView];
            
            UIButton *explainButton = [[UIButton alloc] init];
            [explainButton addTarget:self action:@selector(waitGrantAmountExplain:) forControlEvents:UIControlEventTouchUpInside];
            [self.titleContainerScrollView addSubview:explainButton];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(tmpTitleScrollView.mas_centerY).offset(2);
                make.right.mas_equalTo(tmpTitleScrollView.mas_right).offset(-12);
                make.width.mas_equalTo(16);
                make.height.mas_equalTo(16);
            }];
            
            __weak UIImageView *weakImageView = imageView;
            [explainButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(tmpTitleScrollView.mas_top);
                make.left.mas_equalTo(weakImageView.mas_left).offset(3);
                make.right.mas_equalTo(tmpTitleScrollView.mas_right);
                make.bottom.mas_equalTo(tmpTitleScrollView.mas_bottom);
            }];
        }
        
        if (i == _selectedIndex)
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
    for (NSInteger i = 0 ; i < self.contentCtrlArray.count ; i ++ )
    {
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
    [self.contentContainerScrollView setContentOffset:CGPointMake(SCREEN_FRAME.size.width * _selectedIndex, 0)];

}

#pragma mark - 选中操作
- (void)selectedOption:(UIButton *)sender
{
    NSInteger index = [self.titleObjArray indexOfObject:sender];
    _selectedIndex = index;
    
    switch (index) {
        case 0: //已发放
        {
            _fCellTotalHeight = _fGrantHeight;
            if (self.grantDatasArray.count <= 0)
            {
                _nPageIndex = 1;
                [self loadListDatas];
            }
        }
            break;
        case 1: //未发放
        {
            _fCellTotalHeight = _fWaitGrantHeigh;
            if (self.waitGrantDatasArray.count <= 0)
            {
                _nPageIndex = 1;
                [self loadListDatas];
            }
        }
            break;
        default:
            break;
    }
    [self.tableView reloadRowsAtIndexPaths:@[self.updateIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    NSArray *propertyArray = nil;
    NSInteger dex = 0;
    for (UIButton *titleButton in self.titleObjArray)
    {
    
        dex = [self.titleObjArray indexOfObject:titleButton];
        if (dex < self.titleArray.count) {
            
            NSString *title = [self.titleArray objectAtIndex:[self.titleObjArray indexOfObject:titleButton]];
            if ([titleButton isEqual:sender])
            {
                propertyArray = @[@{@"range": [[title componentsSeparatedByString:@" "] firstObject],
                                    @"color": UIColorFromHex(0x02a0f2),
                                    @"font": [UIFont systemFontOfSize:12]},
                                  @{@"range": [[title componentsSeparatedByString:@" "] lastObject],
                                    @"color": UIColorFromHex(0xa2a2a2),
                                    @"font": [UIFont systemFontOfSize:12]}];
            }
            else
            {
                propertyArray = @[@{@"range": [[title componentsSeparatedByString:@" "] firstObject],
                                    @"color": UIColorFromHex(0x6c6e6d),
                                    @"font": [UIFont systemFontOfSize:12]},
                                  @{@"range": [[title componentsSeparatedByString:@" "] lastObject],
                                    @"color": UIColorFromHex(0xa2a2a2),
                                    @"font": [UIFont systemFontOfSize:12]}];
            }
            
            NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
            [titleButton setAttributedTitle:string forState:UIControlStateNormal];
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

    weakSelf(weakSelf)
    [UIView animateWithDuration:VIEWANIMATIONDURATION animations:^{
        
        [weakSelf.view layoutIfNeeded];
        [weakSelf.contentContainerScrollView setContentOffset:CGPointMake(index*SCREEN_FRAME.size.width, 0)];

    }];
}

#pragma mark - 加载数据
- (void)loadDatas
{
    [[XNMyInformationModule defaultModule] requestMonthProfitStatisticsWithMonth:_currentMonthString];
    [self.view showGifLoading];
}

- (void)loadListDatas
{
    
    if (_nPageIndex < 1)
    {
        _nPageIndex = 1;
    }
    
    if (_selectedIndex == 0)
    {
        _nSelectedType = 2;
    }
    else
    {
        _nSelectedType = 1;
    }
    
    [[XNMyInformationModule defaultModule] requestMonthProfitDetailListWithMonth:_currentMonthString pageIndex:[NSString stringWithFormat:@"%ld", _nPageIndex] pageSize:[NSString stringWithFormat:@"%ld", _nPageSize] profixType:[NSString stringWithFormat:@"%ld", _nSelectedType]];
}

#pragma mark - 总收益说明
- (IBAction)accountIncomeExplainClick:(id)sender
{
    NSString *reasonString = @"总收益＝销售佣金＋推荐奖励＋直接管理津贴＋团队管理津贴＋活动奖励＋投资返现红包";
    [self showCustomAlertViewWithTitle:reasonString okTitle:@"关闭" okTitleColor:UIColorFromHex(0x4E8CEF) okCompleteBlock:^{
        
    } topPadding:23 textAlignment:NSTextAlignmentCenter];
    
}

#pragma mark - 关闭按钮
- (IBAction)closeClickAction:(id)sender
{
    [_LOGIC saveValueForKey:XN_IS_CLOSE_BALANCE_MONTH_INCOME_DESC_TAG Value:@"1"];
    
    NSIndexPath *curIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
     [self.tableView reloadRowsAtIndexPaths:@[curIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - 收益分布说明
- (IBAction)incomeDistributionExplainClick:(id)sender
{
    NSString *url = [AppFramework getConfig].PROFIT_DISTRIBUTION_EXPLAIN_URL;
    [self showCustomAlertViewWithUrl:url okTitle:@"关闭" okTitleColor:JFZ_COLOR_LIGHT_GRAY okCompleteBlock:^{
        
    } topPadding:0];
}

#pragma mark - 待发放说明
- (void)waitGrantAmountExplain:(id)sender
{
    NSString *reasonString = @"销售佣金、推荐奖励、直接管理津贴、团队管理津贴在次月15日发放，活动奖励发放时间详见各个活动详情，投资返现红包将在产品募集完成后发放。";
    [self showCustomAlertViewWithTitle:reasonString okTitle:@"关闭" okTitleColor:UIColorFromHex(0x4E8CEF) okCompleteBlock:^{
        
    } topPadding:23 textAlignment:NSTextAlignmentCenter];
    
}

#pragma mark - 计算cell高度
- (void)calcCellTotalHeight
{
    float fTmpHeight = 0.0f;
    _fCellTotalHeight = 0.0f;
    
    for (MIMonthProfixItemMode *mode in self.commonDatasArray)
    {
        //计算字的高度
        CGFloat fHeight = [mode.desc getSpaceLabelHeightWithFont:12 withWidth:SCREEN_FRAME.size.width - 24 lineSpacing:5] + 5;
        
        if ([mode.profixType integerValue] == SaleCommissionType)
        {
            fTmpHeight = LITTLE_CELL_DEFAULT_HEIGHT + fHeight;
        }
        else
        {
            fTmpHeight = LITTLE_CELL_DEFAULT_HEIGHT - 25 + fHeight;
        }
        _fCellTotalHeight += fTmpHeight;
    }
    
    if (_selectedIndex == 0)
    {
        //已发放
        _fGrantHeight = _fCellTotalHeight;
    }
    else
    {
        //未发放
        _fWaitGrantHeigh = _fCellTotalHeight;
    }

    [self.tableView reloadRowsAtIndexPaths:@[self.updateIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}

///////////////////
#pragma mark - protocol
//////////////////////////////////////

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
        [self.headerCellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakCell);
        }];
        
        __weak UIView *weakHeaderCellView = _headerCellView;
        __weak UIView *weakDescView = _descView;
        BOOL isCloseDesc = [[_LOGIC getValueForKey:XN_IS_CLOSE_BALANCE_MONTH_INCOME_DESC_TAG] boolValue];
        if (!isCloseDesc)
        {
            self.descView.hidden = NO;
            [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakDescView.mas_bottom);
                make.left.mas_equalTo(weakHeaderCellView.mas_left);
                make.right.mas_equalTo(weakHeaderCellView.mas_right);
                make.height.mas_equalTo(211);
            }];
        }
        else
        {
            self.descView.hidden = YES;
            [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakHeaderCellView.mas_top);
                make.left.mas_equalTo(weakHeaderCellView.mas_left);
                make.right.mas_equalTo(weakHeaderCellView.mas_right);
                make.height.mas_equalTo(211);
            }];

        }
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
        BOOL isCloseDesc = [[_LOGIC getValueForKey:XN_IS_CLOSE_BALANCE_MONTH_INCOME_DESC_TAG] boolValue];
        if (isCloseDesc)
        {
            fHeight -= 70;
        }
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

#pragma mark - MIMonthIncomeDetailListViewControllerDelegate
- (void)showExplain:(MIMonthProfixItemMode *)mode
{
    //佣金为0时
    if ([mode.amount floatValue] == 0.00 && mode.remark.length > 0)
    {
        [self showCustomAlertViewWithTitle:mode.remark okTitle:@"关闭" okTitleColor:UIColorFromHex(0x4E8CEF) okCompleteBlock:^{
            
        } topPadding:23 textAlignment:NSTextAlignmentCenter];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@?productType=%@", [AppFramework getConfig].PROFIT_DISTRIBUTION_EXPLAIN_URL, mode.productType];
    [self showCustomAlertViewWithUrl:url okTitle:@"关闭" okTitleColor:JFZ_COLOR_LIGHT_GRAY okCompleteBlock:^{
        
    } topPadding:0];
    
}

#pragma mark - uiscrollview
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.contentContainerScrollView])
    {
        NSInteger index = (int)scrollView.contentOffset.x / SCREEN_FRAME.size.width;
        _selectedIndex = index;
        switch (index) {
            case 0: //已发放
            {
                _fCellTotalHeight = _fGrantHeight;
                if (self.grantDatasArray.count <= 0)
                {
                    _nPageIndex = 1;
                    [self loadListDatas];
                    [self.view showGifLoading];
                }
            }
                break;
            case 1: //未发放
            {
                _fCellTotalHeight = _fWaitGrantHeigh;
                if (self.waitGrantDatasArray.count <= 0)
                {
                    _nPageIndex = 1;
                    [self loadListDatas];
                    [self.view showGifLoading];
                }
            }
                break;
            default:
                break;
        }
        [self.tableView reloadRowsAtIndexPaths:@[self.updateIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        UIButton * sender = [self.titleObjArray objectAtIndex:index];
        NSArray *propertyArray = nil;
        for (UIButton *titleButton in self.titleObjArray)
        {
            NSString *title = [self.titleArray objectAtIndex:[self.titleObjArray indexOfObject:titleButton]];
            if ([titleButton isEqual:sender])
            {
                propertyArray = @[@{@"range": [[title componentsSeparatedByString:@" "] firstObject],
                                    @"color": UIColorFromHex(0x02a0f2),
                                    @"font": [UIFont systemFontOfSize:12]},
                                  @{@"range": [[title componentsSeparatedByString:@" "] lastObject],
                                    @"color": UIColorFromHex(0xa2a2a2),
                                    @"font": [UIFont systemFontOfSize:12]}];
            }
            else
            {
                propertyArray = @[@{@"range": [[title componentsSeparatedByString:@" "] firstObject],
                                    @"color": UIColorFromHex(0x6c6e6d),
                                    @"font": [UIFont systemFontOfSize:12]},
                                  @{@"range": [[title componentsSeparatedByString:@" "] lastObject],
                                    @"color": UIColorFromHex(0xa2a2a2),
                                    @"font": [UIFont systemFontOfSize:12]}];
            }
            
            NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
            [titleButton setAttributedTitle:string forState:UIControlStateNormal];
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

#pragma mark - XNMyInformationModuleObserver

#pragma mark - 月度收益统计
- (void)XNMyInfoModuleMonthProfitStatisticsDidReceive:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    self.monthProfixMode = module.monthProfixMode;
    _accountTotalIncomeLabel.text = self.monthProfixMode.totalProfix;
    
    float fCommission = 0.0f;
    NSMutableArray *array = [NSMutableArray array];
    PieChartModel *model = nil;
    for (NSDictionary *dic in self.monthProfixMode.profixList)
    {
        model = [[PieChartModel alloc] init];
        switch ([[dic objectForKey:XN_MYINFO_ACCOUNT_BALANCE_MODE_PROFIX_TYPE] integerValue]) {
            case SaleCommissionType: //销售佣金
            {
                _saleCommissionLabel.text = [dic objectForKey:XN_MYINFO_ACCOUNT_BALANCE_MODE_AMOUNT];
                model.color = UIColorFromHex(0x7ccdf8);
            }
                break;
            case RecommendRewardType: //推荐津贴
            {
                _recommendRewardLabel.text = [dic objectForKey:XN_MYINFO_ACCOUNT_BALANCE_MODE_AMOUNT];
                model.color = UIColorFromHex(0xf7da94);
            }
                break;
            case ActivityRewardType: //活动奖励
            {
                _activityRewardLabel.text = [dic objectForKey:XN_MYINFO_ACCOUNT_BALANCE_MODE_AMOUNT];
                model.color = UIColorFromHex(0xfca40b);
            }
                break;
            case InvestRedPacketType: //投资返现红包
            {
                _investRedPacketLabel.text = [dic objectForKey:XN_MYINFO_ACCOUNT_BALANCE_MODE_AMOUNT];
                model.color = UIColorFromHex(0x9095f5);
            }
                break;
            case DirectManageRewardType: //直接管理津贴
            {
                _directManageRewardLabel.text = [dic objectForKey:XN_MYINFO_ACCOUNT_BALANCE_MODE_AMOUNT];
                model.color = UIColorFromHex(0xa5eea5);
            }
                break;
            case TeamManageRewardType: //团队管理津贴
            {
                _teamManageRewardLabel.text = [dic objectForKey:XN_MYINFO_ACCOUNT_BALANCE_MODE_AMOUNT];
                model.color = UIColorFromHex(0xf99186);
            }
                break;
            default:
                break;
        }
        
        fCommission = [[dic objectForKey:XN_MYINFO_ACCOUNT_BALANCE_MODE_AMOUNT] floatValue];
        if (fCommission == 0)
        {
            model.fpercent = 0.0f;
        }
        else
        {
            model.fpercent = fCommission / [self.monthProfixMode.totalProfix floatValue];
        }
        
        [array addObject:model];
    }
    
    PieChartView *pieChartView = [[PieChartView alloc] initWithFrame:CGRectMake(0, 0, PIECHART_SIZE, PIECHART_SIZE) withStrokeWidth:(PIECHART_SIZE / 4) bgColor:UIColorFromHex(0xe9e9e9) percentArray:array isAnimation:YES];
    
    [self.pieChartView addSubview:pieChartView];
    
    __weak UIView *weakPieChartView = self.pieChartView;
    [pieChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakPieChartView.mas_top).offset(8);
        make.left.equalTo(weakPieChartView.mas_left).offset(8);
        make.right.equalTo(weakPieChartView.mas_right).offset(-8);
        make.bottom.equalTo(weakPieChartView.mas_bottom).offset(-8);
    }];
    
    //创建底部视图
    [self buildView];

}

- (void)XNMyInfoModuleMonthProfitStatisticsDidFailed:(XNMyInformationModule *)module
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

#pragma mark - 月度收益明细列表
- (void)XNMyInfoModuleMonthProfitDetailListDidReceive:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    _mode = module.monthProfitDetailListMode;
    
    if ([_mode.type integerValue] != _nSelectedType || _mode.datas == nil || _mode.datas.count <= 0)
    {
        return;
    }
    
    [self.commonDatasArray removeAllObjects];
    if (_mode.pageIndex == 1)
    {
        if ([_mode.type integerValue] == 1)
        {
            //待发放
            [self.waitGrantDatasArray removeAllObjects];
        }
        else
        {
            [self.grantDatasArray removeAllObjects];
        }
    }
    
    _nPageIndex = _mode.pageIndex;
    _nPageCount = _mode.pageCount;
    
    if ([_mode.type integerValue] == 1)
    {
        //待发放
        [self.waitGrantDatasArray addObjectsFromArray:_mode.datas];
        [self.commonDatasArray addObjectsFromArray:self.waitGrantDatasArray];
    }
    else
    {
        [self.grantDatasArray addObjectsFromArray:_mode.datas];
        [self.commonDatasArray addObjectsFromArray:self.grantDatasArray];
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
    
    MIMonthIncomeDetailListViewController *ctrl = [self.contentCtrlArray objectAtIndex:_selectedIndex];
    
    [ctrl reloadList:self.commonDatasArray monthProfitDetailListMode:_mode];
    
    //计算高度
    [self calcCellTotalHeight];
}

- (void)XNMyInfoModuleMonthProfitDetailListDidFailed:(XNMyInformationModule *)module
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

#pragma mark - commonDatasArray
- (NSMutableArray *)commonDatasArray
{
    if (!_commonDatasArray)
    {
        _commonDatasArray = [[NSMutableArray alloc] init];
    }
    return _commonDatasArray;
}

#pragma mark - grantDatasArray
- (NSMutableArray *)grantDatasArray
{
    if (!_grantDatasArray)
    {
        _grantDatasArray = [[NSMutableArray alloc] init];
    }
    return _grantDatasArray;
}

#pragma mark - waitGrantDatasArray
- (NSMutableArray *)waitGrantDatasArray
{
    if (!_waitGrantDatasArray)
    {
        _waitGrantDatasArray = [[NSMutableArray alloc] init];
    }
    return _waitGrantDatasArray;
}

#pragma mark - titleArray
- (NSMutableArray *)titleArray
{
    if (!_titleArray)
    {
        if ([self.monthProfixMode.grantedAmount floatValue] == 0 && [self.monthProfixMode.waitGrantAmount floatValue] > 0)
        {
            _selectedIndex = 1;
        }
        else
        {
            _selectedIndex = 0;
        }
        [self loadListDatas];
        _titleArray = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"已发放 (%@元)", self.monthProfixMode.grantedAmount], [NSString stringWithFormat:@"待发放 (%@元)", self.monthProfixMode.waitGrantAmount], nil];
    }
    return _titleArray;
}

#pragma mark - titleLengthArray
- (NSMutableArray *)titleLengthArray
{
    if (!_titleLengthArray)
    {
        _titleLengthArray = [[NSMutableArray alloc]init];
    }
    return _titleLengthArray;
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
- (NSArray *)contentCtrlArray
{
    if (!_contentCtrlArray)
    {
        _contentCtrlArray = [[NSMutableArray alloc] init];
        MIMonthIncomeDetailListViewController *ctrl = nil;
        for (NSInteger i = 2; i > 0; i--)
        {
            ctrl = [[MIMonthIncomeDetailListViewController alloc] initWithNibName:@"MIMonthIncomeDetailListViewController" bundle:nil profitType:i];
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
        _cursorView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, SCREEN_FRAME.size.width / 4, 2)];
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

