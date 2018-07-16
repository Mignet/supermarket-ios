//
//  MyCustomerStatisticsCell.h
//  FinancialManager
//
//  Created by xnkj on 18/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ExpandOperation)(BOOL expandStatus);

@class XNCSCustomerDetailMode,XNCSCfgDetailMode;
@interface MyCustomerStatisticsCell : UITableViewCell

@property (nonatomic, assign) BOOL expandStatus;
@property (nonatomic, copy) ExpandOperation expandBlock;

- (void)refreshData:(XNCSCustomerDetailMode *)mode;
- (void)refreshDataForCfg:(XNCSCfgDetailMode *)mode;

- (void)setClickExpandOperation:(ExpandOperation)block;
- (void)refreshCellWithExpandStatus:(BOOL)status;
@end
