//
//  QQManager.m
//  CFGApp
//
//  Created by LiaoChangping on 7/17/14.
//  Copyright (c) 2014 jinfuzi. All rights reserved.
//

#import "QQManager.h"
#import "SharedConstDefine.h"

@interface QQManager()<QQApiInterfaceDelegate>
{
    TencentOAuth * _oauth;
}

@end

@implementation QQManager

+ (id)sharedInstance
{
    static dispatch_once_t once;
    static QQManager *instance;
    dispatch_once(&once, ^ {
        instance = [[QQManager alloc] init];
    });
    
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _oauth = [[TencentOAuth alloc] initWithAppId:XN_QQ_SHARED_APP_ID andDelegate:self];
        _oauth.redirectURI = @"www.qq.com";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationOpenURL:) name:WXAPPLICATIONOPENURLNOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationHandleOpenURL:) name:WXAPPLICATIONHANDLEOPENURLNOTIFICATION object:nil];
    }
    
    return self;
}

/*
 *bref 判断是否安装了qq
 *return yes/no
 */
+ (BOOL)isInstalledQQ
{
    if(![TencentOAuth iphoneQQInstalled])
    {
        return NO;
    }else
    {
        return YES;
    }
    
    return NO;
}

/*
 *bref qq登入
 *permission 允许第三方应用使用的权限
 *Safair 是否可以在浏览器中进行登入
 *return YES/NO
 */
- (void)qqLoginWithPermission:(NSArray *)arr_Permission Safair:(BOOL)isSafair
{
    [_oauth authorize:arr_Permission inSafari:isSafair];
}

/*
 *bref 分享纯文本
 *param str_Text 需要发送的文本内容
 */
- (QQApiSendResultCode)sendText:(NSString *)str_Text
{
    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:str_Text];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    return sent;
}

/*
 *bref 分享新闻
 *params str_url 分享的url
 *       str_title 分享的标题
 *       str_description 分享描述
 *       str_urlImage 分享的图片链接
 */
- (QQApiSendResultCode)sendTitle:(NSString *)str_Title Description:(NSString *)str_Description Url:(NSString *)str_Url ImageUrl:(NSString *)str_UrlImage
{
    NSString *utf8String = [str_Url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//注意：对于含有中文的链接，由于qq没有对其进行编码，但是url只支持26个英文字母，数字和少数几个特殊字符
    NSString *title = str_Title;
    NSString *description = str_Description;
    NSString *previewImageUrl = str_UrlImage;

    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:utf8String]
                                title:title
                                description:description
                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    return sent;
}

/*
 *bref 分享图片
 *params image 分享的图片 给QQ好友 到QQ朋友圈
 */
- (void)sendImage:(UIImage *)img withFlag:(BOOL)flag
{
    if (img == nil) {
        
        return;
    }
    
    //QQ 分享图片不超过 1M ，没有压缩的必要
    NSData *data = UIImagePNGRepresentation(img);
    
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:data
                                               previewImageData:data
                                                          title:@"我的投资组合"
                                                    description:nil];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    
    if (flag) {
        QQApiSendResultCode code = [QQApiInterface sendReq:req];
        NSLog(@"code = %d", code);
    } else {
        //分享空间
        [QQApiInterface SendReqToQZone:req];
    }
}

/*
 *bref qq加群
 *params str_GroupName
 */
- (QQApiSendResultCode)addNewGroupNumber:(NSString *)str_GroupName
{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external",str_GroupName,kTCWBAppKey];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    else return NO;
}

- (NSString *)qqUrl {
    return [QQApiInterface getQQInstallUrl];
}

- (BOOL)applicationHandleOpenURL:(NSNotification *)notification
{
    return  [QQApiInterface handleOpenURL:notification.object delegate:self];
}

- (BOOL)applicationOpenURL:(NSNotification *)notification
{
    return  [QQApiInterface handleOpenURL:notification.object delegate:self];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// 协议实现汇总
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////
#pragma mark- 分享回调
///////////////////////////
- (void)onResp:(QQBaseResp *)resp
{
    NSString *strMessage = ([resp.result isEqualToString:@"0"]) ? @"分享成功" : @"分享失败";
    
    if ([resp.result isEqualToString:@"0"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Sign_Share_Succeed object:nil];
    }
    

    if (![resp.result isEqualToString:@"-4"]) {
        
        UIWindow *keyWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
        [keyWindow showCustomWarnViewWithContent:strMessage];
        
        return;
    }

    strMessage = @"分享失败";
    UIWindow *keyWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [keyWindow showCustomWarnViewWithContent:strMessage];
}

@end
