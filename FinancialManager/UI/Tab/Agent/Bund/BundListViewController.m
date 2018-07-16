//
//  BundListViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/17/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "BundListViewController.h"
#import "BundHeaderCell.h"
#import "BundCell.h"
#import "MFSystemInvitedEmptyCell.h"
#import "PXAlertView+XNExtenstion.h"
#import "PopContainerViewController.h"
#import "MIAddBankCardController.h"
#import "NetworkUnReachStatusView.h"

#import "XNBundModule.h"
#import "XNBundModuleObserver.h"
#import "XNBundListMode.h"
#import "XNBundItemMode.h"
#import "XNBundThirdPageMode.h"
#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"
#import "MIMySetMode.h"
#import "XNBundSelectTypeMode.h"

#define HEADERHEIGHT ((125 * SCREEN_FRAME.size.width) / 375.0 + 40)
#define CELLHEIGHT 86.0

@interface BundListViewController ()<UITableViewDataSource,UITableViewDelegate,UniversalInteractWebViewControllerDelegate,UIScrollViewDelegate, XNBundModuleObserver, XNMyInformationModuleObserver, BundHeaderCellDelegate, PopContainerViewControllerDelegate>


@property (nonatomic, weak) IBOutlet UITableView  *tableView;

@property (nonatomic, strong) XNBundModule   * bundModuleRequest;
@property (nonatomic, strong) XNMyInformationModule * myInfomationModuleRequest;
@property (nonatomic, strong) NSMutableArray *datasArray;
@property (nonatomic, strong) XNBundItemMode *selectBundItemMode;
@property (nonatomic, assign) NSInteger nPageIndex;
@property (nonatomic, strong) PopContainerViewController *typePopViewController;
@property (nonatomic, strong) PopContainerViewController *periodPopViewController;
@property (nonatomic, strong) NetworkUnReachStatusView * networkErrorView;

@property (nonatomic, assign) BOOL isShowTypePopView;
@property (nonatomic, assign) BOOL isShowPeriodPopView;

@property (nonatomic, strong) NSString *defaultFundTypeString;
@property (nonatomic, strong) NSString *defaultPeriodTypeString;


@property (nonatomic, strong) NSMutableArray *selectedFundTypeValueArray;

@property (nonatomic, strong) NSMutableArray *typeArray;
@property (nonatomic, strong) NSMutableArray *periodArray;

@property (nonatomic, strong) NSMutableArray *typeStringArray;
@property (nonatomic, strong) NSMutableArray *periodStringArray;
@property (nonatomic, assign) BOOL isAbnormalStatus;

@end

@implementation BundListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.typePopViewController.view setHidden:YES];
    [self.periodPopViewController.view setHidden:YES];
    self.tableView.scrollEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //展示筛选后的类型
    if (![[_LOGIC getValueForKey:XN_IS_DEFAULT_TYPE_FUND_LIST_TAG] boolValue])
    {
        [_LOGIC saveValueForKey:XN_IS_DEFAULT_TYPE_FUND_LIST_TAG Value:@"1"];
        return;
    }
    
    [self selectDefaultType];
    [self loadDatas];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.bundModuleRequest removeObserver:self];
    [self.myInfomationModuleRequest removeObserver:self];
}

/////////////////
#pragma mark - 自定义
/////////////////////////////////

