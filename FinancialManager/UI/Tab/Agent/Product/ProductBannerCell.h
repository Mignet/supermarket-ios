//
//  ProductBannerCell.h
//  FinancialManager
//
//  Created by xnkj on 18/09/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XNFMProductCategoryStatisticMode;
@protocol ProductBannerCellDelegate <NSObject>
@optional

- (void)productBannerCellDidClick:(XNFMProductCategoryStatisticMode *)mode;
@end

@class XNFMProductCategoryStatisticMode;
@interface ProductBannerCell : UITableViewCell

@property (nonatomic, weak) id<ProductBannerCellDelegate> delegate;

- (void)refreshBanner:(XNFMProductCategoryStatisticMode *)mode;
@end
