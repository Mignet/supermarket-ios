//
//  CustomerChatManager.m
//  FinancialManager
//
//  Created by xnkj on 09/09/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "CustomerChatManager.h"
#import "CSIMViewController.h"

#import "IMManager.h"

#import "XNUserInfo.h"
#import "XNUserModule.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

@interface CustomerChatManager()<IMManagerDelegate>

@property (nonatomic, assign) BOOL isHXLogining;
@end

@implementation CustomerChatManager

+ (instancetype)defaultCustomerService
{
    static CustomerChatManager * defaultCustomerChatManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        defaultCustomerChatManager = [[CustomerChatManager alloc]init];
    });
    
    return defaultCustomerChatManager;
}

#pragma mark - 进行聊天
- (void)chat
{
    if ((![[IMManager defaultIMManager] imManagerLoginStatus] && ![[IMManager defaultIMManager] isLoginingStatus]) || ([[IMManager defaultIMManager] imManagerLoginStatus] && ![[IMManager defaultIMManager] imManagerConnectStatus])) {
        
        //如果账号和密码为空，重新拉取一遍
        if (![NSObject isValidateInitString:[[[XNUserModule defaultModule] userMode] easemobAccount]] || ![NSObject isValidateInitString:[[[XNUserModule defaultModule] userMode] easemobPassword]]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERHXNILNOTIFICATION object:nil];
            return;
        }
        
        [IMManager defaultIMManager].isLoginingStatus = YES;
        [[IMManager defaultIMManager] setDelegate:self];
        
        @try {
            
            [[IMManager defaultIMManager] imManagerLogout];
            [[IMManager defaultIMManager] imManagerLoginWithAccount:[[[XNUserModule defaultModule] userMode] easemobAccount] password:[[[XNUserModule defaultModule] userMode] easemobPassword]];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
        return;
    }
    
    NSString *serviceString = @"";
    if ([[[XNCommonModule defaultModule] configMode] kefuEasemobileName])
    {
        serviceString = [[[XNCommonModule defaultModule] configMode] kefuEasemobileName];
    }
    else
    {
        serviceString = [AppFramework getConfig].XN_SERVICE_EASEMOB_NAME;
    }
    
    EMConversation * conversation = [[IMManager defaultIMManager] imManagerConversationForChatter:serviceString conversationType:EMConversationTypeChat];
    
    CSIMViewController * imCtrl = [[CSIMViewController alloc]initWithNibName:@"CSIMViewController"
                                                                      bundle:nil
                                                                   titleName:@"客服"
                                                                conversation:conversation
                                                                enterService:YES
                                                                 chatAccount:serviceString
                                                                   themeName:XN_SERVICE_WORK_TIME
                                                            customerImageUrl:@""];
    [_UI pushViewControllerFromRoot:imCtrl animated:YES];
}

/////////////////////////
#pragma mark - protocol
///////////////////////////////////////////

#pragma mark - 环信账号登入
- (void)iMManagerDidLoginStatus:(BOOL)success
{
    [IMManager defaultIMManager].isLoginingStatus = NO;
    
    [[IMManager defaultIMManager] setDelegate:nil];
    if (success) {
        
    }
}
@end
