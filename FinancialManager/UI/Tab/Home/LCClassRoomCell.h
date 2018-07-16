//
//  LCClassRoomCell.h
//  FinancialManager
//
//  Created by xnkj on 13/09/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClassRoomItemBlock)(NSInteger selectedIndex, NSString * linkUrl);

@interface LCClassRoomCell : UITableViewCell

@property (nonatomic, copy) ClassRoomItemBlock classRoomItemBlock;

- (void)setClickClassRoomItemBlock:(ClassRoomItemBlock)block;

//刷新数据
- (void)refreshLcClassRoomContentItemName:(NSArray *)contentList urlItemList:(NSArray *)urlList;
@end
