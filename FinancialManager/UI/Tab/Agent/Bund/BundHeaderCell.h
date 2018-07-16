//
//  BundHeaderCell.h
//  FinancialManager
//
//  Created by ancye.Xie on 8/17/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BundHeaderCellDelegate <NSObject>

- (void)bundHeaderCellDidClick:(NSInteger)nTag;

@end
@interface BundHeaderCell : UITableViewCell

@property (nonatomic, assign) id<BundHeaderCellDelegate> delegate;

- (void)showDatas:(NSString *)selectedPeriodString;

@end
