//
//  XNGlobalNotificationHandler.m
//  FinancialManager
//
//  Created by xnkj on 06/01/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "AppGlobalHandler.h"

#import "IMManager.h"

#import "XNCommonModule.h"
#import "XNCommonModuleObserver.h"
#import "XNUserModule.h"
#import "XNUserInfo.h"
#import "XNUpgradeMode.h"
#import "XNHomeModule.h"
#import "XNCustomerServerModule.h"
#import "XNAccountModule.h"
#import "XNAddBankCardModule.h"
#import "XNAdViewModule.h"
#import "XNAdModuleObserver.h"
#import "XNLeiCaiModule.h"
#import "XNFinancialManagerModule.h"
#import "XNMyInformationModule.h"
#import "XNBundModule.h"
#import "XNInsuranceModule.h"

#import "AsynLoadManager.h"
#import "XNSetGesturePasswordViewController.h"

#define ENVIRONMENTSWITCH 111111

@interface AppGlobalHandler()<UIAlertViewDelegate,XNUserModuleObserver,XNCommonModuleObserver,XNAdModuleObserver,IMManagerDelegate>

@end

@implementation AppGlobalHandler

#pragma mark - 生命周期

- (id)init
{
    self = [super init];
    if (self) {
        
        self.adLoadingSuccess = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relogin:) name:XNUSERLOGINNOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserRelationData) name:XN_USER_LOGIN_SUCCESS_NOTIFICATINO object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSetGesture) name:XN_USER_LOGIN_SET_GESTURE_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:XNUSERBINDCARDSUCCESSNOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relogin:) name:XNUSERENTERMAININTERFACE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewData) name:XNUSERHXNILNOTIFICATION object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteNotification) name:XN_REMOTE_NOTIFICATION object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGesture) name:XN_SHOW_GESTURE_PASSWORD_NOTIFICTION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateToken) name:XN_UPDATE_TOKEN_NOTIFICATION object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRemindDot:) name:XN_APP_UNREAD_REDDOT_NOTIFICATION object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downCustomerList) name:XN_CFG_LIST_FINISHED_NOTIFICATION object:nil];
    }
    return self;
}

#pragma mark - 自定义方法

//重新登录处理
#pragma mark - 登入请求通知处理
- (void)relogin:(NSNotification *)notif
{
    //防治app未启动完毕显示登入
    if ([[_LOGIC getValueForKey:XN_USER_ENTER_MAIN_INTERFACE] isEqualToString:@"1"])
    {
        if (!self.isSwitchingViewController && [[_LOGIC getValueForKey:XN_USER_USER_TOKEN_EXPIRED] isEqualToString:@"1"] &&!_UI.modellingOperation) {
            
            self.isSwitchingViewController = YES;
            [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"0"];
            
            //将uiwindow类型的试图给移除掉
            [self removePopupView];
            
            UseLoginViewController * useLoginCtrl = [[UseLoginViewController alloc]initWithNibName:@"UseLoginViewController" bundle:nil];
            
            if ([_UI isExistModeControllerShow:@"UseLoginViewController"]) {
                
                self.isSwitchingViewController = NO;
            }else
            {
                //如果存在解锁界面，则先关闭解锁界面
                if ([_UI isExistModeControllerShow:@"_TtC16FinancialManager35MIUnlockPasswordContainerController"] || [_UI isExistModeControllerShow:@"XNSetGesturePasswordViewController"])
                {
                    [_UI dismissNaviModalViewCtrlAnimated:YES completion:^{
                        
                        if ([notif.object integerValue] == ForgetGesturePasswordSource || [[_LOGIC getValueForKey:XN_USER_GESTURE_INPUT_ERROR_COUNT_TAG] integerValue] <= 0) {
                            
                            useLoginCtrl.canReSetGesture = YES;
                        }else
                            useLoginCtrl.canReSetGesture = NO;
                        
                        [_UI presentNaviModalViewCtrl:useLoginCtrl animated:YES NavigationController:YES hideNavigationBar:YES completion:^{
                            
                        }];
                    }];
                }else
                {
                    if ([notif.object integerValue] == ForgetGesturePasswordSource || [[_LOGIC getValueForKey:XN_USER_GESTURE_INPUT_ERROR_COUNT_TAG] integerValue] <= 0) {
                        
                        useLoginCtrl.canReSetGesture = YES;
                    }else
                        useLoginCtrl.canReSetGesture = NO;
                    
                    //针对一些keywindow对象一直显示到视图上
                    [self removePopupView];
                    
                    [_UI presentNaviModalViewCtrl:useLoginCtrl animated:YES NavigationController:YES hideNavigationBar:YES completion:^{
                    }];
                }
                
                self.isSwitchingViewController = NO;
            }
        }
    }
}

