//
//  SignCalendarViewController.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/17.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SignCalendarViewController.h"
#import "SignCalendarModule.h"
#import "SignCalendarModel.h"

#import "ZJCalendarManager.h"
#import "ZJCalendarModel.h"

#import "ZJSignCell.h"
#import "SignRuleCell.h"

#define RuleImagView_Height   ((378.f * SCREEN_FRAME.size.width) / 375.f  + 15.f)
#define Calendar_Cell_Height  (25.f + SCREEN_FRAME.size.width / 7.f * 6.f * 0.85)

@interface SignCalendarViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *calendarSupView;
@property (nonatomic, strong) UIImageView *ruleImagView;
@property (nonatomic, strong) UIButton *titleBtn;

@property (nonatomic, strong) NSMutableArray *calendarArr;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SignCalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

/////////////////////////////////
#pragma mark - custom method
//////////////////////////////////

- (void)initView
{
    // 标题
    NSArray *calenderModelArr = [[ZJCalendarManager shareInstance] getSignCalendarModelArr];
    ZJCalendarModel *calenderModel = [calenderModelArr lastObject];
    self.navigationItem.title = [NSString stringWithFormat:@"%ld年%ld月", calenderModel.year, calenderModel.month];
    
    // 右侧按钮
    [self.navigationItem addRightBarItemWithTitle:@"活动规则" titleColor:[UIColor whiteColor] target:self action:@selector(ruleClick)];
    
    // 注册
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZJSignCell class]) bundle:nil] forCellReuseIdentifier:@"ZJSignCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SignRuleCell class]) bundle:nil] forCellReuseIdentifier:@"SignRuleCell"];
    
    // 请求数据
    [[SignCalendarModule defaultModule] addObserver:self];
    NSString *param = [NSString stringWithFormat:@"%ld-%ld", calenderModel.year, calenderModel.month];
    [[SignCalendarModule defaultModule] signCalendarSignTime:param];
}

- (void)dealloc
{
    [[SignCalendarModule defaultModule] removeObserver:self];
}

// 签到规则
- (void)ruleClick
{
    // https://preliecai.toobei.com/pages/message/signRule.html
    
    NSString *url = [_LOGIC getWebUrlWithBaseUrl:@"/pages/message/signRule.html"];
    UniversalInteractWebViewController *webViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"GET"];
    [webViewController setNeedNewSwitchViewAnimation:YES];
    [_UI pushViewControllerFromRoot:webViewController animated:YES];
    
}

//////////////////////////////
#pragma mark - protocol method
//////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        ZJSignCell *signCell = [tableView dequeueReusableCellWithIdentifier:@"ZJSignCell"];
        
        __weak typeof(self) weakSelf = self;
        signCell.passBlock = ^(NSInteger year, NSInteger month) {
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%ld年%.2ld月", year, month];
            
            NSString *param = [NSString stringWithFormat:@"%ld-%ld", year, month];
            
            //控制滑动日历反复请求接口
            [[SignCalendarModule defaultModule] signCalendarSignTime:param];
            
        };
    
        signCell.signCalendarArr = self.calendarArr;

        return signCell;
    }
    
    SignRuleCell *ruleCell = [tableView dequeueReusableCellWithIdentifier:@"SignRuleCell"];
    return ruleCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        return Calendar_Cell_Height;
    }
    
    return RuleImagView_Height;
}

///////////////////////////
#pragma mark - 网络请求回调
///////////////////////////

// 签到日历
- (void)userSignCalendarReceive:(SignCalendarModule *)module
{
    [self.view hideLoading];
    
    //[self.calendarArr removeAllObjects];
    //[self.calendarArr addObjectsFromArray:module.signCalendarModel.data];
    
    if ([NSObject isValidateObj:module.signCalendarModel]) {
        [self.calendarArr addObject:module.signCalendarModel];
    }
    
    [self.tableView reloadData];
}

- (void)userSignCalendarDidFailed:(SignCalendarModule *)module
{
    [self.view hideLoading];
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

/////////////////////////////////
#pragma mark - setter / getter
//////////////////////////////////

- (NSMutableArray *)calendarArr
{
    if (!_calendarArr) {
        _calendarArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _calendarArr;
}

@end
