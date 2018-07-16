//
//  MIMyAccountController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/22.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "MIMyAccountController.h"
#import "MIAccountRecordCell.h"
#import "MIPullListController.h"
#import "MIDeportMoneyController.h"
#import "MIDeportDetailController.h"
#import "MIAddBankCardController.h"

#import "MFSystemInvitedEmptyCell.h"

#import "MJRefresh.h"
#import "UINavigationItem+Extension.h"

#import "XNAccountRecordItemMode.h"
#import "XNAccountRecordListMode.h"
#import "XNMyAccountDetailType.h"
#import "XNMyAccountInfoMode.h"
#import "XNAccountModule.h"
#import "XNAccountModuleObserver.h"

#import "MIMySetMode.h"
#import "XNMyInformationModule.h"

#define HEADERHEIGHT 160.0f
#define DEFAULTCELLHEIGHT 112.0f

#define DEFAULTPAGEINDEX @"1"
#define DEFAULTPAGESIZE @"30"


@interface MIMyAccountController ()<XNAccountModuleObserver>

@property (nonatomic, assign) BOOL                   finishedRequest;
@property (nonatomic, strong) NSMutableArray       * contentMutableArray;
@property (nonatomic, strong) UIView               * selectTypeView;
@property (nonatomic, strong) UILabel              * selectTypeLabel;
@property (nonatomic, strong) MIPullListController * pullListCtrl;
@property (nonatomic, strong) NSString             * detailTypeStr;

@property (nonatomic, weak) IBOutlet UILabel     * accountBalanceLabel;
@property (nonatomic, weak) IBOutlet UILabel     * blockedAccountLabel;
@property (nonatomic, strong) IBOutlet UIView      * headerView;
@property (nonatomic, weak) IBOutlet UITableView * contentTableView;
@end

@implementation MIMyAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.view hideLoading];
    [self.contentTableView.mj_header endRefreshing];
    [self.contentTableView.mj_footer endRefreshing];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[XNAccountModule defaultModule] removeObserver:self];
}

////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.finishedRequest = NO;
    self.navigationItem.titleView = self.selectTypeView;
    self.detailTypeStr = @"1";
    self.accountBalanceLabel.textColor = MONEYCOLOR;
    
    [self.contentTableView setSeparatorColor:[UIColor clearColor]];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"MIAccountRecordCell" bundle:nil] forCellReuseIdentifier:@"MIAccountRecordCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"MFSystemInvitedEmptyCell" bundle:nil] forCellReuseIdentifier:@"MFSystemInvitedEmptyCell"];
    
    weakSelf(weakSelf)
    self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.finishedRequest = NO;
        
        [[XNAccountModule defaultModule] getMyAccountDetailListForTypeId:weakSelf.detailTypeStr PageIndex:DEFAULTPAGEINDEX PageSize:DEFAULTPAGESIZE];
    }];
    self.contentTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [[XNAccountModule defaultModule] getMyAccountDetailListForTypeId:weakSelf.detailTypeStr PageIndex:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:([[[[XNAccountModule defaultModule] myAccountRecordListMode] pageIndex] integerValue] + 1)]] PageSize:DEFAULTPAGESIZE];
    }];
    
    [self.view addSubview:self.pullListCtrl.view];
    [self addChildViewController:self.pullListCtrl];
    [self.pullListCtrl.view setHidden:YES];
    
    NSMutableArray * arr = [NSMutableArray array];
    for (XNMyAccountDetailType * obj in [[XNAccountModule defaultModule] myAccountDetailTypeArray]) {
        
        [arr addObject:obj.typeName];
    }
    
    if (arr.count > 0) {
        
        [self.selectTypeLabel setText:[arr objectAtIndex:0]];
        [self.pullListCtrl setShowContent:arr];
        [self.pullListCtrl setSelectedIndex:0];
    }
    [[XNAccountModule defaultModule] addObserver:self];
    [self initLoadNetwork];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 启动加载
- (void)initLoadNetwork
{
    self.finishedRequest = NO;
    
    [[XNAccountModule defaultModule] getMyAccountInfo];
    [[XNAccountModule defaultModule] getMyAccountDetailListForTypeId:self.detailTypeStr PageIndex:DEFAULTPAGEINDEX PageSize:DEFAULTPAGESIZE];
    
    [self.view showGifLoading];
}

#pragma mark - 选择类型
- (void)selectType:(UIButton *)sender
{
    [self.pullListCtrl.view setHidden:NO];
    
    [self.pullListCtrl show];
}