//启动加载的接口处理
- (void)loadData
{
    if (![_LOGIC isExitDirectory:XN_LIBRARY_COMMON_DIRECTORY])
    {
        [_LOGIC createXNCommonDirectoryAtPath:XN_LIBRARY_COMMON_DIRECTORY];
        
        //开始往文件夹中写入本地数据
        NSString * path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"json"];
        NSData * data = [[NSData alloc]initWithContentsOfFile:path];
        
        NSError * error = nil;
        [_LOGIC saveDataDictionary:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error] intoFileName:@"config.plist"];
    }
    
    [[XNCommonModule defaultModule] removeObserver:self];
    [[XNCommonModule defaultModule] addObserver:self];
    
    [[XNCommonModule defaultModule] checkAppUpgrade];
    [[XNCommonModule defaultModule] requestConfigInfo];
    [[XNBundModule defaultModule] requestBundTypeSelector];
    
    //查看是否需要更换节日图片
    [[XNCommonModule defaultModule] request_App_SysConfig_ConfigKey:@"switch_config" configType:@"lcs_app_skin_config"];
    
    
    // 程序启动时请求保险种类
    [[XNInsuranceModule defaultModule] removeObserver:self];
    [[XNInsuranceModule defaultModule] addObserver:self];
    [[XNInsuranceModule defaultModule] request_insurance_category];
    
    
    //当token存在的时候，app启动进行及时加载
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if ([NSObject isValidateInitString:token]) {
        
        [[XNUserModule defaultModule] removeObserver:self];
        [[XNUserModule defaultModule] addObserver:self];
        
        [[XNUserModule defaultModule] requestUserInfo];
        [[XNMyInformationModule defaultModule] requestMySettingInfo];
        [[XNAddBankCardModule defaultModule] getUserBindBankCardInfo];
        
        [[XNInsuranceModule defaultModule] requestInsuranceOrderListLink];
        
        //加载推广海报类型
        [[XNLeiCaiModule defaultModule] removeObserver:self];
        [[XNLeiCaiModule defaultModule] addObserver:self];
        [[XNLeiCaiModule defaultModule] request_Liecai_User_BrandPosters];
        
    }
   
    //加载广告
    [self loadAd];
}

//需要登录态的更新数据
- (void)refreshUserRelationData
{
    [[XNCommonModule defaultModule] removeObserver:self];
    [[XNCommonModule defaultModule] addObserver:self];
    [[XNCommonModule defaultModule] requestConfigInfo];
    [[XNCommonModule defaultModule] checkAppUpgrade];
    
    [[XNUserModule defaultModule] removeObserver:self];
    [[XNUserModule defaultModule] addObserver:self];
    [[XNUserModule defaultModule] requestUserInfo];
    
    [[XNMyInformationModule defaultModule] requestMySettingInfo];
    [[XNAddBankCardModule defaultModule] getUserBindBankCardInfo];
    [[XNInsuranceModule defaultModule] requestInsuranceOrderListLink];
    
    //开始执行数据库的插入操作
    [[AsynLoadManager defaultAsynLoadManager] loadCfgList];

    //加载推广海报类型
    [[XNLeiCaiModule defaultModule] removeObserver:self];
    [[XNLeiCaiModule defaultModule] addObserver:self];
    [[XNLeiCaiModule defaultModule] request_Liecai_User_BrandPosters];
}

//需要每次进来从新加载的数据
- (void)refreshNewData
{
    [[XNCommonModule defaultModule] removeObserver:self];
    [[XNCommonModule defaultModule] addObserver:self];
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if ([NSObject isValidateInitString:token]) {
        
        [[XNUserModule defaultModule] removeObserver:self];
        [[XNUserModule defaultModule] addObserver:self];
        [[XNUserModule defaultModule] requestUserInfo];
       
        [[XNMyInformationModule defaultModule] requestMySettingInfo];
        [[XNAddBankCardModule defaultModule] getUserBindBankCardInfo];
        [[XNInsuranceModule defaultModule] requestInsuranceOrderListLink];
    }
    
    [[XNCommonModule defaultModule] checkAppUpgrade];
    

}

