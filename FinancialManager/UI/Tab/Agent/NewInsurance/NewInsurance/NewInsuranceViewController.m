//
//  NewInsuranceViewController.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/21.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "NewInsuranceViewController.h"

#import "NewInsuranceBannerCell.h"
#import "NoEvaluationCell.h"
#import "AchieveEvaluationCell.h"
#import "InsuranceKnowLedgeCell.h"
#import "InsuranceListCell.h"
#import "NewInsuranceFooterView.h"
#import "SeekTreasureHeaderView.h"
#import "NewInsuranceProductController.h"

#import "XNInsuranceModule.h"
#import "InsuranceBannerModel.h"
#import "InsuranceSelectModel.h"
#import "XNInsuranceItem.h"
#import "XNInsuranceDetailMode.h"
#import "XNInsuranceQquestionResultModel.h"

#import "CapacityAssessmentViewController.h"
#import "CapacityAssessmentManager.h"
#import "XNHomeBannerMode.h"


#define New_Insurance_BannerCell_Height ((125.f * SCREEN_FRAME.size.width) / 375.f + (SCREEN_FRAME.size.width / 4.f))
#define No_Insurance_Banner_Height (SCREEN_FRAME.size.width / 4.f)

#define ITEM_CELL_WIDTH ((SCREEN_FRAME.size.width - 10 - 10 - 20) / 2.f)
#define ITEM_CELL_HEIGHT (ITEM_CELL_WIDTH * 375 / SCREEN_FRAME.size.height)

#define achieveEvaluationCell_height (130 + 60.f + ITEM_CELL_HEIGHT)

@interface NewInsuranceViewController () <UITableViewDataSource, UITableViewDelegate, NewInsuranceBannerCellDelegate, AchieveEvaluationCellDelegate, NoEvaluationCellDelegate, InsuranceKnowLedgeCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSMutableArray *bannerArr;

@property (nonatomic, strong) NSMutableArray *selectInsuranceArr;

@end

@implementation NewInsuranceViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
    //1.判断是否登录
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if ([NSObject isValidateInitString:token]) {
        //首页-保险评测结果
        [[XNInsuranceModule defaultModule] request_insurance_qixin_queryQquestionResult];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

//////////////////////////////////
#pragma mark - custom method
//////////////////////////////////

- (void)initView
{
    [self.view addSubview:self.tableView];
    
    [[XNInsuranceModule defaultModule] addObserver:self];
    
    [self requestDatas];
    
    // 一级分类   1-意外险  2-旅游险 3-家财险  4-医疗险 5-重疾险 6-年金险 7-寿险 8-少儿险 9-老年险
    weakSelf(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestDatas];
    }];
    
}

- (void)requestDatas
{
    // 保险banner
    [[XNInsuranceModule defaultModule] request_insurance_banner];
    
    // 甄选保险
    [[XNInsuranceModule defaultModule] request_insurance_qixin_insuranceSelect];
}

