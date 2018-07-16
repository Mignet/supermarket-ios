//
//  HomeHeaderCell.h
//  FinancialManager
//
//  Created by xnkj on 5/12/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HeaderType)
{
    aboutUsType = 0,
    newUserType,
    invitedCustomerType,
    adviceCfgType,
    iMax
};

@class  XNFMProductCategoryStatisticMode, XNHomeAchievementModel;
@protocol HomeHeaderCellDelelgate <NSObject>
@optional

- (void)XNHomeHeaderCellDidClickWithUrl:(NSString *)url;
- (void)XNHomeHeaderCellDidClickAction:(NSInteger)index;

@end

@interface HomeHeaderCell : UITableViewCell

@property (nonatomic, assign) id<HomeHeaderCellDelelgate> delegate;

- (void)refreshAdScrollViewWithAdObjectArray:(NSArray *)adObjectArray urlArray:(NSArray *)bannerUrlArray commissionAmount:(NSString *)commission;

@property (nonatomic, copy) NSString *safeOperationTime;

@end
