//
//  CSMyCustomerViewController.m
//  FinancialManager
//
//  Created by xnkj on 6/22/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "MyCfgViewController.h"

#import "CSCustomerDelegate.h"
#import "CSCfgOptionalCell.h"
#import "MyCfgCell.h"
#import "CSCfgHeader.h"
#import "ContactHeaderCell.h"
#import "AddressBookController.h"
#import "MyCfgCategoryCustomerViewController.h"
#import "MyCfgDetailViewController.h"
#import "XNRedPacketEmptyCell.h"

#import "ChineseString.h"
#import "MJRefresh.h"

#import "XNCSNewCustomerItemModel.h"
#import "XNCSNewCustomerModel.h"
#import "XNCSMyCustomerItemMode.h"
#import "XNCSMyCustomerListMode.h"
#import "XNCSCustomerCfpMemberMode.h"
#import "XNCustomerServerModule.h"
#import "XNCustomerServerModuleObserver.h"

#import "XNInvitedContactMode.h"
#import "XNInvitedModule.h"
#import "XNInvitedModuleObserver.h"

#define DEFAULTHEADERCELLHEIGHT 210.0f
#define DEFAULTCELLHEIGHT 65.0f
#define DEFAULTHEADERIMPORTHEIGHT 44.0f
#define DEFAULTPAGEINDEX @"1"
#define DEFAULTPAGESIZE @"30"

@interface MyCfgViewController ()<CSCustomerDelegate,XNCustomerServerModuleObserver,AddressBookDelegate,XNInvitedModuleObserver,MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer  * tapGesture;
@property (nonatomic, strong) NSMutableArray     * customerArray;
@property (nonatomic, strong) NSMutableArray     * contactArray;
@property (nonatomic, strong) NSMutableArray     * unRegContactArray;

@property (nonatomic, weak) IBOutlet UITextField  *  searchTextField;
@property (nonatomic, weak) IBOutlet UITableView  *  customerListTableView;
@end

@implementation MyCfgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[XNCustomerServerModule defaultModule] addObserver:self];
    [[XNInvitedModule defaultModule] addObserver:self];

    //开始加载
    [[XNCustomerServerModule defaultModule] getCsCustomerCfpMemberWithType:@"1"];
    [[XNCustomerServerModule defaultModule] getNewCustomerListForCustomerType:@"1" pageIndex:@"1" pageSize:DEFAULTPAGESIZE attenInvestType:@"" nameOrMobile:self.searchTextField.text];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[XNCustomerServerModule defaultModule] removeObserver:self];
    [[XNInvitedModule defaultModule] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self exitKeyboard];
}

///////////////////
#pragma mark - Custom Method
////////////////////////////////////

//初始化
- (void)initView
{
    self.title = @"理财师团队成员";
    
    [self.customerListTableView setSeparatorColor:[UIColor clearColor]];
    [self.customerListTableView registerNib:[UINib nibWithNibName:@"CSCfgOptionalCell" bundle:nil] forCellReuseIdentifier:@"CSCfgOptionalCell"];
    [self.customerListTableView registerNib:[UINib nibWithNibName:@"MyCfgCell" bundle:nil] forCellReuseIdentifier:@"MyCfgCell"];
    [self.customerListTableView registerClass:[CSCfgHeader class] forHeaderFooterViewReuseIdentifier:@"CSCfgHeader"];
    [self.customerListTableView registerNib:[UINib nibWithNibName:@"XNRedPacketEmptyCell" bundle:nil] forCellReuseIdentifier:@"XNRedPacketEmptyCell"];
    
    weakSelf(weakSelf)
    self.customerListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [[XNCustomerServerModule defaultModule] getCsCustomerCfpMemberWithType:@"1"];
        [[XNCustomerServerModule defaultModule] getNewCustomerListForCustomerType:@"1" pageIndex:@"1" pageSize:DEFAULTPAGESIZE attenInvestType:@"" nameOrMobile:weakSelf.searchTextField.text];
    }];
    
    self.customerListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [[XNCustomerServerModule defaultModule] getNewCustomerListForCustomerType:@"1" pageIndex:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[[[XNCustomerServerModule defaultModule] myNewCustomerModel] pageIndex] integerValue] + 1]] pageSize:DEFAULTPAGESIZE attenInvestType:@"" nameOrMobile:weakSelf.searchTextField.text];
    }];
    
    [self.customerListTableView.mj_footer setHidden:YES];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

//退出键盘
- (void)exitKeyboard
{
    [self.view removeGestureRecognizer:self.tapGesture];
    [super exitKeyboard];
}

//键盘显示
- (void)keyboardShow:(NSNotification *)notif
{
    [self.view addGestureRecognizer:self.tapGesture];
}

//键盘隐藏
- (void)keyboardHide:(NSNotification *)notif
{
    [self exitKeyboard];
}

//////////////////
#pragma mark - 控件回调
////////////////////////////////////