//////////////////////////////////
#pragma mark - system protcol
//////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3) {
        return self.selectInsuranceArr.count;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        NewInsuranceBannerCell *bannerCell  = [tableView dequeueReusableCellWithIdentifier:@"NewInsuranceBannerCell"];
        bannerCell.delegate = self;
        
        if (self.bannerArr.count > 0) {
            bannerCell.adSupView.height = (125.f * SCREEN_FRAME.size.width) / 375.f;
        } else {
            bannerCell.adSupView.height = 0.f;
        }
        
        bannerCell.urlArr = self.bannerArr;
        
        return bannerCell;
    
    } else if (indexPath.section == 1) {
        
        NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
        if (![NSObject isValidateInitString:token]) {
            NoEvaluationCell *noEvaluationCell = [tableView dequeueReusableCellWithIdentifier:@"NoEvaluationCell"];
            noEvaluationCell.delegate = self;
            return noEvaluationCell;
        } else {
            
            // 判断是否有测评
            if ([[XNInsuranceModule defaultModule].insuranceResultModel.totalScore integerValue] > 0) {
                
                AchieveEvaluationCell *achieveCell = [tableView dequeueReusableCellWithIdentifier:@"AchieveEvaluationCell"];
                achieveCell.questionResultModel = [XNInsuranceModule defaultModule].insuranceResultModel;
                achieveCell.delegate = self;
                return achieveCell;
                
            } else {
                
                NoEvaluationCell *noEvaluationCell = [tableView dequeueReusableCellWithIdentifier:@"NoEvaluationCell"];
                noEvaluationCell.delegate = self;
                return noEvaluationCell;
                
            }
        }
        
    } else if (indexPath.section == 2) {
        
        InsuranceKnowLedgeCell *knowLedgeCell = [tableView dequeueReusableCellWithIdentifier:@"InsuranceKnowLedgeCell"];
        knowLedgeCell.delegate = self;
        [knowLedgeCell startAnimation];
        return knowLedgeCell;
    }
    
    InsuranceListCell *listCell  = [tableView dequeueReusableCellWithIdentifier:@"InsuranceListCell"];
    listCell.insuranceItemModel = self.selectInsuranceArr[indexPath.row];
    return listCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (self.bannerArr.count > 0) {
            return New_Insurance_BannerCell_Height;
        } else {
            return No_Insurance_Banner_Height;
        }
    }
    
    else if (indexPath.section == 1) {
        
        NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
        if (![NSObject isValidateInitString:token]) {
            return 155.f;
        } else {
            
            if ([[XNInsuranceModule defaultModule].insuranceResultModel.totalScore integerValue] > 0) {
                return achieveEvaluationCell_height;
            } else {
                return 155.f;
            }
        }
    }
    
    else if (indexPath.section == 2) {
        
        return 160.f;
    }
    
    else if (indexPath.section == 3) {
        
        return 260.f;
    }
    
    return New_Insurance_BannerCell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        
        return 45.f;
    }
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        
        SeekTreasureHeaderView *seekHeaderView = [SeekTreasureHeaderView seekTreasureHeaderViewType:NewInsuranceProduct];
        return seekHeaderView;
    }
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 45.f;
    }
    
    return 15.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        NewInsuranceFooterView *footerView = [NewInsuranceFooterView newInsuranceFooterView];
        return footerView;
    }
    
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) { // 智能测试
        
    }
    
    if (indexPath.section == 2) { // 保险知识库
        
    }
    
    if (indexPath.section == 3) { // 甄选保险
        
        [XNUMengHelper umengEvent:@"T_4_1_5"];
        
        NSInteger nRow = [indexPath row];
        if (self.selectInsuranceArr.count > 0) {
            [XNUMengHelper umengEvent:@"T_4_2"];
            NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
            if (![NSObject isValidateInitString:token]) {
                
                [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
                [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
                return;
            }
            XNInsuranceItem * item = [self.selectInsuranceArr objectAtIndex:nRow];
            [[XNInsuranceModule defaultModule]  requestInsuranceDetaiParamsWithCaseCode:item.caseCode];
            [self.view showGifLoading];
        }
    }
}

////////////////////////////////////
#pragma mark - custom protocol
////////////////////////////////////

// 重疾险 意外险 少儿险 查看更多
- (void)newInsuranceBannerCellDid:(NewInsuranceBannerCell *)insuranceBannerCell ClickType:(NewInsuranceBannerCellClickType)clickType withUrl:(NSString *)linkUrl 
{
    /****
     Severe_Illness_Click = 0,
     Accident_Click,
     Children_Click,
     More_Insurance
     **/
    
    // // 1-意外险  2-旅游险 3-家财险  4-医疗险 5-重疾险 6-年金险 7-寿险 8-少儿险 9-老年险
    
    if (clickType == Severe_Illness_Click) { // 重疾险
        
        [XNUMengHelper umengEvent:@"T_4_1_2"];
        
        NewInsuranceProductController *insuranceProductVC = [[NewInsuranceProductController alloc] initWithNibName:@"NewInsuranceProductController" bundle:nil withInsuranceType:@"5"];
        [_UI pushViewControllerFromRoot:insuranceProductVC animated:YES];
    }
    
    else if (clickType == Accident_Click) { // 意外险
        
        [XNUMengHelper umengEvent:@"T_4_1_2"];
        
        NewInsuranceProductController *insuranceProductVC = [[NewInsuranceProductController alloc] initWithNibName:@"NewInsuranceProductController" bundle:nil withInsuranceType:@"1"];
        [_UI pushViewControllerFromRoot:insuranceProductVC animated:YES];
        
    }
    
    else if (clickType == Children_Click) { // 少儿险
        
        [XNUMengHelper umengEvent:@"T_4_1_2"];
        
        NewInsuranceProductController *insuranceProductVC = [[NewInsuranceProductController alloc] initWithNibName:@"NewInsuranceProductController" bundle:nil withInsuranceType:@"8"];
        [_UI pushViewControllerFromRoot:insuranceProductVC animated:YES];
    }
    
    else if (clickType == More_Insurance) { // 更多默认第一个开始
        
        [XNUMengHelper umengEvent:@"T_4_1_2"];
        
        NewInsuranceProductController *insuranceProductVC = [[NewInsuranceProductController alloc] initWithNibName:@"NewInsuranceProductController" bundle:nil withInsuranceType:@"1"];
        [_UI pushViewControllerFromRoot:insuranceProductVC animated:YES];
    }
    
    
    else if (clickType == Banner_Click) { // banner点击
        
        [XNUMengHelper umengEvent:@"T_4_1_1"];
        
        // [_LOGIC getWebUrlWithBaseUrl:@"/pages/commonweal/list.html"]
        UniversalInteractWebViewController *webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:linkUrl requestMethod:@"GET"];
        
        NSArray *datas = [[XNInsuranceModule defaultModule] bannerModel].datas;
        XNHomeBannerMode *model;
        for (NSInteger i = 0; i < datas.count; i ++) {
            XNHomeBannerMode *bannerMode = datas[i];
            if ([linkUrl isEqualToString:bannerMode.linkUrl]) {
                model = bannerMode;
            }
        }
        
        [webCtrl setSharedOpertionWithParams:[NSDictionary dictionaryWithObjectsAndKeys:model.title,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_TITLE,
                                              model.desc,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_DESC,model.link,XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_URL,
                                              [_LOGIC getImagePathUrlWithBaseUrl:model.icon],XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_IMGURL, nil]];
        
        
        [_UI pushViewControllerFromRoot:webCtrl animated:YES];
    }
}

