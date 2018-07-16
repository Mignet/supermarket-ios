//
//  CSTradeListController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/18.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "MIMyMsgController.h"
#import "MIMyMsgCell.h"
#import "MFSystemInvitedEmptyCell.h"

#import "MJRefresh.h"

#import "XNPrivateMsgItemMode.h"
#import "XNPrivateMsgListMode.h"
#import "XNMessageModule.h"
#import "XNMessageModuleObserver.h"

#define TRADETYPE @"2"
#define DEFAULTPAGEINDEX @"1"
#define DEFAULTPAGESIZE @"30"

@interface MIMyMsgController ()<XNMessageModuleObserver,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) BOOL                 finishedRequest;
@property (nonatomic, assign) BOOL                 canEdited;
@property (nonatomic, assign) BOOL                 selectedAll;
@property (nonatomic, strong) NSMutableArray     * contentArray;
@property (nonatomic, strong) NSMutableArray     * statusArray;
@property (nonatomic, weak) IBOutlet UITableView * listTableView;
@property (nonatomic, weak) IBOutlet UIView      * editView;
@property (nonatomic, weak) IBOutlet UIImageView * selectAllImageView;
@property (nonatomic, weak) IBOutlet UILabel     * totalSelectedLabel;
@property (nonatomic, weak) IBOutlet UIButton     * deleteButton;
@end

@implementation MIMyMsgController

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
    self.canEdited = NO;
    
    [[XNMessageModule defaultModule] addObserver:self];
    
    [self.view addSubview:self.editView];
    
     weakSelf(weakSelf)
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.top.mas_equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    [self.deleteButton setTitleColor:MONEYCOLOR forState:UIControlStateNormal];
    [self.totalSelectedLabel setTextColor:MONEYCOLOR];
    
    [self.listTableView setSeparatorColor:[UIColor clearColor]];
    [self.listTableView registerNib:[UINib nibWithNibName:@"MIMyMsgCell" bundle:nil]
             forCellReuseIdentifier:@"MIMyMsgCell"];
    [self.listTableView registerNib:[UINib nibWithNibName:@"MFSystemInvitedEmptyCell" bundle:nil] forCellReuseIdentifier:@"MFSystemInvitedEmptyCell"];
    
    self.listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.finishedRequest = NO;
        [[XNMessageModule defaultModule] requestPrivateMsgListAtPageIndex:DEFAULTPAGEINDEX PageSize:DEFAULTPAGESIZE];
    }];
    self.listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [[XNMessageModule defaultModule] requestPrivateMsgListAtPageIndex:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[[[XNMessageModule defaultModule] privateMsgListMode] pageIndex] integerValue] + 1]] PageSize:DEFAULTPAGESIZE];
    }];
    [self.listTableView.mj_footer setAutomaticallyHidden:YES];
    
    [self.listTableView.mj_header beginRefreshing];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 全选
- (IBAction)clickSelectedAll:(id)sender
{
    self.selectedAll = !self.selectedAll;
    
    [self.selectAllImageView setImage:[UIImage imageNamed:@"XN_Home_Invite_unChecked.png"]];
    if (self.selectedAll) {
        
        [self.selectAllImageView setImage:[UIImage imageNamed:@"XN_Home_Invite_checked.png"]];
    }
    
    
    for (NSInteger i = 0 ; i < self.statusArray.count; i ++ ) {
        
        [self.statusArray replaceObjectAtIndex:i withObject:self.selectedAll?@"1":@"0"];
    }
    [self.listTableView reloadData];
}

#pragma mark - 删除
- (IBAction)clickDelete:(id)sender
{
    NSString * strId = @"";
    XNPrivateMsgItemMode * pd = nil;
    for(NSInteger i = 0 ; i < self.statusArray.count ; i ++ )
    {
        if ([[self.statusArray objectAtIndex:i] isEqualToString:@"1"]) {
            
            pd = (XNPrivateMsgItemMode *)[self.contentArray objectAtIndex:i];
            if (i == 0) {
                
                strId = pd.msgId;
            }else
                strId = [strId stringByAppendingFormat:@",%@",pd.msgId];
        }
    }
    
    if (strId.length <= 0) {
        
        [self showCustomWarnViewWithContent:@"请选择删除的内容"];
        return;
    }
    
    [[XNMessageModule defaultModule] deletePrivateMsgForMsgId:strId];
    [self.view showGifLoading];
}

