//
//  ProductCategoryCell.h
//  FinancialManager
//
//  Created by ancye.Xie on 2/24/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductCategoryCellDelegate <NSObject>

- (void)XNProductCategoryCellDidClick:(productCategoryType)type;

@end

@interface ProductCategoryCell : UITableViewCell

@property (nonatomic, assign) id<ProductCategoryCellDelegate> delegate;

- (void)showProductCategory:(NSArray *)params;

@end