// 查看报告 推荐保险跳转
- (void)achieveEvaluationCellDid:(AchieveEvaluationCell *)achieveEvaluationCell withInsuranceCategroy:(NSString *)insuranceCategroy
{
    if (insuranceCategroy.length == 0) {
        
        [XNUMengHelper umengEvent:@"T_4_4_2"];
        
        // 设置数据源为空
        //[[CapacityAssessmentManager shareInstance] setShowContentArr];
        // 查看报告
        NSString *url = [_LOGIC getWebUrlWithBaseUrl:@"/pages/guide/evaluate.html"];
        UniversalInteractWebViewController *webViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"GET"];
        [_UI pushViewControllerFromRoot:webViewController animated:YES];
        
    } else { // 保险首页为你推荐
        
        [XNUMengHelper umengEvent:@"T_4_1_6"];
        NewInsuranceProductController *insuranceProductVC = [[NewInsuranceProductController alloc] initWithNibName:@"NewInsuranceProductController" bundle:nil withInsuranceType:insuranceCategroy];
        [_UI pushViewControllerFromRoot:insuranceProductVC animated:YES];
    }
}

// 保险知识库
- (void)insuranceKnowLedgeCellDid:(InsuranceKnowLedgeCell *)knowLedgeCell
{
    [XNUMengHelper umengEvent:@"T_4_1_4"];
    
    NSString *url = [_LOGIC getWebUrlWithBaseUrl:@"/pages/message/insuranceKnowledge.html"];
    UniversalInteractWebViewController *webViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"GET"];
    [webViewController setNewWebView:YES];
    [_UI pushViewControllerFromRoot:webViewController animated:YES];
}