//初始化
- (void)initView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDefaultTypeList:) name:XN_DEFAULT_TYPE_FUND_LIST_NOTIFICATION object:nil];
    
    [_LOGIC saveValueForKey:XN_IS_DEFAULT_TYPE_FUND_LIST_TAG Value:@"1"];
    self.nPageIndex = 1;
    self.isAbnormalStatus = NO;
    [self.bundModuleRequest addObserver:self];
    [self.myInfomationModuleRequest addObserver:self];
    
    self.isShowTypePopView = NO;
    self.isShowPeriodPopView = NO;
    self.defaultFundTypeString = @"";
    self.defaultPeriodTypeString = @"";
    self.selectedFundTypeString = @"";
    self.selectedFundTypeValueString = @"";
    self.selectedPeriodTypeString = @"";
    self.selectedPeriodValueString = @"";
    
    [self selectDefaultType];
    
    [self.view addSubview:self.typePopViewController.view];
    [self.view addSubview:self.periodPopViewController.view];
    
    weakSelf(weakSelf)
    [self.typePopViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(HEADERHEIGHT);
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.right.mas_equalTo(weakSelf.view.mas_right);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
    }];
    
    [self.periodPopViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(HEADERHEIGHT);
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.right.mas_equalTo(weakSelf.view.mas_right);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
    }];
    
    [_tableView registerNib:[UINib nibWithNibName:@"BundHeaderCell" bundle:nil] forCellReuseIdentifier:@"BundHeaderCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MFSystemInvitedEmptyCell" bundle:nil] forCellReuseIdentifier:@"MFSystemInvitedEmptyCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BundCell" bundle:nil] forCellReuseIdentifier:@"BundCell"];
    
    
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

#pragma mark - 默认选中的类型
- (void)selectDefaultType
{
    [self.typeArray removeAllObjects];
    [self.periodArray removeAllObjects];
    [self.typeStringArray removeAllObjects];
    [self.periodStringArray removeAllObjects];
    [self.selectedFundTypeValueArray removeAllObjects];
    
    NSDictionary *dic = [_LOGIC readDicDataFromFileName:@"bundTypeList.plist"];
    if (dic != nil)
    {
        self.defaultFundTypeString = [dic objectForKey:@"defaultFundType"];
        self.defaultPeriodTypeString = [dic objectForKey:@"defaultPeriod"];
        self.selectedFundTypeString = self.defaultFundTypeString;
        self.selectedPeriodTypeString = self.defaultPeriodTypeString;
        
        NSArray *fundTypeArray = [dic objectForKey:@"fundTypeList"];
        NSArray *periodArray = [dic objectForKey:@"periodList"];
        if (fundTypeArray && fundTypeArray.count > 0)
        {
            XNBundSelectTypeMode *mode = nil;
            for (NSDictionary *dic in fundTypeArray)
            {
                mode = [XNBundSelectTypeMode initWithObject:dic];
                [self.typeArray addObject:mode];
                [self.typeStringArray addObject:mode.fundTypeValue];
                if ([mode.fundTypeKey isEqualToString:self.selectedFundTypeString])
                {
                    self.selectedFundTypeValueString = mode.fundTypeValue;
                }
            }
        }
        
        if (periodArray && periodArray.count > 0)
        {
            XNBundSelectTypeMode *mode = nil;
            for (NSDictionary *dic in periodArray)
            {
                mode = [XNBundSelectTypeMode initWithObject:dic];
                [self.periodArray addObject:mode];
                [self.periodStringArray addObject:mode.fundTypeValue];
                if ([mode.fundTypeKey isEqualToString:self.selectedPeriodTypeString])
                {
                    self.selectedPeriodValueString = mode.fundTypeValue;
                }
                
            }
        }
    }
    
    [self.selectedFundTypeValueArray addObject:self.selectedFundTypeValueString];
}

#pragma mark - 加载数据
- (void)loadDatas
{
    [self.networkErrorView removeFromSuperview];
    if ([_ASSIST getNetworkStatus] == Network_NotReachable) {
        
        [self.view addSubview:self.networkErrorView];
        
        weakSelf(weakSelf)
        [self.networkErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakSelf.view);
        }];
        
        return;
    }
    
    if (self.nPageIndex < 1)
    {
        self.nPageIndex = 1;
    }
    
    //基金列表
    [self.bundModuleRequest requestBundListWithFundCodes:@"" fundHouseCode:@"" fundType:self.selectedFundTypeString geographicalSector:@"" isBuyEnable:@"0" isMMFund:@"" isQDII:@"" isRecommended:@"" pageIndex:[NSString stringWithFormat:@"%ld", self.nPageIndex] pageSize:@"10" period:self.selectedPeriodTypeString queryCodeOrName:@"" shortName:@"" sort:@"DESC" specializeSector:@""];
    
}

