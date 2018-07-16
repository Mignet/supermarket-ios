//
//  SaleGoodNewsCell.h
//  FinancialManager
//
//  Created by ancye.Xie on 7/26/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNLCSaleGoodNewsItemMode.h"

@protocol SaleGoodNewsCellDelegate <NSObject>

- (void)saleGoodNewsCellDidClick:(XNLCSaleGoodNewsItemMode *)itemMode;

@end

@interface SaleGoodNewsCell : UITableViewCell

@property (nonatomic, assign) id<SaleGoodNewsCellDelegate> delegate;

- (void)showDatas:(NSArray *)datasArray selectedMode:(XNLCSaleGoodNewsItemMode *)mode;

@end
