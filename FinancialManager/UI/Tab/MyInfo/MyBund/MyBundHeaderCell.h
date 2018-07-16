//
//  MyBundHeaderCell.h
//  FinancialManager
//
//  Created by ancye.Xie on 8/21/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XNMyBundHoldingStatisticMode;

@protocol MyBundHeaderCellDelegate <NSObject>

- (void)MyBundHeaderCellDidClick:(NSInteger)nIndex;

@end

@interface MyBundHeaderCell : UITableViewCell

@property (nonatomic, assign) id<MyBundHeaderCellDelegate> delegate;

- (void)showDatas:(XNMyBundHoldingStatisticMode *)mode isAbnormalStatus:(BOOL)isAbnormalStatus;

@end
