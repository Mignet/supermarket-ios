//
//  MIDeportDetailCell.h
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XNMyAccountWithDrawRecordItemMode;

@protocol MIDeportDetailCellDelegate <NSObject>

@optional
- (void)showExplain:(XNMyAccountWithDrawRecordItemMode *)mode;

@end

@interface MIDeportDetailCell : UITableViewCell

@property (nonatomic, assign) id<MIDeportDetailCellDelegate> delegate;

- (void)showDatas:(XNMyAccountWithDrawRecordItemMode *)mode;

@end