//加载广告
- (void)loadAd
{
    NSDictionary * openAdvisementDictionary = [_LOGIC readDicDataFromFileName:@"openAdvertisement.plist"];
    
    self.adLoadingSuccess = NO;
    if ([NSObject isValidateObj:openAdvisementDictionary] && [[openAdvisementDictionary objectForKey:@"datas"] count] > 0 && [NSObject isValidateObj:[_LOGIC getImageFromLocalBox:@"openAdImage.png"]]) {
        
        self.adLoadingSuccess = YES;
    }
    
    [[XNAdViewModule defaultModule] removeObserver:self];
    [[XNAdViewModule defaultModule] addObserver:self];
    [[XNAdViewModule defaultModule] requestAppAdvertisementWithAppType:@"" advType:@"app_opening"];
}

//设置手势密码
- (void)userSetGesture
{
    XNSetGesturePasswordViewController * setGestureCtrl = [[XNSetGesturePasswordViewController alloc]init];
    
    [_UI presentNaviModalViewCtrl:setGestureCtrl animated:!([_LOGIC integerForKey:XN_USER_FINGER_PASSWORD_SET] ==1) NavigationController:NO completion:nil];
}

//绑卡成功
- (void)paySuccess
{
    [[XNMyInformationModule defaultModule] requestMySettingInfo];
}

//跳转到对应的通知页面（远程推送）
- (void)remoteNotification
{
    if (self.isHasRemoteUserInfo)
    {
        [_CORE application:[UIApplication sharedApplication] didReceiveRemoteNotification:self.remoteUserInfoDictionary];
    }
}

//显示手势密码
- (void)showGesture
{
    if ([NSObject isValidateObj:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]] && [NSObject isValidateInitString:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]] && [[_LOGIC getValueForKey:XN_USER_GESTURE_INPUT_ERROR_COUNT_TAG] integerValue] > 0 && ![_UI isExistModeControllerShow:@"_TtC16FinancialManager35MIUnlockPasswordContainerController"]) {
        
        MIUnlockPasswordContainerController * setGestureCtrl = [[MIUnlockPasswordContainerController alloc]initWithNibName:@"MIUnlockPasswordContainerController" bundle:nil];
        
        [_UI presentNaviModalViewCtrl:setGestureCtrl animated:YES NavigationController:YES hideNavigationBar:YES navigationBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6] modalPresentationStyle:UIModalPresentationOverCurrentContext completion:^{
            
        }];
        
    }else if([NSObject isValidateObj:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]] && [NSObject isValidateInitString:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]] && [[_LOGIC getValueForKey:XN_USER_GESTURE_INPUT_ERROR_COUNT_TAG] integerValue] <= 0 && ![_UI isExistModeControllerShow:@"UseLoginViewController"])
    {
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
    }
}

//更新token
- (void)updateToken
{
    //更新token
    [[XNUserModule defaultModule] userGestureLogin];
}

//更新tab中是否存在红点
- (void)updateRemindDot:(NSNotification *)notif
{
    NSDictionary * userInfo = notif.object;
    
    if ([[userInfo objectForKey:@"showDot"] boolValue]) {
        
        [_UI addNormalRemindDot:@"btn_lc_redDot_normal.png" selectedDotImageName:@"btn_lc_redDot.png" atIndex:[[userInfo objectForKey:@"index"] integerValue]];
    }else
    {
        [_UI replaceRemindDotAtIndex:[[userInfo objectForKey:@"index"] integerValue] withNormalImageName:@"btn_lc_unselected.png" selectedImageName:@"btn_lc_selected.png"];
    }
}

//启动完成,可以立即后去未读的消息等
- (void)launch
{

}

//移除上层图
- (void)removePopupView
{
    if (self.currentPopup)
    {
       [self.currentPopup removeFromSuperview];
       self.currentPopup = nil;
    }
}