#pragma mark - 展示默认类型数据
- (void)showDefaultTypeList:(NSNotification *)notification
{
    BOOL isFirstIn = [[[notification userInfo] objectForKey:@"isFirstIn"] boolValue];
    if (isFirstIn)
    {
        return;
    }
    [_LOGIC saveValueForKey:XN_IS_DEFAULT_TYPE_FUND_LIST_TAG Value:@"1"];
    [self selectDefaultType];
    [self loadDatas];
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
        static NSString *cellIdentifierString = @"BundHeaderCell";
        BundHeaderCell *cell = (BundHeaderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
        cell.delegate = self;
        [cell showDatas:self.selectedPeriodValueString];
        
        return cell;
    }
    
    if (self.datasArray.count <= 0)
    {
        MFSystemInvitedEmptyCell *emptyCell = (MFSystemInvitedEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"MFSystemInvitedEmptyCell"];
        
        //报异常
        if (self.isAbnormalStatus)
        {
            [emptyCell refreshTitle:@"该页面已经飞到了外太空，\n请稍后再试" imageView:@"XN_My_Fund_Error_icon"];
        }
        else
        {
            [emptyCell refreshTitle:@"暂无基金"];
        }
        
        [emptyCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return emptyCell;
    }
    
    static NSString *cellIdentifierString = @"BundCell";
    BundCell *cell = (BundCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
    
    [cell showDatas:[self.datasArray objectAtIndex:nRow - 1] selectedPeriodType:self.selectedPeriodTypeString selectedPeriod:self.selectedPeriodValueString];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = indexPath.row;
    if (nRow == 0)
    {
        return HEADERHEIGHT;
    }
    
    if (self.datasArray.count <= 0)
    {
        return SCREEN_FRAME.size.height - HEADERHEIGHT;
    }
    
    return CELLHEIGHT;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = [indexPath row];
    if (nRow == 0 || self.datasArray.count <= 0)
    {
        return;
    }
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectBundItemMode = [self.datasArray objectAtIndex:(nRow - 1)];
    
    [XNUMengHelper umengEvent:@"T_3_2"];
    
    //是否登陆
    NSString *token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    BOOL isExpired = [[_LOGIC getValueForKey:XN_USER_USER_TOKEN_EXPIRED] isEqualToString:@"1"];
    if (token == nil || [token isKindOfClass:[NSNull class]] || [token isEqual:[NSNull null]] || token.length < 1 || isExpired)
    {
        //弹框
        [self showCustomAlertViewWithTitle:@"基金详情需登录后才可查看" titleColor:[UIColor blackColor] titleFont:14 okTitle:@"立即登录" okTitleColor:[UIColor blackColor] okCompleteBlock:^{
            
            //跳转到登录页面
            [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
            [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
            
            
        } cancelTitle:@"取消" cancelCompleteBlock:^{
            
        } topPadding:20 textAlignment:NSTextAlignmentCenter];
        
        return;
    }
    
    //判断是否绑卡
    [self.myInfomationModuleRequest requestMySettingInfo];
    [self.view showGifLoading];
    
}

#pragma mark - BundHeaderCellDelegate
- (void)bundHeaderCellDidClick:(NSInteger)nTag
{
    CGFloat fTop = self.tableView.contentOffset.y;
    CGFloat lastTop = HEADERHEIGHT - fTop;
    
    weakSelf(weakSelf)
    [self.typePopViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(lastTop);
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.right.mas_equalTo(weakSelf.view.mas_right);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
    }];
    
    [self.periodPopViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(lastTop);
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.right.mas_equalTo(weakSelf.view.mas_right);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
    }];
    
    switch (nTag) {
        case 1: //基金类型
        {
            self.periodPopViewController.view.hidden = YES;
            if (!self.isShowTypePopView)
            {
                self.isShowTypePopView = YES;
                self.typePopViewController.view.hidden = NO;
                [self.typePopViewController updateDatas:self.typeStringArray selectedArray:self.selectedFundTypeValueArray];
                self.tableView.scrollEnabled = NO;
            }
            else
            {
                self.isShowTypePopView = NO;
                self.typePopViewController.view.hidden = YES;
                self.tableView.scrollEnabled = YES;
            }
            
        }
            break;
        case 2: //收益率
        {
            self.typePopViewController.view.hidden = YES;
            if (!self.isShowPeriodPopView)
            {
                self.isShowPeriodPopView = YES;
                self.periodPopViewController.view.hidden = NO;
                [self.periodPopViewController updateDatas:self.periodStringArray selectedArray:[[NSArray alloc] initWithObjects:self.selectedPeriodValueString, nil]];
                self.tableView.scrollEnabled = NO;
            }
            else
            {
                self.isShowPeriodPopView = NO;
                self.periodPopViewController.view.hidden = YES;
                self.tableView.scrollEnabled = YES;
            }
        }
            break;
        case 100: //banner页
        {
            UniversalInteractWebViewController * ctrl = [[UniversalInteractWebViewController alloc] initRequestUrl:[_LOGIC getComposeUrlWithBaseUrl:[[AppFramework getConfig].XN_REQUEST_H5_BASE_URL stringByAppendingString:@"/pages/guide/fundIntro.html"] compose:@""] requestMethod:@"GET"];
            [ctrl setNewWebView:YES];
            
            [_UI pushViewControllerFromRoot:ctrl animated:YES];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - PopContainerViewControllerDelegate
- (void)popContainerViewControllerClick:(NSArray *)selectedArray
{
    if (selectedArray.count <= 0)
    {
        return;
    }
    self.nPageIndex = 1;
    
    //基金类型
    if ([self.typeStringArray containsObject:selectedArray.firstObject])
    {
        [self.selectedFundTypeValueArray removeAllObjects];
        [self.selectedFundTypeValueArray addObjectsFromArray:selectedArray];
        NSMutableString *mutableTypeString = [[NSMutableString alloc] initWithString:@""];
        for (XNBundSelectTypeMode *mode in self.typeArray)
        {
            NSString *typeString = mode.fundTypeValue;
            for (NSString *str in selectedArray)
            {
                if ([typeString containsString:str])
                {
                    [mutableTypeString appendFormat:@"%@,",mode.fundTypeKey];
                    
                    break;
                }
            }
        }
        
        self.selectedFundTypeString = mutableTypeString;
        
    }
    
    if ([self.selectedFundTypeString hasSuffix:@","])
    {
        self.selectedFundTypeString = [self.selectedFundTypeString substringWithRange:NSMakeRange(0, self.selectedFundTypeString.length - 1)];
    }
    
    //基金收益类型
    if ([self.periodStringArray containsObject:selectedArray.firstObject])
    {
        
        for (XNBundSelectTypeMode *mode in self.periodArray)
        {
            NSString *periodString = mode.fundTypeValue;
            for (NSString *str in selectedArray)
            {
                if ([periodString containsString:str])
                {
                    self.selectedPeriodTypeString = mode.fundTypeKey;
                    self.selectedPeriodValueString = mode.fundTypeValue;
                    break;
                }
            }
        }
    }
    
    [self loadDatas];
}

- (void)popContainerViewControllerHidden
{
    self.tableView.scrollEnabled = YES;
}

#pragma mark - 基金列表
- (void)XNBundModuleBundListDidReceive:(XNBundModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    XNBundListMode *mode = module.bundListMode;
    _nPageIndex = [mode.pageIndex integerValue];
    
    if (_nPageIndex == 1)
    {
        [self.datasArray removeAllObjects];
    }
    
    if (mode.datas.count > 0)
    {
        [self.datasArray addObjectsFromArray:mode.datas];
    }
    
    if (_nPageIndex >= [mode.pageCount integerValue])
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

- (void)XNBundModuleBundListDidFailed:(XNBundModule *)module
{
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    //系统异常
    if ([module.retCode.ret isEqualToString:@"-999999"])
    {
        self.isAbnormalStatus = YES;
        [self.datasArray removeAllObjects];
        [_tableView.mj_footer setHidden:YES];
        [self.tableView reloadData];
        return;
    }
    
    if (module.retCode.detailErrorDic)
    {
        if (![module.retCode.ret isEqualToString:@"100006"] && ![module.retCode.ret isEqualToString:@"-999999"])
        {
           [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
        }
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }

}

#pragma mark - 用户绑卡信息
- (void)XNMyInfoModulePeopleSettingDidReceive:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    
    //已绑卡
    if ([[self.myInfomationModuleRequest settingMode] bundBankCard])
    {
        //是否已注册基金账户
        [self.bundModuleRequest isRegisterBundResult];
        [self.view showGifLoading];
    }
    else
    {
        [self showCustomAlertViewWithTitle:@"为了您的资金安全，请先绑定银行卡" titleColor:[UIColor blackColor] titleFont:14 okTitle:@"确认" okTitleColor:[UIColor blackColor] okCompleteBlock:^{
            
            MIAddBankCardController *addBankCardCtrl = [[MIAddBankCardController alloc] initWithNibName:@"MIAddBankCardController" bundle:nil];
            [_UI pushViewControllerFromRoot:addBankCardCtrl animated:YES];
            
        } cancelTitle:@"取消" cancelCompleteBlock:^{
            
        } topPadding:20 textAlignment:NSTextAlignmentCenter];
        
    }
}

- (void)XNMyInfoModulePeopleSettingDidFailed:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    
    if (module.retCode.detailErrorDic)
    {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

#pragma mark - 是否注册过基金
- (void)XNBundModuleIsRegisterBundDidReceive:(XNBundModule *)module
{
    [self.view hideLoading];
    //已注册
    if (module.isRegisterBund)
    {
        //跳转到基金平台对应的基金详情
        [self.bundModuleRequest gotoFundDetail:self.selectBundItemMode.fundCode];
        [self.view showGifLoading];
    }
    else
    {
        //开通注册基金平台
        [self showFMRecommandViewWithTitle:@"一键开通基金账户?" subTitle:@"开通后，将同步个人身份信息和联系方式" subTitleLeftPadding:12 otherSubTitle:@"" okTitle:@"一键开通" okCompleteBlock:^{
            
            //注册基金平台
            [self.bundModuleRequest registerBund];
            [self.view showGifLoading];
            
        } cancelTitle:@"取消" cancelCompleteBlock:^{
            
        }];
    }
    
}

- (void)XNBundModuleIsRegisterBundDidFailed:(XNBundModule *)module
{
    [self.view hideLoading];
    
    if (module.retCode.detailErrorDic)
    {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

#pragma mark - 注册基金
- (void)XNBundModuleRegisterBundDidReceive:(XNBundModule *)module
{
    [self.view hideLoading];
    //跳转基金平台
    [self.bundModuleRequest gotoFundDetail:self.selectBundItemMode.fundCode];
    [self.view showGifLoading];
}

- (void)XNBundModuleRegisterBundDidFailed:(XNBundModule *)module
{
    [self.view hideLoading];
    
    if (module.retCode.detailErrorDic)
    {
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

#pragma mark - 奕丰基金详情页跳转
- (void)XNBundModuleRegisterGotoBundDetailDidReceive:(XNBundModule *)module
{
    [self.view hideLoading];
    //是否为默认展示类型
    [_LOGIC saveValueForKey:XN_IS_DEFAULT_TYPE_FUND_LIST_TAG Value:@"0"];
    
    XNBundThirdPageMode *mode = module.bundThirdPageMode;
    
    NSString *urlString = [NSString stringWithFormat:@"%@?data=%@&integrationMode=%@&productCode=%@&referral=%@", mode.requestUrl, mode.data, mode.integrationMode, mode.productCode, mode.referral];
    UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:urlString requestMethod:@"POST"];
    [webCtrl setTitleName:@""];
    
    [webCtrl setIsEnterThirdPlatform:YES platformName:@"奕丰金融"];
    [webCtrl.view setBackgroundColor:[UIColor whiteColor]];
    [_UI pushViewControllerFromHomeViewControllerForController:webCtrl hideNavigationBar:NO animated:YES];
    
}

- (void)XNBundModuleRegisterGotoBundDetailDidFailed:(XNBundModule *)module
{
    [self.view hideLoading];
    
    if (module.retCode.detailErrorDic)
    {
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}


////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

#pragma mark - datasArray
- (NSMutableArray *)datasArray
{
    if (!_datasArray)
    {
        _datasArray = [[NSMutableArray alloc] init];
    }
    return _datasArray;
}

#pragma mark - typeArray
- (NSMutableArray *)typeArray
{
    if (!_typeArray)
    {
        _typeArray = [[NSMutableArray alloc] init];
    }
    return _typeArray;
}

#pragma mark - periodArray
- (NSMutableArray *)periodArray
{
    if (!_periodArray)
    {
        _periodArray = [[NSMutableArray alloc] init];
    }
    return _periodArray;
}

#pragma mark - typeStringArray
- (NSMutableArray *)typeStringArray
{
    if (!_typeStringArray)
    {
        _typeStringArray = [[NSMutableArray alloc] init];
    }
    return _typeStringArray;
}

#pragma mark - periodStringArray
- (NSMutableArray *)periodStringArray
{
    if (!_periodStringArray)
    {
        _periodStringArray = [[NSMutableArray alloc] init];
    }
    return _periodStringArray;
}

#pragma mark - selectedFundTypeValueArray
- (NSMutableArray *)selectedFundTypeValueArray
{
    if (!_selectedFundTypeValueArray)
    {
        _selectedFundTypeValueArray = [[NSMutableArray alloc] init];
    }
    return _selectedFundTypeValueArray;
}

#pragma mark - typePopViewController
- (PopContainerViewController *)typePopViewController
{
    if (!_typePopViewController)
    {
        _typePopViewController = [[PopContainerViewController alloc] initWithDatas:YES topPadding:HEADERHEIGHT leftPadding:0 datas:self.typeStringArray];
        _typePopViewController.delegate = self;
    }
    return _typePopViewController;
}

#pragma mark - periodPopViewController
- (PopContainerViewController *)periodPopViewController
{
    if (!_periodPopViewController)
    {
        _periodPopViewController = [[PopContainerViewController alloc] initWithDatas:NO topPadding:HEADERHEIGHT leftPadding:(SCREEN_FRAME.size.width / 2) datas:self.periodStringArray];
        _periodPopViewController.delegate = self;
    }
    return _periodPopViewController;
}

//请求对象
- (XNBundModule *)bundModuleRequest
{
    if (!_bundModuleRequest) {
        
        _bundModuleRequest = [[XNBundModule alloc]init];
    }
    return _bundModuleRequest;
}

- (XNMyInformationModule *)myInfomationModuleRequest
{
    if (!_myInfomationModuleRequest) {
        
        _myInfomationModuleRequest = [[XNMyInformationModule alloc]init];
    }
    return _myInfomationModuleRequest;
}

//无网络视图
- (NetworkUnReachStatusView *)networkErrorView
{
    if (!_networkErrorView) {
        
        _networkErrorView = [[NetworkUnReachStatusView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
        [_networkErrorView setNetworkUnReachStatusImage:@"" title:@"请检查您的网络"];
        
        weakSelf(weakSelf)
        [_networkErrorView setNetworkRetryOperation:^{
            
            [weakSelf loadDatas];
        }];
    }
    return _networkErrorView;
}

@end
