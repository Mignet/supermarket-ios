//
//  MessageNoDisturbViewCell.h
//  Lhlc
//
//  Created by ancye.Xie on 3/21/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageNoDisturbViewCell;

@protocol MessageNoDisturbViewDelegate <NSObject>

@optional

- (void)switchButtonPressed:(NSInteger)nBtnTag isPlatformflag:(BOOL)isPlatformflag;

@end

@interface MessageNoDisturbViewCell : UITableViewCell

@property (nonatomic, weak) id<MessageNoDisturbViewDelegate> delegate;

- (void)showDatas:(NSInteger)nRow title:(NSString *)titleString isOpenMsgNoDisturb:(BOOL)isOpenMsgNoDisturb;

@end
