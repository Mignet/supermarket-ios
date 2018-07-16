//
//  UINavigationItem+Extension.h
//  GXQApp
//
//  Created by 振增 黄 on 14-5-6.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "objc/runtime.h"

@interface UINavigationItem (Extension)

//添加item项
- (void)addBackButtonItemWithTarget:(id)target action:(SEL)action;

- (void)addCommitButtonItemWithTarget:(id)target action:(SEL)action;

- (void)addRightBarItemWithTitle:(NSString *)title titleColor:(UIColor *)color target:(id)target action:(SEL)action;

- (void)addRightBarItemWithImage:(NSString *)imageName frame:(CGRect )frame target:(id)target action:(SEL)action;
- (void)addRightBarItemWithButtonArray:(NSArray *)btnArray frameArray:(NSArray *)frameArray target:(id)target action:(NSArray *)actionArray;

- (void)addSaveButtonItemWithTarget:(id)target action:(SEL)action;

- (void)addEditItemWithTarget:(id)target action:(SEL)action;

- (void)addRechargeDetailWithTarget:(id)target action:(SEL)action;

- (void)addDeportDetailWithTarget:(id)target action:(SEL)action;

- (void)addShareButtonItemWithTarget:(id)target action:(SEL)action;

- (void)addConversationItemWithTarget:(id)target action:(SEL)action;

- (void)addMessageRemindItemWithTarget:(id)target action:(SEL)action;

- (void)addInvitedItemWithTarget:(id)target action:(SEL)action;

- (void)addTakePictureItemWithTarget:(id)target action:(SEL)action;

- (void)addSelectCustomerCountItemWithTarget:(id)target action:(SEL)action;

- (void)addReadAllMsgItemWithTarget:(id)target action:(SEL)action;

- (void)addRedPacketDispatchRuleItemWithTarget:(id)target action:(SEL)action;

// 佣金说明
- (void)addComissionDescWithTarget:(id)target action:(SEL)action;

// 标题带有解释按钮
- (void)addTitle:(NSString *)title target:(id)target action:(SEL)action;

// 标题带有向下图标的按钮
- (void)addDownTitle:(NSString *)title target:(id)target action:(SEL)action;

// 全选
- (void)selectAllWithTarget:(id)target title:(NSString *)title action:(SEL)action;

- (void)removeRightButton;
- (void)removeLeftButton;

//显示返回按钮
- (void)showLeftButton:(id)target action:(SEL)action;

//对item上的内容进行操作
- (void)refreshMessageRemindItemWithMessageCount:(NSString *)messageCount forTarget:(id)target;

- (void)refreshSelectCustomerCountItemWithCustomerCount:(NSString *)customerCount forTarget:(id)target;
// 刷新item上邀请的图标
- (void)refreshServiceImage:(BOOL)isUnReadMsg forTarget:(id)target;

//获取对应试图
- (UIView *)getItemViewWithTag:(NSString *)tagStr forTarget:(id)target;
@end
