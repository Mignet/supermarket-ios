//
//  MFActivityController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/18.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "CSIMListController.h"
#import "CSIMListCell.h"
#import "MFSystemInvitedEmptyCell.h"

#import "MJRefresh.h"
#import "CSIMViewController.h"
#import "UINavigationItem+Extension.h"

#import "CSIMCreateConversationController.h"

#import "IMManager.h"
#import "IMManagerNotificationDefine.h"

#import "JFZDataBase.h"

#import "XNIMUserInfoMode.h"
#import "XNCustomerServerModule.h"
#import "XNCustomerServerModuleObserver.h"

#import "XNUserInfo.h"
#import "XNUserModule.h"
#import "XNCommonModule.h"
#import "XNConfigMode.h"

#define DEFAULTPAGEINDEX @"0"
#define DEFAULTPAGESIZE @"30"

#define DEFAULTCELLHEIGHT 62

@interface CSIMListController ()<UITableViewDataSource,UITableViewDelegate,IMManagerDelegate,XNCustomerServerModuleObserver>

@property (nonatomic, assign) BOOL             finishedRequest;
@property (nonatomic, strong) NSMutableArray * conversationArray;
@property (nonatomic, strong) NSMutableArray * contentArray;
@property (nonatomic, assign) NSInteger        currentSelectedIndex;

@property (nonatomic, weak) IBOutlet UITableView * listTableView;
@end

@implementation CSIMListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //进行用户的登入
    [self.view showGifLoading];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getAllConversation) name:IMManager_New_Message_Notification object:nil];
    [[IMManager defaultIMManager] setDelegate:self];
    
     if ((![[IMManager defaultIMManager] imManagerLoginStatus] && ![[IMManager defaultIMManager] isLoginingStatus]) || ([[IMManager defaultIMManager] imManagerLoginStatus] && ![[IMManager defaultIMManager] imManagerConnectStatus])) {
        
        //如果账号和密码为空，重新拉取一遍
        if (![NSObject isValidateInitString:[[[XNUserModule defaultModule] userMode] easemobAccount]] || ![NSObject isValidateInitString:[[[XNUserModule defaultModule] userMode] easemobPassword]]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERHXNILNOTIFICATION object:nil];
            
            [self.view hideLoading];
            return;
        }

         @try {
             
             [[IMManager defaultIMManager] imManagerLogout];
             [[IMManager defaultIMManager] imManagerLoginWithAccount:[[[XNUserModule defaultModule] userMode] easemobAccount] password:[[[XNUserModule defaultModule] userMode] easemobPassword]];
         } @catch (NSException *exception) {
             
         } @finally {
             
         }
        
    }else
        [self getAllConversation];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[IMManager defaultIMManager] setDelegate:nil];
   
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[XNCustomerServerModule defaultModule] removeObserver:self];
    [[IMManager defaultIMManager] setDelegate:nil];
}

///////////////////////////
#pragma mark - Custom Methods
/////////////////////////////////////
#pragma mark - 初始化
- (void)initView
{
    [self setTitle:@"互动列表"];
    self.finishedRequest = NO;
    self.currentSelectedIndex = 0;
    [[IMManager defaultIMManager] setDelegate:self];
    [self.navigationItem addConversationItemWithTarget:self action:@selector(newConversation)];
    
    [[XNCustomerServerModule defaultModule] addObserver:self];
    
    [self.listTableView registerNib:[UINib nibWithNibName:@"CSIMListCell" bundle:nil] forCellReuseIdentifier:@"CSIMListCell"];
    [self.listTableView registerNib:[UINib nibWithNibName:@"MFSystemInvitedEmptyCell" bundle:nil] forCellReuseIdentifier:@"MFSystemInvitedEmptyCell"];
    [self.listTableView setSeparatorColor:[UIColor clearColor]];
    
    weakSelf(weakSelf)
    self.listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.finishedRequest = NO;
        [weakSelf.view showGifLoading];
        [weakSelf getAllConversation];
    }];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 新建会话
- (void)newConversation
{
    CSIMCreateConversationController * conversationCtrl = [[CSIMCreateConversationController alloc]initWithNibName:@"CSIMCreateConversationController" bundle:nil];
    
    [_UI pushViewControllerFromRoot:conversationCtrl animated:YES];
}