//移除上层控制器
- (void)removePopupCtrl
{
    if (self.currentPopupCtrl) {
        
        [self.currentPopupCtrl.view removeFromSuperview];
        self.currentPopupCtrl = nil;
    }
}

//下载客户列表
- (void)downCustomerList
{
    [[AsynLoadManager defaultAsynLoadManager] loadCustomerList];
}

#pragma mark - 协议实现

//判断是否需要升级
- (void)XNCommonModuleUpgradeDidReceive:(XNCommonModule *)module
{
    NSInteger type =  [module.upgradeMode.upgradeType integerValue];
    
    switch (type) {
        case NoNeedUpgrade:
        {
            //获取首页弹出窗
            NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
            if ([NSObject isValidateInitString:token]) {
             
               [[XNCommonModule defaultModule] requestHomeRemindInfo];
            }
            
            [[XNCommonModule defaultModule] requestHomeWithPopAdv];
        }
            break;
        case RemindToUpgrade: //提示升级
        {
        
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[XNCommonModule defaultModule].upgradeMode.updateTitle message:[XNCommonModule defaultModule].upgradeMode.updateContent delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            alertView.tag = RemindToUpgrade;
            [alertView show];
            
//            CGSize size = [[XNCommonModule defaultModule].upgradeMode.updateContent sizeOfStringWithFont:15 InRect:CGSizeMake(alertView.size.width - 24, 1000)];
//
//            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,size.width, size.height + 12)];
//            textLabel.font = [UIFont systemFontOfSize:15];
//            textLabel.textColor = [UIColor blackColor];
//            textLabel.backgroundColor = [UIColor clearColor];
//            textLabel.lineBreakMode =NSLineBreakByWordWrapping;
//            textLabel.numberOfLines =0;
//            textLabel.textAlignment =NSTextAlignmentLeft;
//
//            NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:[XNCommonModule defaultModule].upgradeMode.updateContent];
//
//            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//            [paragraphStyle setLineSpacing:2.0];
//            //段落间距
//            [paragraphStyle setParagraphSpacing:4.0];
//            //第一行头缩进
//            [paragraphStyle setFirstLineHeadIndent:20];
//            [paragraphStyle setHeadIndent:20];
//            [paragraphStyle setTailIndent:-10];
//
//            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [XNCommonModule defaultModule].upgradeMode.updateContent.length)];
//            [textLabel setAttributedText:attributedString];
            
//            CGFloat labelX = 0.f;
//            CGFloat labelY = 0.f;
//            CGFloat labelH = [XNCommonModule defaultModule].upgradeMode.updateContent.length;
//            CGFloat labelW = alertView.frame.size.width;
//            textLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
//
//            [alertView setValue:textLabel forKey:@"accessoryView"];
//
////            alertView.frame = CGRectMake(0.f, 0.f, 300, 500);
//
//            alertView.message = @"";
            
         
            
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            /***
            NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:[XNCommonModule defaultModule].upgradeMode.updateContent];
            
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            
            [paragraphStyle setLineSpacing:2.0];
            //段落间距
            [paragraphStyle setParagraphSpacing:4.0];
            //第一行头缩进
            [paragraphStyle setFirstLineHeadIndent:20];
            
            [paragraphStyle setHeadIndent:20];
            [paragraphStyle setTailIndent:-10];
            
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [XNCommonModule defaultModule].upgradeMode.updateContent.length)];
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[XNCommonModule defaultModule].upgradeMode.updateTitle message:[attributedString string] preferredStyle:UIAlertControllerStyleAlert];
            
            //attributedMessage
            NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:[XNCommonModule defaultModule].upgradeMode.updateContent];
            
            [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:NSMakeRange(0, [[hogan string] length])];
            [hogan addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [[hogan string] length])];
            [alertVC setValue:hogan forKey:@"attributedMessage"];
            
            
            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            
            [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[[XNCommonModule defaultModule] upgradeMode] downloadUrl]]];
            }]];
            
            [_UI.currentViewCtrl presentViewController:alertVC animated:YES completion:nil];
            **/
            
        }
            break;
        case ForceToUpgrade:  //强制升级
        {
          
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[XNCommonModule defaultModule].upgradeMode.updateTitle message:[XNCommonModule defaultModule].upgradeMode.updateContent delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            alertView.tag = ForceToUpgrade;
            [alertView show];
            
//            CGSize size = [[XNCommonModule defaultModule].upgradeMode.updateContent sizeOfStringWithFont:15 InRect:CGSizeMake(alertView.size.width - 24, 1000)];
//
//            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,size.width, size.height + 12)];
//            textLabel.font = [UIFont systemFontOfSize:15];
//            textLabel.textColor = [UIColor blackColor];
//            textLabel.backgroundColor = [UIColor clearColor];
//            textLabel.lineBreakMode =NSLineBreakByWordWrapping;
//            textLabel.numberOfLines =0;
//            textLabel.textAlignment =NSTextAlignmentLeft;
//
//            NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:[XNCommonModule defaultModule].upgradeMode.updateContent];
//
//            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//
//            [paragraphStyle setLineSpacing:2.0];
//            //段落间距
//            [paragraphStyle setParagraphSpacing:4.0];
//            //第一行头缩进
//            [paragraphStyle setFirstLineHeadIndent:20];
//
//            [paragraphStyle setHeadIndent:20];
//            [paragraphStyle setTailIndent:-10];
//
//            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [XNCommonModule defaultModule].upgradeMode.updateContent.length)];
//
//
//            [textLabel setAttributedText:attributedString];
//            [alertView setValue:textLabel forKey:@"accessoryView"];
//
//            alertView.message =@"";
            
//            alertView.tag = ForceToUpgrade;
//            [alertView show];
        
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            
              /***
            NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:[XNCommonModule defaultModule].upgradeMode.updateContent];
            
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            
            [paragraphStyle setLineSpacing:2.0];
            //段落间距
            [paragraphStyle setParagraphSpacing:4.0];
            //第一行头缩进
            [paragraphStyle setFirstLineHeadIndent:20];
            
            [paragraphStyle setHeadIndent:20];
            [paragraphStyle setTailIndent:-10];
            
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [XNCommonModule defaultModule].upgradeMode.updateContent.length)];
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[XNCommonModule defaultModule].upgradeMode.updateTitle message:[attributedString string] preferredStyle:UIAlertControllerStyleAlert];
            
            //attributedMessage
            NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:[XNCommonModule defaultModule].upgradeMode.updateContent];
            [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:NSMakeRange(0, [[hogan string] length])];
            [hogan addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [[hogan string] length])];
            [alertVC setValue:hogan forKey:@"attributedMessage"];
            
            [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[[XNCommonModule defaultModule] upgradeMode] downloadUrl]]];
            }]];
            
            [_UI presentNaviModalViewCtrl:alertVC animated:YES];
        
               **/
            
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
        }
            break;
        default:
            break;
    }
}

