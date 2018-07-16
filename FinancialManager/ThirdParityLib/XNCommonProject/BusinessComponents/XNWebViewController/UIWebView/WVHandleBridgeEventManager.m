//
//  WKHandleBridgeEventManager.m
//  FinancialManager
//
//  Created by xnkj on 09/01/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "WVHandleBridgeEventManager.h"
#import "SharedViewController.h"
#import "UniversalInteractWebViewController.h"
#import "PXAlertView.h"
#import "PXAlertView+XNExtenstion.h"
#import "MIAddBankCardController.h"
#import "CfgLevelCalcViewController.h"
#import "AgentDetailViewController.h"
#import "AgentContainerController.h"

#import "XNFMProductListItemMode.h"
#import "MIMySetMode.h"
#import "XNPlatformUserCenterOrProductMode.h"
#import "XNFinancialManagerModule.h"
#import "XNFinancialManagerModuleObserver.h"
#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"

#import "UINavigationItem+Extension.h"

#import "RecommendViewController.h"

#import "RecommendMemberViewController.h"
#import "RecommendCustomerViewController.h"

#import "WeChatManager.h"
#import "XNInsuranceModule.h"
#import "XNInsuranceDetailMode.h"
#import "CapacityAssessmentManager.h"

typedef NS_ENUM(NSInteger, SharedTypeValue){
    systemShared,
    webShared
};

@interface WVHandleBridgeEventManager()<SharedViewControllerDelegate,XNFinancialManagerModuleObserver,XNMyInformationModuleObserver, RecommendViewControllerDelegate>

@property (nonatomic, assign) BOOL  existSharedView;//是否已经存在分享视图
@property (nonatomic, assign) SharedTypeValue sharedType;//分享类型
@property (nonatomic, copy) NSDictionary * systemSharedDictionary;//系统分享字典
@property (nonatomic, copy) NSDictionary * webSharedDictionary;//web分享内容
@property (nonatomic, copy) NSString * productId;//用于产品分享的产品id
@property (nonatomic, copy) NSString * webJumpUrl;//当前跳转url（前端控制)
@property (nonatomic, copy) NSString * jsExecuteMethod;//js执行的方法
@property (nonatomic, strong) XNFMProductListItemMode * productListItemMode;
@property (nonatomic, strong) SharedViewController * sharedCtrl; //分享控件
@property (nonatomic, strong) RecommendViewController *recommendVC; //推荐
@property (nonatomic, weak) UniversalInteractWebViewController * mainWebViewController;

@property (nonatomic, strong) XNInsuranceModule *insuranceModule;

@end

@implementation WVHandleBridgeEventManager

#pragma mark - cycle

- (id)init
{
    self = [super init];
    if (self) {
        
        [self initManager];
        self.insuranceModule = [[XNInsuranceModule alloc] init];
        [self.insuranceModule addObserver:self];
    }
    return self;
}

- (void)dealloc
{
    _sharedCtrl.delegate = nil;
    _recommendVC.proDelegate = nil;
    [self.insuranceModule removeObserver:self];
}

#pragma mark - 自定义方法

//初始化
- (void)initManager
{
    self.existSharedView = NO;
    self.sharedType = systemShared;
}

//设置代理
- (void)setDelegateMainWebViewController:(UniversalInteractWebViewController *)mainWebViewController
{
    self.mainWebViewController = mainWebViewController;
    
    [self setupListenEvents];
}

