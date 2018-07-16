//
//  BundSearchViewController.m
//  FinancialManager
//
//  Created by xnkj on 22/08/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "BundSearchViewController.h"

#import "BundCell.h"
#import "BundUnNormalCell.h"
#import "MFProductListEmptyCell.h"
#import "PXAlertView.h"
#import "PXAlertView+XNExtenstion.h"

#import "MIAddBankCardController.h"
#import "NetworkUnReachStatusView.h"

#import "XNBundThirdPageMode.h"
#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"
#import "MIMySetMode.h"
#import "XNBundItemMode.h"
#import "XNBundListMode.h"
#import "XNBundModule.h"
#import "XNBundModuleObserver.h"

#define DEFAULTPAGEINDEX @"1"
#define DEFAULTPAGESIZE @"10"

#define DEFAULTBUNDSCELLHEIGHT 86.0f

@interface BundSearchViewController ()<UITextFieldDelegate,XNBundModuleObserver,XNMyInformationModuleObserver>

@property (nonatomic, assign) BOOL  finishedRequest;//是否完成了请求
@property (nonatomic, assign) BOOL  requestUnNormal;//是否请求异常
@property (nonatomic, strong) NSString * queryBundsStr;//查询基金字符串
@property (nonatomic, strong) NSString * selectedPeriodTypeString;//选中的基金时间类型
@property (nonatomic, strong) NSString * selectedPeriodValueString;//选中的基金时间显示
@property (nonatomic, strong) NSString * selectedFundTypeString; //选中的基金类型
@property (nonatomic, strong) NSString * selectedFundTypeValueString; //选中的基金类型值

@property (nonatomic, strong) NSMutableArray * bundsArray;
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@property (nonatomic, strong) XNBundItemMode *selectBundItemMode;
@property (nonatomic, strong) XNBundModule * bundModuleRequest;
@property (nonatomic, strong) XNMyInformationModule * myInfomationModuleRequest;
@property (nonatomic, strong) NetworkUnReachStatusView * networkErrorView;

@property (nonatomic, weak) IBOutlet UITextField * searchTextField;
@property (nonatomic, weak) IBOutlet UITableView * bundsListView;
@end

@implementation BundSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil selectedPeriodType:(NSString *)selectedPeriodType selectedPeriodString:(NSString *)selectedPeriodString selectedFundTypeString:(NSString *)selectedFundTypeString selectedFundTypeValueString:(NSString *)selectedFundTypeValueString
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.selectedPeriodTypeString = selectedPeriodType;
        self.selectedPeriodValueString = selectedPeriodString;
        self.selectedFundTypeString = selectedFundTypeString;
        self.selectedFundTypeValueString = selectedFundTypeValueString;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//////////////
#pragma mark - 自定义方法
///////////////////////////////////

//初始化
- (void)initView
{
    self.finishedRequest = NO;
    self.requestUnNormal = NO;
    self.queryBundsStr = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchContentChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self.bundsListView registerNib:[UINib nibWithNibName:@"BundCell" bundle:nil] forCellReuseIdentifier:@"BundCell"];
    [self.bundsListView registerNib:[UINib nibWithNibName:@"MFProductListEmptyCell" bundle:nil] forCellReuseIdentifier:@"MFProductListEmptyCell"];
    [self.bundsListView registerNib:[UINib nibWithNibName:@"BundUnNormalCell" bundle:nil] forCellReuseIdentifier:@"BundUnNormalCell"];
    
    weakSelf(weakSelf)
//    self.bundsListView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//       
//        [weakSelf queryBundsListWithPageIndex:DEFAULTPAGEINDEX];
//    }];
    self.bundsListView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf queryBundsListWithPageIndex:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:([[[weakSelf.bundModuleRequest bundListMode] pageIndex] integerValue] + 1)]]];
    }];
    [self.bundsListView.mj_footer setHidden:YES];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

//请求接口
- (void)queryBundsListWithPageIndex:(NSString *)pageIndex
{
    [self.networkErrorView removeFromSuperview];
    if ([_ASSIST getNetworkStatus] == Network_NotReachable) {
        
        [self.view addSubview:self.networkErrorView];
        
        weakSelf(weakSelf)
        [self.networkErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakSelf.view);
        }];
        
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        return;
    }
    
    self.finishedRequest = NO;
    self.requestUnNormal = NO;
    
    [self.bundModuleRequest requestBundListWithFundCodes:@""
                                                 fundHouseCode:@""
                                                      fundType:@""
                                            geographicalSector:@""
                                                   isBuyEnable:@""
                                                      isMMFund:@""
                                                        isQDII:@""
                                                 isRecommended:@""
                                                     pageIndex:pageIndex
                                                      pageSize:DEFAULTPAGESIZE
                                                        period:self.selectedPeriodTypeString
                                               queryCodeOrName:self.queryBundsStr
                                                     shortName:@""
                                                          sort:@""
                                              specializeSector:@""];
    [self.view showGifLoading];
}

//搜索内容发生变化
- (void)searchContentChange
{
    self.queryBundsStr = self.searchTextField.text;
    
    [self queryBundsListWithPageIndex:DEFAULTPAGEINDEX];
}