- (void)XNCommonModuleUpgradeDidFailed:(XNCommonModule *)module
{
    //开始获取bug日志
    [[XNCommonModule defaultModule] userGetPatch];
}

//UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == RemindToUpgrade) {
        
        if (buttonIndex == 0) {
            //获取首页弹出窗
            [[XNCommonModule defaultModule] requestHomeWithPopAdv];
            
        }else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[[XNCommonModule defaultModule] upgradeMode] downloadUrl]]];
        }
    
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[[XNCommonModule defaultModule] upgradeMode] downloadUrl]]];
    }
}

//广告回调
- (void)XNAdModuleDidGetAdSuccess:(XNAdViewModule *)module
{
    [[XNAdViewModule defaultModule] removeObserver:self];
}

- (void)XNAdModuleDidGetAdFailed:(XNAdViewModule *)module
{
    [[XNAdViewModule defaultModule] removeObserver:self];
}

//用户信息回调
- (void)XNUserModuleUserInfoDidReceive:(XNUserModule *)module
{
    [[XNUserModule defaultModule] removeObserver:self];
    
    [[IMManager defaultIMManager] imManagerLogout];
    [[IMManager defaultIMManager] imManagerLoginWithAccount:[[[XNUserModule defaultModule] userMode] easemobAccount] password:[[[XNUserModule defaultModule] userMode] easemobPassword]];
}

//环信账号登入
- (void)iMManagerDidLoginStatus:(BOOL)success
{
    [[IMManager defaultIMManager] setDelegate:nil];
    if (success)
    {
    }
}
@end
