//
//  QQManager.h
//  CFGApp
//
//  Created by LiaoChangping on 7/17/14.
//  Copyright (c) 2014 jinfuzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface QQManager : NSObject

+ (id)sharedInstance;

/*
 *bref 判断是否安装了qq
 *return yes/no
 */
+ (BOOL)isInstalledQQ;

/*
 *bref qq登入
 *permission 允许第三方应用使用的权限
 *Safair 是否可以在浏览器中进行登入
 *return YES/NO
 */
- (void)qqLoginWithPermission:(NSArray *)arr_Permission Safair:(BOOL)isSafair;

/*
 *bref 分享纯文本
 *param str_Text 需要发送的文本内容
 */
- (QQApiSendResultCode)sendText:(NSString *)str_Text;

/*
 *bref 分享新闻　
 *params str_url 分享的url 
 *       str_title 分享的标题
 *       str_description 分享描述
 *       str_urlImage 分享的图片链接
 */
- (QQApiSendResultCode)sendTitle:(NSString *)str_Title Description:(NSString *)str_Description Url:(NSString *)str_Url ImageUrl:(NSString *)str_UrlImage;

/*
 *bref 分享图片
 *params image 分享的图片
 */
- (void)sendImage:(UIImage *)img withFlag:(BOOL)flag;

/*
 *bref qq加群
 *params GroupNumber
 */
- (QQApiSendResultCode)addNewGroupNumber:(NSString *)str_GroupName;

/*
 *bref 获取qq安装路径 
 */
- (NSString *)qqUrl;



@end
