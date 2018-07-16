//
//  InsuranceTypeListViewController.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/26.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "InsuranceTypeListViewController.h"

#import "InsuranceListCell.h"
#import "XNInsuranceModule.h"
#import "XNInsuranceList.h"
#import "XNInsuranceItem.h"
#import "XNInsuranceDetailMode.h"

#import "XNRedPacketEmptyCell.h"
#import "XNInsuranceCategoryModel.h"

@interface InsuranceTypeListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) NSString *insuranceType;

@property (nonatomic, assign) NSInteger nPageIndex;

@property (nonatomic, strong) NSMutableArray *insuranceArr;

@property (nonatomic, strong) XNInsuranceModule *module;

@property (nonatomic, assign) BOOL isRequst;

@end

@implementation InsuranceTypeListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isRequst = NO;
    
    [self initView];
    
    weakSelf(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.nPageIndex = 1;
        [weakSelf loadInsuranceDatas];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.nPageIndex += 1;
        [weakSelf loadInsuranceDatas];
    }];
    
    [self loadInsuranceDatas];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // 设置frame
    CGFloat nav_h = SCREEN_FRAME.size.height - 64.f - 45.f;
    if (Device_Is_iPhoneX) {
        nav_h -= 24.f;
    }
    self.view.frame = CGRectMake(SCREEN_FRAME.size.width * self.index, 0, SCREEN_FRAME.size.width, nav_h);
}

- (void)dealloc
{
    [self.module removeObserver:self];
}

////////////////////////////////
#pragma mark - custom method
////////////////////////////////

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Index:(NSInteger)index InsuranceType:(NSString *)insuranceType
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        // 保险类型
        self.insuranceType = insuranceType;
        self.index = index;
        
        return self;
    }
    return nil;
}

- (void)initView
{
    self.nPageIndex = 1;
    
    // 注册单元格
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 空视图
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XNRedPacketEmptyCell class]) bundle:nil] forCellReuseIdentifier:@"XNRedPacketEmptyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InsuranceListCell class]) bundle:nil] forCellReuseIdentifier:@"InsuranceListCell"];
    
    // 添加观察者
    self.module = [[XNInsuranceModule alloc] init];
    [self.module addObserver:self];
}

- (void)loadInsuranceDatas
{
    [self.module requestInsuranceListWithPageIndex:[NSString stringWithFormat:@"%ld", self.nPageIndex] pageSize:@"10" insuranceCategory:self.insuranceType];
    [self.view showGifLoading];
}

/*** 获取保险名字 **/
- (NSString *)getInsuranceName
{
    // 初始化数组
    NSArray *categoryArr = [_LOGIC readDataFromFileName:@"insurance_category.plist"];
    
    NSString *insuranceName = [NSString string];
    for (NSDictionary *params in categoryArr) {
        XNInsuranceCategoryModel * categoryModel = [XNInsuranceCategoryModel createInsuranceCategoryModel:params];
        
        if ([categoryModel.category isEqualToString:self.insuranceType]) {
            insuranceName = categoryModel.message;
        }
    }
    return [NSString stringWithFormat:@"当前没有%@", insuranceName];
}

////////////////////////////////
#pragma mark - system protocol
////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isRequst == YES && self.insuranceArr.count == 0) {
        return 1;
    }
    return self.insuranceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isRequst == YES && self.insuranceArr.count == 0) {
        
        // 1-意外险  2-旅游险 3-家财险  4-医疗险 5-重疾险 6-年金险 7-寿险 8-少儿险 9-老年险
        [self getInsuranceName];
        
        XNRedPacketEmptyCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:@"XNRedPacketEmptyCell"];
        [emptyCell showTitle:[self getInsuranceName] subTitle:nil];

        return emptyCell;
    }
    
    InsuranceListCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"InsuranceListCell"];
    listCell.insuranceItemModel = self.insuranceArr[indexPath.row];
    return listCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.insuranceArr.count == 0) {
        return;
    }
    
    [XNUMengHelper umengEvent:@"T_4_2_1"];
    
     NSInteger nRow = [indexPath row];
     if (self.insuranceArr.count > 0) {
         [XNUMengHelper umengEvent:@"T_4_2"];
         NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
         if (![NSObject isValidateInitString:token]) {
     
             [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
             [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
             return;
         }
         XNInsuranceItem * item = [self.insuranceArr objectAtIndex:nRow];
         [self.module  requestInsuranceDetaiParamsWithCaseCode:item.caseCode];
         [self.view showGifLoading];
     }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isRequst == YES && self.insuranceArr.count == 0) {
        return SCREEN_FRAME.size.height - 180.f;
    }
    return (SCREEN_FRAME.size.width / 375.f) * 125.f + 125.f;
}

////////////////////////////////
#pragma mark - custom protocol
////////////////////////////////

#pragma mark - 保险列表
- (void)XNFinancialManagerModuleInsuranceListDidReceive:(XNInsuranceModule *)module
{
    self.isRequst = YES;
    
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    XNInsuranceList *mode = module.insuranceList;
    _nPageIndex = [mode.pageIndex integerValue];
    
    if (_nPageIndex == 1)
    {
        [self.insuranceArr removeAllObjects];
    }
    
    if (mode.insuranceList.count > 0)
    {
        [self.insuranceArr addObjectsFromArray:mode.insuranceList];
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

- (void)XNFinancialManagerModuleInsuranceListDidFailed:(XNInsuranceModule *)module
{
    self.isRequst = YES;
    
    [self.view hideLoading];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_footer setHidden:YES];
    
    if (module.retCode.detailErrorDic)
    {
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

//保险详情
- (void)XNFinancialManagerModuleInsuranceDetailDidReceive:(XNInsuranceModule *)module
{
    [self.view hideLoading];
    
    UniversalInteractWebViewController * interactWebViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:module.insuranceDetailMode.jumpInsuranceUrl requestMethod:@"GET"];
    
    //[interactWebViewController setHidenThirdAgentHeaderElement:YES];
    
    [interactWebViewController setIsEnterThirdPlatform:YES platformName:@"慧择"];
    [interactWebViewController.view setBackgroundColor:[UIColor whiteColor]];
    
    [_UI pushViewControllerFromRoot:interactWebViewController animated:YES];
}

- (void)XNFinancialManagerModuleInsuranceDetailDidFailed:(XNInsuranceModule *)module
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

//////////////////////////////
#pragma mark - setter / getter
//////////////////////////////

- (NSMutableArray *)insuranceArr
{
    if (!_insuranceArr) {
        _insuranceArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _insuranceArr;
}

@end
