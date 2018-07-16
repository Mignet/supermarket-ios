//
//  SeekTreasureViewController.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/20.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SeekTreasureViewController.h"

#import "SeekTreasureHeaderView.h"
#import "SeekTreasureOptionCell.h"
#import "SeekTreasureActivityCell.h"
#import "SeekTreasureRecommendCell.h"
#import "SeekTreasureReadCell.h"
#import "NetworkUnReachStatusView.h"

#import "XNLeiCaiModule.h"
#import "SeekTreasureHotActivityModel.h"
#import "SeekTreasureHotActivityItemModel.h"
#import "SeekTreasureReadListModel.h"
#import "SeekTreasureRecommendListModel.h"

#import "SeekTreasureActivityViewController.h"
#import "GrowthManualViewController.h"               //成长手册

#import "BrandPromotionViewController.h"             //推广海报
#import "NewBrandPromotionController.h"              //新的推广海报

#import "PersonalCardViewController.h"
#import "CfgLevelCalcViewController.h"
#import "SaleGoodNewsDetailViewController.h"

#import "XNHomeBannerMode.h"
#import "XNConfigMode.h"
#import "XNCommonModule.h"

#import "SeekTreasureReadItemModel.h"

@interface SeekTreasureViewController () <UITableViewDataSource, UITableViewDelegate, SeekTreasureHeaderViewDelegate, SeekTreasureOptionCellDelegate, SeekTreasureActivityCellDelegate>

@property (nonatomic, assign) NSInteger requestTotalCount;
@property (nonatomic, assign) NSInteger currentRequestCount;
@property (nonatomic, strong) NetworkUnReachStatusView * networkErrorView;

@property (nonatomic, strong) NSArray *groupArr;

@property (nonatomic, strong) NSMutableArray *activityArr;
@property (nonatomic, strong) NSMutableArray *recommendArr;
@property (nonatomic, strong) NSMutableArray *hotReadArr;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SeekTreasureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    /*****
    if ([_LOGIC canShowGuildViewAt:self withKey:XN_USER_SEEK_TREASURE_ACTIVITY])
    {
        CGFloat width = (SCREEN_FRAME.size.width / 4) * 2;
        CGFloat height = (SCREEN_FRAME.size.width / 4) - 5.f;
        NSArray *a = @[
                       [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.f, 64.f, width, height) cornerRadius:5] bezierPathByReversingPath]
                       ];
        
        NSArray *b = @[
                       [UIImage imageNamed:@"new_user_guide_three.png"],
                       ];
        
        NSArray *c = @[
                       [NSValue valueWithCGRect:CGRectMake(30.f, 74 + height, 311.f, 75.f)], //622 × 150 pixels
                       ];
        
        NewUserGuildController * userGuildController = [[NewUserGuildController alloc]initWithNibName:@"NewUserGuildController" bundle:nil masksPathArray:a guildImagesArray:b guildImageLocationArray:c];
        
        [userGuildController setClickCompleteBlock:^{
            
            [_LOGIC saveValueForKey:XN_USER_SEEK_TREASURE_ACTIVITY Value:@"0"];
            
            [[AppFramework getGlobalHandler] removePopupView];
        }];
        
        [_KEYWINDOW addSubview:userGuildController.view];
        [self addChildViewController:userGuildController];
        
        __weak UIWindow * tmpWindow = [[UIApplication sharedApplication] keyWindow];
        [userGuildController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(tmpWindow);
        }];
        
        [AppFramework getGlobalHandler].currentPopup = userGuildController.view;
        
        return;
    }
    ****/
    

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[AppFramework getGlobalHandler] removePopupView];
}

- (void)dealloc
{
    [[XNLeiCaiModule defaultModule] removeObserver:self];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (@available(iOS 11.0, *)) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0,safeAreaInsets(self.view).bottom, 0);
        }];
    }
}

////////////////////////
#pragma mark - 自定义方法
////////////////////////