#pragma amrk - 重新加载
- (void)reload
{
    [self hideLoadingTarget:self];
    
    //开始加载数据
    [self initLoadNetwork];
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
    if (self.finishedRequest && self.contentMutableArray.count <=0 ) {
        
        return 1;
    }
    return self.contentMutableArray.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADERHEIGHT;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.finishedRequest && self.contentMutableArray.count <=0 ) {
        
        return self.view.frame.size.height - 160;
    }
    return DEFAULTCELLHEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.finishedRequest && self.contentMutableArray.count <= 0) {
        
        MFSystemInvitedEmptyCell * cell = (MFSystemInvitedEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"MFSystemInvitedEmptyCell"];
        
        [cell refreshTitle:XNMyAccountDetailEmpty];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    MIAccountRecordCell * cell = (MIAccountRecordCell *)[tableView dequeueReusableCellWithIdentifier:@"MIAccountRecordCell"];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell refreshAccountRecordItemCell:[self.contentMutableArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - 获取账户信息
- (void)XNAccountModuleMyAccountInfoDidReceive:(XNAccountModule *)module
{
    [self.view hideLoading];
    [self.accountBalanceLabel setText:[NSString convertUnits:module.myAccountMode.accountBalance]];
    //    [self.blockedAccountLabel setText:[NSString convertUnits:module.myAccountMode.blockedAmount]];
}

- (void)XNAccountModuleMyAccountInfoDidFailed:(XNAccountModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    [self showNetworkLoadingFailedDidReloadTarget:self Action:@selector(reload)];
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

#pragma mark - 获取资金明细列表
- (void)XNAccountModuleMyAccountDetailListDidReveive:(XNAccountModule *)module
{
    self.finishedRequest = YES;
    [self.view hideLoading];
    [self.contentTableView.mj_header endRefreshing];
    [self.contentTableView.mj_footer endRefreshing];
    
    if ([module.myAccountRecordListMode.pageIndex integerValue] == 1)
        [self.contentMutableArray removeAllObjects];
    
    [self.contentMutableArray addObjectsFromArray:module.myAccountRecordListMode.dataArray];
    
    if ([module.myAccountRecordListMode.pageIndex integerValue] >= [module.myAccountRecordListMode.pageCount integerValue]) {
        
        [self.contentTableView.mj_footer endRefreshingWithNoMoreData];
    }else
        [self.contentTableView.mj_footer resetNoMoreData];
    
    [self.contentTableView reloadData];
}

- (void)XNAccountModuleMyAccountDetailListDidFailed:(XNAccountModule *)module
{
    self.finishedRequest = YES;
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    [self.contentTableView.mj_header endRefreshing];
    [self.contentTableView.mj_footer endRefreshing];
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

#pragma mark - contentMutableArray
- (NSMutableArray *)contentMutableArray
{
    if (!_contentMutableArray) {
        
        _contentMutableArray = [[NSMutableArray alloc]init];
    }
    return _contentMutableArray;
}

#pragma mark - pullListCtrl
- (MIPullListController *)pullListCtrl
{
    if (!_pullListCtrl) {
        
        _pullListCtrl = [[MIPullListController alloc]initWithNibName:@"MIPullListController" bundle:nil];
        
        weakSelf(weakSelf)
        [_pullListCtrl setClickSelectedTypeBlock:^(NSString * type,NSInteger index) {
            
            [weakSelf.selectTypeLabel setText:type];
            
            weakSelf.detailTypeStr = [[[[XNAccountModule defaultModule] myAccountDetailTypeArray] objectAtIndex:index] typeId];
            [weakSelf initLoadNetwork];
        }];
        [_pullListCtrl setClickExitTypeSelectBlock:^(NSString * type,NSInteger index) {
            
            [weakSelf.pullListCtrl.view setHidden:YES];
        }];
    }
    return _pullListCtrl;
}

#pragma mark - selectTypeBtn
- (UIView *)selectTypeView
{
    if (!_selectTypeView) {
        
        _selectTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 34)];
        
        UIImageView * img = [[UIImageView alloc]init];
        [img setImage:[UIImage imageNamed:@"down_list.png"]];
        [_selectTypeView addSubview:img];
        
        self.selectTypeLabel = [[UILabel alloc]init];
        [self.selectTypeLabel setTextColor:[UIColor whiteColor]];
        [_selectTypeView addSubview:self.selectTypeLabel];
        
        UIButton * selectTypeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0 , 0 , 150 , 34)];
        [selectTypeBtn addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        [_selectTypeView addSubview:selectTypeBtn];
        
        __weak UIView * selectTypeTmpView = _selectTypeView;
        [self.selectTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(selectTypeTmpView.mas_top);
            make.centerX.mas_equalTo(selectTypeTmpView.mas_centerX);
            make.height.mas_equalTo(34);
        }];
        
        __weak UILabel * tmpLabel = self.selectTypeLabel;
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpLabel.mas_trailing).offset(8);
            make.top.mas_equalTo(selectTypeTmpView.mas_top).offset(15);
            make.height.mas_equalTo(4);
            make.width.mas_equalTo(@(8));
        }];
        
        
        [selectTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(selectTypeTmpView);
        }];
    }
    return _selectTypeView;
}

@end
