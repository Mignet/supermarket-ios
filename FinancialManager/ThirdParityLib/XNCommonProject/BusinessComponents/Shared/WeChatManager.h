//
//  WeChatManager.h
//  GXQ
//
//  Created by GXQ on 13-11-4.
//
//

#import <Foundation/Foundation.h>

@protocol WeChatManagerDelegate <NSObject>
@optional

- (void)weChatSharedImageLoadingStatus:(BOOL)status;
@end

@interface WeChatManager : NSObject

@property (nonatomic, assign) id<WeChatManagerDelegate> delegate;

+ (WeChatManager *)sharedManager;
+ (BOOL)isWeChatInstall;
+ (NSString *)weChatUrl;

- (BOOL)openWXApp;
- (void)sendTextContent:(NSString *)text;
- (void)sendLinkWithTitle:(NSString *)title description:(NSString *)description image:(UIImage *)image link:(NSString *)url scene:(int)scene;
- (void)sendLinkWithTitle:(NSString *)title description:(NSString *)description imageUrl:(NSString *)imageUrl link:(NSString *)url scene:(int)scene;

//单独分享一张图片
- (void)sendImage:(UIImage *)image atScene:(int)scene;
@end
