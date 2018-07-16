//
//  RedPacketCell.h
//  FinancialManager
//
//  Created by xnkj on 20/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RedPacketInfoMode;
@interface CanUsedRedPacketCell : UITableViewCell

- (void)refreshRedPacketInfoWithRedPacketInfoMode:(RedPacketInfoMode *)mode;
@end
