//
//  AgentDetailViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/21/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "AgentDetailViewController.h"
#import "UniversalInteractWebViewController.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "UINavigationItem+Extension.h"
#import "AgentIntroductionViewController.h"
#import "MFSystemInvitedEmptyCell.h"
#import "ManagerFinancialProgressCell.h"
#import "CustomAdScrollView.h"
#import "SharedViewController.h"
#import "MIAddBankCardController.h"
#import "PXAlertView.h"
#import "PXAlertView+XNExtenstion.h"

#import "FMComissionCaculateVController.h"
#import "NewUserGuildController.h"

#import "XNFMProductDetailMode.h"
#import "XNFMProductListItemMode.h"
#import "XNFinancialManagerModule.h"
#import "XNFinancialManagerModuleObserver.h"
#import "XNFMAgentDetailMode.h"
#import "XNCommonModule.h"
#import "XNConfigMode.h"
#import "XNFMProductCategoryListMode.h"
#import "XNFMAgentActivityMode.h"
#import "XNPlatformUserCenterOrProductMode.h"

#import "MIMySetMode.h"
#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"

#import "RecommendViewController.h"
#import "RecommendMemberViewController.h"
#import "RecommendCustomerViewController.h"

#define DEFAULTPROGRESSCELLHEIGHT 144.0f
#define DEFAULTPAGEINDEX @"1"
#define DEFAULTPAGESIZE @"10"
#define BACKGROUND_COLOR UIColorFromHex(0xf6f6f6)
#define HEADVIEW_HEIGHT 183.0f
#define DESC_VIEW_HEIGHT 55.0f
#define TITLE_WIDTH (SCREEN_FRAME.size.width / 4)
#define TITLE_HEIGHT 43.0f
#define HEIGHT_DEFAULT 126//176
#define PLATFORM_ACTIVITY_VIEW_HEIGHT 85
#define agentTag 0x111111111
#define CTRL_DEFAULT_TAG 10000

@interface AgentDetailViewController () <UniversalInteractWebViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, XNFinancialManagerModuleObserver, UIScrollViewDelegate, AgentIntroductionViewControllerDelegate, SharedViewControllerDelegate, RecommendViewControllerDelegate,XNMyInformationModuleObserver>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *topView;
@property (nonatomic, strong) IBOutlet UILabel *topLabel;

@property (nonatomic, weak) IBOutlet UIView *headView;
@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;
@property (nonatomic, weak) IBOutlet UILabel *platformNameLabel;
@property (nonatomic, weak) IBOutlet UIView *descAgentTagView; //机构标签
@property (nonatomic, weak) IBOutlet UILabel *expectAnnualLabel; //预期年化
@property (nonatomic, weak) IBOutlet UILabel *annualCommisionLabel; //年化佣金
@property (nonatomic, weak) IBOutlet UILabel *agentAdvantageLabel; //机构亮点

@property (nonatomic, weak) IBOutlet UIView *safeLevelView;
@property (nonatomic, weak) IBOutlet UILabel *securityLevelLabel; //安全等级
@property (nonatomic, weak) IBOutlet UILabel *thirdPartyOpenStateLabel;

@property (nonatomic, weak) IBOutlet UIView *platformActivityView; //平台活动
@property (nonatomic, strong) CustomAdScrollView  *adScrollView;

@property (nonatomic, weak) IBOutlet UIView *saleProductView; //在售产品
@property (nonatomic, weak) IBOutlet UILabel *saleProductCountLabel;
@property (nonatomic, weak) IBOutlet UIButton *buyButton; //购买

@property (weak, nonatomic) IBOutlet UILabel *myAgentAccountLabel; //我的平台账户

@property (nonatomic, assign) BOOL initPlatformOpenState;
@property (nonatomic, strong) UIScrollView *titleContainerScrollView;
@property (nonatomic, strong) UIView *cursorView;
@property (nonatomic, strong) UIScrollView *listScrollView;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *titleTabMutableArray;
@property (nonatomic, strong) NSArray *listCtrlArray;
@property (nonatomic, strong) NSMutableArray *listContentMutableArray;
@property (nonatomic, strong) NSMutableArray *activityImageUrlArray;

@property (nonatomic, strong) UniversalInteractWebViewController *interactWebViewController;
@property (nonatomic, strong) NSMutableArray *productsArray;
@property (nonatomic, strong) NSString *platformNoString; //平台编码
@property (nonatomic, assign) NSInteger nPageIndex;
@property (nonatomic, assign) NSInteger nPageSize;
@property (nonatomic, assign) NSInteger nPageCount;
@property (nonatomic, strong) XNFMAgentDetailMode *mode;
@property (nonatomic, strong) XNFMProductListItemMode *selectedMode;
@property (nonatomic, strong) XNFMAgentActivityMode *selectedActivityMode;
@property (nonatomic, strong) XNMyInformationModule * myInformationModule;

@property (nonatomic, strong) NSMutableDictionary *platTabHeightDictionary;
@property (nonatomic, assign) NSInteger nCurrentTabTag; //当前显示的tab,用于是否显示所有高度
@property (nonatomic, assign) BOOL isShowDefaultHeight; //是否显示listScrollView的默认高度
@property (nonatomic, assign) BOOL isShowDefaultPlatIntroductHeight;
@property (nonatomic, assign) float fDefaultHeight;
@property (nonatomic, assign) NSInteger nSharedTag; //用于区分产品分享、活动分享
@property (nonatomic, assign) NSInteger nSelectActivityIndex;

@property (nonatomic, assign) BOOL                   existSharedView;//是否已经存在分享视图
@property (nonatomic, strong) SharedViewController * sharedCtrl; //分享控件

@property (nonatomic, strong) RecommendViewController *recommendVC; //推荐控件


@end

@implementation AgentDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil platNo:(NSString *)platNo
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _platformNoString = platNo;
        _isShowDefaultHeight = YES;
    }
    return self;
}

