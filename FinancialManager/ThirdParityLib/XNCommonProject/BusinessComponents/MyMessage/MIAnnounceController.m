//
//  CSTradeListController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/18.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "MIAnnounceController.h"
#import "MIMsgAnnounceCell.h"

#import "MFSystemInvitedEmptyCell.h"

#import "SharedViewController.h"
#import "UniversalInteractWebViewController.h"
#import "MJRefresh.h"

#import "XNCommonMsgItemMode.h"
#import "XNCommonMsgListMode.h"
#import "XNMessageModule.h"
#import "XNMessageModuleObserver.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

#define PURCHASECELLHEIGHT 75.0f
#define DEFAULTPAGEINDEX @"1"
#define DEFAULTPAGESIZE @"30"

@interface MIAnnounceController ()<XNMessageModuleObserver,UITableViewDataSource,UITableViewDelegate,UniversalInteractWebViewControllerDelegate>

@property (nonatomic, assign) BOOL                 finishedRequest;
@property (nonatomic, assign) BOOL                 canEdited;
@property (nonatomic, assign) NSInteger            currentSelectedIndex;
@property (nonatomic, strong) NSMutableArray     * contentArray;

@property (nonatomic, strong) UIButton          * flagReadButton;
@property (nonatomic, strong) UITableView      * listTableView;
@end

@implementation MIAnnounceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.listTableView.mj_header endRefreshing];
    [self.listTableView.mj_footer endRefreshing];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[XNMessageModule defaultModule] removeObserver:self];
}

///////////////////////////////
#pragma mark - Custom Methods
//////////////////////////////////////////

#pragma mark - 初始化
- (void)initView
{
    self.finishedRequest = NO;
    self.currentSelectedIndex = 0;
    
    [[XNMessageModule defaultModule] addObserver:self];
    
    [self.view addSubview:self.listTableView];
    [self.view addSubview:self.flagReadButton];
    
    weakSelf(weakSelf)
    [self.flagReadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.height.mas_equalTo(50);
    }];
    
    __weak UIButton * tmpButton = self.flagReadButton;
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.top.mas_equalTo(weakSelf.view.mas_top);
        make.bottom.mas_equalTo(tmpButton.mas_top);
    }];

    [self.listTableView setSeparatorColor:[UIColor clearColor]];
    [self.listTableView registerNib:[UINib nibWithNibName:@"MIMsgAnnounceCell" bundle:nil]
             forCellReuseIdentifier:@"MIMsgAnnounceCell"];
    [self.listTableView registerNib:[UINib nibWithNibName:@"MFSystemInvitedEmptyCell" bundle:nil] forCellReuseIdentifier:@"MFSystemInvitedEmptyCell"];
    
    self.listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.finishedRequest = NO;
        
        [[XNMessageModule defaultModule] requestCommonMsgListAtPageIndex:DEFAULTPAGEINDEX PageSize:DEFAULTPAGESIZE];
    }];
    self.listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [[XNMessageModule defaultModule] requestCommonMsgListAtPageIndex:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[[[XNMessageModule defaultModule] commonMsgListMode] pageIndex] integerValue] + 1]] PageSize:DEFAULTPAGESIZE];
    }];
    [self.listTableView.mj_footer setAutomaticallyHidden:YES];
    [self.listTableView.mj_header beginRefreshing];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 标记全部已读
- (void)readAllMsg:(id)sender
{
    [[XNMessageModule defaultModule] readAllMsg];
    [self.view showGifLoading];
}

#pragma mark - 隐藏标记按钮
- (void)setFlagButtonHidden:(BOOL)hidden
{
    [self.flagReadButton setHidden:hidden];
    
    CGFloat height = hidden?0:50;
    weakSelf(weakSelf)
    [self.flagReadButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.height.mas_equalTo(height);
    }];

    [self.view layoutIfNeeded];
}

#pragma mark - 重新加载
- (void)reload
{
    [self hideLoadingTarget:self];
    
    [[XNMessageModule defaultModule] requestCommonMsgListAtPageIndex:DEFAULTPAGEINDEX PageSize:DEFAULTPAGESIZE];
}

