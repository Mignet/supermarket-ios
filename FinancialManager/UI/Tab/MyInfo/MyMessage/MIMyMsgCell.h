//
//  CSRedeemCell.h
//  FinancialManager
//
//  Created by xnkj on 15/9/21.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XNPrivateMsgItemMode;
@interface MIMyMsgCell : UITableViewCell

- (void)updateContent:(XNPrivateMsgItemMode *)params isSelected:(BOOL)selected canEdit:(BOOL)edited firstCell:(BOOL)isFirstCell lastCell:(BOOL)isLastCell;
@end