- (void)initView
{
    self.navigationItem.title = @"猎财";
    
    [[XNLeiCaiModule defaultModule] addObserver:self];
    
    //注册
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SeekTreasureOptionCell class]) bundle:nil] forCellReuseIdentifier:@"SeekTreasureOptionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SeekTreasureActivityCell class]) bundle:nil] forCellReuseIdentifier:@"SeekTreasureActivityCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SeekTreasureRecommendCell class]) bundle:nil] forCellReuseIdentifier:@"SeekTreasureRecommendCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SeekTreasureReadCell class]) bundle:nil] forCellReuseIdentifier:@"SeekTreasureReadCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SeekTreasureHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"SeekTreasureHeaderView"];
    
    weakSelf(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestDatas];
    }];

    [self requestDatas];
}

//请求热门活动数据、精选推荐数据、最近热读数据
- (void)requestDatas
{
    //判断网络是否可达
    [self.networkErrorView removeFromSuperview];
    if ([_ASSIST getNetworkStatus] == Network_NotReachable) {
        
        [self.view addSubview:self.networkErrorView];
        
        weakSelf(weakSelf)
        [self.networkErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakSelf.view);
        }];
        
        return;
    }

    
    self.requestTotalCount = 3;
    self.currentRequestCount = 1;
    
    [[XNLeiCaiModule defaultModule] requestSeekTreasureHotActivity];
    [[XNLeiCaiModule defaultModule] requestSeekTreasureRecommend];
    [[XNLeiCaiModule defaultModule] requestSeekTreasureRead];
}

//////////////////////////
#pragma mark - 协议方法
//////////////////////////

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groupArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3) {
        return self.hotReadArr.count;
    }
    
    else if (section == 2) {
    
        return self.recommendArr.count;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        SeekTreasureOptionCell *optionCell = [tableView dequeueReusableCellWithIdentifier:@"SeekTreasureOptionCell"];
        optionCell.delegate = self;
        return optionCell;
    }
    
    else if (indexPath.section == 1) {
    
        SeekTreasureActivityCell *activityCell = [tableView dequeueReusableCellWithIdentifier:@"SeekTreasureActivityCell"];
        activityCell.delegate = self;
        activityCell.urlArr = self.activityArr;
        return activityCell;
    }
    
    else if (indexPath.section == 2) {
    
        SeekTreasureRecommendCell *recommendCell = [tableView dequeueReusableCellWithIdentifier:@"SeekTreasureRecommendCell"];
        recommendCell.itemModel = self.recommendArr[indexPath.row];
        return recommendCell;
    
    }
    
    else if (indexPath.section == 3) {
    
        SeekTreasureReadCell *readCell = [tableView dequeueReusableCellWithIdentifier:@"SeekTreasureReadCell"];
        readCell.itemModel = self.hotReadArr[indexPath.row];
        return readCell;
    }
    
    else {
    
        return nil;
    }

}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        
        return 85.f;
    }
    
    else if (indexPath.section == 1) {
    
        return 185.f * (SCREEN_FRAME.size.width) / 375.f;
    }
    
    else if (indexPath.section == 2) {
    
        return 185.f * (SCREEN_FRAME.size.width) / 375.f;
    }
    
    return 169.f * (SCREEN_FRAME.size.width) / 375.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    
    return 45.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        
        if (section == 1) {
            SeekTreasureHeaderView *seekHeaderView = [SeekTreasureHeaderView seekTreasureHeaderViewType:SeekTreasureActivity];
            seekHeaderView.delegate = self;
            return seekHeaderView;
        }
        
        else if (section == 2) {
            SeekTreasureHeaderView *seekHeaderView = [SeekTreasureHeaderView seekTreasureHeaderViewType:SeekTreasureOption];
            seekHeaderView.delegate = self;
            
            return seekHeaderView;

        }
        
        else { //3
            SeekTreasureHeaderView *seekHeaderView = [SeekTreasureHeaderView seekTreasureHeaderViewType:SeekTreasureRead];
            seekHeaderView.delegate = self;
            return seekHeaderView;

        }
    }

    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        
        SeekTreasureReadItemModel *itemModel = self.recommendArr[indexPath.row];
        
        NSString *lcNewsDetalUrl = itemModel.linkUrl;
        if (![NSObject isValidateInitString:itemModel.linkUrl])
        {
            lcNewsDetalUrl = [[[XNCommonModule defaultModule] configMode] informationDetailUrl];
            if ([itemModel.msgType isEqualToString:@"今日财经早知道"]) {
                
                lcNewsDetalUrl = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"/pages/information/morningPaper.html?id=%@",itemModel.itemId]];
            }else
            {
                lcNewsDetalUrl = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"/pages/information/selectedRecomendDetail.html?id=%@",itemModel.itemId]];
            }
        }
        
        UniversalInteractWebViewController *webViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:lcNewsDetalUrl requestMethod:@"GET"];
        
        NSDictionary *params = @{
                                 @"shareTitle" : [NSObject isValidateObj:itemModel.title] ? itemModel.title: @"",
                                 @"shareDesc"  : [NSObject isValidateObj:itemModel.content] ? itemModel.content : @"",
                                 @"shareImgurl": [_LOGIC getImagePathUrlWithBaseUrl:itemModel.shareIcon],
                                 @"shareLink"  : [NSObject isValidateObj:itemModel.linkUrl]?itemModel.linkUrl:lcNewsDetalUrl
                                 };
        [webViewController setSharedOpertionWithParams:params];
        
        [_UI pushViewControllerFromRoot:webViewController animated:YES];
        
    }
    
    if (indexPath.section == 3) {
        
        [XNUMengHelper umengEvent:@"L_1_12"];
        SeekTreasureReadItemModel *itemModel = self.hotReadArr[indexPath.row];
        
        
        
        NSString *url = itemModel.linkUrl;
        if (![NSObject isValidateInitString:itemModel.linkUrl])
        {
            url = [NSString stringWithFormat:@"%@/pages/guide/handbook.html?id=%@",[AppFramework getConfig].XN_REQUEST_H5_BASE_URL, itemModel.itemId];

        }
        
        UniversalInteractWebViewController *webViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"GET"];
        
        
        NSDictionary *params = @{
                                 @"shareTitle" : [NSObject isValidateObj:itemModel.title] ? itemModel.title : @"",
                                 @"shareDesc"  : [NSObject isValidateObj:itemModel.content] ? itemModel.content : @"",
                                 @"shareImgurl": [_LOGIC getImagePathUrlWithBaseUrl:[NSObject isValidateObj:itemModel.shareIcon] ? itemModel.shareIcon : @""],
                                 @"shareLink"  : url
                                 };
        [webViewController setSharedOpertionWithParams:params];

        
        
        [_UI pushViewControllerFromRoot:webViewController animated:YES];
        
    }
}