- (id)init
{
    self = [super initWithNibName:@"AgentDetailViewController" bundle:nil];
    if (self)
    {
        _isShowDefaultHeight = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.buyButton.userInteractionEnabled = NO;
    self.buyButton.backgroundColor = UIColorFromHex(0xc7c7cd);
    
    _nPageIndex = 1;
    _nPageSize = 10;
    
    [self loadAgentDetailDatas];
    [self loadProductDatas];
    
    NSString *token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if ([NSObject isValidateInitString:token])
    {
        self.initPlatformOpenState = YES;
        [self.myInformationModule addObserver:self];
        [self.myInformationModule isBindOrgAcct:_platformNoString];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.myInformationModule removeObserver:self];
    
    [self.view hideLoading];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[XNFinancialManagerModule defaultModule] removeObserver:self];
    _interactWebViewController.delegate = nil;
    _interactWebViewController = nil;
    [_productsArray removeAllObjects];
    _productsArray = nil;
    _platformNoString = nil;
    _mode = nil;
}

////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////

#pragma mark - 初始化
- (void)initView
{
//    [self.navigationItem addShareButtonItemWithTarget:self action:@selector(clickSharedAction)];
    [self.navigationItem addRightBarItemWithTitle:@"推荐" titleColor:[UIColor whiteColor] target:self action:@selector(recommendAction)];
    self.existSharedView = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ManagerFinancialProgressCell" bundle:nil] forCellReuseIdentifier:@"ManagerFinancialProgressCell"];
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"ManagerFinancialCell" bundle:nil]
//         forCellReuseIdentifier:@"ManagerFinancialCell"];
    
    weakSelf(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.nPageIndex = 1;
        [weakSelf reloadDatas];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.nPageIndex ++;
        [weakSelf loadProductDatas];
    }];
    [self.tableView.mj_footer setHidden:YES];
    
    [[XNFinancialManagerModule defaultModule] addObserver:self];
    
    if (!self.existSharedView) {
        self.existSharedView = YES;
        
        [self.view addSubview:self.recommendVC.view];
        [self addChildViewController:self.recommendVC];
        
        weakSelf(weakSelf)
        [self.recommendVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.view);
        }];
        [self.view layoutIfNeeded];
        
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 更新cell
- (void)updateSystemCellHeight:(UITableViewCell *)cell
{
    [_platformActivityView addSubview:self.adScrollView];
    __weak UIView *weakListScrollView = _listScrollView;
    __weak UIView *weakPlatformActivityView = _platformActivityView;
    
    [_platformActivityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakListScrollView.mas_bottom).offset(10);
        make.left.equalTo(weakListScrollView.mas_left);
        make.right.equalTo(weakListScrollView.mas_right);
        make.height.mas_equalTo(PLATFORM_ACTIVITY_VIEW_HEIGHT);
    }];
    
    [self.adScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakPlatformActivityView);
    }];
    
    [self.view layoutIfNeeded];
}

#pragma mark - 初始化topCell
- (void)initTopCell:(UITableViewCell *)cell
{
    CGFloat fHeight = [self.mode.orgFeeRatioLimit getSpaceLabelHeightWithFont:12 withWidth:SCREEN_FRAME.size.width - 10 lineSpacing:4];
    [cell addSubview:_topView];
    __weak UITableViewCell *weakTableCell = cell;
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakTableCell.mas_top);
        make.left.equalTo(weakTableCell.mas_left);
        make.right.equalTo(weakTableCell.mas_right);
        make.height.mas_equalTo(fHeight);
    }];
    _topLabel.text = _mode.orgFeeRatioLimit;
}

#pragma mark - 初始化cell
- (void)initSystemCell:(UITableViewCell *)cell
{
    _titleContainerScrollView = [UIScrollView new];
    _titleContainerScrollView.layer.borderWidth = 0.5;
    _titleContainerScrollView.layer.borderColor = JFZ_LINE_COLOR_GRAY.CGColor;
    _titleContainerScrollView.backgroundColor = UIColorFromHex(0xf6f6f7);
    
    _listScrollView = [UIScrollView new];
    _listScrollView.backgroundColor = [UIColor whiteColor];
    _listScrollView.pagingEnabled = YES;
    _listScrollView.delegate = self;
    _listScrollView.contentSize = CGSizeZero;
    _listScrollView.scrollEnabled = NO;
    
    [cell addSubview:_headView];
    [cell addSubview:_safeLevelView];
    [cell addSubview:_titleContainerScrollView];
    [cell addSubview:_listScrollView];
    [cell addSubview:_platformActivityView];
    [cell addSubview:_saleProductView];
    
    weakSelf(weakSelf)
    __weak UITableViewCell *weakTableCell = cell;
    __weak UIView *weakHeadView = _headView;
    __weak UIView *weakSafeLevelView = _safeLevelView;
    __weak UIScrollView *weakTitleContainerScrollView = _titleContainerScrollView;
    __weak UIView *weakListScrollView = _listScrollView;
    
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakTableCell.mas_top);
        make.left.equalTo(weakTableCell.mas_left);
        make.right.equalTo(weakTableCell.mas_right);
        make.height.mas_equalTo(HEADVIEW_HEIGHT);
    }];
    
    [_safeLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakHeadView.mas_bottom);
        make.left.equalTo(weakTableCell.mas_left);
        make.right.equalTo(weakTableCell.mas_right);
        make.height.mas_equalTo(DESC_VIEW_HEIGHT);
    }];
    
    [_titleContainerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSafeLevelView.mas_bottom);
        make.left.equalTo(weakSafeLevelView.mas_left);
        make.right.equalTo(weakSafeLevelView.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    [_listScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakTitleContainerScrollView.mas_bottom);
        make.left.equalTo(weakTitleContainerScrollView.mas_left);
        make.right.equalTo(weakTitleContainerScrollView.mas_right);
        make.height.mas_equalTo(weakSelf.fDefaultHeight);//HEIGHT_DEFAULT);
    }];
    
    [_platformActivityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakListScrollView.mas_bottom).offset(15);
        make.left.equalTo(weakListScrollView.mas_left);
        make.right.equalTo(weakListScrollView.mas_right);
    }];
    
    [_saleProductView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakTableCell.mas_bottom);
        make.left.equalTo(weakTableCell.mas_left);
        make.right.equalTo(weakTableCell.mas_right);
        make.height.mas_equalTo(33);
    }];
    
    [self initTabScrollView];
}

