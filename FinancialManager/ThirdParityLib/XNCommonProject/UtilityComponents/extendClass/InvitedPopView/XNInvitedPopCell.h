//
//  XNInvitedPopCell.h
//  XNCommonProject
//
//  Created by xnkj on 5/4/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNInvitedPopCell : UITableViewCell

- (void)updateIcon:(NSString *)imageName title:(NSString *)title isLastCell:(BOOL)lastCell isHiddenRedPoint:(BOOL)isHiddenRedPoint;
@end
