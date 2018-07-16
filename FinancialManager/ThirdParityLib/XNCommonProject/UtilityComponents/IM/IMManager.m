//
//  IMManager.m
//  FinancialManager
//
//  Created by xnkj on 15/12/9.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "IMManager.h"
#import "IMManagerNotificationDefine.h"
#import "ConvertToCommonEmoticonsHelper.h"

@implementation IMManager

#pragma mark - 生命周期

- (id)init
{
    self = [super init];
    if (self) {
        [[[EMClient sharedClient] chatManager] addDelegate:self delegateQueue:nil];
    }
    return self;
}

+ (instancetype)defaultIMManager
{
    static IMManager *_iMManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _iMManager = [[IMManager alloc] init];
    });
    
    return _iMManager;
}

/**
 *   初始化环信
 *
 * params application uiapplication对象
 * params appKey 注册的环信appkey
 * params certName 证书名
 * params launchOptiona 启动的时候相关参数
 **/
- (void)initIManagerForApplication:(UIApplication *)application
                            AppKey:(NSString *)appKey
                      apnsCertName:(NSString *)certName LaunchOptions:(NSDictionary *)launchOptions
{
    EMOptions * options = [EMOptions optionsWithAppkey:appKey];
    options.apnsCertName = certName;
    options.usingHttpsOnly = YES;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [[EMClient sharedClient] updatePushOptionsToServer];
}

/**
 *   通知环信app进入后台
 *
 * params application uiapplication对象
 **/
- (void)imManagerDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

/**
 *   通知环信app进入前台
 *
 * params application uiapplication对象
 **/
- (void)imManagerWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

/**
 *  接收到推送消息
 *  
 *  params application
 *  params userInfo 推送内容
 *
 **/
- (void)IManagerForApplication:(UIApplication *)application
                 notificationInfo:(NSDictionary *)userInfo
{
    [[EMClient sharedClient] application:application
            didReceiveRemoteNotification:userInfo];
}

#pragma mark - 基础业务逻辑

/**
 *  绑定设备token
 * 
 * params token 设备返回的token
 * params application UIApplication 对象
 **/
- (void)imManagerUploadApplicationToken:(NSData *)token
                        FromApplication:(UIApplication *)application
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
         [[EMClient sharedClient] bindDeviceToken:token];
    });
}

/**
 *  设置apn的昵称
 *
 * params nikname 名字
 **/
- (void)imManagerSetAPNSNikName:(NSString *)nikname
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[EMClient sharedClient] setApnsNickname:nikname];
    });
}

/**
 *  用户登录
 *
 * params account 账户
 * params password 密码
 **/
- (void)imManagerLoginWithAccount:(NSString *)account
                         password:(NSString *)password
{
    if ([NSObject isValidateInitString:account] && [NSObject isValidateInitString:password])
    {
        self.isLoginingStatus = YES;
        
        weakSelf(weakSelf)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [[EMClient sharedClient] loginWithUsername:account password:password completion:^(NSString *aUsername, EMError *aError) {
                
                weakSelf.isLoginingStatus = NO;
                if ([NSObject isValidateObj:aError] || ![[EMClient sharedClient] isLoggedIn]) {
                    
                    [weakSelf imManagerLoginWithAccount:account password:password];
                }else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        [[EMClient sharedClient].options setIsAutoLogin:YES];
                        [[EMClient sharedClient] updatePushOptionsToServer];
                        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(iMManagerDidLoginStatus:)]) {
                            
                            [weakSelf.delegate iMManagerDidLoginStatus:true];
                        }
                    });
                }
            }];
        });
    }
}

/**
 *  用户注销
 **/
- (void)imManagerLogout
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [[EMClient sharedClient] logout:NO completion:^(EMError *aError) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                self.isLoginingStatus = NO;
            });
        }];
    });
}

/**
 *  是否连接到服务器
 *
 *  返回连接状态
 **/
- (BOOL)imManagerConnectStatus
{
    BOOL status = [[EMClient sharedClient] isConnected];
    return status;
}

/**
 *  是否登录
 *
 *  返回登录状态
 **/
- (BOOL)imManagerLoginStatus
{
    BOOL status = [[EMClient sharedClient] isLoggedIn];
    
    return status;
}

/**
 *  是否设置自动登录
 *
 *  返回登录状态
 **/
- (BOOL)imManagerIsSetAutoLogin
{
    BOOL isAutoLogin = [[EMClient sharedClient] isAutoLogin];
    return isAutoLogin;
}