//////////////////////
#pragma mark - javascriptBridge  ---Start
/////////////////////////////////////
//监听事件（由js中调用)
- (void)setupListenEvents
{
    //分享操作
    weakSelf(weakSelf)
    [self.mainWebViewController.bridge registerHandler:@"getAppShareFunction" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [weakSelf getAppShareFunction:data];
    }];
    
    //传递分享内容
    [self.mainWebViewController.bridge registerHandler:@"getSharedContent" handler:^(id data, WVJBResponseCallback responseCallback) {
    
        [weakSelf setNativeSharedDictionary:data];
    }];
    
    //退出操作
    [self.mainWebViewController.bridge registerHandler:@"getAppLogOut" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:[NSNumber numberWithInteger:ILoginSourceMax]];
    }];
    
    //提示处理
    [self.mainWebViewController.bridge registerHandler:@"showAppPrompt" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [weakSelf.mainWebViewController showCustomWarnViewWithContent:[data objectForKey:@"title"]];
    }];
    
    //调用本地理财师佣金计算功能
    [self.mainWebViewController.bridge registerHandler:@"getApplhlcsCommissionCalc" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if ([weakSelf.mainWebViewController.delegate respondsToSelector:@selector(getAppLhlcsCommissionCalc:)])
            [weakSelf.mainWebViewController.delegate getAppLhlcsCommissionCalc:data];
    }];
    
    //产品推荐
    [self.mainWebViewController.bridge registerHandler:@"productRecommend" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //统计_产品详情推荐
        [XNUMengHelper umengEvent:@"C_product_details_Recommended"];
        
        if ([weakSelf.mainWebViewController.delegate respondsToSelector:@selector(productRecommend)])
            [weakSelf.mainWebViewController.delegate productRecommend];
    }];
    
    //设置标题
    [self.mainWebViewController.bridge registerHandler:@"setAppWebTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.mainWebViewController.title = [data objectForKey:@"title"];
    }];
    
    //进入平台详情页
    [self.mainWebViewController.bridge registerHandler:@"getAppPlatfromDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if ([NSObject isValidateInitString:[data objectForKey:@"orgNo"]]) {
            
            AgentDetailViewController *viewController = [[AgentDetailViewController alloc] initWithNibName:@"AgentDetailViewController" bundle:nil platNo:[data objectForKey:@"orgNo"]];
            [_UI pushViewControllerFromRoot:viewController animated:YES];
        }
    }];
    
    //购买产品
    [self.mainWebViewController.bridge registerHandler:@"buyTBProduct" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [weakSelf buyAction:data];
    }];
    
    //是否存在这个购买按钮,进行引导处理
    [self.mainWebViewController.bridge registerHandler:@"showInvestCaseTip" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [weakSelf.mainWebViewController loadNewUserGuild:CGRectMake([[data objectForKey:@"x"] floatValue], [[data objectForKey:@"y"] floatValue], [[data objectForKey:@"width"] floatValue], [[data objectForKey:@"height"] floatValue])];
    }];
    
    //通知web是否显示对应的web内容
    [self.mainWebViewController.bridge registerHandler:@"getAppVersion" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        responseCallback(appVersion);
    }];
    
    //绑卡认证
    [self.mainWebViewController.bridge registerHandler:@"bindCardAuthenticate" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        MIAddBankCardController * bankCardInfoCtrl = [[MIAddBankCardController alloc]initWithNibName:@"MIAddBankCardController" bundle:nil];
        
        [_LOGIC saveValueForKey:XN_USER_INIT_PAY_PASSWORD_CONTROLLER Value:@"UniversalInteractWebViewController"];
        
        [_UI pushViewControllerFromRoot:bankCardInfoCtrl animated:YES];
    }];
    
    //去除右上角的按钮
    [self.mainWebViewController.bridge registerHandler:@"removeLocalSharedBtn" handler:^(id data, WVJBResponseCallback responseCallback) {

        [self.mainWebViewController.navigationItem removeRightButton];
    }];
    
    //添加右上角按钮
    [self.mainWebViewController.bridge registerHandler:@"addNaviRightBtn" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [weakSelf.mainWebViewController.navigationItem removeRightButton];
        [weakSelf.mainWebViewController.navigationItem addRightBarItemWithTitle:[data objectForKey:@"title"] titleColor:[UIColor whiteColor] target:weakSelf action:@selector(handleNavigationRightItemAction)];
        weakSelf.jsExecuteMethod = [data objectForKey:@"jsMethod"];
    }];
    
    //职级计算器
    [self.mainWebViewController.bridge registerHandler:@"jumpCfgLevelCalculate" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        CfgLevelCalcViewController *viewController = [[CfgLevelCalcViewController alloc] initWithNibName:@"CfgLevelCalcViewController" bundle:nil];
        [_UI pushViewControllerFromRoot:viewController animated:YES];
    }];
    
    //前端动态控制显示按钮
    [self.mainWebViewController.bridge registerHandler:@"showTopRightText" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.webJumpUrl = [data objectForKey:@"url"];
        
        [weakSelf.mainWebViewController.navigationItem addRightBarItemWithTitle:[data objectForKey:@"rightText"] titleColor:[UIColor whiteColor] target:weakSelf action:@selector(launchNewWebView)];
    }];
    
    //运营活动动态化处理
    [self.mainWebViewController.bridge registerHandler:@"jumpToNativePage" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString * jsonStr = [data debase64];
        if (![NSObject isValidateInitString:jsonStr]) {
            return;
        }
        
        NSData * jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError * error = nil;
        id params = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        NSString * targetName = [params objectForKey:@"name"];
        NSString * methodName = [params objectForKey:@"method"];
        NSString * paramsStr = [params objectForKey:@"params"];
        
        if ([targetName isEqualToString:@"HomeViewController"]) {
            
            [_UI currentViewController:weakSelf.mainWebViewController popToRootViewController:YES AndSwitchToTabbarIndex:0 comlite:nil];
            
            return;
        }else if([targetName isEqualToString:@"AgentContainerViewController"])
        {
            UINavigationController * platformCtrl = [_UI getRootNavigationControllerAtIndex:1];
            AgentContainerController * agentCtrl = platformCtrl.viewControllers[0];
            
            NSArray * paramArray = [paramsStr componentsSeparatedByString:@","];
            [agentCtrl selectedAtIndex:[[paramArray firstObject] integerValue]];
            
            [_UI currentViewController:weakSelf.mainWebViewController popToRootViewController:YES AndSwitchToTabbarIndex:1 comlite:nil];
            
            return;
        }else if([targetName isEqualToString:@"SeekTreasureViewController"])
        {
            
            [_UI currentViewController:weakSelf.mainWebViewController popToRootViewController:YES AndSwitchToTabbarIndex:2 comlite:nil];
            
            return;
        }else if([targetName isEqualToString:@"MyInfoViewController"])
        {
            [_UI currentViewController:weakSelf.mainWebViewController popToRootViewController:YES AndSwitchToTabbarIndex:3 comlite:nil];
            
            return;
        }
        
        Class VC = NSClassFromString(targetName);
        SEL method = NSSelectorFromString(methodName);
        NSArray * paramArray = [paramsStr componentsSeparatedByString:@","];
        
        // 方法签名(方法的描述)
        NSMethodSignature *signature = [VC instanceMethodSignatureForSelector:method];
        if (signature == nil)
        {
            [NSException raise:@"签名无效" format:@"%@方法找不到", NSStringFromSelector(method)];
        }
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        id obj = [VC alloc];
        invocation.target = obj;
        invocation.selector = method;
        
        //设置参数
        NSInteger nParamCount = paramArray.count; //除self、_cmd以外的参数个数
        for (NSInteger i = 0; i < nParamCount; i++)
        {
            id object = paramArray[i];
            
            if ([object isEqualToString:@"nil"])
            {
                object = [NSBundle mainBundle];
                [invocation setArgument:&object atIndex:i + 2];
            }else
            {
                //根据函数签名获取对应参数的类型：
                const char * argumentType = [signature getArgumentTypeAtIndex:i + 2];
                switch (argumentType[0] == 'r'?argumentType[1] : argumentType[0]) {
                        
                    case 'i':
                    {
                        int val = [[NSString stringWithFormat:@"%@",object] intValue];
                        [invocation setArgument:&val atIndex:i + 2];
                    }
                        break;
                    case 'q':
                    {
                        NSInteger val = [[NSString stringWithFormat:@"%@",object] integerValue];
                        [invocation setArgument:&val atIndex:i + 2];
                    }
                        break;
                        
                    case 'f':
                    {
                        float val = [[NSString stringWithFormat:@"%@",object] floatValue];
                        [invocation setArgument:&val atIndex:i+2];
                    }
                        break;
                    case 'B':
                    {
                        BOOL val = [[NSString stringWithFormat:@"%@",object] boolValue];
                        [invocation setArgument:&val atIndex:i + 2];
                    }
                        break;
                    default:
                    {
                        [invocation setArgument:&object atIndex:i + 2];
                    }
                        break;
                }
            }
        }
        
        [invocation retainArguments];
        
        //调用方法
        [invocation invoke];
        
        __autoreleasing UIViewController * value=nil;
        
        // 有返回值类型，才去获得返回值
        if (signature.methodReturnLength)
        {
            [invocation getReturnValue:&(value)];
        }
        
        NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
        if (![NSObject isValidateInitString:token]) {
            
            [value setSwitchToHomePage:NO];
        }
        
        [_UI pushViewControllerFromRoot:value animated:YES];
    }];
    
    //获取个人名片位置
    [self.mainWebViewController.bridge registerHandler:@"getPositionCoordinate" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [weakSelf.mainWebViewController loadNewUserGuild:CGRectMake([[data objectForKey:@"left"] floatValue], [[data objectForKey:@"top"] floatValue] + 64, [[data objectForKey:@"width"] floatValue], [[data objectForKey:@"height"] floatValue])];
    }];
    
    //Token失效
    [self.mainWebViewController.bridge registerHandler:@"tokenExpired" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.mainWebViewController.reRefreshPage = YES;
        [weakSelf.mainWebViewController setSwitchToHomePage:NO];
       
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:[NSNumber numberWithInteger:ILoginSourceMax]];
    }];
    
    //网页是否需要刷新
    [self.mainWebViewController.bridge registerHandler:@"refreshPage" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.mainWebViewController.reRefreshPage = YES;
    }];
    
    //进入一个新的网页，右上角添加邀请理财师和邀请客户操作（针对新手福利6连送）
    [self.mainWebViewController.bridge registerHandler:@"invitedOperation" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf handleInviteOperation:[[data objectForKey:@"type"] integerValue]];
    }];
    
    //重新测评
    [self.mainWebViewController.bridge registerHandler:@"jumpThirdInsurancePage" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //[weakSelf handleInviteOperation:[[data objectForKey:@"type"] integerValue]];
        //NSLog(@"data = %@", data);
        // tag  1: 保险详情  2：个人中心
        
        [weakSelf handleInvestCaseCode:[data objectForKey:@"caseCode"] withTag:[data objectForKey:@"tag"]];
    }];
}

