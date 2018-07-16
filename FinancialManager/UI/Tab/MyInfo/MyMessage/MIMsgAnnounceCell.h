//
//  CSPurchaseCell.h
//  FinancialManager
//
//  Created by xnkj on 15/9/18.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XNCommonMsgItemMode;
@interface MIMsgAnnounceCell : UITableViewCell

- (void)updateContent:(XNCommonMsgItemMode *)params firstCell:(BOOL)isFirstCell lastCell:(BOOL)isLastCell;
@end