/**
 *  发送文字消息（包括系统表情）
 *
 *  params content 发送的内容(包括系统表情）
 *  params conversationId 会话id
 *  params receiverId 接收消息的用户id
 *  params chatType 消息类型
 *  params ext 消息的附加信息
 **/
- (EMMessage *)imManagerSendContent:(NSString *)content
              conversationId:(NSString *)conversationId
                fromReceiver:(NSString *)receiverId
                    chatType:(EMChatType)chatType
                         ext:(NSDictionary *)ext
{
   return [self imManagerSendContentFormat:content
                      conversationId:conversationId
                        fromReceiver:receiverId
                            chatType:chatType
                                 ext:ext];
}

/**
 *  发送文字消息（包括系统表情）
 *
 *  params content 发送的内容(包括系统表情）
 *  params conversationId 会话id
 *  params receiverId 接收消息的用户id
 *  params chatType 消息类型
 *  params ext 消息的附加信息
 *
 *  返回消息对象
 **/
- (EMMessage *)imManagerSendContentFormat:(NSString *)content
                         conversationId:(NSString *)conversationId
                           fromReceiver:(NSString *)receiverId
                               chatType:(EMChatType)chatType
                                    ext:(NSDictionary *)ext
{
    //表情映射
    NSString *sendText = [ConvertToCommonEmoticonsHelper convertToCommonEmoticons:content];
    
    EMMessage * message = [self imManagerCreateMessageBodyForConversationId:conversationId
                                                        receiveId:receiverId
                                                           chatContent:sendText
                                                              chatType:chatType
                                                                   ext:ext];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[[EMClient sharedClient] chatManager] sendMessage:message
                                                  progress:nil
                                                completion:^(EMMessage *message, EMError *error) {
                                                   
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        JCLogInfo(@"发送文本消息成功!");
                                                    });
                                                    
                                                }];
    });
    
    return message;
}

/**
 *  创建消息对象
 *
 *  params conversationId 会话id
 *  params receiverId 接收消息的用户id
 *  params content 发送的内容(包括系统表情）
 *  params chatType 消息类型
 *  params ext 消息的附加信息
 *
 *  返回登录状态
 **/
- (EMMessage *)imManagerCreateMessageBodyForConversationId:(NSString *)conversationId
                                                 receiveId:(NSString *)receiveId
                                               chatContent:(NSString *)content
                                                  chatType:(EMChatType)chatType
                                                       ext:(NSDictionary *)ext
{
    EMTextMessageBody * body = [[EMTextMessageBody alloc] initWithText:content];
    
    NSString * from = [[EMClient sharedClient] currentUsername];
    
    EMMessage * message = [[EMMessage alloc] initWithConversationID:conversationId
                                                               from:from
                                                                 to:receiveId
                                                               body:body
                                                                ext:ext];
    message.chatType = chatType;
    
    return message;
}


/**
 *  发送图片
 *
 *  params image 发送图片
 *  params imageName 图片名
 *  params conversationId 会话id
 *  params receiverId  接受者id
 *  params chatType 消息类型
 *  params ext 消息的附加信息
 *
 *  返回消息对象
 **/
- (EMMessage *)imManagerSendImage:(UIImage *)image
                        iMageName:(NSString *)imageName
                   conversationId:(NSString *)conversationId
                     fromReceiver:(NSString *)receiverId
                         chatType:(EMChatType)chatType
                              ext:(NSDictionary *)ext
{
    EMImageMessageBody * body = [[EMImageMessageBody alloc] initWithData:UIImagePNGRepresentation(image)
                                                             displayName:imageName];
   
    NSString * from = [[EMClient sharedClient] currentUsername];
    
    EMMessage * message = [[EMMessage alloc] initWithConversationID:conversationId
                                                               from:from
                                                                 to:receiverId
                                                               body:body
                                                                ext:ext];
    message.chatType = chatType;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[[EMClient sharedClient] chatManager] sendMessage:message
                                                  progress:nil
                                                completion:^(EMMessage *message, EMError *error) {
                                                   
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                       JCLogInfo(@"发送图片消息成功!");
                                                    });
                                                }];
    });
    
    return message;
}

/**
 *  发送语音
 *
 *  params audio 语音数据
 *  params audioName 语音名
 *  params conversationId 会话id
 *  params receiverId  接受者id
 *  params chatType 消息类型
 *  params ext 消息的附加信息
 *
 *  返回消息对象
 **/