- (void)initTabScrollView
{
    [self.view layoutIfNeeded];
    [_titleContainerScrollView addSubview:self.cursorView];
    [_titleContainerScrollView setContentSize:CGSizeMake(SCREEN_FRAME.size.width / 4 * self.titleArray.count, 0)];
    
    //添加滑动标题
    UIButton *btn = nil;
    UIButton *lastBtn = nil;
    weakSelf(weakSelf)
    for (int i = 0; i < self.titleArray.count; i++)
    {
        btn = [[UIButton alloc] initWithFrame:CGRectMake(i * TITLE_WIDTH, 0, TITLE_WIDTH, TITLE_HEIGHT)];
        [btn setTag:i];
        btn.backgroundColor = [UIColor whiteColor];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [btn setTitle:[NSString stringWithFormat:@"%@", [self.titleArray objectAtIndex:i]] forState:UIControlStateNormal];
        [btn setTitleColor:i==0?JFZ_COLOR_BLUE:JFZ_COLOR_GRAY forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [_titleContainerScrollView addSubview:btn];
        [self.titleTabMutableArray addObject:btn];
        
        __weak UIScrollView *weakTitleContainerScrollView = _titleContainerScrollView;
        __weak UIButton *weakLastBtn = lastBtn;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0)
            {
                make.left.mas_equalTo(weakTitleContainerScrollView.mas_left);
            }
            else if (i == weakSelf.listCtrlArray.count - 1)
            {
                make.left.mas_equalTo(weakLastBtn.mas_right);
                make.right.mas_equalTo(weakTitleContainerScrollView.mas_right);
            }
            else
            {
                make.leading.mas_equalTo(weakLastBtn.mas_trailing);
            }
            make.top.mas_equalTo(weakTitleContainerScrollView.mas_top);
            make.width.mas_equalTo(TITLE_WIDTH);
            make.height.mas_equalTo(TITLE_HEIGHT);
        }];
        lastBtn = btn;
        
        if (i == 0)
        {
            __weak UIButton *weakButton = btn;
            __weak UIScrollView *weakTitleContainerScrollView = _titleContainerScrollView;
            [self.cursorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(weakButton.mas_centerX);
                make.bottom.mas_equalTo(weakButton.mas_bottom).offset(1.5);
                make.width.equalTo(weakTitleContainerScrollView.mas_width).multipliedBy(0.25);
                make.height.mas_equalTo(100);
            }];
        }
    }
    
}

#pragma mark - listContentScrollView
- (void)initListContentView
{
    weakSelf(weakSelf)
    //添加滑动内容列表
    AgentIntroductionViewController *ctrl = nil;
    AgentIntroductionViewController *lastCtrl = nil;
    Class classCtrl;
    for (int i = 0; i < self.listCtrlArray.count; i++)
    {
        classCtrl = NSClassFromString([self.listCtrlArray objectAtIndex:i]);
        ctrl = [[classCtrl alloc] initWithNibName:[self.listCtrlArray objectAtIndex:i] bundle:nil mode:_mode];
        ctrl.view.frame = CGRectMake(i * SCREEN_FRAME.size.width, 0, SCREEN_FRAME.size.width, self.listScrollView.frame.size.height);
        ctrl.view.tag = CTRL_DEFAULT_TAG + i;
        ctrl.delegate = self;
        [_listScrollView addSubview:ctrl.view];
        
        [self addChildViewController:ctrl];
        [self.listContentMutableArray addObject:ctrl];
        
        __weak UIViewController *weakLastCtrl = lastCtrl;
        __weak UIScrollView *weakScrollView = self.listScrollView;
        [ctrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0)
            {
                make.leading.mas_equalTo(weakScrollView.mas_leading);
            }
            else if (i == weakSelf.listCtrlArray.count - 1)
            {
                make.leading.mas_equalTo(weakLastCtrl.view.mas_trailing);
                make.trailing.mas_equalTo(weakScrollView.mas_trailing);
            }
            else
            {
                make.leading.mas_equalTo(weakLastCtrl.view.mas_trailing);
            }
            
            make.top.mas_equalTo(weakScrollView.mas_top);
            make.bottom.mas_equalTo(weakScrollView.mas_bottom);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.equalTo(weakScrollView);
        }];
        lastCtrl = ctrl;
        
        switch (i) {
            case 0:
                [ctrl showIntroduction];
                break;
            case 1:
                [ctrl showInvestMessage];
                
                break;
            case 2:
                
                [ctrl showPlatformMessage];
                
                break;
            case 3:
                [ctrl showPlatDynamic];
                break;
            default:
                break;
        }
        
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 选中标题操作
- (void)selectedTab:(UIButton *)sender
{
    _nCurrentTabTag = sender.tag;
    
    AgentIntroductionViewController *ctrl = [self.listContentMutableArray objectAtIndex:_nCurrentTabTag];
    if (_nCurrentTabTag == 0)
    {
        //改变ui
        _isShowDefaultHeight = YES;
        [ctrl updateArrowImage:_isShowDefaultHeight nTabTag:ctrl.view.tag];
    }
    else
    {
        _isShowDefaultHeight = NO;
    }
    
    for (UIButton *btn in self.titleTabMutableArray)
    {
        if ([btn isEqual:sender])
        {
            [btn setTitleColor:JFZ_COLOR_BLUE forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitleColor:JFZ_COLOR_GRAY forState:UIControlStateNormal];
        }
    }
    
    NSInteger index = [self.titleTabMutableArray indexOfObject:sender];
    [self.view layoutIfNeeded];
    
    __weak UIButton *weakButton = sender;
    __weak UIScrollView *weakScrollView = _titleContainerScrollView;
    [self.cursorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakButton.mas_centerX);
        make.bottom.mas_equalTo(weakButton.mas_bottom).offset(1.5);
        make.width.equalTo(weakScrollView.mas_width).multipliedBy(0.25);
        make.height.mas_equalTo(100);
    }];
    
    weakSelf(weakSelf)
    [UIView animateWithDuration:VIEWANIMATIONDURATION animations:^{
        [weakSelf.view layoutIfNeeded];
        [weakSelf.listScrollView setContentOffset:CGPointMake(index * SCREEN_FRAME.size.width, 0)];
    }];
    
    [self.tableView reloadData];
}