//////////////////////
#pragma mark - javascriptBridge  ---End
/////////////////////////////////////


// 测评结果h5页面保险跳转

- (void)handleInvestCaseCode:(NSString *)caseCode withTag:(NSString *)tag
{
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    // 设置单利数据为空
    //[[CapacityAssessmentManager shareInstance] setShowContentArr];
    [self.insuranceModule requestInsuranceDetaiParamsWithCaseCode:caseCode];
}

/***********************************针对猎财大师邀请操作等特殊情况（针对新手福利6连送）**************/
//根据类型判断对应操作-针对邀请操作
- (void)handleInviteOperation:(NSInteger)type
{
    //邀请客户
    UniversalInteractWebViewController *webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:[_LOGIC getWebUrlWithBaseUrl:@"/pages/guide/plannerInvitation.html"] requestMethod:@"GET"];
    
    [_UI pushViewControllerFromRoot:webCtrl animated:YES];
}

/********************************通用右上角与web交互***********************/

//处理web前端给app添加的右上角按钮操作
- (void)handleNavigationRightItemAction
{
    [self.mainWebViewController.bridge callHandler:self.jsExecuteMethod];
}

//调用下一张
- (void)swiperEvent
{
    [self.mainWebViewController.bridge callHandler:@"swiperEvent"];
}