- (EMMessage *)imManagerSendAudioData:(NSData *)audio
                     audioName:(NSString *)audioName
                conversationId:(NSString *)conversationId
                  fromReceiver:(NSString *)receiverId
                      chatType:(EMChatType)chatType
                           ext:(NSDictionary *)ext
{
    EMVoiceMessageBody * body = [[EMVoiceMessageBody alloc]initWithData:audio displayName:audioName];
    
    NSString * from = [[EMClient sharedClient] currentUsername];
    
    EMMessage * message = [[EMMessage alloc] initWithConversationID:conversationId
                                                               from:from
                                                                 to:receiverId
                                                               body:body
                                                                ext:ext];
    message.chatType = chatType;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[[EMClient sharedClient] chatManager] sendMessage:message
                                                  progress:nil
                                                completion:^(EMMessage *message, EMError *error) {
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                       JCLogInfo(@"发送语音消息成功!");
                                                    });
                                                }];
    });

    
    
    return message;
}

/*!
 *  \~chinese
 *  下载消息附件（语音，视频，图片原图，文件），SDK会自动下载语音消息，所以除非自动下载语音失败，用户不需要自动下载语音附件
 *
 *  异步方法
 *
 *  @param aMessage            消息
 *  @param aProgressBlock      附件下载进度回调block
 *  @param aCompletion         下载完成回调block
 *
 *  \~english
 *  Download message attachment(voice, video, image or file), SDK downloads attachment automatically, no need to download attachment manually unless automatic download failed
 *
 *
 *  @param aMessage            Message instance
 *  @param aProgressBlock      The callback block of attachment download progress
 *  @param aCompletion         The callback block of download complete
 */

- (void)downloadIMMessage:(EMMessage *)message
                 progress:(void (^)(int))progressBlock
               completion:(void (^)(EMMessage *, EMError *))completionBlock
{
    [[[EMClient sharedClient] chatManager] downloadMessageAttachment:message
                                                            progress:progressBlock
                                                          completion:completionBlock];
}

/*!
 *  \~chinese
 *  下载缩略图（图片消息的缩略图或视频消息的第一帧图片），SDK会自动下载缩略图，所以除非自动下载失败，用户不需要自己下载缩略图
 *
 *  @param aMessage            消息
 *  @param aProgressBlock      附件下载进度回调block
 *  @param aCompletion         下载完成回调block
 *
 *  \~english
 *  Download message thumbnail (thumbnail of image message or first frame of video image), SDK downloads thumbails automatically, no need to download thumbail manually unless automatic download failed.
 *
 *  @param aMessage            Message instance
 *  @param aProgressBlock      The callback block of attachment download progress
 *  @param aCompletion         The callback block of download complete
 */
- (void)downloadIMMessageThumbnail:(EMMessage *)aMessage
                          progress:(void (^)(int))aProgressBlock
                        completion:(void (^)(EMMessage *, EMError *))aCompletionBlock
{

    [[[EMClient sharedClient] chatManager] downloadMessageThumbnail:aMessage
                                                           progress:aProgressBlock
                                                         completion:aCompletionBlock];
}

/**
 *  创建一个会话
 *
 *  params userId 会话id 默认使用 CONVERSATIONID
 *  params conversationType 会话类型
 *
 *  返回会话对象
 **/
- (EMConversation *)imManagerConversationForChatter:(NSString *)userId
                                   conversationType:(EMConversationType)conversationType
{
    EMConversation * conversation = [[[EMClient sharedClient] chatManager] getConversation:userId
                                                                          type:conversationType
                                                                          createIfNotExist:YES];
    return conversation;
}

/**
 *  删除会话
 *
 *  @param userId      会话ID
 *  @param isDeleteConversationMsg     是否删除会话中的消息
 *
 *  返回会话对象
 **/
- (void)imManagerDeleteConversationForChatter:(NSString *)userId
                      isDeleteConversationMsg:(BOOL)isDeleteConversationMsg
{
    [[[EMClient sharedClient] chatManager] deleteConversation:userId
                                             isDeleteMessages:isDeleteConversationMsg
                                                   completion:^(NSString *aConversationId, EMError *aError) {
                                                       
                                                   }];
}

/**
 *  保存会话到数据库中(DB)
 *
 *  @param conversation      会话数组
 *
 *  返回会话对象
 **/
- (void)imManagerInsertDBForConversation:(NSArray *)conversation
{
   [[[EMClient sharedClient] chatManager] importConversations:conversation completion:^(EMError *aError) {
       
   }];
}

/**
 *  获取会话列表
 *
 *  返回会话数组
 **/
- (NSArray *)imManagerGetConversationArray
{
    NSArray * conversations = [[[EMClient sharedClient] chatManager] getAllConversations];
    
    return conversations;
}