//UITableView 回调处理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) return 1;
    
    if (self.customerArray.count <= 0) {
        
        return 1;
    }
    
    return self.customerArray.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 0.0f;
    return DEFAULTHEADERIMPORTHEIGHT;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) return DEFAULTHEADERCELLHEIGHT;
    
    if (self.customerArray.count <= 0) {
        
        return SCREEN_FRAME.size.height - 254;
    }
    return DEFAULTCELLHEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CSCfgHeader * header = (CSCfgHeader * )[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CSCfgHeader"];
    if (header == nil) {
        
        header = [[CSCfgHeader alloc] initWithReuseIdentifier:@"CSCfgHeader"];
    }
    
    if (section != 0) {
        
        if ([NSObject isValidateObj:[[XNCustomerServerModule defaultModule] customerCfpMemberMode]]) {
        
            [header refreshTitle:[NSString stringWithFormat:@"直推理财师 (%@人)",[[[XNCustomerServerModule defaultModule] customerCfpMemberMode] directRecomNum]] secondLevel:[[[XNCustomerServerModule defaultModule] customerCfpMemberMode] secondLevelNum] thirdLevel:[[[XNCustomerServerModule defaultModule] customerCfpMemberMode] threeLevelNum]];
        }else
        {
            [header refreshTitle:@"直推理财师" secondLevel:@"0" thirdLevel:@"0"];
        }
    }
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        CSCfgOptionalCell * cell = (CSCfgOptionalCell *)[tableView dequeueReusableCellWithIdentifier:@"CSCfgOptionalCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate = self;
        
        if ([NSObject isValidateObj:[[XNCustomerServerModule defaultModule] customerCfpMemberMode]]) {
            
            [cell showUnInvestCustomer:[[[XNCustomerServerModule defaultModule] customerCfpMemberMode] noInvest] careCustomer:[[[XNCustomerServerModule defaultModule] customerCfpMemberMode] myAttention]];
        }else
        {
            [cell showUnInvestCustomer:@"0" careCustomer:@"0"];
        }

        
        return cell;
    }
    
    
    if (self.customerArray.count <= 0) {
        
        XNRedPacketEmptyCell * cell = (XNRedPacketEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"XNRedPacketEmptyCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell showTitle:@"当前没有理财师团队成员" subTitle:@""];
        
        return cell;
    }

    
    MyCfgCell * cell = (MyCfgCell *)[tableView dequeueReusableCellWithIdentifier:@"MyCfgCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell showCfgInfo:[self.customerArray objectAtIndex:indexPath.row] type:@""];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    
    if (self.customerArray.count <= 0) {
        return;
    }
    
    XNCSNewCustomerItemModel * item = [self.customerArray objectAtIndex:indexPath.row];
    
    MyCfgDetailViewController * ctrl = [[MyCfgDetailViewController alloc]initWithNibName:@"MyCfgDetailViewController" bundle:nil userId:item.userId];
    
    [_UI pushViewControllerFromRoot:ctrl animated:YES];
}

//return搜索处理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [[XNCustomerServerModule defaultModule] getNewCustomerListForCustomerType:@"1" pageIndex:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[[[XNCustomerServerModule defaultModule] myCustomerListMode] pageIndex] integerValue] + 1]] pageSize:DEFAULTPAGESIZE attenInvestType:@"" nameOrMobile:self.searchTextField.text];
    
    [self.view showGifLoading];
    [self exitKeyboard];
    
    return YES;
}

//通讯录邀请
- (void)cfgListDidClickMobileContact
{
    AddressBookController * contactInvitedCtrl = [[AddressBookController alloc]initWithNibName:@"AddressBookController" bundle:nil title:@"推荐理财师" btnTitle:@"推荐" remindDesc:@"以下好友尚未注册，快推荐他们加入你的团队吧"];
    contactInvitedCtrl.delegate = self;
    
    [_UI pushViewControllerFromRoot:contactInvitedCtrl animated:YES];
}

//未投资客户
- (void)cfgListDidClickUnInvestedCfg
{
    MyCfgCategoryCustomerViewController * categoryCfgCtrl = [[MyCfgCategoryCustomerViewController alloc] initWithNibName:@"MyCfgCategoryCustomerViewController" bundle:nil title:@"未出单的直推理财师" attenInvestType:@"3"];
    
    [_UI pushViewControllerFromRoot:categoryCfgCtrl animated:YES];
}

//我关注的客户
- (void)cfgListDidClickCaredCfg
{
    MyCfgCategoryCustomerViewController * categoryCfgCtrl = [[MyCfgCategoryCustomerViewController alloc] initWithNibName:@"MyCfgCategoryCustomerViewController" bundle:nil title:@"我关注的直推理财师" attenInvestType:@"4"];
    
    [_UI pushViewControllerFromRoot:categoryCfgCtrl animated:YES];
}

//通讯录回调
- (void)AddressBookControllerDidSendContact:(NSArray *)contact
{
    [self.contactArray removeAllObjects];
    [self.contactArray addObjectsFromArray:contact];
    
    __block NSMutableArray * mobile = [NSMutableArray array];
    __block NSMutableArray * userName = [NSMutableArray array];
    
    BOOL existCustomer = NO;
    for (NSDictionary * dic in self.contactArray) {
        
        for (XNCSNewCustomerItemModel * mode in self.customerArray) {
            
            if ([mode.mobile isEqualToString:[dic objectForKey:ADDRESSBOOK_CONTRACT_TEL]] && [mode.userName isEqualToString:[dic objectForKey:ADDRESSBOOK_CONTRACT_NAME]])
            {
                existCustomer = YES;
                break;
            }
        }
        
        if (!existCustomer) {
            
            [mobile addObject:[dic objectForKey:ADDRESSBOOK_CONTRACT_TEL]];
            [userName addObject:[dic objectForKey:ADDRESSBOOK_CONTRACT_NAME]];
        }
    }
    
    if (mobile.count > 0) {
        
        //回调通讯录邀请
        [[XNInvitedModule defaultModule] xnInvitedContactListRequestWithMobile:mobile userNames:userName type:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:InvitedFM]]];
        [self.view showGifLoading];
        return;
    }
    
    [self.view showCustomWarnViewWithContent:@"通讯录用户已经是您的客户,不能再被邀请!"];
}

