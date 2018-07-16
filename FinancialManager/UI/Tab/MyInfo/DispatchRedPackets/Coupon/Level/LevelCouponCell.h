//
//  RedPacketCell.h
//  FinancialManager
//
//  Created by xnkj on 20/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LevelCouponItemMode;
@interface LevelCouponCell : UITableViewCell

- (void)refreshLevelCouponInfoWithLevelCouponInfoMode:(LevelCouponItemMode *)mode;
@end