/**
 *  获取指定会话的指定数量的消息数组
 *
 *  prams conversation 会话对象
 *  prams msgCount 消息数
 *  prams complettion 回调block
 *
 *  返回会话数组
 **/
- (void)imManagerGetMessageForConversation:(EMConversation *)conversation
                              messageCount:(int)msgCount
                                completion:(void (^)(NSArray *aMessages, EMError *aError))completion
{
    [conversation loadMessagesStartFromId:@""
                                count:msgCount
                        searchDirection:EMMessageSearchDirectionUp
                            completion:^(NSArray *aMessages, EMError *aError) {
                                
                                //消息回调
                                completion(aMessages, aError);
                        }];
}

/**
 *  获取指定会话在指定时间断内的指定条数的消息
 *
 *  prams conversation 会话对象
 *  prams msgCount 消息数
 *  prams MsgId  msgid
 *  prams complettion 回调block
 *
 *  返回会话数组
 **/
- (void)imManagerGetMessageCount:(int)msgCount
                    FromConversation:(EMConversation *)conversation
                   FromMessageId:(NSString *)msgId
                          completion:(void (^)(NSArray *aMessages, EMError *aError))completion
{
    [conversation loadMessagesStartFromId:msgId
                                    count:msgCount
                          searchDirection:EMMessageSearchDirectionUp
                               completion:^(NSArray *aMessages, EMError *aError) {
                                   
                                   completion(aMessages,aError);
                               }];
}

/**
 *  获取未读的消息
 *
 *  params conversation 会话对象
 *
 **/
- (NSInteger)imManagerGetUnReadMessageForConversation:(EMConversation *)conversation
{
    NSInteger unReadMsgCount = [conversation unreadMessagesCount];
    
    return unReadMsgCount;
}

/**
 *  标记所有消息为已读
 *
 *  params conversation 会话对象
 *
 **/
- (void)imManagerMaskMesasgeReadedForConversation:(EMConversation *)conversation
{
    EMError * error = nil;
    [conversation markAllMessagesAsRead:&error];
}

#pragma mark - 业务回调

#pragma mark - 接收消息回调
- (void)messagesDidReceive:(NSArray *)aMessages
{
    //发送通知，改变导航栏图标
    [[NSNotificationCenter defaultCenter] postNotificationName:XN_UNREAD_SERVICE_MSG object:@"1"];
    
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    for (EMMessage * message  in aMessages) {
        
         [self resolveMessagBody:message];
        
        //处于后台运行
        if (state == UIApplicationStateBackground)
        {
            [self showNotificationMessage:message];
        }
    }
}

#pragma mark - 辅助函数

/**
 *  解析消息
 *
 *
 **/
- (void)resolveMessagBody:(EMMessage *)message
{
    EMMessageBody * msgBody = message.body;
    
    //通知有新的消息
    [[NSNotificationCenter defaultCenter] postNotificationName:IMManager_New_Message_Notification object:message];
    
    switch (msgBody.type) {
        case EMMessageBodyTypeText:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(iMManager:didReceiveTextContent:)]) {
                
                [self.delegate iMManager:self didReceiveTextContent:message];
            }
        }
            break;
        case EMMessageBodyTypeImage:
        {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(iMManager:didReceiveImageUrl:)]) {
                
                [self.delegate iMManager:self didReceiveImageUrl:message];
            }
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            
        }
            break;
        case EMMessageBodyTypeVideo:
        {
            
        }
            break;
        case EMMessageBodyTypeFile:
        {
            
        }
            break;
        default:
            break;
    }
}

/**
 *  组建本地通知消息
 *
 **/
- (void)showNotificationMessage:(EMMessage *)message
{
    EMMessageBody * msgBody = message.body;
    
    NSString *contentString = @"";
    
    switch (msgBody.type) {
        case EMMessageBodyTypeText:
        {
            EMTextMessageBody * textBody = (EMTextMessageBody *)msgBody;
            
            contentString = textBody.text;
        }
            break;
        case EMMessageBodyTypeImage:
        {
            
           contentString = @"发来一张图片";
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            
        }
            break;
        case EMMessageBodyTypeVideo:
        {
            
        }
            break;
        case EMMessageBodyTypeFile:
        {
            
        }
            break;
        default:
            break;
    }

    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date];
    notification.alertBody = [NSString stringWithFormat:@"%@：%@", message.from, contentString];
    notification.alertAction = @"Open";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@"contactCtmService" forKey:@"customUrlKey"];
    notification.userInfo = userInfo;
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];

}

@end
