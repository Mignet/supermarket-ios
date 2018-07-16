//
//  MyAccountBookDetailViewController.m
//  FinancialManager
//
//  Created by xnkj on 19/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyAccountBookDetailViewController.h"
#import "MyAccountBookAddItemViewController.h"

#import "MyAccountBookInvestItemMode.h"
#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"

@interface MyAccountBookDetailViewController ()<XNMyInformationModuleObserver>

@property (nonatomic, strong) NSString       * titleName;
@property (nonatomic, strong) NSString       * detailId;

@property (nonatomic, weak) IBOutlet UILabel * investMoneyLabel;
@property (nonatomic, weak) IBOutlet UILabel * investProfitLabel;
@property (nonatomic, weak) IBOutlet UILabel * investDirectionLabel;
@property (nonatomic, weak) IBOutlet UILabel * createTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel * remarkLabel;
@property (nonatomic, weak) IBOutlet UIView  * containerView;
@property (nonatomic, weak) IBOutlet UIView  * headerView;
@end

@implementation MyAccountBookDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil titleName:(NSString *)title detailId:(NSString *)detailId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.titleName = title;
        self.detailId = detailId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //网络加载
    [[XNMyInformationModule defaultModule] addObserver:self];
    [[XNMyInformationModule defaultModule] requestAccountBookItemDetail:self.detailId];
    [self.view showGifLoading];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[XNMyInformationModule defaultModule] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////
#pragma mark - 自定义方法
////////////////////////////////////

//初始化
- (void)initView
{
    self.title = self.titleName;
    [self.navigationItem addRightBarItemWithButtonArray:@[@"XN_AccountBook_edit_new_icon.png",@"XN_AccountBook_del_new_icon.png"] frameArray:@[[NSValue valueWithCGRect:CGRectMake(SCREEN_FRAME.size.width - 14 - 4, 0, 17, 17)],[NSValue valueWithCGRect:CGRectMake(SCREEN_FRAME.size.width + 4, 0, 17, 17)]] target:self action:@[@"editAccountBookItem",@"delAccountBookItem"]];
    
    [self.view addSubview:self.containerView];
    
    weakSelf(weakSelf)
    __weak UIView * tmpHeaderView = self.headerView;
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.equalTo(weakSelf.view);
        make.top.mas_equalTo(tmpHeaderView.mas_bottom);
        make.trailing.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(@(178));
    }];
    
    if ([self.view respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

//更新数据
- (void)updateUI
{
    self.investMoneyLabel.text = [[[XNMyInformationModule defaultModule] accountBookInvestItemMode] investAmt];
    self.investProfitLabel.text = [[[XNMyInformationModule defaultModule] accountBookInvestItemMode] investProfit];
    self.investDirectionLabel.text = [[[XNMyInformationModule defaultModule] accountBookInvestItemMode] direction];
    self.createTimeLabel.text = [[[XNMyInformationModule defaultModule] accountBookInvestItemMode] createTime];
    self.remarkLabel.text = [[[XNMyInformationModule defaultModule] accountBookInvestItemMode] remark];
    
    
    CGFloat height = [self.remarkLabel sizeThatFits:CGSizeMake(SCREEN_FRAME.size.width - 109, 1000)].height;
    
    weakSelf(weakSelf)
    __weak UIView * tmpHeaderView = self.headerView;
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(weakSelf.view);
        make.top.mas_equalTo(tmpHeaderView.mas_bottom);
        make.trailing.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(160 + height);
    }];
}

//删除记录
- (void)delAccountBookItem
{
    weakSelf(weakSelf)
    [self showCustomAlertViewWithTitle:@"是否删除该项目" titleFont:17 okTitle:@"删除" okCompleteBlock:^{
        
        [[XNMyInformationModule defaultModule] requestAccountBookEditWithDetailId:weakSelf.detailId  investAmt:@"" investDirection:@"" profit:@"" remark:@"" status:NO];
        
        [weakSelf.view showGifLoading];
    } cancelTitle:@"取消" cancelCompleteBlock:^{
    }];
}

//编辑记录
- (void)editAccountBookItem
{
    MyAccountBookAddItemViewController * ctrl = [[MyAccountBookAddItemViewController alloc]initWithNibName:@"MyAccountBookAddItemViewController" bundle:nil accountBookItem:[[XNMyInformationModule defaultModule] accountBookInvestItemMode]];
    
    [_UI pushViewControllerFromRoot:ctrl animated:YES];
}

//////////////////
#pragma mark - 网络请求回调
////////////////////////////////////

//账本详情
- (void)XNMyInfoModuleAccountBookInvestDetailDidReceive:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    
    [self updateUI];
}

- (void)XNMyInfoModuleAccountBookInvestDetailDidFailed:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//删除投资记录
- (void)XNMyInfoModuleAccountBookEditDidReceive:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    
    [self showCustomWarnViewWithContent:@"删除成功" Completed:^{
        
        [_UI popViewControllerFromRoot:YES];
    }];
}

- (void)XNMyInfoModuleAccountBookEditDidFailed:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

@end