//////////////////////////////
#pragma mark - protocol Methods
//////////////////////////////////////////

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.finishedRequest && self.contentArray.count <= 0) {
        
        return 1;
    }
    
    return self.contentArray.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.finishedRequest && self.contentArray.count <= 0) {
        
        return self.view.frame.size.height;
    }
    
    return PURCHASECELLHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.finishedRequest && self.contentArray.count <= 0) {
        
        MFSystemInvitedEmptyCell * cell = (MFSystemInvitedEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"MFSystemInvitedEmptyCell"];
        
        [cell refreshTitle:XNMIAnnounceControllerEmpty];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    MIMsgAnnounceCell * cell = (MIMsgAnnounceCell *)[tableView dequeueReusableCellWithIdentifier:@"MIMsgAnnounceCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell updateContent:[self.contentArray objectAtIndex:indexPath.row] firstCell:indexPath.row == 0 lastCell:indexPath.row == self.contentArray.count - 1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.contentArray.count > 0) {
    
        self.currentSelectedIndex = indexPath.row;
        
        [[XNMessageModule defaultModule] getMsgDetailWithMsgId:[[self.contentArray objectAtIndex:indexPath.row] msgId]];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(MIAnnounceControllerDidRead)]) {
            
            [self.delegate MIAnnounceControllerDidRead];
        }
        
        NSString * url = [_LOGIC getComposeUrlWithBaseUrl:[[[XNCommonModule defaultModule] configMode] bulletinDetailDefaultUrl] compose:[NSString stringWithFormat:@"msgId=%@",[[self.contentArray objectAtIndex:indexPath.row] msgId]]];
        
        UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:url requestMethod:@"GET"];
        
        [_UI pushViewControllerFromRoot:webCtrl animated:YES];
    }
}

#pragma mark - 获取数据
- (void)XNMessageModuleCommonMsgListDidReceive:(XNMessageModule *)module
{
    self.finishedRequest = YES;
    [self.listTableView.mj_header endRefreshing];
    [self.listTableView.mj_footer endRefreshing];
    [self.view hideLoading];
    
    if ([module.commonMsgListMode.pageIndex integerValue] == 1)
        [self.contentArray removeAllObjects];
    
    [self.contentArray addObjectsFromArray:module.commonMsgListMode.dataArray];
    
    if ([module.commonMsgListMode.pageIndex integerValue] >= [module.commonMsgListMode.pageCount integerValue]) {
        
        [self.listTableView.mj_footer endRefreshingWithNoMoreData];
    }else
        [self.listTableView.mj_footer resetNoMoreData];
    
    [self.listTableView reloadData];
}

- (void)XNMessageModuleCommonMsgListDidFailed:(XNMessageModule *)module
{
    self.finishedRequest = YES;
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    [self.listTableView.mj_header endRefreshing];
    [self.listTableView.mj_footer endRefreshing];
    [self.view hideLoading];
    
    if (self.contentArray.count <= 0) {
        
        [self showNetworkLoadingFailedDidReloadTarget:self Action:@selector(reload)];
    }
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

#pragma mark - readAllMsg
- (void)XNMessageModuleReadAllMsgDidReceive:(XNMessageModule *)module
{
    [self.view hideLoading];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(MIAnnounceControllerDidReadAll)]) {
        
        [self.delegate MIAnnounceControllerDidReadAll];
    }
    
    [self.listTableView.mj_header beginRefreshing];
}

- (void)XNMessageModuleReadAllMsgDidFailed:(XNMessageModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

#pragma mark - 读某一条消息
- (void)XNMessageModuleAnnounceMsgDetailDidReceive:(XNMessageModule *)module
{
    [self.listTableView.mj_header beginRefreshing];
}

- (void)XNMessageModuleAnnounceMsgDetailDidFailed:(XNMessageModule *)module
{
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

/////////////////////////////////
#pragma mark - setter/getter
//////////////////////////////////////////////

#pragma mark - contentArray
- (NSMutableArray *)contentArray
{
    if (!_contentArray) {
        
        _contentArray = [[NSMutableArray alloc]init];
    }
    return _contentArray;
}

#pragma mark - flagReadButton
- (UIButton *)flagReadButton
{
    if (!_flagReadButton) {
        
        _flagReadButton = [[UIButton alloc]init];
        [_flagReadButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_flagReadButton addTarget:self action:@selector(readAllMsg:) forControlEvents:UIControlEventTouchUpInside];
        [_flagReadButton setBackgroundColor:MONEYCOLOR];
        [_flagReadButton setTitle:@"标记全部已读" forState:UIControlStateNormal];
    }
    return _flagReadButton;
}

#pragma mark - listTableView
- (UITableView *)listTableView
{
    if (!_listTableView) {
        
        _listTableView = [[UITableView alloc]init];
        _listTableView.backgroundColor = JFZ_COLOR_PAGE_BACKGROUND;
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
    }
    return _listTableView;
}

@end
