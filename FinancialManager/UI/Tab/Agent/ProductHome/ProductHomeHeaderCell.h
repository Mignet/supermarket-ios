//
//  ProductHeaderCell.h
//  FinancialManager
//
//  Created by ancye.Xie on 2/24/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductHomeHeaderCellDelegate <NSObject>

- (void)XNProductHeaderCellDidClickWithUrl:(NSString *)url;

@end

@interface ProductHomeHeaderCell : UITableViewCell

@property (nonatomic, assign) id<ProductHomeHeaderCellDelegate> delegate;

- (void)refreshAdScrollViewWithAdObjectArray:(NSArray *)adObjectArray urlArray:(NSArray *)bannerUrlArray;

@end
