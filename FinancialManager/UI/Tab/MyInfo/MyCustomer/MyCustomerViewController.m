//
//  CSMyCustomerViewController.m
//  FinancialManager
//
//  Created by xnkj on 6/22/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "MyCustomerViewController.h"
#import "CSCustomerDelegate.h"
#import "CSCustomerOptionalCell.h"
#import "MyCustomerCell.h"
#import "CSCustomerHeader.h"
#import "ContactHeaderCell.h"
#import "XNRedPacketEmptyCell.h"
#import "AddressBookController.h"
#import "MyCustomerDetailViewController.h"

#import "ChineseString.h"
#import "MJRefresh.h"

#import "XNCSNewCustomerItemModel.h"
#import "XNCSMyCustomerItemMode.h"
#import "XNCSMyCustomerListMode.h"
#import "XNCSCustomerCfpMemberMode.h"
#import "XNCSNewCustomerModel.h"
#import "XNCustomerServerModule.h"
#import "XNCustomerServerModuleObserver.h"

#import "XNInvitedContactMode.h"
#import "XNInvitedModule.h"
#import "XNInvitedModuleObserver.h"

#import "MyCategoryCustomerViewController.h"

#define DEFAULTHEADERCELLHEIGHT 210.0f
#define DEFAULTCELLHEIGHT 65.0f
#define DEFAULTHEADERIMPORTHEIGHT 44.0f
#define DEFAULTPAGEINDEX @"1"
#define DEFAULTPAGESIZE @"30"

@interface MyCustomerViewController ()<CSCustomerDelegate,XNCustomerServerModuleObserver,AddressBookDelegate,XNInvitedModuleObserver,MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray     * customerArray;
@property (nonatomic, strong) NSMutableArray     * contactArray;
@property (nonatomic, strong) NSMutableArray     * unRegContactArray;
@property (nonatomic, strong) NSMutableArray     * dataArray;
@property (nonatomic, strong) UITapGestureRecognizer  * tapGesture;

@property (nonatomic, weak) IBOutlet UITextField  *  searchTextField;
@property (nonatomic, weak) IBOutlet UITableView  *  customerListTableView;
@end

@implementation MyCustomerViewController

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
    [[XNCustomerServerModule defaultModule] getCsCustomerCfpMemberWithType:@"2"];
    [[XNCustomerServerModule defaultModule] getNewCustomerListForCustomerType:@"2" pageIndex:DEFAULTPAGEINDEX pageSize:DEFAULTPAGESIZE attenInvestType:@"" nameOrMobile:self.searchTextField.text];
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
    self.title = @"客户成员";
    
    [self.customerListTableView setSeparatorColor:[UIColor clearColor]];
    [self.customerListTableView registerNib:[UINib nibWithNibName:@"CSCustomerOptionalCell" bundle:nil] forCellReuseIdentifier:@"CSCustomerOptionalCell"];
    [self.customerListTableView registerNib:[UINib nibWithNibName:@"MyCustomerCell" bundle:nil] forCellReuseIdentifier:@"MyCustomerCell"];
    [self.customerListTableView registerClass:[CSCustomerHeader class] forHeaderFooterViewReuseIdentifier:@"CSCustomerHeader"];
    [self.customerListTableView registerNib:[UINib nibWithNibName:@"XNRedPacketEmptyCell" bundle:nil] forCellReuseIdentifier:@"XNRedPacketEmptyCell"];
    
    weakSelf(weakSelf)
    self.customerListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [[XNCustomerServerModule defaultModule] getCsCustomerCfpMemberWithType:@"2"];
        [[XNCustomerServerModule defaultModule] getNewCustomerListForCustomerType:@"2" pageIndex:DEFAULTPAGEINDEX pageSize:DEFAULTPAGESIZE attenInvestType:@"" nameOrMobile:weakSelf.searchTextField.text];
    }];
    
    self.customerListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [[XNCustomerServerModule defaultModule] getNewCustomerListForCustomerType:@"2" pageIndex:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[[[XNCustomerServerModule defaultModule] myNewCustomerModel] pageIndex] integerValue] + 1]] pageSize:DEFAULTPAGESIZE attenInvestType:@"" nameOrMobile:weakSelf.searchTextField.text];
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
#pragma mark - 组件回调
////////////////////////////////////

