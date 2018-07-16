//
//  XNInvitedPopView.h
//  XNCommonProject
//
//  Created by xnkj on 5/4/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XNInvitedPopViewDelegate <NSObject>
@optional

- (void)XNInvitedPopViewDidSelectedAtIndex:(NSInteger )index;
@end

@interface XNInvitedPopView : UIView

@property (nonatomic, assign) id<XNInvitedPopViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame titleDataSource:(NSArray *)invitedTitleList iconDataSource:(NSArray *)invitedIconList;

- (void)refreshTableView;

@end