#pragma mark - 获取所有会话更更新数据
- (void)getAllConversation
{
    //从环信SDK中获取所有的会话
    [self.conversationArray removeAllObjects];
    NSArray * conversation = [[IMManager defaultIMManager] imManagerGetConversationArray];
    NSString * currentAccount = [[EMClient sharedClient] currentUsername];

    __block NSString * netRequestEasemobAccount = @"";
    NSString * easemobAcct = nil;
    EMConversation * conversationItem = nil;
    for (int i = 0 ; i < conversation.count; i ++ ) {
        
        conversationItem = [conversation objectAtIndex:i];
        
        easemobAcct = [[conversationItem lastReceivedMessage] to];
        if ([currentAccount isEqualToString:[[conversationItem lastReceivedMessage] to]]) {
            
            easemobAcct = [[conversationItem lastReceivedMessage] from];
        }
        
        [[JFZDataBase shareDataBaseWithDBName:@"FinancialManagerDb"] findSingleDataInTable:@"CustomerList" WithKey:@"easemobAcct" value:easemobAcct condition:JFZDataBaseConditionEqual conditionStr:nil orderBy:nil success:^(id result, FMDatabase *db) {
            
            
            if ([NSObject isValidateObj:result]) {
                
                XNIMUserInfoMode * mode = [XNIMUserInfoMode initIMUserInfoWithParams:[NSDictionary dictionaryWithObjectsAndKeys:[result objectForKey:@"customerName"],@"userName",[result objectForKey:@"customerId"],@"userId",[result objectForKey:@"customerMobile"],@"mobile",[result objectForKey:@"image"],@"image",[result objectForKey:@"easemobAcct"],@"easemobAcct", nil]];
                [self.conversationArray addObject:@{@"userInfo":mode,@"conversation":conversationItem}];
            }else
            {
                //如果是客服
                if ([self isServiceEaseMob:easemobAcct])
                {
                    XNIMUserInfoMode * mode = [XNIMUserInfoMode initIMUserInfoWithParams:[NSDictionary dictionaryWithObjectsAndKeys:@"客服",@"userName",@"",@"userId",@"",@"mobile",@"XN_CS_IM_List_ServiceHeaderImg",@"image",easemobAcct,@"easemobAcct", nil]];
                    [self.conversationArray addObject:@{@"userInfo":mode,@"conversation":conversationItem}];
                }
                else
                {
                    //开始进行网络请求
                    XNIMUserInfoMode * mode = [XNIMUserInfoMode initIMUserInfoWithParams:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"userName",@"",@"userId",@"",@"mobile",@"",@"image",@"",@"easemobAcct",nil]];
                    [self.conversationArray addObject:@{@"conversation":conversationItem,@"userInfo":mode}];
                    netRequestEasemobAccount = [netRequestEasemobAccount stringByAppendingFormat:@",%@",easemobAcct];
                }
                
            }
        } failed:^(NSError *error) {
            
            NSLog(@"error:%@",error.description);
        }];
    }
    
    //判断是否需要进行网络加载
    if ([netRequestEasemobAccount isEqualToString:@""]) {
        
        [self.listTableView.mj_header endRefreshing];
        [self.view hideLoading];
        [self.listTableView reloadData];
    }else
    {
        [[XNCustomerServerModule defaultModule] getUserInfoByEaseMob:[netRequestEasemobAccount substringFromIndex:1]];
    }
}

