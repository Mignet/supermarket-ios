//
//  WeChatManager.m
//  GXQ
//
//  Created by GXQ on 13-11-4.
//
//

#import "WeChatManager.h"
#import "WXApi.h"
#import "SharedConstDefine.h"

@interface WeChatManager () <WXApiDelegate> {
    enum WXScene _scene;
}

@end

@implementation WeChatManager

+ (WeChatManager *)sharedManager {
    static dispatch_once_t once;
    static WeChatManager *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[WeChatManager alloc] init];
    });
    
    return sharedView;
}

+ (BOOL)isWeChatInstall {
    BOOL bInstalled = [WXApi isWXAppInstalled];
    BOOL bSupported = [WXApi isWXAppSupportApi];
    return bInstalled || bSupported;
}

+ (NSString *)weChatUrl {
    return [WXApi getWXAppInstallUrl];
}

- (BOOL)openWXApp
{
    return [WXApi openWXApp];
}

- (void)sendTextContent:(NSString *)text
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = text;
    req.bText = YES;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void)sendLinkWithTitle:(NSString *)title description:(NSString *)description image:(UIImage *)image link:(NSString *)url scene:(int)scene
{
    _scene = scene;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    req.type = scene;
    
    [WXApi sendReq:req];
}

- (void)sendLinkWithTitle:(NSString *)title description:(NSString *)description imageUrl:(NSString *)imageUrl link:(NSString *)url scene:(int)scene
{
    _scene = scene;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    if ([imageUrl hasPrefix:@"http"]) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(weChatSharedImageLoadingStatus:)])
        [self.delegate weChatSharedImageLoadingStatus:YES];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
             UIImage *desImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
            
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 if (self.delegate && [self.delegate respondsToSelector:@selector(weChatSharedImageLoadingStatus:)])
                     [self.delegate weChatSharedImageLoadingStatus:NO];
                 
                 [message setThumbImage:desImage];
                 
                 WXWebpageObject *ext = [WXWebpageObject object];
                 ext.webpageUrl = url;
                 
                 message.mediaObject = ext;
                 
                 SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                 req.bText = NO;
                 req.message = message;
                 req.scene = scene;
                 req.type = scene;
                 
                 [WXApi sendReq:req];
             });
        });
       
        return;
    }
    else {
       
        UIImage *desImage = [UIImage imageNamed:imageUrl];
        [message setThumbImage:desImage];
    
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = url;
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = scene;
        req.type = scene;
    
        [WXApi sendReq:req];
    }
}

- (id)init {
    self = [super init];
    if (self) {
        _scene = WXSceneSession;
        [WXApi registerApp:@"wx3a487af474002a23" withDescription:@"lhlcs"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationHandleOpenURL:) name:WXAPPLICATIONHANDLEOPENURLNOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationOpenURL:) name:WXAPPLICATIONOPENURLNOTIFICATION object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        id alert = [JFZModelView showAlertViewWithTitle:strTitle message:strMsg cancelButtonTitle:nil cancelBlock:^{
            
        } okButtonTitle:@"确认" okBlock:^{
            
        }];
        [_CORE observerPopup:alert];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
        
        id alert = [JFZModelView showAlertViewWithTitle:strTitle message:strMsg cancelButtonTitle:nil cancelBlock:^{
            
        } okButtonTitle:@"确认" okBlock:^{
            
        }];
        [_CORE observerPopup:alert];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        id alert = [JFZModelView showAlertViewWithTitle:strTitle message:strMsg cancelButtonTitle:nil cancelBlock:^{
            
        } okButtonTitle:@"确认" okBlock:^{
            
        }];
        [_CORE observerPopup:alert];
    }
}

-(void) onResp:(BaseResp*)resp
{
    NSString *strMessage = nil;
    if (resp.errCode == 0) {
        //分享成功
        if (_scene == WXSceneSession)
        {
            strMessage = @"分享成功";
        }
        else if (_scene == WXSceneTimeline)
        {
            strMessage = @"分享成功";
        }
        else
        {
            strMessage = @"分享成功";
        }
    }
    else if (resp.errCode == -2) {
        //取消分享
        if (_scene == WXSceneSession)
        {
            strMessage = @"分享失败";
        }
        else if (_scene == WXSceneTimeline)
        {
            strMessage = @"分享失败";
        } else
        {
            strMessage = @"分享失败";
        }
    }
    else {
        //分享失败
        if (_scene == WXSceneSession)
        {
            strMessage = @"分享失败";
        }
        else if (_scene == WXSceneTimeline) 
        {
            strMessage = @"分享失败";
        }
        else
        {
            strMessage = @"分享失败";
        }
    }
}

- (BOOL)applicationHandleOpenURL:(NSNotification *)notification
{
    return  [WXApi handleOpenURL:notification.object delegate:[WeChatManager sharedManager]];
}

- (BOOL)applicationOpenURL:(NSNotification *)notification
{
    return  [WXApi handleOpenURL:notification.object delegate:[WeChatManager sharedManager]];
}

@end
