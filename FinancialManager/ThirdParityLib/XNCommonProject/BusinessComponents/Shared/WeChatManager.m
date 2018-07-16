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
#import "UIImage+Common.h"

@interface WeChatManager () <WXApiDelegate> {
    enum WXScene _scene;
}

@end

@implementation WeChatManager

- (id)init {
    self = [super init];
    if (self) {
        _scene = WXSceneSession;
        [WXApi registerApp:XN_WX_SHARED_APP_ID withDescription:XN_WX_DESCRIPTION_CONTENT];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationHandleOpenURL:) name:WXAPPLICATIONHANDLEOPENURLNOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationOpenURL:) name:WXAPPLICATIONOPENURLNOTIFICATION object:nil];
    }
    
    return self;
}

+ (WeChatManager *)sharedManager {
    static dispatch_once_t once;
    static WeChatManager *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[WeChatManager alloc] init];
    });
    
    return sharedView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/////////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////////

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
    
    if ([NSObject isValidateInitString:imageUrl]) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(weChatSharedImageLoadingStatus:)])
        [self.delegate weChatSharedImageLoadingStatus:YES];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSString * imgUrl = @"";
            
            if ([imageUrl hasPrefix:@"http"]) {
                
                imgUrl = imageUrl;
            }else
            {
                imgUrl = [_LOGIC getImagePathUrlWithBaseUrl:imageUrl];
            }
            
            UIImage *desImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
            
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

//单独分享一张图片
- (void)sendImage:(UIImage *)image atScene:(int)scene
{
     _scene = scene;
    
    WXMediaMessage *message = [WXMediaMessage message];
    UIImage * thumbImage = [image imageWithSize:CGSizeMake(320, 320)];
    [message setThumbImage:thumbImage];

    WXImageObject *imageObj = [WXImageObject object];
    imageObj.imageData = UIImagePNGRepresentation(image);
    message.mediaObject =  imageObj;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    req.type = scene;

    [WXApi sendReq:req];
}

- (BOOL)applicationHandleOpenURL:(NSNotification *)notification
{
    return  [WXApi handleOpenURL:notification.object delegate:[WeChatManager sharedManager]];
}

- (BOOL)applicationOpenURL:(NSNotification *)notification
{
    return  [WXApi handleOpenURL:notification.object delegate:[WeChatManager sharedManager]];
}

/////////////////////
#pragma mark - Protocal -- WXApiDelegate
//////////////////////////////////////////

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Sign_Share_Succeed object:nil];
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


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

@end
