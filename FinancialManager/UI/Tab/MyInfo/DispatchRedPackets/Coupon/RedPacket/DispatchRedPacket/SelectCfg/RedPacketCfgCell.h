//
//  CSCustomerCell.h
//  FinancialManager
//
//  Created by xnkj on 15/9/21.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RedPacketCfgCell;
@protocol RedPacketCfgCellDelegate <NSObject>
@optional
- (void)RedPacketCfgCell:(RedPacketCfgCell *)cell didSelectedAtIndexPath:(NSIndexPath *)indexPath;
- (void)RedPacketCfgCell:(RedPacketCfgCell *)cell didClickDetailAtIndexPath:(NSIndexPath *)indexPath;
@end

@class XNCSMyCustomerItemMode;
@interface RedPacketCfgCell : UITableViewCell

@property (nonatomic, assign) id<RedPacketCfgCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath * indexPath;

- (void)updateContent:(XNCSMyCustomerItemMode *)params;
- (void)setBottomHiden:(BOOL)hide;
- (void)updateStatus:(BOOL)selected;
@end