//block初始化
- (void)setInitClickExitSearchBlock:(ExitSearch)block
{
    if (block) {
        
        self.exitSearchBlock = nil;
        self.exitSearchBlock = block;
    }
}

//添加观察者
- (void)addObserver
{
    [self.bundModuleRequest addObserver:self];
    [self.myInfomationModuleRequest addObserver:self];
}

//取消
- (IBAction)clickCancelSearch:(id)sender
{
    [self.bundModuleRequest removeObserver:self];
    [self.myInfomationModuleRequest removeObserver:self];
    
    if (self.exitSearchBlock) {
        
        self.exitSearchBlock();
    }
}

- (void)keyboardShow:(NSNotification *)notif
{
    [self.view addGestureRecognizer:self.tapGesture];
}

- (void)keyboardHide:(NSNotification *)notif
{
    [self.view removeGestureRecognizer:self.tapGesture];
}

#pragma mark - 退出键盘
- (void)exitKeyboard:(UIGestureRecognizer *)gesture
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

//////////////////////////////
#pragma mark - protocol Methods
//////////////////////////////////////////

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.finishedRequest) {
    
        if (self.bundsArray.count <= 0 || self.requestUnNormal) {
            
            return 1;
        }
        
        return self.bundsArray.count;
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   return 0.00001;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bundsArray.count <= 0 || self.requestUnNormal) {
        
        return  SCREEN_FRAME.size.height - 57.0 - 49 - 64.0;
    }
    
    return DEFAULTBUNDSCELLHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bundsArray.count <= 0 && !self.requestUnNormal) {
        
        MFProductListEmptyCell * cell = (MFProductListEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"MFProductListEmptyCell"];
        
        return cell;
    }
    
    if (self.requestUnNormal) {
        
        BundUnNormalCell * cell = (BundUnNormalCell *)[tableView dequeueReusableCellWithIdentifier:@"BundUnNormalCell"];
        
        return cell;
    }
    
    BundCell * cell = (BundCell *)[tableView dequeueReusableCellWithIdentifier:@"BundCell"];
    
    [cell showDatas:[self.bundsArray objectAtIndex:indexPath.row] selectedPeriodType:self.selectedPeriodTypeString selectedPeriod:self.self.selectedPeriodValueString];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.bundsListView deselectRowAtIndexPath:indexPath animated:YES];
    
    //异常处理
    if (self.requestUnNormal) {
        
        [self queryBundsListWithPageIndex:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:([[[self.bundModuleRequest bundListMode] pageIndex] integerValue] + 1)]]];
        
        return;
    }
    
    if (self.bundsArray.count <= 0) {
        
        return;
    }
    
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
    
    self.selectBundItemMode = [self.bundsArray objectAtIndex:indexPath.row];
    
    //判断是否绑卡
    [self.myInfomationModuleRequest requestMySettingInfo];
    [self.view showGifLoading];
}

//基金列表请求回调
- (void)XNBundModuleBundListDidReceive:(XNBundModule *)module
{
    [self.bundsListView.mj_header endRefreshing];
    [self.bundsListView.mj_footer endRefreshing];
    [self.view hideLoading];
    self.finishedRequest = YES;
    self.requestUnNormal = NO;
    
    if (module.bundListMode.pageIndex.integerValue == 1) {
        
        [self.bundsArray removeAllObjects];
    }
    
    [self.bundsArray addObjectsFromArray:module.bundListMode.datas];
    
    if (module.bundListMode.pageIndex.integerValue >= module.bundListMode.pageCount.integerValue) {
        
        [self.bundsListView.mj_footer endRefreshingWithNoMoreData];
        [self.bundsListView.mj_footer setHidden:YES];
    }
    else
    {
        [self.bundsListView.mj_footer resetNoMoreData];
        [self.bundsListView.mj_footer setHidden:NO];
    }
    
    [self.bundsListView reloadData];
}

- (void)XNBundModuleBundListDidFailed:(XNBundModule *)module
{
    [self.bundsListView.mj_header endRefreshing];
    [self.bundsListView.mj_footer endRefreshing];
    [self.view hideLoading];
    self.finishedRequest = YES;
    self.requestUnNormal = NO;
    
    //系统异常
    if ([module.retCode.ret isEqualToString:@"-999999"]) {
        
        self.requestUnNormal = YES;
        [self.bundsArray removeAllObjects];
        [self.bundsListView.mj_footer setHidden:YES];
        [self.bundsListView reloadData];
        
        return;
    }
    
    if (module.retCode.detailErrorDic) {
        
        if (![module.retCode.ret isEqualToString:@"100006"] && ![module.retCode.ret isEqualToString:@"-999999"])
        {
            [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
        }
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//点击搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self queryBundsListWithPageIndex:DEFAULTPAGEINDEX];
    return YES;
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

//////////////
#pragma mark - setter/getter
/////////////////////////////////

- (NSMutableArray *)bundsArray
{
    if (!_bundsArray) {
        
        _bundsArray = [[NSMutableArray alloc]init];
    }
    return _bundsArray;
}


//tapGesture
- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exitKeyboard:)];
    }
    return _tapGesture;
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
        
        weakSelf(weakSelf)
        [_networkErrorView setNetworkRetryOperation:^{
            
            [weakSelf queryBundsListWithPageIndex:@"1"];
        }];
    }
    return _networkErrorView;
}
@end
