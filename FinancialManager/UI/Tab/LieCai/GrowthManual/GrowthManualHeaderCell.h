//
//  GrowthManualHeaderCell.h
//  FinancialManager
//
//  Created by ancye.Xie on 7/31/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNGrowthManualCategoryMode.h"

@protocol GrowthManualHeaderCellDelegate <NSObject>

- (void)growthManualHeaderCellDidClick:(XNGrowthManualCategoryMode *)mode;

@end

@interface GrowthManualHeaderCell : UITableViewCell

@property (nonatomic, assign) id<GrowthManualHeaderCellDelegate> delegate;

- (void)showDatas:(NSArray *)datasArray;

@end