//短信回调
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [_UI dismissNaviModalViewCtrlAnimated:YES];
    if (result == MessageComposeResultSent) {
        
        [self.view showCustomWarnViewWithContent:@"发送成功!"];
        return;
    }
    
    [self.view showCustomWarnViewWithContent:@"发送失败!"];
    return;
}

//////////////////
#pragma mark - 网络回调
////////////////////////////////////

//理财师列表
- (void)XNCustomerServerModuleNewCustomerListDidReceive:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    [self.customerListTableView.mj_header endRefreshing];
    [self.customerListTableView.mj_footer endRefreshing];
    [self.customerListTableView.mj_footer setHidden:NO];
    
    if ([module.myNewCustomerModel.pageIndex integerValue] == 1)
        [self.customerArray removeAllObjects];
    
    [self.customerArray addObjectsFromArray:module.myNewCustomerModel.dataArray];
    
    if ([module.myNewCustomerModel.pageIndex integerValue] >= [module.myNewCustomerModel.pageCount integerValue]) {
        
        [self.customerListTableView.mj_footer endRefreshingWithNoMoreData];
        [self.customerListTableView.mj_footer setHidden:YES];
    }else
        [self.customerListTableView.mj_footer resetNoMoreData];
    
    [self.customerListTableView reloadData];
}

- (void)XNCustomerServerModuleNewCustomerListDidFailed:(XNCustomerServerModule *)module;
{
    [self.view hideLoading];
    [self.customerListTableView.mj_header endRefreshing];
    [self.customerListTableView.mj_footer endRefreshing];
    [self.customerListTableView.mj_footer setHidden:NO];
    
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//理财师信息
- (void)XNCustomerServerModuleCustomerCfpMemberDidReceive:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    [self.customerListTableView.mj_header endRefreshing];
    [self.customerListTableView.mj_footer endRefreshing];
    
    [self.customerListTableView reloadData];
}

- (void)XNCustomerServerModuleCustomerCfpMemberDidFailed:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    [self.customerListTableView.mj_header endRefreshing];
    [self.customerListTableView.mj_footer endRefreshing];
    
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}


//邀请客户回调
- (void)xnInvitedModuleInvitedContactDidReceiver:(XNInvitedModule *)module
{
    [self.view hideLoading];
    
    [self.unRegContactArray removeAllObjects];
    
    for (NSDictionary * telDic in module.invitedContactMode.allowedInvitedCustomer) {
        
        [self.unRegContactArray addObject:[telDic objectForKey:XN_INVITED_CONTACT_ALLOW_INVITED_CUSTOMER_MOBILE]];
    }
    
    if (self.unRegContactArray.count > 0) {
        
        MFMessageComposeViewController * picker = [[MFMessageComposeViewController alloc]init];
        picker.recipients = self.unRegContactArray;
        picker.body = module.invitedContactMode.content;
        
        picker.messageComposeDelegate = self;
        [_UI presentNaviModalViewCtrl:picker animated:YES];
    }else
    {
        [self.view showCustomWarnViewWithContent:@"您选择的用户已经注册！"];
    }
}

- (void)xnInvitedModuleInvitedContactDidFailed:(XNInvitedModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

////////////////////////
#pragma mark - setter/getter
/////////////////////////////////

//tapGesture
- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exitKeyboard)];
    }
    return _tapGesture;
}

//customerArray
- (NSMutableArray *)customerArray
{
    if (!_customerArray) {
        
        _customerArray = [[NSMutableArray alloc]init];
    }
    return _customerArray;
}

//contactArray
- (NSMutableArray *)contactArray
{
    if (!_contactArray) {
        
        _contactArray = [[NSMutableArray alloc]init];
    }
    return _contactArray;
}

//unRegContactArray
- (NSMutableArray *)unRegContactArray
{
    if (!_unRegContactArray) {
        
        _unRegContactArray = [[NSMutableArray alloc]init];
    }
    return _unRegContactArray;
}
@end
