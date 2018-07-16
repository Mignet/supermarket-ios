//
//  CapacityAssessmentViewController.m
//  CapacityAssessment
//
//  Created by 张吉晴 on 2018/1/4.
//  Copyright © 2018年 张吉晴. All rights reserved.
//

#import "CapacityAssessmentViewController.h"
#import "CapacityAssessmentCell.h"
#import "CapacityAssessmentModel.h"
#import "CapacityAssessmentManager.h"
#import "CapacityAssessmentSinglePopView.h"
#import "CapacityAssessmentPopView.h"
#import "XNInsuranceModule.h"
#import "CapacityAssessmentModel.h"

#define UIColorHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

//#define Max_Content_Width (SCREEN_WIDTH - 70.f - 30.f)

@interface CapacityAssessmentViewController () <UITableViewDataSource, UITableViewDelegate, CapacityAssessmentCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *showArr;

@property (nonatomic, strong) CapacityAssessmentManager *assessmentManager;

@end

@implementation CapacityAssessmentViewController

- (void)clickBack:(UIButton *)sender
{
    [_UI popToRootViewController:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    
    
    [XNUMengHelper umengEvent:@"T_4_4_1"];
    
    [[XNInsuranceModule defaultModule] addObserver:self];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUI) name:@"Capacity_Assessment_ViewController_LoadData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"Capacity_Assessment_ViewController_RequestData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame) name:@"Capacity_Assessment_ViewController_Frame" object:nil];
    
    // 开始智能测评
    [self.assessmentManager startCapacityAssessment:self];
    
    if ([self.view respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [[XNInsuranceModule defaultModule] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

////////////////////////////////
#pragma mark - custom method
////////////////////////////////

- (void)initView
{
    // 标题
    self.navigationItem.title = @"保险智能测评";
    
    // 注册
    self.view.backgroundColor = UIColorHex(0xEFF0F1);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CapacityAssessmentCell class] forCellReuseIdentifier:@"CapacityAssessmentCell"];
}

- (void)loadUI
{
    [self.tableView reloadData];
    
    [self.tableView layoutIfNeeded];

    if ([self.assessmentManager getShowContentArr].count >= 1) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.assessmentManager getShowContentArr].count - 1 inSection:0]
                              atScrollPosition: UITableViewScrollPositionBottom
                                      animated:YES];
    }
}

- (void)requestData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            CapacityAssessmentModel *assessmentModel = [CapacityAssessmentModel capacityAssessmentModelContent:@"你的家庭情况我已经大致了解了哦，快来查看你的家庭保障评测结果吧！" isSystem:YES isWait:YES issueNum:0];
            [self.assessmentManager addObjc:assessmentModel];
            
            [self loadUI];
        });
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *params = [self.assessmentManager getParasDic];
            [[XNInsuranceModule defaultModule] request_insurance_qixin_questionSummaryParams:params];
            
        });
    });
    
    /**
     {
     age = "18\U5c81-40\U5c81";
     familyEnsure = "5,6";
     familyLoan = "\U65e0\U503a\U4e00\U8eab\U8f7b";
     familyMember = "0,2,1,3,6,7";
     sex = "\U5973";
     yearIncome = "100\U4e07\U4ee5\U4e0a";
     }
     */
}

- (void)capacityAssessmentCellDid:(CapacityAssessmentCell *)assessmentCell
{
    NSString *url = [_LOGIC getWebUrlWithBaseUrl:@"/pages/guide/evaluate.html"];
    UniversalInteractWebViewController *webViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"GET"];
    [_UI pushViewControllerFromRoot:webViewController animated:YES];
}

#pragma mark - 弹框高度处理
- (void)keyboardWillChangeFrame {
    
    [self.tableView layoutIfNeeded];
    
    CGFloat contentSize_height = self.tableView.contentSize.height;
    CGFloat show_height = self.view.height - self.assessmentManager.frameHeight - 64.f;
    
    if (contentSize_height > show_height - 64.f) {
        
        [UIView animateWithDuration:0.35 animations:^{
            self.tableView.transform = CGAffineTransformMakeTranslation(0, - (self.assessmentManager.frameHeight));
        }];
    }
    
    if ([self.assessmentManager getShowContentArr].count >= 1) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.assessmentManager getShowContentArr].count - 1 inSection:0]
                              atScrollPosition: UITableViewScrollPositionBottom
                                      animated:YES];
    }
}

////////////////////////////////
#pragma mark - system method
////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.assessmentManager getShowContentArr].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CapacityAssessmentCell *assessmentCell = [tableView dequeueReusableCellWithIdentifier:@"CapacityAssessmentCell"];
    assessmentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *getShowContentArr = [self.assessmentManager getShowContentArr];

    assessmentCell.delegate = self;
    assessmentCell.assessmentModel = getShowContentArr[indexPath.row];
    
    return assessmentCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *getShowContentArr = [self.assessmentManager getShowContentArr];
    
    CapacityAssessmentModel *assessmentModel = getShowContentArr[indexPath.row];

    CGSize moreSize =  [assessmentModel.content boundingRectWithSize:CGSizeMake(SCREEN_FRAME.size.width - 100.f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]} context:nil].size;
    
    if (indexPath.row == getShowContentArr.count - 1) {
        return moreSize.height + 60.f;
    }
    
    return moreSize.height + 40.f;
}

////////////////////////////////
#pragma mark - 网络请求回调
////////////////////////////////

- (void)request_insurance_qixin_questionSummaryParamsDidReceive:(XNInsuranceModule *)module
{
    [self.view hideLoading];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CapacityAssessmentModel *mentModel = [CapacityAssessmentModel capacityAssessmentModelContent:@"查看评测结果＞" isSystem:YES isWait:YES issueNum:100];
            [self.assessmentManager addObjc:mentModel];
            [self loadUI];
        });
    });
}

- (void)request_insurance_qixin_questionSummaryParamsDidFailed:(XNInsuranceModule *)module
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

- (CapacityAssessmentManager *)assessmentManager
{
    if (!_assessmentManager) {
        _assessmentManager = [[CapacityAssessmentManager alloc] init];
    }
    return _assessmentManager;
}


@end