//添加右上角邀请操作
- (void)addRightItemWithTitle:(NSString *)title
{
    [self.mainWebViewController.navigationItem removeRightButton];
    [self.mainWebViewController.navigationItem addRightBarItemWithTitle:title titleColor:[UIColor whiteColor] target:self action:@selector(invitedCustomer)];
}

///////////////////////////
#pragma mark - 针对邀请理财师/邀请客户的函数操作 ------Start
////////////////////////////////////////////

//添加右上角邀请客户
- (void)addRightInvitedCustomer
{
    [self.mainWebViewController.navigationItem addRightBarItemWithTitle:@"邀请客户" titleColor:[UIColor whiteColor] target:self action:@selector(invitedCustomerFirst)];
}

//邀请客户操作
- (void)invitedCustomerFirst
{
    UniversalInteractWebViewController *webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:[_LOGIC getWebUrlWithBaseUrl:@"/pages/guide/clientInvitation.html"] requestMethod:@"GET"];
    [webCtrl setNewWebView:YES];
    [webCtrl setTitleName:@""];
    [webCtrl setNeedNewSwitchViewAnimation:YES];
    [webCtrl.navigationItem addRightBarItemWithTitle:@"邀请理财师" titleColor:[UIColor whiteColor] target:self action:@selector(invitedCfgAfter)];
    
    [_UI pushViewControllerFromRoot:webCtrl animated:YES];
}

//邀请理财师
- (void)invitedCfgAfter
{
    [_UI popViewControllerFromRoot:YES];
}

//添加右上角邀请理财师
- (void)addRightInvitedCfg
{
    [self.mainWebViewController.navigationItem addRightBarItemWithTitle:@"邀请理财师" titleColor:[UIColor whiteColor] target:self action:@selector(invitedCfgFirst)];
}

//邀请客户操作
- (void)invitedCustomerAfter
{
    [_UI popViewControllerFromRoot:YES];
}

//邀请理财师
- (void)invitedCfgFirst
{
    UniversalInteractWebViewController *webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:[_LOGIC getWebUrlWithBaseUrl:@"/pages/guide/clientInvitation.html"] requestMethod:@"GET"];
    [webCtrl setNewWebView:YES];
    [webCtrl setTitleName:@""];
    [webCtrl setNeedNewSwitchViewAnimation:YES];
    [webCtrl.navigationItem addRightBarItemWithTitle:@"邀请客户" titleColor:[UIColor whiteColor] target:self action:@selector(invitedCustomerAfter)];
    
    [_UI pushViewControllerFromRoot:webCtrl animated:YES];
}


///////////////////////////
#pragma mark - 针对邀请理财师/邀请客户的函数操作 ------End
////////////////////////////////////////////

/**
 * web分享
 *
 * params data web传递过来的分享信息
 **/
- (void)getAppShareFunction:(NSDictionary *)data
{
    if (data) {
        
        self.sharedType = webShared;
        self.webSharedDictionary = [NSDictionary dictionaryWithDictionary:data];
        
        if (!self.existSharedView) {
            
            self.existSharedView = YES;
            
            [self.mainWebViewController.view addSubview:self.sharedCtrl.view];
            [self.mainWebViewController addChildViewController:self.sharedCtrl];
            
            weakSelf(weakSelf)
            [self.sharedCtrl.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.edges.equalTo(weakSelf.mainWebViewController.view);
            }];
            
            [self.mainWebViewController.view layoutIfNeeded];
        }
        
        [self.sharedCtrl show];
    }
}

