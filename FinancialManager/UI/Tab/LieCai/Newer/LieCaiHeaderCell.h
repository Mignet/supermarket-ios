//
//  LieCaiHeaderCell.h
//  FinancialManager
//
//  Created by ancye.Xie on 6/29/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LieCaiHeaderCellDelegate <NSObject>

- (void)levelExplainAction;

- (void)jumpToPageAction:(NSInteger)tag;

@end

@class XNLCLevelPrivilegeMode;
@interface LieCaiHeaderCell : UITableViewCell

@property (nonatomic, assign) id<LieCaiHeaderCellDelegate> delegate;

- (void)showDatas:(XNLCLevelPrivilegeMode *)levelMode unreadSaleGoodNews:(BOOL)isUnReadSaleGoodNews;

@end
