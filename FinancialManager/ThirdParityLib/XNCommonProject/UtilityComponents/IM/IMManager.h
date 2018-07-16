//
//  IMManager.h
//  FinancialManager
//
//  Created by xnkj on 15/12/9.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EMSDK.h"

@class IMManager;
@protocol IMManagerDelegate <NSObject>
@optional

- (void)iMManagerDidLoginStatus:(BOOL)success;

- (void)iMManager:(IMManager *)manager didReceiveTextContent:(EMMessage *)content;
- (void)iMManager:(IMManager *)manager didReceiveImageUrl:(EMMessage *)contentUrl;
- (void)iMManager:(IMManager *)manager didReceiveVoiceContent:(EMMessage *)content;
@end

@interface IMManager : NSObject<IEMChatManager>

@property (nonatomic, assign) id<IMManagerDelegate> delegate;
@property (nonatomic, assign) BOOL isLoginingStatus; //当前是否正登录中的状态
@property (nonatomic, assign) BOOL isLoginSuccess;//是否登录成

+ (instancetype)defaultIMManager;

#pragma mark -  环信生命周期 - Start
/**
 * 初始化SDK
 *
 * params application app对象
 * params AppKey 注册的appkey
 * params ApnsCertName 推送证书名字
 * params launchOptions 启动字典
 *
 **/
- (void)initIManagerForApplication:(UIApplication *)application
                            AppKey:(NSString *)appKey
                      apnsCertName:(NSString *)certName
                     LaunchOptions:(NSDictionary *)launchOptions;

/**
 * app进入后台，环信生命周期跟踪
 *
 * params application app对象
 *
 */
- (void)imManagerDidEnterBackground:(UIApplication *)application;

/**
 * app加药从后台返回，环信生命周期跟踪
 *
 * params application app对象
 *
 */
- (void)imManagerWillEnterForeground:(UIApplication *)application;

/**
 *  接收到推送消息
 *
 *  params application
 *  params userInfo 推送内容
 *
 **/
- (void)IManagerForApplication:(UIApplication *)application
              notificationInfo:(NSDictionary *)userInfo;

#pragma mark -  环信生命周期 - End

#pragma mark - 环信基本业务 - Start

/**
 * 上传token到sdk
 *
 * params application app应用
 * params token 设备唯一标识
 *
 **/
- (void)imManagerUploadApplicationToken:(NSData *)token
                        FromApplication:(UIApplication *)application;

/**
 * 设置环信apns昵称
 *
 * params nikname 昵称
 *
 **/
- (void)imManagerSetAPNSNikName:(NSString *)nikname;

/**
 * 客户端登入(异步)
 *
 * params account 账号
 * params password 密码
 * result 返回是否登入成功
 *
 **/
- (void)imManagerLoginWithAccount:(NSString *)account
                         password:(NSString *)password;

/**
 * 退出当前登入账户
 *
 *
 **/
- (void)imManagerLogout;

/**
 * 是否登入
 * */
- (BOOL)imManagerLoginStatus;

/**
 * 是否连接到服务器
 **/
- (BOOL)imManagerConnectStatus;

/**
 * 是否设置自动登入
 **/
- (BOOL)imManagerIsSetAutoLogin;


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
                         ext:(NSDictionary *)ext;

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
                                      ext:(NSDictionary *)ext;

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
                                                       ext:(NSDictionary *)ext;

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
                              ext:(NSDictionary *)ext;

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
                                  ext:(NSDictionary *)ext;

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
               completion:(void (^)(EMMessage *, EMError *))completionBlock;

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
                        completion:(void (^)(EMMessage *, EMError *))aCompletionBlock;

/**
 *  创建一个会话
 *
 *  params userId 会话id 默认使用 CONVERSATIONID
 *  params conversationType 会话类型
 *
 *  返回会话对象
 **/
- (EMConversation *)imManagerConversationForChatter:(NSString *)userId
                                   conversationType:(EMConversationType)conversationType;

/**
 *  删除会话
 *
 *  @param userId      会话ID
 *  @param isDeleteConversationMsg     是否删除会话中的消息
 *
 *  返回会话对象
 **/
- (void)imManagerDeleteConversationForChatter:(NSString *)userId
                      isDeleteConversationMsg:(BOOL)isDeleteConversationMsg;

/**
 *  保存会话到数据库中(DB)
 *
 *  @param conversation      会话数组
 *
 *  返回会话对象
 **/
- (void)imManagerInsertDBForConversation:(NSArray *)conversation;

/**
 *  获取会话列表
 *
 *  返回会话数组
 **/
- (NSArray *)imManagerGetConversationArray;

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
                                completion:(void (^)(NSArray *aMessages, EMError *aError))completion;

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
                      completion:(void (^)(NSArray *aMessages, EMError *aError))completion;

/**
 *  获取未读的消息
 *
 *  params conversation 会话对象
 *
 **/
- (NSInteger)imManagerGetUnReadMessageForConversation:(EMConversation *)conversation;

/**
 *  标记所有消息为已读
 *
 *  params conversation 会话对象
 *
 **/
- (void)imManagerMaskMesasgeReadedForConversation:(EMConversation *)conversation;

#pragma mark - 环信基本业务 - End
@end