//当前页面有所改变
- (void)changeCurrentPage
{
    if (self.sharedCtrl) {
        
        [self.sharedCtrl hide];
    }
}

/**
 * 添加推荐操作
 *
 * */
- (void)setRecommendOperation
{
    if (!self.existSharedView) {
        self.existSharedView = YES;
        
        [self.mainWebViewController.view addSubview:self.recommendVC.view];
        
        weakSelf(weakSelf)
        [self.recommendVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.mainWebViewController.view);
        }];
        [self.mainWebViewController.view layoutIfNeeded];
    }
}

/**
 * 设置
 */
- (void)setNativeSharedDictionary:(NSDictionary *)sharedDictionary
{
    if (sharedDictionary) {
        
        self.sharedType = systemShared;
        self.systemSharedDictionary = sharedDictionary;
        
        if (!self.existSharedView) {
            
            self.existSharedView = YES;
            [self.mainWebViewController.navigationItem addShareButtonItemWithTarget:self action:@selector(clickSharedAction)];
            
            [self.mainWebViewController.view addSubview:self.sharedCtrl.view];
            [self.mainWebViewController addChildViewController:self.sharedCtrl];
            
            weakSelf(weakSelf)
            [self.sharedCtrl.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.edges.equalTo(weakSelf.mainWebViewController.view);
            }];
            
            [self.mainWebViewController.view layoutIfNeeded];
        }
    }
}

/**
 * 通过产品id进行分享
 *
 * params productId 产品id
 **/
- (void)setSharedProductId:(NSString *)productId
{
    if ([NSObject isValidateInitString:productId]) {
        
        self.sharedType = systemShared;
        self.productId = productId;
        
        if (!self.existSharedView) {
            
            self.existSharedView = YES;
            [self.mainWebViewController.navigationItem addShareButtonItemWithTarget:self action:@selector(clickSharedAction)];
            
            [self.mainWebViewController.view addSubview:self.sharedCtrl.view];
            [self.mainWebViewController addChildViewController:self.sharedCtrl];
            
            weakSelf(weakSelf)
            [self.sharedCtrl.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.edges.equalTo(weakSelf.mainWebViewController.view);
            }];
            
            [self.mainWebViewController.view layoutIfNeeded];
        }}
}

/**
 * 点击分享弹出分享
 **/
- (void)clickSharedAction
{
    //是否是产品分享
    if ([NSObject isValidateInitString:self.productId]) {
        
        [[XNFinancialManagerModule defaultModule] addObserver:self];
        [[XNFinancialManagerModule defaultModule] fmGetSharedProductInfoWithProductId:self.productId];
        [self.mainWebViewController.view showGifLoading];
    }else
    {
        [self.sharedCtrl show];
    }
}

/**
 * 产品推荐
 **/
- (void)productDetailRecommend:(XNFMProductListItemMode *)productMode
{
    if ([NSObject isValidateObj:productMode])
    {
        self.productListItemMode = productMode;
        
        [self.mainWebViewController.navigationItem addRightBarItemWithTitle:@"推荐" titleColor:[UIColor whiteColor] target:self action:@selector(productRecommendAction)];
        
        [self setRecommendOperation];
    }
}

/**
 * 点击产品推荐
 **/
- (void)productRecommendAction
{
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
     
        //跳转到登录页面
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    //弹出底部推荐视图
    [self.recommendVC show:ProductShareShow];
}

/**
 * 弹出新的web页面
 **/
- (void)launchNewWebView
{
    UniversalInteractWebViewController * ctrl = [[UniversalInteractWebViewController alloc]initRequestUrl:self.webJumpUrl requestMethod:@"GET"];
    [ctrl setNewWebView:YES];
    
    [_UI pushViewControllerFromRoot:ctrl animated:YES];
}

/**
 * js产品详情里的购买回调(orgNo ：是机构编码 productId ： 产品id)
 **/