#pragma mark - 加载数据
- (void)loadProductDatas
{
    if (_nPageIndex < 1)
    {
        _nPageIndex = 1;
    }
    
    [[XNFinancialManagerModule defaultModule] fmAgentSaleProductListWithOrgNo:_platformNoString pageIndex:[NSString stringWithFormat:@"%ld", _nPageIndex] pageSize:[NSString stringWithFormat:@"%ld", _nPageSize] order:@"1" sort:@"1"];
}

#pragma mark - 加载机构详情
- (void)loadAgentDetailDatas
{
    [[XNFinancialManagerModule defaultModule] fmAgentDetailWithOrgNo:_platformNoString];
    [self.view showGifLoading];
}

#pragma mark - 重新加载数据
- (void)reloadDatas
{
    [self loadAgentDetailDatas];
    [self loadProductDatas];
}

#pragma mark - 机构头部
- (void)showAgentHeadView
{
    _logoImageView.layer.masksToBounds = YES;
    _logoImageView.layer.cornerRadius = 5;
    _logoImageView.layer.borderWidth = 0.5;
    _logoImageView.layer.borderColor = UIColorFromHex(0x999999).CGColor;
    
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?f=png", [_LOGIC getImagePathUrlWithBaseUrl:_mode.platformIco]]] placeholderImage:[UIImage imageNamed:@"hot_commend_bannner_default.png"]];
    
    _platformNameLabel.text = _mode.orgName;
    
    NSMutableArray *tagMutableArray = [NSMutableArray array];
    if (_mode.orgTag && _mode.orgTag.length > 0)
    {
        NSArray *agentTagArray = [_mode.orgTag componentsSeparatedByString:@","];
        [tagMutableArray addObjectsFromArray:agentTagArray];
    }
    
    if ([tagMutableArray.lastObject isEqual:@""])
    {
        [tagMutableArray removeLastObject];
    }
    
    float fWidth = 0;
    CGFloat fPadding = 20;
    float fTotalWidth = 0;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:10] forKey:NSFontAttributeName];
    
    for (NSString *str in tagMutableArray)
    {
        CGSize size = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        fWidth += size.width;
    }
    fTotalWidth = fWidth + (tagMutableArray.count - 1) * fPadding;
    
    
    if (self.descAgentTagView.subviews.count > 0)
    {
        for (UIView *view in self.descAgentTagView.subviews)
        {
            [view removeFromSuperview];
        }
    }
    
    CGFloat fLeft = 0.0f;
    for (int i = 0; i < tagMutableArray.count; i++)
    {
        UIView *tmpView = [self createTag:_mode desc:[tagMutableArray objectAtIndex:i]];
        [tmpView setBackgroundColor:[UIColor whiteColor]];
        tmpView.layer.masksToBounds = YES;
        tmpView.layer.cornerRadius = 3;
        tmpView.layer.borderWidth = 0.5;
        tmpView.layer.borderColor = UIColorFromHex(0x4e8cef).CGColor;
        [self.descAgentTagView addSubview:tmpView];
        UILabel *tmpLabel = [tmpView viewWithTag:agentTag];
        [tmpLabel sizeToFit];
        float fWidth = tmpLabel.size.width + fPadding;

        __weak UIView *weakDescAgentTagView = self.descAgentTagView;
        __weak UILabel *weakLabel = tmpLabel;
        [tmpView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakDescAgentTagView.mas_top);
            make.left.equalTo(weakDescAgentTagView.mas_left).offset(fLeft);
            make.bottom.mas_equalTo(weakDescAgentTagView.mas_bottom);
            make.width.mas_equalTo(weakLabel.size.width + 10);
        }];
        
        fLeft += fWidth;
    }
    
    NSString *annualString = [NSString stringWithFormat:@"%@%@", _mode.feeRateMin == nil ? @"0.00" : _mode.feeRateMin, @"%"];
    if (![_mode.feeRateMin isEqual:(_mode.feeRateMax == nil ? @"0.00" : _mode.feeRateMax)])
    {
        annualString = [NSString stringWithFormat:@"%@%@~%@%@", _mode.feeRateMin, @"%", _mode.feeRateMax, @"%"];
    }
    _expectAnnualLabel.text = annualString;
    
    _annualCommisionLabel.text = [NSString stringWithFormat:@"%@%@",_mode.orgFeeRatio,@"%"];
    
    NSString *orgAdvantageString = [_mode.orgAdvantage stringByReplacingOccurrencesOfString:@"," withString:@"｜"];
    _agentAdvantageLabel.text = orgAdvantageString;
//    [_agentAdvantageLabel sizeToFit];
//    if (_agentAdvantageLabel.size.width > SCREEN_FRAME.size.width)
//    {
//        _agentAdvantageLabel.font = [UIFont systemFontOfSize:12];
//    }
//    else
//    {
//        _agentAdvantageLabel.font = [UIFont systemFontOfSize:13];
//    }
//    _agentAdvantageLabel.textAlignment = NSTextAlignmentCenter;
    
}

#pragma mark - 创建标签
- (UIView *)createTag:(XNFMAgentDetailMode *)params desc:(NSString *)desc
{
    UIView *descView = [[UIView alloc] init];
    
    UILabel *descLabel = [[UILabel alloc] init];
//    [descLabel setBackgroundColor:UIColorFromHex(0x4e8cef)];
    [descLabel setTag:agentTag];
    [descLabel setFont:[UIFont systemFontOfSize:10]];
    [descLabel setTextAlignment:NSTextAlignmentCenter];
    [descLabel setText:desc];
    [descLabel setTextColor:UIColorFromHex(0x4e8cef)];
    [descView addSubview:descLabel];
    
    __weak UIView *weakDescView = descView;
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakDescView.mas_left);
        make.top.equalTo(weakDescView.mas_top);
        make.right.equalTo(weakDescView.mas_right);
        make.bottom.equalTo(weakDescView.mas_bottom);
    }];
    
    return descView;
}

#pragma mark - 推荐平台给客户
- (void)recommendAction
{
    [XNUMengHelper umengEvent:@"T_1_5"];
    
    NSString *token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        //跳转到登录页面
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    [self.recommendVC show:ProductShareShow];
}

