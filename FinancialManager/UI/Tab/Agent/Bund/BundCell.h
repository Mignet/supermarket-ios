//
//  BundCell.h
//  FinancialManager
//
//  Created by ancye.Xie on 8/17/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XNBundItemMode;
@interface BundCell : UITableViewCell

- (void)showDatas:(XNBundItemMode *)mode selectedPeriodType:(NSString *)selectedPeriodType selectedPeriod:(NSString *)selectedPeriodString;

@end
