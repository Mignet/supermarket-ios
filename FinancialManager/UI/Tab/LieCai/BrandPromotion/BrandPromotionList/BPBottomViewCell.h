//
//  BPBottomViewCell.h
//  FinancialManager
//
//  Created by ancye.Xie on 7/5/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BPBottomViewCellDelegate <NSObject>

- (void)BPBottomViewCellDelegateDidSelectedPics:(NSArray *)selectedPicsArray selectedPicUrls:(NSArray *)selectedPicUrlsArray isMoreThreePic:(BOOL)isMoreThreePic;

- (void)BPBottomViewCellDelegateDidShowMoreDatas:(NSInteger)index;

@end

@class XNLCBrandPromotionMode;
@interface BPBottomViewCell : UITableViewCell

@property (nonatomic, assign) id<BPBottomViewCellDelegate> delegate;


- (void)showDatas:(XNLCBrandPromotionMode *)mode type:(NSString *)type selectedPics:(NSArray *)selectedPicArray selectedPicUrls:(NSArray *)selectedPicUrlsArray shouldUpdatePics:(BOOL)isShouldUpdatePics;

@end