// 平台 我的账户 进入或注册
- (IBAction)agentAccount
{
    [XNUMengHelper umengEvent:@"T_1_4"];
    
    //判断是否登录
    NSString *token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    BOOL isExpired = [[_LOGIC getValueForKey:XN_USER_USER_TOKEN_EXPIRED] isEqualToString:@"1"];
    if (token == nil || [token isKindOfClass:[NSNull class]] || [token isEqual:[NSNull null]] || token.length < 1 || isExpired)
    {
        //跳转到登录页面
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        self.switchToHomePage = NO;
        return;
    }

    [self.myInformationModule removeObserver:self];
    [self.myInformationModule addObserver:self];
    self.initPlatformOpenState = NO;
    
    //判断是否绑卡
    [self.myInformationModule requestMySettingInfo];
    [self.view showGifLoading];
}

//////////////////////////////
#pragma mark - protocol Methods
//////////////////////////////////////////

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nTopCount = 0;
    if (_mode && _mode.orgFeeRatioLimit && self.mode.orgFeeRatioLimit.length > 0)
    {
        nTopCount = 1;
    }
    
    if (self.productsArray.count <= 0)
    {
        return 2 + nTopCount;
    }
    return self.productsArray.count + 1 + nTopCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = [indexPath row];
    
    NSInteger nTopRow = 0;
    if (_mode && _mode.orgFeeRatioLimit && self.mode.orgFeeRatioLimit.length > 0)
    {
        if (nRow == nTopRow)
        {
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UITableViewTopCell"];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewTopCell"];
                cell.backgroundColor = BACKGROUND_COLOR;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [self initTopCell:cell];
            }
            return cell;
        }
         
        nTopRow = 1;
    }
    
    if (nRow == nTopRow)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            cell.backgroundColor = BACKGROUND_COLOR;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [self initSystemCell:cell];
        }
        
        if (_mode && _mode.orgAdvertises.count > 0)
        {
            [self updateSystemCellHeight:cell];
        }
        return cell;
    }
    
    if (self.productsArray.count <= 0)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.backgroundColor = UIColorFromHex(0xf6f6f6);
            UILabel *label = [UILabel new];
            label.textColor = UIColorFromHex(0x999999);
            label.font = [UIFont systemFontOfSize:14];
            label.text = @"平台暂无可投产品";
            [cell addSubview:label];
            __weak UITableViewCell *weakCell = cell;
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(weakCell.mas_centerX);
                make.centerY.mas_equalTo(weakCell.mas_centerY);
                make.height.mas_equalTo(30);
            }];
        }
        return cell;
    }
    
    XNFMProductListItemMode *productItemMode = [self.productsArray objectAtIndex:nRow - 1 - nTopRow];
    ManagerFinancialProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ManagerFinancialProgressCell"];
   
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = BACKGROUND_COLOR;
    [cell refreshDataWithParams:productItemMode section:indexPath.section index:nRow - 1];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nTopRow = 0;
    
    if (_mode && _mode.orgFeeRatioLimit && self.mode.orgFeeRatioLimit.length > 0)
    {
        if (indexPath.row == nTopRow)
        {
            CGFloat fHeight = [self.mode.orgFeeRatioLimit getSpaceLabelHeightWithFont:12 withWidth:SCREEN_FRAME.size.width - 10 lineSpacing:4];
            return fHeight;
        }
        nTopRow = 1;
    }
    
//    if (self.productsArray.count <= 0)
//    {
//        return 50;
//    }
    
    if (indexPath.row == nTopRow)
    {
        float fPlatHeight = self.fDefaultHeight;//HEIGHT_DEFAULT;
        float fPlatActivityHeight = 0.0f;
        if (_mode && _mode.orgAdvertises.count > 0)
        {
            fPlatActivityHeight = PLATFORM_ACTIVITY_VIEW_HEIGHT;
        }
        if (self.platTabHeightDictionary.count < 1)
        {
            return (HEADVIEW_HEIGHT + DESC_VIEW_HEIGHT + fPlatHeight + 40 + 31 + 33) + fPlatActivityHeight - 10;
        }

        if ([self.platTabHeightDictionary objectForKey:[NSString stringWithFormat:@"%ld", _nCurrentTabTag]] && !_isShowDefaultHeight)
        {
            fPlatHeight = [[self.platTabHeightDictionary objectForKey:[NSString stringWithFormat:@"%ld",_nCurrentTabTag]] floatValue];
            
            if (_nCurrentTabTag == PlatIntroductTag && _isShowDefaultPlatIntroductHeight)
            {
                fPlatHeight = self.fDefaultHeight;
            }
            
        }
    
        __weak UIScrollView *weakTitleContainerScrollView = _titleContainerScrollView;
        [_listScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakTitleContainerScrollView.mas_bottom);
            make.left.equalTo(weakTitleContainerScrollView.mas_left);
            make.right.equalTo(weakTitleContainerScrollView.mas_right);
            make.height.mas_equalTo(fPlatHeight);
        }];
        
        return (HEADVIEW_HEIGHT + DESC_VIEW_HEIGHT + fPlatHeight + 40 + 31 + 33) + fPlatActivityHeight - 10;
    }
    
    return DEFAULTPROGRESSCELLHEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nTopRow = 0;
    if (_mode && _mode.orgFeeRatioLimit && self.mode.orgFeeRatioLimit.length > 0)
    {
        nTopRow = 1;
    }
    
    if (indexPath.row == nTopRow)
    {
        return;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger nRow = [indexPath row];
    _nSharedTag = ProductSharedTag;
    if (self.productsArray.count > nRow - 1 || (self.productsArray.count >= nRow - 1 && nTopRow == 1))
    {
        _selectedMode = [self.productsArray objectAtIndex:nRow - 1 - nTopRow];
        if (self.interactWebViewController)
        {
            self.interactWebViewController = nil;
        }
        
        NSString * url = [_LOGIC getComposeUrlWithBaseUrl:_selectedMode.openLinkUrl compose:[NSString stringWithFormat:@"productId=%@",_selectedMode.productId]];
        
        self.interactWebViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"GET"];
        self.interactWebViewController.delegate = self;
//        [self.interactWebViewController setSharedProductId:_selectedMode.productId];
        [self.interactWebViewController setProductDetailRecommend:_selectedMode];
        [self.interactWebViewController setNewWebView:YES];
        
        [_UI pushViewControllerFromRoot:self.interactWebViewController animated:YES];
    }
}