//UITableView 回调用
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
    CSCustomerHeader * header = (CSCustomerHeader * )[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CSCustomerHeader"];
    if (header == nil) {
        
        header = [[CSCustomerHeader alloc] initWithReuseIdentifier:@"CSCustomerHeader"];
    }
    
    if ([NSObject isValidateObj:[[XNCustomerServerModule defaultModule] customerCfpMemberMode]]) {
        
        [header refreshTitle:section==0?@"":[NSString stringWithFormat:@"我的客户 (%@人)",[[[XNCustomerServerModule defaultModule] customerCfpMemberMode] myCustomerNum]]];
    }else
    {
        [header refreshTitle:section==0?@"":@"我的客户"];
    }
    
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        CSCustomerOptionalCell * cell = (CSCustomerOptionalCell *)[tableView dequeueReusableCellWithIdentifier:@"CSCustomerOptionalCell"];
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
        [cell showTitle:@"暂无客户" subTitle:@""];
        
        return cell;
    }
    
    MyCustomerCell * cell = (MyCustomerCell *)[tableView dequeueReusableCellWithIdentifier:@"MyCustomerCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setItemModel:[self.customerArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || self.customerArray.count <= 0) {
        
        return;
    }
    
    XNCSNewCustomerItemModel * item = [self.customerArray objectAtIndex:indexPath.row];
    
    MyCustomerDetailViewController * ctrl = [[MyCustomerDetailViewController alloc]initWithNibName:@"MyCustomerDetailViewController" bundle:nil userId:item.userId];
    
    [_UI pushViewControllerFromRoot:ctrl animated:YES];
}

//搜索处理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[XNCustomerServerModule defaultModule] getNewCustomerListForCustomerType:@"2" pageIndex:DEFAULTPAGEINDEX pageSize:DEFAULTPAGESIZE attenInvestType:@"" nameOrMobile:self.searchTextField.text];
    
    [self.view showGifLoading];
    [self exitKeyboard];
    
    return YES;
}

//通讯录
- (void)customerListDidClickMobileContact
{
    AddressBookController * contactInvitedCtrl = [[AddressBookController alloc]initWithNibName:@"AddressBookController" bundle:nil title:@"邀请客户" btnTitle:@"邀请" remindDesc:@"以下好友尚未注册，快邀请他们加入你的团队吧"];
    contactInvitedCtrl.delegate = self;
    [_UI pushViewControllerFromRoot:contactInvitedCtrl animated:YES];
}

//未投资客户
- (void)customerListDidClickUnInvestedCustomer
{
    MyCategoryCustomerViewController *categoryCustomerVC = [[MyCategoryCustomerViewController alloc]initWithNibName:NSStringFromClass([MyCategoryCustomerViewController class]) bundle:nil title:@"未投资的客户" attenInvestType:@"1"];
    [_UI pushViewControllerFromRoot:categoryCustomerVC animated:YES];
}

//关注的客户
- (void)customerListDidClickCaredCustomer
{
    //1未投资客户 2我关注的客户
    MyCategoryCustomerViewController *categoryCustomerVC = [[MyCategoryCustomerViewController alloc]initWithNibName:NSStringFromClass([MyCategoryCustomerViewController class]) bundle:nil title:@"我关注的客户" attenInvestType:@"2"];
    [_UI pushViewControllerFromRoot:categoryCustomerVC animated:YES];
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
        [[XNInvitedModule defaultModule] xnInvitedContactListRequestWithMobile:mobile userNames:userName type:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:InvitedCustomer]]];
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
#pragma mark - 网络请求回调
////////////////////////////////////

//客户列表
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
    {
        [self.customerListTableView.mj_footer resetNoMoreData];
        [self.customerListTableView.mj_footer setHidden:NO];
    }
    
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

//客户信息
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
