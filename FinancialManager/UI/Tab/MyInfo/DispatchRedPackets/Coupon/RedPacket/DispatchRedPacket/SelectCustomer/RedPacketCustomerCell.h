//
//  CSCustomerCell.h
//  FinancialManager
//
//  Created by xnkj on 15/9/21.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RedPacketCustomerCell;
@protocol RedPacketCustomerCellDelegate <NSObject>
@optional
- (void)RedPacketCustomerCell:(RedPacketCustomerCell *)cell didSelectedAtIndexPath:(NSIndexPath *)indexPath;
@end

@class XNCSMyCustomerItemMode;
@interface RedPacketCustomerCell : UITableViewCell

@property (nonatomic, assign) id<RedPacketCustomerCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath * indexPath;

- (void)updateContent:(XNCSMyCustomerItemMode *)params;
- (void)setBottomHiden:(BOOL)hide;
- (void)updateStatus:(BOOL)selected;
@end
