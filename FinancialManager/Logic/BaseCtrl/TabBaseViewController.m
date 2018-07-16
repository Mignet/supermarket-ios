//
//  TabBaseViewController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/17.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "TabBaseViewController.h"
#import "UINavigationItem+Extension.h"
#import "MIMessageContainerController.h"

#import "XNInvitedPopViewController.h"
#import "CSIMViewController.h"
#import "UniversalInteractWebViewController.h"
#import "CSMyCustomerServiceController.h"

#import "IMManager.h"
#import "CustomerChatManager.h"

#import "XNUserModule.h"
#import "XNUserInfo.h"
#import "XNConfigMode.h"
#import "XNCommonModule.h"

#import "XNMIHomePageInfoMode.h"
#import "XNMyInformationModule.h"

#import "XNMessageModule.h"
#import "XNMessageModuleObserver.h"

@interface TabBaseViewController ()<XNInvitedPopViewDelegate,IMManagerDelegate,XNMessageModuleObserver>

@property (nonatomic, assign) BOOL isHXLogining;
@property (nonatomic, assign) BOOL messageBoxStatus;

@property (nonatomic, strong) XNInvitedPopViewController * invitedPopViewController;
@end

@implementation TabBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.needNewSwitchViewAnimation = NO;
        [self setSwitchToHomePage:YES];//登录后跳转首页
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.needNewSwitchViewAnimation = NO;
        [self setSwitchToHomePage:YES];//登录后跳转首页
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubView];
}

- (void)viewWillAppear:(BOOL)animate
{
    [super viewWillAppear:animate];
    //打开umeng
    [XNUMengHelper beginLogPageView:self.class];
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if ([NSObject isValidateInitString:token]) {
        
        [self messageCountChange];
    }
    
    if ([[_LOGIC getValueForKey:XN_USER_SERVICE_NEW_MESSAGE] boolValue])
    {
        //发送通知，改变导航栏图标
        [[NSNotificationCenter defaultCenter] postNotificationName:XN_UNREAD_SERVICE_MSG object:[_LOGIC getValueForKey:XN_USER_SERVICE_NEW_MESSAGE]];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //结束umeng
    [XNUMengHelper endLogPageView:self.class];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadPopOperationRequest];
    
    [self.invitedPopViewController.view setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////
#pragma mark - Custom Method
//////////////////////////////////////

#pragma mark - 初始化
- (void)initSubView
{
    self.navigationSeperatorLineStatus = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToHomePageRefresh) name:XN_USER_SWITCH_TAB_HOMEPAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToManageFinancialRefresh) name:XN_USER_SWITCH_TAB_FINANCIALMANAGER object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToLeiCaiRefresh) name:XN_USER_SWITCH_TAB_LIECAI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToCustomerServiceRefresh) name:XN_USER_SWITCH_TAB_CUSTOMERSERVICE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToMyInfoRefresh) name:XN_USER_SWITCH_TAB_MYINFO object:nil];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessRfreshData) name:XN_USER_LOGIN_SUCCESS_NOTIFICATINO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageCountChange) name:XN_USER_LOGIN_SUCCESS_NOTIFICATINO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unReadMessageCount:) name:XN_MESSAGECENTER_UNREAD_MESSAGE_COUNT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unReadServiceMsg:) name:XN_UNREAD_SERVICE_MSG object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFrontFromBack) name:XN_APP_FROM_BACK_TO_FRONT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackFromFront) name:XN_APP_FROM_FRONT_TO_BACK object:nil];
}

#pragma mark - 刷新首页
- (void)switchToHomePageRefresh
{
    
}

#pragma mark - 刷新金融圈
- (void)switchToManageFinancialRefresh
{
    
}

#pragma makr - 切换到猎财
- (void)switchToLeiCaiRefresh
{
    
}

#pragma mark - 刷新客户服务
- (void)switchToCustomerServiceRefresh
{
    
}

#pragma mark - 刷新我的
- (void)switchToMyInfoRefresh
{
    
}

#pragma mark - 登入成功刷新
- (void)loginSuccessRfreshData
{
    
}

#pragma mark - 点击消息
- (void)clickMessageRemind:(id)sender
{
    MIMessageContainerController * messageContainerController = [[MIMessageContainerController alloc] initWithMessageType:NotificationMessage];
    
    [_UI pushViewControllerFromRoot:messageContainerController animated:YES];
}

#pragma mark - 消息数目的变化
- (void)messageCountChange
{
    [[XNMessageModule defaultModule] removeObserver:self];
    [[XNMessageModule defaultModule] addObserver:self];
    [[XNMessageModule defaultModule] getUnReadMsgCount];
}

#pragma mark - 所有未读消息数变化
- (void)unReadMessageCount:(NSNotification *)notification
{
    NSString *totalCount = [notification.userInfo objectForKey:@"totalCount"];
    [[[XNMyInformationModule defaultModule] homePageMode] setMsgCount:totalCount];
    [self.navigationItem refreshMessageRemindItemWithMessageCount:totalCount forTarget:self];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:totalCount, @"msgCount", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:XN_HOME_UNREAD_MESSAGE_COUNT object:self userInfo:dic];
}

#pragma mark - 移动客服未读消息
- (void)unReadServiceMsg:(NSNotification *)notification
{
    NSString *objectString = notification.object;
    [_LOGIC saveValueForKey:XN_USER_SERVICE_NEW_MESSAGE Value:objectString];
    BOOL isNewMsg = [objectString boolValue];
    [self.navigationItem refreshServiceImage:isNewMsg forTarget:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:XN_UNREAD_SERVICE_ICON object:nil];
}

#pragma mark - 从后台进入前台
- (void)enterFrontFromBack
{
    [self viewWillAppear:YES];
    [self viewDidAppear:YES];
}

#pragma mark - 从前台到后台
- (void)enterBackFromFront
{
    [self viewDidDisappear:YES];
}

//获取活动弹出请求
- (void)loadPopOperationRequest
{
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if ([NSObject isValidateInitString:token]) {
        
        [[XNCommonModule defaultModule] requestNewLeveCoupon];
        [[XNCommonModule defaultModule] requestHomeNewComissionCoupon];
        [[XNCommonModule defaultModule] requestHomeComissionHasNewRecord];
        [[XNCommonModule defaultModule] requestHomeNewRedPacket];
    }
}
///////////////////
#pragma mark - Protocol
/////////////////////////////////////

#pragma mark - 未读消息请求回调
- (void)XNMessageModuleUnreadMsgCountDidReceive:(XNMessageModule *)module
{
    [[XNMessageModule defaultModule] removeObserver:self];
    
    NSString * messageCount = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[[module unReadMsgMode] objectForKey:XN_MYINFO_MYMESSAGECENTER_UNREADMSG_BULLETIONMSGCOUNT] integerValue] + [[[module unReadMsgMode] objectForKey:XN_MYINFO_MYMESSAGECENTER_UNREADMSG_PERSIONMSGCOUNT] integerValue]]];
    [self.navigationItem refreshMessageRemindItemWithMessageCount:messageCount forTarget:self];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:messageCount, @"msgCount", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:XN_HOME_UNREAD_MESSAGE_COUNT object:self userInfo:dic];
}

- (void)XNMessageModuleUnreadMsgCountDidFailed:(XNMessageModule *)module
{
    [[XNMessageModule defaultModule] removeObserver:self];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    
}

@end