- (void)buyAction:(NSDictionary *)params
{
    self.productListItemMode = self.productListItemMode = [[XNFMProductListItemMode alloc] init];
    self.productListItemMode.orgNumber = [params objectForKey:@"orgNo"];
    self.productListItemMode.productId = [params objectForKey:@"productId"];
    self.productListItemMode.orgName = [params objectForKey:@"orgName"];
    
    //判断是否登录
    NSString *token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    BOOL isExpired = [[_LOGIC getValueForKey:XN_USER_USER_TOKEN_EXPIRED] isEqualToString:@"1"];
    if (token == nil || [token isKindOfClass:[NSNull class]] || [token isEqual:[NSNull null]] || token.length < 1 || isExpired)
    {
        //跳转到登录页面
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    [[XNMyInformationModule defaultModule] addObserver:self];
    
    //判断是否绑卡
    [[XNMyInformationModule defaultModule] requestMySettingInfo];
    [self.mainWebViewController.view showGifLoading];
    
}

#pragma mark - 协议

// 4.5.1 推荐视图协议回调
- (NSDictionary *)recommendViewControllerProDid:(RecommendViewController *)controller shareType:(RecommendViewControllerType)clickType
{
    /***
     Rmanage = 0, // 推荐我的直推理财师
     Rclient,     // 推荐给我的客户
     Rcircle,     // 推荐到朋友圈
     Rfriend      // 推荐给好友
     **/
    if (clickType == Rmanage) {
        
        RecommendMemberViewController *recommendMemberVC = [[RecommendMemberViewController alloc] init];
        recommendMemberVC.productOrgId = self.productListItemMode.productId;;
        /*** 1=产品ID 2 =机构ID **/
        recommendMemberVC.IdType = @"1";
        [_UI pushViewControllerFromRoot:recommendMemberVC animated:YES];
    }
    
    else if (clickType == Rclient) {
        
        RecommendCustomerViewController *recommendCustomerVC = [[RecommendCustomerViewController alloc] init];
        recommendCustomerVC.productOrgId = self.productListItemMode.productId;;
        recommendCustomerVC.IdType = @"1";
        [_UI pushViewControllerFromRoot:recommendCustomerVC animated:YES];
    
    }
    
    else if (clickType == Rcircle) {
        
        return self.systemSharedDictionary;
    }
    
    else if (clickType == Rfriend) {
        
         return self.systemSharedDictionary;
    }
    
    return nil;
}

//产品分享数据回调
- (void)XNFinancialManagerModuleProductSharedDidReceive:(XNFinancialManagerModule *)module{
    
    [[XNFinancialManagerModule defaultModule] removeObserver:self];
    [self.mainWebViewController.view hideLoading];
    
    self.systemSharedDictionary = module.productSharedMode;
    
    [self.sharedCtrl show];
}

- (void)XNFinancialManagerModuleProductSharedDidFailed:(XNFinancialManagerModule *)module{
    
    [[XNFinancialManagerModule defaultModule] removeObserver:self];
    [self.mainWebViewController.view hideLoading];
    
    if (module.retCode.detailErrorDic) {
        
        [self.mainWebViewController showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self.mainWebViewController showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//加载图片回调用
- (void)sharedImageUrlLoadingFinished:(BOOL)status
{
    if (status) {
        
        [self.mainWebViewController.view showGifLoading];
    }else
    {
        [self.mainWebViewController.view hideLoading];
    }
}

//分享回调
- (NSDictionary *)SharedViewControllerDidReceiveSharedParamsWithKey:(SharedType)type
{
    NSDictionary * sharedDictionary = nil;
    if (self.sharedType == systemShared) {
        sharedDictionary = self.systemSharedDictionary;
    }else
    {
        sharedDictionary = self.webSharedDictionary;
    }
    
    NSString * title = [sharedDictionary objectForKey:XN_MYINFO_RECOMMEND_SHARCONTENT_TITLE];
    if (![NSObject isValidateObj:title]) {
        
        title = @"";
    }
    
    NSString* desc = [sharedDictionary objectForKey:XN_MYINFO_RECOMMEND_SHARCONTENT_DESC];
    if (![NSObject isValidateObj:desc]) {
        
        desc = @"";
    }
    
    NSString * iconImage = [sharedDictionary objectForKey:XN_MYINFO_RECOMMEND_SHARCONTENT_IMGURL];
    if (![NSObject isValidateObj:iconImage]) {
        
        iconImage = @"";
    }
    
    NSString * url = [sharedDictionary objectForKey:XN_MYINFO_RECOMMEND_SHARCONTENT_LINK];
    if (![NSObject isValidateObj:url]) {
        
        url = @"";
    }
    url = [_LOGIC getSharedUrlWithBaseUrl:url];
    
    switch (type) {
        case  WXFriend_SharedType:
        {
            return @{XN_WEIBO_PUBLIC_TITLE: title, XN_WEIBO_PUBLIC_CONTENT: desc, XN_WEIBO_PUBLIC_URL: url,XN_WEIBO_PUBLIC_ICON:iconImage};
        }
            break;
        case WXFriendArea_SharedType:
        {
            return @{XN_WEIBO_PUBLIC_TITLE: title, XN_WEIBO_PUBLIC_CONTENT: desc, XN_WEIBO_PUBLIC_URL: url,XN_WEIBO_PUBLIC_ICON:iconImage};
        }
            break;
        case QQ_SharedType:
        {
            return @{XN_WEIBO_PUBLIC_TITLE: title, XN_WEIBO_PUBLIC_CONTENT: desc, XN_WEIBO_PUBLIC_URL: url,XN_WEIBO_PUBLIC_ICON:iconImage};
        }
            break;
        case Copy_SharedType:
        {
            return @{XN_COPY_CONTENT:url};
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - 用户绑卡信息
- (void)XNMyInfoModulePeopleSettingDidReceive:(XNMyInformationModule *)module
{
    [self.mainWebViewController.view hideLoading];
    
    //已绑卡
    if ([[[XNMyInformationModule defaultModule] settingMode] bundBankCard])
    {
        //是否已绑定
        [[XNMyInformationModule defaultModule] isBindOrgAcct:self.productListItemMode.orgNumber];
        [self.mainWebViewController.view showGifLoading];
    }
    else
    {
        [self.mainWebViewController showCustomAlertViewWithTitle:@"为了您的资金安全，请先绑定银行卡" titleColor:[UIColor blackColor] titleFont:14 okTitle:@"确认" okTitleColor:[UIColor blackColor] okCompleteBlock:^{
            
            MIAddBankCardController *addBankCardCtrl = [[MIAddBankCardController alloc] initWithNibName:@"MIAddBankCardController" bundle:nil];
            [_LOGIC saveValueForKey:XN_USER_INIT_PAY_PASSWORD_CONTROLLER Value:@"UniversalInteractWebViewController"];
            [_UI pushViewControllerFromRoot:addBankCardCtrl animated:YES];
            
        } cancelTitle:@"取消" cancelCompleteBlock:^{
            
        } topPadding:20 textAlignment:NSTextAlignmentCenter];
    }
}

- (void)XNMyInfoModulePeopleSettingDidFailed:(XNMyInformationModule *)module
{
    [self.mainWebViewController.view hideLoading];
    
    if (module.retCode.detailErrorDic) {
        
        [self.mainWebViewController showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self.mainWebViewController showCustomWarnViewWithContent:module.retCode.errorMsg];
}

#pragma mark - 是否已绑定的机构
- (void)XNMyInfoModuleIsBindOrgAcctDidReceive:(XNMyInformationModule *)module
{
    [self.mainWebViewController.view hideLoading];
    //已经绑定了第三方平台
    if (module.isBindCurOrg)
    {
        //进入平台
        [[XNMyInformationModule defaultModule] requestOrgProductUrl:self.productListItemMode.orgNumber productId:self.productListItemMode.productId];
        [self.mainWebViewController.view showGifLoading];
    }
    else
    {
        //是否已经存在于第三方平台
        [[XNMyInformationModule defaultModule] isExistInPlatform:self.productListItemMode.orgNumber];
        [self.mainWebViewController.view showGifLoading];
    }
    
}

- (void)XNMyInfoModuleIsBindOrgAcctDidFailed:(XNMyInformationModule *)module
{
    [[XNMyInformationModule defaultModule] removeObserver:self];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    [self.mainWebViewController.view hideLoading];
    if (module.retCode.detailErrorDic)
    {
        [[UIApplication sharedApplication].keyWindow showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [[UIApplication sharedApplication].keyWindow showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

#pragma mark - 是否存在于第三方平台
- (void)XNMyInfoModuleIsExistInPlatformDidReceive:(XNMyInformationModule *)module
{
    [self.mainWebViewController.view hideLoading];
    //已经注册过第三方平台（非通过t呗绑定第三方平台）
    if (module.isExistForThirdOrg)
    {
        /*
         NSString *string = [NSString stringWithFormat:@"您是%@老用户，通过T呗投资不能享受红包等奖励，建议购买其他平台产品", self.productListItemMode.orgName];
         //弹出提示框
         [[UIApplication sharedApplication].keyWindow showCustomWarnViewWithContent:string];
         */
        
        NSString *titleString = [NSString stringWithFormat:@"您已有%@账号", self.productListItemMode.orgName];
        [PXAlertView xn_showCustomAlertWithTitle:titleString message:@"通过猎财大师投资不能享受佣金、津贴、红包等奖励，建议您购买其他平台产品。" cancelTitle:@"好的" otherTitle:nil completion:^(BOOL cancelled, NSInteger buttonIndex) {
            if (buttonIndex == 1)
            {
                MIAddBankCardController *addBankCardCtrl = [[MIAddBankCardController alloc] initWithNibName:@"MIAddBankCardController" bundle:nil];
                [_LOGIC saveValueForKey:XN_USER_INIT_PAY_PASSWORD_CONTROLLER Value:@"UniversalInteractWebViewController"];
                [_UI pushViewControllerFromRoot:addBankCardCtrl animated:YES];
            }
        }];
    }
    else
    {
        NSString *titleString = [NSString stringWithFormat:@"一键开通%@账户?", self.productListItemMode.orgName];
        [PXAlertView xn_showCustomAlertWithTitle:titleString message:@"开通后，将同步个人身份信息和联系方式" cancelTitle:@"取消" otherTitle:@"一键开通" completion:^(BOOL cancelled, NSInteger buttonIndex) {
            if (buttonIndex == 1)
            {
                //绑定平台帐号
                [[XNMyInformationModule defaultModule] bindPlatformAccount:self.productListItemMode.orgNumber];
                [self.mainWebViewController.view showGifLoading];
            }
        }];
    }
    
}

- (void)XNMyInfoModuleIsExistInPlatformDidFailed:(XNMyInformationModule *)module
{
    [[XNMyInformationModule defaultModule] removeObserver:self];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    [self.mainWebViewController.view hideLoading];
    
    if (module.retCode.detailErrorDic)
    {
        [[UIApplication sharedApplication].keyWindow showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [[UIApplication sharedApplication].keyWindow showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

#pragma mark - 绑定平台帐号
- (void)XNMyInfoModuleBindPlatformAccountDidReceive:(XNMyInformationModule *)module
{
    [self.mainWebViewController.view hideLoading];
    //进入平台的产品
    [[XNMyInformationModule defaultModule] requestOrgProductUrl:self.productListItemMode.orgNumber productId:self.productListItemMode.productId];
    [self.mainWebViewController.view showGifLoading];
}

- (void)XNMyInfoModuleBindPlatformAccountDidFailed:(XNMyInformationModule *)module
{
    [[XNMyInformationModule defaultModule] removeObserver:self];
    [self.mainWebViewController.view hideLoading];
    if (module.retCode.detailErrorDic)
    {
        [[UIApplication sharedApplication].keyWindow showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [[UIApplication sharedApplication].keyWindow showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

#pragma mark - 绑定完成机构-产品跳转地址
- (void)XNMyInfoModulePlatformProductUrlDidReceive:(XNMyInformationModule *)module
{
    [self.mainWebViewController.view hideLoading];
    [[XNMyInformationModule defaultModule] removeObserver:self];
    
    XNPlatformUserCenterOrProductMode *mode = module.platformProductMode;
    
    NSString *httpBody = [NSString stringWithFormat:@"orgAccount=%@&orgKey=%@&orgNumber=%@&requestFrom=%@&sign=%@&timestamp=%@&thirdProductId=%@&txId=%@", mode.orgAccount, mode.orgKey, mode.orgNumber, mode.requestFrom, mode.sign, mode.timestamp, mode.thirdProductId, mode.txId];
    
    //进入平台用户中心
    UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:mode.orgProductUrl httpBody:httpBody requestMethod:@"POST"];
    [webCtrl setIsEnterThirdPlatform:YES platformName:self.productListItemMode.orgName];
    [webCtrl.view setBackgroundColor:[UIColor whiteColor]];
    [_UI pushViewControllerFromHomeViewControllerForController:webCtrl hideNavigationBar:NO animated:YES];
}

- (void)XNMyInfoModulePlatformProductUrlDidFailed:(XNMyInformationModule *)module
{
    [self.mainWebViewController.view hideLoading];
    [[XNMyInformationModule defaultModule] removeObserver:self];
    if (module.retCode.detailErrorDic)
    {
        [[UIApplication sharedApplication].keyWindow showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [[UIApplication sharedApplication].keyWindow showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

//保险详情
- (void)XNFinancialManagerModuleInsuranceDetailDidReceive:(XNInsuranceModule *)module
{
    UniversalInteractWebViewController * interactWebViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:module.insuranceDetailMode.jumpInsuranceUrl requestMethod:@"GET"];
    
    //    [interactWebViewController setHidenThirdAgentHeaderElement:YES];
    
    [interactWebViewController setIsEnterThirdPlatform:YES platformName:@"慧择"];
    [interactWebViewController.view setBackgroundColor:[UIColor whiteColor]];
    
    [_UI pushViewControllerFromRoot:interactWebViewController animated:YES];
}

- (void)XNFinancialManagerModuleInsuranceDetailDidFailed:(XNInsuranceModule *)module
{
    if (module.retCode.detailErrorDic) {
        
        [[UIApplication sharedApplication].keyWindow showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else {
        
        [[UIApplication sharedApplication].keyWindow showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

#pragma mark - setter／getter

- (SharedViewController *)sharedCtrl
{
    if (!_sharedCtrl) {
        
        _sharedCtrl = [[SharedViewController alloc]init];
        _sharedCtrl.delegate = self;
    }
    return _sharedCtrl;
}

//保存系统分享信息字典
- (NSDictionary *)systemSharedDictionary
{
    if (!_systemSharedDictionary) {
        
        _systemSharedDictionary = [[NSDictionary alloc]init];
    }
    return _systemSharedDictionary;
}

//保存web分享信息字典
- (NSDictionary *)webSharedDictionary
{
    if (!_webSharedDictionary) {
        
        _webSharedDictionary = [[NSDictionary alloc]init];
    }
    return _webSharedDictionary;
}

- (RecommendViewController *)recommendVC
{
    if (!_recommendVC) {
        
        _recommendVC = [[RecommendViewController alloc] init];
        _recommendVC.proDelegate = self;
        _recommendVC.agentDelegate = nil;
        _recommendVC.signDelegate = nil;
        _recommendVC.shareTitle = @"选择推荐产品方式";
    }
    
    return _recommendVC;
}



@end