#pragma mark - 可以编辑么
- (void)canEdit:(BOOL)edited
{
    self.canEdited = edited;
    [self.listTableView reloadData];
    
    [self.view layoutIfNeeded];
    weakSelf(weakSelf)
    [self.editView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        
        if (edited) {
            
            make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        }else
            make.top.mas_equalTo(weakSelf.view.mas_bottom);
        
        make.height.mas_equalTo(50);
    }];
    
    [UIView animateWithDuration:VIEWANIMATIONDURATION animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 
- (void)loadNewMsg
{
    [self.listTableView.mj_header beginRefreshing];
}

#pragma mark - 重新加载 
- (void)reload
{
    [self hideLoadingTarget:self];
    
    [[XNMessageModule defaultModule] requestPrivateMsgListAtPageIndex:DEFAULTPAGEINDEX PageSize:DEFAULTPAGESIZE];
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
        
        return self.view.size.height;
    }
    
//    UILabel * caculateHeightLabel = [[UILabel alloc]init];
//    
//    if (IOS10_OR_LATER) {
//        
//        [caculateHeightLabel setAdjustsFontForContentSizeCategory:YES];
//    }
//    [caculateHeightLabel setText:[[self.contentArray objectAtIndex:indexPath.row] content]];
    
    CGFloat contentHight = 0.0;
    if (self.canEdited) {
        
        contentHight = [[[self.contentArray objectAtIndex:indexPath.row] content] sizeOfStringWithFont:14.0 InRect:CGSizeMake(SCREEN_FRAME.size.width - 46 - 30, 2000)].height;
        
//        contentHight = [caculateHeightLabel adjustLabelHeightInSize:CGSizeMake(SCREEN_FRAME.size.width - 46 - 12, 2000) fontSize:[UIFont systemFontOfSize:14]];
    }else
        contentHight = [[[self.contentArray objectAtIndex:indexPath.row] content] sizeOfStringWithFont:14.0 InRect:CGSizeMake(SCREEN_FRAME.size.width - 12 - 30, 2000)].height;
//        contentHight = [caculateHeightLabel adjustLabelHeightInSize:CGSizeMake(SCREEN_FRAME.size.width - 12 - 12, 2000) fontSize:[UIFont systemFontOfSize:14]];
    
    return contentHight + 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.finishedRequest && self.contentArray.count <= 0) {
        
        MFSystemInvitedEmptyCell * cell = (MFSystemInvitedEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"MFSystemInvitedEmptyCell"];
        
        [cell refreshTitle:XNMIMyMsgControllerEmpty];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    MIMyMsgCell * cell = (MIMyMsgCell *)[tableView dequeueReusableCellWithIdentifier:@"MIMyMsgCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell updateContent:[self.contentArray objectAtIndex:indexPath.row] isSelected:[[self.statusArray objectAtIndex:indexPath.row] isEqualToString:@"1"]?YES:NO canEdit:self.canEdited firstCell:indexPath.row == 0 lastCell:indexPath.row == self.contentArray.count - 1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.contentArray.count > 0) {
        
        if ([[self.statusArray objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
            
            [self.statusArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
        }else
        {
            [self.statusArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
        }
        
        [self.listTableView reloadData];
    }
}

#pragma mark - 获取数据
- (void)XNMessageModulePrivateMsgListDidReceive:(XNMessageModule *)module
{
    self.finishedRequest = YES;
    [self.listTableView.mj_header endRefreshing];
    [self.listTableView.mj_footer endRefreshing];
    [self.view hideLoading];
    
    if ([module.privateMsgListMode.pageIndex integerValue] == 1)
    {
        [self.contentArray removeAllObjects];
        [self.statusArray removeAllObjects];
        
        self.selectedAll = !self.selectedAll;
        [self.selectAllImageView setImage:[UIImage imageNamed:@"XN_Home_Invite_unChecked.png"]];
    }
    
    [self.contentArray addObjectsFromArray:module.privateMsgListMode.dataArray];
    
    if ([module.privateMsgListMode.pageIndex integerValue] >= [module.privateMsgListMode.pageCount integerValue]) {
        
        [self.listTableView.mj_footer endRefreshingWithNoMoreData];
    }else
        [self.listTableView.mj_footer resetNoMoreData];
    
    for (int i = 0 ; i < module.privateMsgListMode.dataArray.count; i ++) {
        
        [self.statusArray addObject:@"0"];
    }
    
    [self.listTableView reloadData];
    //通知获取最新的未读数
    [[NSNotificationCenter defaultCenter] postNotificationName:XN_UNREAD_MESSAGE_COUNT object:nil];
}

- (void)XNMessageModulePrivateMsgListDidFailed:(XNMessageModule *)module
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

#pragma mark - 删除消息
- (void)XNMessageModulePrivateMsgDeleDidReceive:(XNMessageModule *)module
{
    [self.view hideLoading];
    
    self.selectedAll = YES;
    [self clickSelectedAll:nil];
    [self showCustomWarnViewWithContent:@"删除成功"];
    [self.listTableView.mj_header beginRefreshing];
}

- (void)XNMessageModulePrivateMsgDeleDidFailed:(XNMessageModule *)module
{
    [self.view hideLoading];
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

#pragma mark - statusArray
- (NSMutableArray *)statusArray
{
    if (!_statusArray) {
        
        _statusArray = [[NSMutableArray alloc]init];
    }
    return _statusArray;
}

@end