#pragma mark - 推荐给 理财师 客户 微信好友  微信朋友圈
- (NSDictionary *)recommendViewControllerAgentDid:(RecommendViewController *)controller shareType:(RecommendViewControllerType)clickType
{
    /***
     Rmanage = 0, // 推荐我的直推理财师
     Rclient,     // 推荐给我的客户
     Rcircle,     // 推荐到朋友圈
     Rfriend      // 推荐给好友
     **/
    if (clickType == Rmanage) {
        
        RecommendMemberViewController *recommendMemberVC = [[RecommendMemberViewController alloc] init];
        recommendMemberVC.productOrgId = _mode.orgNo;
        /*** 1=产品ID 2 =机构ID **/
        recommendMemberVC.IdType = @"2";
        [_UI pushViewControllerFromRoot:recommendMemberVC animated:YES];
    }
    
    else if (clickType == Rclient) {
    
        RecommendCustomerViewController *recommendCustomerVC = [[RecommendCustomerViewController alloc] init];
        recommendCustomerVC.productOrgId = _mode.orgNo;
        recommendCustomerVC.IdType = @"2";
        [_UI pushViewControllerFromRoot:recommendCustomerVC animated:YES];
    }
    
    else if (clickType == Rcircle) {
        
        NSString *shareLink = [NSString stringWithFormat:@"%@", [_LOGIC getWeChatWebUrlWithBaseUrl:[NSString stringWithFormat:@"/platformDetail?orgNumber=%@", _mode.orgNo]]];
        NSString *shareTitle = [NSString stringWithFormat:@"%@", _mode.orgName];
        NSString *shareDesc = [NSString stringWithFormat:@"%@，该平台已通过猎财大师36道风控流程筛选。", _mode.orgAdvantage];
        NSString *shareImgurl = [NSString stringWithFormat:@"%@?f=png", [_LOGIC getImagePathUrlWithBaseUrl:_mode.platformIco]];
        
        NSDictionary *dic = @{
                              @"shareLink":shareLink,
                              @"shareTitle":shareTitle,
                              @"shareDesc":shareDesc,
                              @"shareImgurl":shareImgurl
                              };
        
        return dic;
    }
    
    else if (clickType == Rfriend) {
    
        NSString *shareLink = [NSString stringWithFormat:@"%@", [_LOGIC getWeChatWebUrlWithBaseUrl:[NSString stringWithFormat:@"/platformDetail?orgNumber=%@", _mode.orgNo]]];
        NSString *shareTitle = [NSString stringWithFormat:@"%@", _mode.orgName];
        NSString *shareDesc = [NSString stringWithFormat:@"%@，该平台已通过猎财大师36道风控流程筛选。", _mode.orgAdvantage];
        NSString *shareImgurl = [NSString stringWithFormat:@"%@?f=png", [_LOGIC getImagePathUrlWithBaseUrl:_mode.platformIco]];
        
        NSDictionary *dic = @{
                              @"shareLink":shareLink,
                              @"shareTitle":shareTitle,
                              @"shareDesc":shareDesc,
                              @"shareImgurl":shareImgurl
                              };
        
        //https://prenliecai.toobei.com/platformDetail?orgNumber=OPEN_JIANGONGEDAI_WEB
        
        return dic;
    }
    
    return nil;
}


#pragma mark - AgentIntroductionViewControllerDelegate

#pragma mark - 展开显示更多平台信息
- (void)showPlatformMoreMsgWithHeight:(float)fHeight nTabTag:(NSInteger)nTag defaultHeight:(float)fDefaultHeight showDefaultHeight:(BOOL)isShowDefaultHeight
{
    if (nTag == PlatIntroductTag)
    {
        self.fDefaultHeight = fDefaultHeight;
        _isShowDefaultPlatIntroductHeight = isShowDefaultHeight;
    }
    
    [self.platTabHeightDictionary setObject:[NSString stringWithFormat:@"%f", fHeight] forKey:[NSString stringWithFormat:@"%ld", nTag]];
    _isShowDefaultHeight = NO;
//    _isShowDefaultPlatIntroductHeight = NO;
    [self.tableView reloadData];
}

#pragma mark - XNFinancialManagerModuleObserver

#pragma mark - 平台信息和详情
- (void)XNFinancialManagerModuleAgentDetailDidReceive:(XNFinancialManagerModule *)module
{
    [self.view hideLoading];
    _mode = module.agentDetailMode;
    if (_mode.orgFeeRatio == nil)
    {
        _mode.orgFeeRatio = @"0.00";
    }
    self.title = _mode.orgName;
    
    self.securityLevelLabel.text = _mode.orgLevel;
    
    /*
    //是未技术对接,1：是 ,0：否
    if (_mode.orgIsstaticproduct == 0)
    {
        _descLabel.text = XNPlatformHaveDocking;
    }
    else
    {
        _descLabel.text = XNPlatformNotDocking;
    }
     */
    
    if (_mode.orgAdvertises && _mode.orgAdvertises.count > 0)
    {
        NSMutableArray *imagesArray = [NSMutableArray array];
        NSMutableArray *urlArray = [NSMutableArray array];
        for (XNFMAgentActivityMode *itemMode in _mode.orgAdvertises)
        {
            NSString *imageUrlString = [_LOGIC getImagePathUrlWithBaseUrl:itemMode.orgActivityAdvertise];
            [imagesArray addObject:imageUrlString];
            [urlArray addObject:itemMode.orgActivityAdvertiseUrl];
        }
        self.activityImageUrlArray = [urlArray mutableCopy];
        
        [self.adScrollView refreshAdScrollViewWithAdObjectArray:urlArray urlArray:imagesArray];
    }
    
    //头部
    [self showAgentHeadView];
    [self initListContentView];
    [self.tableView reloadData];
}

- (void)XNFinancialManagerModuleAgentDetailDidFailed:(XNFinancialManagerModule *)module
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