// 立即测评
- (void)noEvaluationCellDid:(NoEvaluationCell *)noEvaluationCell
{
    //1.判断是非登录
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    [XNUMengHelper umengEvent:@"T_4_1_3"];
    
    // 设置数据源为空
    //[[CapacityAssessmentManager shareInstance] setShowContentArr];
    CapacityAssessmentViewController *capacityAssessmentVC = [[CapacityAssessmentViewController alloc] init];
    [_UI pushViewControllerFromRoot:capacityAssessmentVC animated:YES];
}

//甄选保险
- (void)insurance_Qixin_Insurance_SelectDidReceive:(XNInsuranceModule *)module
{
    [self.tableView.mj_header endRefreshing];
    [self.selectInsuranceArr removeAllObjects];
    
    [self.selectInsuranceArr addObjectsFromArray:module.insuranceSelectModel.datas];
    
    [self.tableView reloadData];
}

- (void)insurance_Qixin_Insurance_SelectDidFailed:(XNInsuranceModule *)module
{
    [self.tableView.mj_header endRefreshing];
    
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

// 保险banner
- (void)request_insurance_banner_DidReceive:(XNInsuranceModule *)module
{
    [self.tableView.mj_header endRefreshing];
    
    [self.bannerArr removeAllObjects];
    
    [self.bannerArr addObjectsFromArray:module.bannerModel.datas];

    [self.tableView reloadData];
}

- (void)request_insurance_banner_DidFailed:(XNInsuranceModule *)module
{
    [self.tableView.mj_header endRefreshing];
}

//保险详情
- (void)XNFinancialManagerModuleInsuranceDetailDidReceive:(XNInsuranceModule *)module
{
    [self.tableView.mj_header endRefreshing];
    
    [self.view hideLoading];
    
    UniversalInteractWebViewController * interactWebViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:module.insuranceDetailMode.jumpInsuranceUrl requestMethod:@"GET"];
    
    //    [interactWebViewController setHidenThirdAgentHeaderElement:YES];
    
    [interactWebViewController setIsEnterThirdPlatform:YES platformName:@"慧择"];
    [interactWebViewController.view setBackgroundColor:[UIColor whiteColor]];
    
    [_UI pushViewControllerFromRoot:interactWebViewController animated:YES];
}

- (void)XNFinancialManagerModuleInsuranceDetailDidFailed:(XNInsuranceModule *)module
{
    [self.view hideLoading];
    
    [self.tableView.mj_header endRefreshing];
    
    if (module.retCode.detailErrorDic)
    {
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

//首页-保险评测结果
- (void)request_Insurance_Qixin_queryQquestionResultDidReceive:(XNInsuranceModule *)module
{
    [self.tableView.mj_header endRefreshing];
    
    [self.tableView reloadData];
}

- (void)request_Insurance_Qixin_queryQquestionResultDidFailed:(XNInsuranceModule *)module
{
    [self.view hideLoading];
    
    [self.tableView.mj_header endRefreshing];
    
    if (module.retCode.detailErrorDic)
    {
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

//////////////////////////////////
#pragma mark - setter / getter
//////////////////////////////////

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height - 64.f - 49.f) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorFromHex(0XEFF0F1);
        
        // 注册
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewInsuranceBannerCell class]) bundle:nil] forCellReuseIdentifier:@"NewInsuranceBannerCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AchieveEvaluationCell class]) bundle:nil] forCellReuseIdentifier:@"AchieveEvaluationCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NoEvaluationCell class]) bundle:nil] forCellReuseIdentifier:@"NoEvaluationCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InsuranceKnowLedgeCell class]) bundle:nil] forCellReuseIdentifier:@"InsuranceKnowLedgeCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InsuranceListCell class]) bundle:nil] forCellReuseIdentifier:@"InsuranceListCell"];
    }
    
    return _tableView;
}

- (NSMutableArray *)bannerArr
{
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _bannerArr;
}

- (NSMutableArray *)selectInsuranceArr
{
    if (!_selectInsuranceArr) {
        _selectInsuranceArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectInsuranceArr;
}

@end