#pragma mark - 获取客服的环信账号
- (BOOL)isServiceEaseMob:(NSString *)serviceEaseMobName
{
    NSString *serviceString = @"";
    if ([[[XNCommonModule defaultModule] configMode] kefuEasemobileName])
    {
        serviceString = [[[XNCommonModule defaultModule] configMode] kefuEasemobileName];
    }
    else
    {
        serviceString = [AppFramework getConfig].XN_SERVICE_EASEMOB_NAME;
    }
    
    if ([serviceString isEqualToString:serviceEaseMobName])
    {
        return YES;
    }
    
    return NO;
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
    
    return self.conversationArray.count;
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
    return DEFAULTCELLHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.finishedRequest && self.contentArray.count <= 0) {
        
        MFSystemInvitedEmptyCell * cell = (MFSystemInvitedEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"MFSystemInvitedEmptyCell"];
        
        [cell refreshTitle:XNCSIMListControllerListEmpty];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    
    CSIMListCell * cell = (CSIMListCell *)[tableView dequeueReusableCellWithIdentifier:@"CSIMListCell"];
    
    [cell refreshIMInformationForConversation:[self.conversationArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.conversationArray.count > 0) {
        
        EMConversation * conversation = [[self.conversationArray objectAtIndex:indexPath.row] objectForKey:@"conversation"];
        XNIMUserInfoMode   * dic = (XNIMUserInfoMode *)[[self.conversationArray objectAtIndex:indexPath.row] objectForKey:@"userInfo"];
        
        BOOL isService = NO;
        NSString *themeNameString = @"";
        if ([self isServiceEaseMob:dic.easemobAccount])
        {
            isService = YES;
            themeNameString = XN_SERVICE_WORK_TIME;
        }
        
        CSIMViewController * imCtrl = [[CSIMViewController alloc]initWithNibName:@"CSIMViewController"
                                                                          bundle:nil
                                                                       titleName:dic.userName
                                                                    conversation:conversation
                                                                    enterService:isService
                                                                     chatAccount:dic.easemobAccount
                                                                       themeName:themeNameString
                                                                customerImageUrl:@""];
        [_UI pushViewControllerFromRoot:imCtrl animated:YES];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    EMConversation * conversation = [[self.conversationArray objectAtIndex:indexPath.row] objectForKey:@"conversation"];
    
    [[IMManager defaultIMManager] imManagerDeleteConversationForChatter:conversation.conversationId
                                                isDeleteConversationMsg:YES];
    
    [self.conversationArray removeObjectAtIndex:indexPath.row];
    [self.listTableView reloadData];
}

#pragma mark - 用户信息请求
- (void)XNCustomerServerModuleGetUesrInfoByEasemobDidReceive:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    [self.listTableView.mj_header endRefreshing];
    
    NSString * currentAccount = [[EMClient sharedClient] currentUsername];
    
    NSString * chatEasemobAcct = @"";
    EMConversation * conversationItem = nil;
    NSArray * tmpConversationArray = [NSArray arrayWithArray:self.conversationArray];
    for(NSDictionary * dic in tmpConversationArray)
    {
        conversationItem = [dic objectForKey:@"conversation"];
        
        for (XNIMUserInfoMode * mode in module.imUserInfoArray) {
            
            chatEasemobAcct = [[conversationItem lastReceivedMessage] to];
            if ([currentAccount isEqualToString:[[conversationItem lastReceivedMessage] to]]) {
                
                chatEasemobAcct = [[conversationItem lastReceivedMessage] from];
            }

            if ([chatEasemobAcct isEqualToString:mode.easemobAccount]) {
                
                [self.conversationArray replaceObjectAtIndex:[self.conversationArray indexOfObject:dic] withObject:@{@"userInfo":mode,@"conversation":conversationItem}];
            }
        }
    }
    
    [self.listTableView reloadData];
}

- (void)XNCustomerServerModuleGetUserInfoByEasemobDidFailed:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    [self.listTableView.mj_header endRefreshing];
    
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

#pragma mark - 登入状态
- (void)iMManagerDidLoginStatus:(BOOL)success
{
    if (!success) {
        
        [self showCustomWarnViewWithContent:@"账户登入失败,请重新拉下登入!"];
        [self.view hideLoading];
        return;
    }
    
    [self getAllConversation];
}


///////////////////////////////
#pragma mark - setter/getter
////////////////////////////////////////////

#pragma mark - conversationArray
- (NSMutableArray *)conversationArray
{
    if (!_conversationArray) {
        
        _conversationArray = [[NSMutableArray alloc]init];
    }
    return _conversationArray;
}

#pragma mark - contentArray
- (NSMutableArray *)contentArray
{
    if (!_contentArray) {
        
        _contentArray = [[NSMutableArray alloc]init];
    }
    return _contentArray;
}

@end