#pragma mark - 平台在售产品
- (void)XNFinancialManagerModuleAgentSaleProductListDidReceive:(XNFinancialManagerModule *)module
{
    [self.tableView.mj_footer setHidden:NO];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (_nPageIndex == 1)
    {
        [self.productsArray removeAllObjects];
    }
    
    XNFMProductCategoryListMode *agentSaleProductListMode = module.agentSaleProductListMode;
    _nPageIndex = [agentSaleProductListMode.pageIndex integerValue];
    _nPageCount = [agentSaleProductListMode.pageCount integerValue];
    _saleProductCountLabel.text = [NSString stringWithFormat:@"在售产品(%@)", agentSaleProductListMode.totalCount];
    
    if (agentSaleProductListMode.dataArray.count > 0)
    {
        [self.productsArray addObjectsFromArray:agentSaleProductListMode.dataArray];
    }
    
    if (self.productsArray.count > 0)
    {
        self.buyButton.userInteractionEnabled = YES;
        self.buyButton.backgroundColor = UIColorFromHex(0x58c0fb);
    }
    else
    {
        self.buyButton.userInteractionEnabled = NO;
        self.buyButton.backgroundColor = UIColorFromHex(0x92aab6);
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
    
    [self.tableView reloadData];
}

- (void)XNFinancialManagerModuleAgentSaleProductListDidFailed:(XNFinancialManagerModule *)module
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    [self.tableView.mj_footer setHidden:NO];
    
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

#pragma mark - 佣金计算
- (void)getAppLhlcsCommissionCalc:(NSDictionary *)params
{
    FMComissionCaculateVController * comissionCaculateCtrl = [[FMComissionCaculateVController alloc]initWithNibName:@"FMComissionCaculateViewController" bundle:nil detailMode:_selectedMode];
    
    [_UI pushViewControllerFromRoot:comissionCaculateCtrl animated:YES];
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

#pragma mark - 返回微信加载图片状态
- (void)sharedImageUrlLoadingFinished:(BOOL)status
{
    if (status) {
        
        [self.view showGifLoading];
    }else
        [self.view hideLoading];
}

#pragma mark - 用户绑卡信息
- (void)XNMyInfoModulePeopleSettingDidReceive:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    
    //已绑卡
    if ([[[XNMyInformationModule defaultModule] settingMode] bundBankCard])
    {
        //是否已绑定
        [self.myInformationModule isBindOrgAcct:self.mode.orgNo];
        [self.view showGifLoading];
    }
    else
    {
        [self showCustomAlertViewWithTitle:@"为了您的资金安全，请先绑定银行卡" titleColor:[UIColor blackColor] titleFont:14 okTitle:@"确认" okTitleColor:[UIColor blackColor] okCompleteBlock:^{
            
            MIAddBankCardController *addBankCardCtrl = [[MIAddBankCardController alloc] initWithNibName:@"MIAddBankCardController" bundle:nil];
            [_LOGIC saveValueForKey:XN_USER_INIT_PAY_PASSWORD_CONTROLLER Value:@"AgentDetailViewController"];
            [_UI pushViewControllerFromRoot:addBankCardCtrl animated:YES];
            
        } cancelTitle:@"取消" cancelCompleteBlock:^{
            
        } topPadding:20 textAlignment:NSTextAlignmentCenter];
    }
}

- (void)XNMyInfoModulePeopleSettingDidFailed:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//是否绑定机构
- (void)XNMyInfoModuleIsBindOrgAcctDidReceive:(XNMyInformationModule *)module
{
    if (self.initPlatformOpenState) {
        
        self.thirdPartyOpenStateLabel.text = module.isBindCurOrg?@"进入":@"开通";
        return;
    }
    
    [self.view hideLoading];
    //已经绑定了第三方平台
    if (module.isBindCurOrg)
    {
        //进入详情
        [self.myInformationModule requestPlatformUserCenterUrl:self.mode.orgNo];
        [self.view showGifLoading];
    }
    else
    {
        //是否已经存在于第三方平台
        [self.myInformationModule isExistInPlatform:self.mode.orgNo];
        [self.view showGifLoading];
    }
}

- (void)XNMyInfoModuleIsBindOrgAcctDidFailed:(XNMyInformationModule *)module
{
    if (module.retCode.detailErrorDic)
    {
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

#pragma mark - 是否存在于第三方平台
- (void)XNMyInfoModuleIsExistInPlatformDidReceive:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    //已经注册过第三方平台（非通过t呗绑定第三方平台）
    if (module.isExistForThirdOrg)
    {
        NSString *titleString = [NSString stringWithFormat:@"您已有%@账号", self.mode.orgName];
        [PXAlertView xn_showCustomAlertWithTitle:titleString message:@"通过猎财大师投资不能享受佣金、津贴、红包等奖励，建议您购买其他平台产品。" cancelTitle:@"好的" otherTitle:nil completion:^(BOOL cancelled, NSInteger buttonIndex) {
            if (buttonIndex == 1)
            {
                MIAddBankCardController *addBankCardCtrl = [[MIAddBankCardController alloc] initWithNibName:@"MIAddBankCardController" bundle:nil];
                [_LOGIC saveValueForKey:XN_USER_INIT_PAY_PASSWORD_CONTROLLER Value:@"AgentDetailViewController"];
                [_UI pushViewControllerFromRoot:addBankCardCtrl animated:YES];
            }
        }];
    }
    else
    {
        NSString *titleString = [NSString stringWithFormat:@"一键开通%@账户?", self.mode.orgName];
        [PXAlertView xn_showCustomAlertWithTitle:titleString message:@"开通后，将同步个人身份信息和联系方式" cancelTitle:@"取消" otherTitle:@"一键开通" completion:^(BOOL cancelled, NSInteger buttonIndex) {
            if (buttonIndex == 1)
            {
                //绑定平台帐号
                [[XNMyInformationModule defaultModule] bindPlatformAccount:self.mode.orgNo];
                [self.view showGifLoading];
            }
        }];
    }
}

- (void)XNMyInfoModuleIsExistInPlatformDidFailed:(XNMyInformationModule *)module
{
    [[XNMyInformationModule defaultModule] removeObserver:self];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    [self.view hideLoading];
    
    if (module.retCode.detailErrorDic)
    {
        [[UIApplication sharedApplication].keyWindow showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [[UIApplication sharedApplication].keyWindow showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

#pragma mark - 绑定平台帐号
- (void)XNMyInfoModuleBindPlatformAccountDidReceive:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    
    //进入平台的产品
    //进入详情
    [self.myInformationModule requestPlatformUserCenterUrl:self.mode.orgNo];
    [self.view showGifLoading];
}

- (void)XNMyInfoModuleBindPlatformAccountDidFailed:(XNMyInformationModule *)module
{
    [self.myInformationModule removeObserver:self];
    [self.view hideLoading];
    if (module.retCode.detailErrorDic)
    {
        [[UIApplication sharedApplication].keyWindow showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [[UIApplication sharedApplication].keyWindow showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

#pragma mark - 绑定完成机构-产品跳转地址
- (void)XNMyInfoModulePlatformUserCenterUrlDidReceive:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    [self.myInformationModule removeObserver:self];
    
    XNPlatformUserCenterOrProductMode *mode = module.platformUserCenterMode;
    
    NSString *urlString = [NSString stringWithFormat:@"orgAccount=%@&orgKey=%@&orgNumber=%@&requestFrom=%@&sign=%@&timestamp=%@", mode.orgAccount, mode.orgKey, mode.orgNumber, mode.requestFrom, mode.sign, mode.timestamp];
    
    //进入平台用户中心
    UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:mode.orgUsercenterUrl httpBody:urlString requestMethod:@"POST"];
    [webCtrl setIsEnterThirdPlatform:YES platformName:self.mode.orgName];
    [webCtrl.view setBackgroundColor:[UIColor whiteColor]];
    [_UI pushViewControllerFromRoot:webCtrl animated:YES];
}

- (void)XNMyInfoModulePlatformUserCenterUrlDidFailed:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    [self.myInformationModule removeObserver:self];
    if (module.retCode.detailErrorDic)
    {
        [[UIApplication sharedApplication].keyWindow showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [[UIApplication sharedApplication].keyWindow showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

////////////////////
#pragma mark - setter/getter
////////////////////////////////////////////

#pragma mark - productsArray
- (NSMutableArray *)productsArray
{
    if (!_productsArray)
    {
        _productsArray = [[NSMutableArray alloc] init];
    }
    return _productsArray;
}

- (UIView *)cursorView
{
    if (!_cursorView)
    {
        _cursorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width / 4, 100)];
        _cursorView.backgroundColor = JFZ_COLOR_BLUE;
    }
    return _cursorView;
}

- (NSArray *)titleArray
{
    if (!_titleArray)
    {
        _titleArray = [[NSArray alloc] initWithObjects:@"简介", @"投资相关", @"档案", @"动态", nil];
    }
    return _titleArray;
}

- (NSMutableArray *)titleTabMutableArray
{
    if (!_titleTabMutableArray)
    {
        _titleTabMutableArray = [[NSMutableArray alloc] init];
    }
    return _titleTabMutableArray;
}

- (NSArray *)listCtrlArray
{
    if (!_listCtrlArray)
    {
        _listCtrlArray = [[NSArray alloc] initWithObjects:@"AgentIntroductionViewController", @"AgentIntroductionViewController", @"AgentIntroductionViewController", @"AgentIntroductionViewController", nil];
    }
    return _listCtrlArray;
}

- (NSMutableArray *)listContentMutableArray
{
    if (!_listContentMutableArray)
    {
        _listContentMutableArray = [[NSMutableArray alloc] init];
    }
    return _listContentMutableArray;
}

- (NSMutableDictionary *)platTabHeightDictionary
{
    if (!_platTabHeightDictionary)
    {
        _platTabHeightDictionary = [[NSMutableDictionary alloc] init];
    }
    return _platTabHeightDictionary;
}

- (NSMutableArray *)activityImageUrlArray
{
    if (!_activityImageUrlArray)
    {
        _activityImageUrlArray = [[NSMutableArray alloc] init];
    }
    return _activityImageUrlArray;
}

#pragma mark - adScrollView
- (CustomAdScrollView *)adScrollView
{
    if (!_adScrollView)
    {
        _adScrollView = [[CustomAdScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width, PLATFORM_ACTIVITY_VIEW_HEIGHT)];
        _adScrollView.autoPlay = YES;
        _adScrollView.interminal = 0.5f;
        _adScrollView.scrollDirection = CustomAdScrollRightDirection;
        
        weakSelf(weakSelf)
        [_adScrollView setClickedImgBlock:^(id object) {
            NSInteger nIndex = [weakSelf.activityImageUrlArray indexOfObject:object];
            weakSelf.nSharedTag = PlatformActivitySharedTag;
            weakSelf.selectedActivityMode = [weakSelf.mode.orgAdvertises objectAtIndex:nIndex];
            
            UniversalInteractWebViewController *webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:object requestMethod:@"GET"];
              
            [webCtrl setSharedOpertionWithParams:[NSDictionary dictionaryWithObjectsAndKeys:weakSelf.selectedActivityMode.shareTitle,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_TITLE,weakSelf.selectedActivityMode.shareDesc,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_DESC,weakSelf.selectedActivityMode.shareLink ,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_URL,[_LOGIC getImagePathUrlWithBaseUrl:weakSelf.selectedActivityMode.shareIcon],XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_IMGURL, nil]];
            
            [webCtrl setNewWebView:YES];
            
            [_UI pushViewControllerFromRoot:webCtrl animated:YES];
            
        }];
    }
    return _adScrollView;
}

#pragma mark－ 分享view
- (SharedViewController *)sharedCtrl
{
    if (!_sharedCtrl)
    {
        _sharedCtrl = [[SharedViewController alloc] init];
        _sharedCtrl.delegate = self;
    }
    return _sharedCtrl;
}

- (RecommendViewController *)recommendVC
{
    if (!_recommendVC) {
        
        _recommendVC = [[RecommendViewController alloc] init];
        
        _recommendVC.signDelegate = nil;
        _recommendVC.proDelegate = nil;
        _recommendVC.agentDelegate = self;
        
        _recommendVC.shareTitle = @"选择推荐平台方式";
    }
    return _recommendVC;
}

//myInformationModule
- (XNMyInformationModule *)myInformationModule
{
    if (!_myInformationModule) {
        
        _myInformationModule = [[XNMyInformationModule alloc]init];
    }
    
    return _myInformationModule;
}


@end
