//
//  RedPacketCell.h
//  FinancialManager
//
//  Created by xnkj on 20/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SendBlock)(NSString * redPacketId, NSString * redPacketMoney);
typedef void(^UseRedPacketBlock)();

@class RedPacketInfoMode;
@interface RedPacketCell : UITableViewCell

@property (nonatomic, copy) SendBlock sendRedPacketBlock;
@property (nonatomic, copy) UseRedPacketBlock useRedPacketBlock;

- (void)refreshRedPacketInfoWithRedPacketInfoMode:(RedPacketInfoMode *)mode;

- (void)setClickSendRedPacketBlock:(SendBlock)block;
- (void)setClickUseRedPacketBlock:(UseRedPacketBlock)block;
@end