#pragma mark - SeekTreasureHeaderViewDelegate
- (void)seekTreasureHeaderViewDid:(SeekTreasureHeaderView *)HeaderView HeaderViewType:(SeekTreasureHeaderViewType)headerViewType
{
    if (headerViewType == SeekTreasureActivity) { //热门活动
        
        [XNUMengHelper umengEvent:@"L_1_10"];
        SeekTreasureActivityViewController *activityVC = [[SeekTreasureActivityViewController alloc] init];
        [_UI pushViewControllerFromRoot:activityVC animated:YES];
    }
    
    else if (headerViewType == SeekTreasureOption) { //精选推荐
        
    }
    
    else if (headerViewType == SeekTreasureRead) { //最近热读
        
        [XNUMengHelper umengEvent:@"L_1_14"];
        
        GrowthManualViewController *viewController = [[GrowthManualViewController alloc] initWithNibName:@"GrowthManualViewController" bundle:nil];
        [_UI pushViewControllerFromRoot:viewController animated:YES];
    }
}

#pragma mark - SeekTreasureOptionCellDelegate
- (void)seekTreasureOptionCellDid:(SeekTreasureOptionCell *)seekTreasureOptionCell OptionCellBtn:(SeekTreasureOptionCellBtn)optionCellBtn
{
    if (optionCellBtn == ActivityBtn) { //活动中心
        
        [XNUMengHelper umengEvent:@"L_1_7"];
        SeekTreasureActivityViewController *activityVC = [[SeekTreasureActivityViewController alloc] init];
        [_UI pushViewControllerFromRoot:activityVC animated:YES];
    }
    
    else if (optionCellBtn == DayPaperBtn) { //每日早报
        
        [XNUMengHelper umengEvent:@"L_1_8"];
        
        NSString * url = [_LOGIC getWebUrlWithBaseUrl:@"/pages/information/morningPaper.html"];
        
        UniversalInteractWebViewController *webViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"GET"];
        
        [_UI pushViewControllerFromRoot:webViewController animated:YES];
    }

    else if (optionCellBtn == ManualBtn) { //成长手册
        
        [XNUMengHelper umengEvent:@"L_1_13"];

        GrowthManualViewController *viewController = [[GrowthManualViewController alloc] initWithNibName:@"GrowthManualViewController" bundle:nil];
        [_UI pushViewControllerFromRoot:viewController animated:YES];
    }
    
    else if (optionCellBtn == InviteBtn) { //邀请有礼
        [XNUMengHelper umengEvent:@"L_1_9"];
        
        UniversalInteractWebViewController *webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:[_LOGIC getWebUrlWithBaseUrl:@"/pages/guide/plannerInvitation.html"] requestMethod:@"GET"];
        [webCtrl setTitleName:@""];
        [webCtrl.handleBridgeEventManager addRightInvitedCustomer];
        
        [_UI pushViewControllerFromRoot:webCtrl animated:YES];
    }
    
    else if (optionCellBtn == NewsPaperBtn) { //推广海报
        
        [XNUMengHelper umengEvent:@"L_1_3"];
        
        NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
        if (![NSObject isValidateInitString:token]) {
            
            [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
            [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
            return;
        }
        
//        BrandPromotionViewController *viewController = [[BrandPromotionViewController alloc] initWithNibName:@"BrandPromotionViewController" bundle:nil];
//        [_UI pushViewControllerFromRoot:viewController animated:YES];
        
        // 4.5.3版本 推广海报页面
        NewBrandPromotionController *brandPromotionbVC = [[NewBrandPromotionController alloc] init];
        [_UI pushViewControllerFromRoot:brandPromotionbVC animated:YES];
        

    }
    
    else if (optionCellBtn == ListPaperBtn) { // 出单喜报
        
        [XNUMengHelper umengEvent:@"L_1_5"];
        
        NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
        if (![NSObject isValidateInitString:token]) {
            
            [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
            [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
            return;
        }
        
        [[XNLeiCaiModule defaultModule] setIsHaveNewSaleGoodNews:NO];
        SaleGoodNewsDetailViewController *viewController = [[SaleGoodNewsDetailViewController alloc] initWithNibName:@"SaleGoodNewsDetailViewController" bundle:nil billId:@""];
        [_UI pushViewControllerFromRoot:viewController animated:YES];

    }
    
    else if (optionCellBtn == CardBtn) { //个人名片
        
        [XNUMengHelper umengEvent:@"L_1_2"];
        
        NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
        if (![NSObject isValidateInitString:token]) {
            
            [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
            [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
            return;
        }
        
        PersonalCardViewController *viewController = [[PersonalCardViewController alloc] initWithNibName:@"PersonalCardViewController" bundle:nil];
        [_UI pushViewControllerFromRoot:viewController animated:YES];
    }
    
    else if (optionCellBtn == CompBtn) { //职级计算机
        
        [XNUMengHelper umengEvent:@"L_1_6"];
        CfgLevelCalcViewController *viewController = [[CfgLevelCalcViewController alloc] initWithNibName:@"CfgLevelCalcViewController" bundle:nil];
        [_UI pushViewControllerFromRoot:viewController animated:YES];

    }

}

#pragma mark - SeekTreasureActivityCellDelegate
- (void)seekTreasureActivityCellDid:(SeekTreasureActivityCell *)activityCell withStringUrl:(NSString *)stringUrl
{
    //[self.customPopAdvView hiddenPopAdvView];
    
    [XNUMengHelper umengEvent:@"L_1_11"];
    
    UniversalInteractWebViewController *webViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:stringUrl requestMethod:@"GET"];
    
    SeekTreasureHotActivityItemModel *targetItem = [[SeekTreasureHotActivityItemModel alloc] init];
    for (SeekTreasureHotActivityItemModel *item in self.activityArr) {
        if ([stringUrl isEqualToString:item.linkUrl]) {
            targetItem = item;
        }
    }
    NSDictionary *params = @{
                             @"shareTitle" : [NSObject isValidateObj:targetItem.shareTitle] ? targetItem.shareTitle: @"",
                             @"shareDesc"  : [NSObject isValidateObj:targetItem.shareDesc] ? targetItem.shareDesc : @"",
                             @"shareImgurl": [_LOGIC getImagePathUrlWithBaseUrl:[NSObject isValidateObj:targetItem.shareIcon] ? targetItem.shareIcon : @""],
                             @"shareLink"  : targetItem.shareLink
                             };
    
    [webViewController setSharedOpertionWithParams:params];
    

    [_UI pushViewControllerFromRoot:webViewController animated:YES];
}

////////////////////////////
#pragma mark - 网络请求
//////////////////////////////////////////////

//热门活动
- (void)SeekRequestSeekTreasureHotActivityDidSuccess:(XNLeiCaiModule *)module
{
    //更新状态数组
    [self.activityArr removeAllObjects];
    [self.activityArr addObjectsFromArray:module.SeekTreasureHotActivityModel.datas];
    
    if (self.currentRequestCount < self.requestTotalCount) {
        
        self.currentRequestCount ++;
        return;
    }
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

- (void)SeekRequestSeekTreasureHotActivityDidFailed:(XNLeiCaiModule *)module
{
    if (self.currentRequestCount < self.requestTotalCount) {
        
        self.currentRequestCount ++;
        return;
    }
    
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

//获取猎才热门推荐
- (void)SeekTreasureRecommendListDidSuccess:(XNLeiCaiModule *)module
{
    //更新状态数组
    [self.recommendArr removeAllObjects];
    [self.recommendArr addObjectsFromArray:module.seekTreasureRecommendListModel.datas];
    
    if (self.currentRequestCount < self.requestTotalCount) {
        
        self.currentRequestCount ++;
        return;
    }
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];

}

- (void)SeekTreasureRecommendListDidFailed:(XNLeiCaiModule *)module
{
    if (self.currentRequestCount < self.requestTotalCount) {
        
        self.currentRequestCount ++;
        return;
    }
    
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

//最近热读
- (void)SeekTreasureReadListDidSuccess:(XNLeiCaiModule *)module
{
    //更新状态数组
    [self.hotReadArr removeAllObjects];
    [self.hotReadArr addObjectsFromArray:module.seekTreasureReadListModel.datas];
    
    if (self.currentRequestCount < self.requestTotalCount) {
        
        self.currentRequestCount ++;
        return;
    }

    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

- (void)SeekTreasureReadListDidFailed:(XNLeiCaiModule *)module
{
    if (self.currentRequestCount < self.requestTotalCount) {
        
        self.currentRequestCount ++;
        return;
    }
    
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

/////////////////
#pragma mark - setter / getter
////////////////////
- (NSMutableArray *)hotReadArr
{
    if (!_hotReadArr) {
        _hotReadArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _hotReadArr;
}

- (NSMutableArray *)recommendArr
{
    if (!_recommendArr) {
        _recommendArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _recommendArr;
}

- (NSMutableArray *)activityArr
{
    if (!_activityArr) {
        _activityArr = [NSMutableArray arrayWithCapacity:0];
    }

    return _activityArr;
}

//无网络视图
- (NetworkUnReachStatusView *)networkErrorView
{
    if (!_networkErrorView) {
        
        _networkErrorView = [[NetworkUnReachStatusView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
        weakSelf(weakSelf)
        [_networkErrorView setNetworkRetryOperation:^{
            
            [weakSelf requestDatas];
        }];
    }
    return _networkErrorView;
}

- (NSArray *)groupArr
{
    if (!_groupArr) {
        _groupArr = @[@"按钮选项", @"热门活动", @"精选推荐", @"最近热读"];
    }
    return _groupArr;
}


@end
