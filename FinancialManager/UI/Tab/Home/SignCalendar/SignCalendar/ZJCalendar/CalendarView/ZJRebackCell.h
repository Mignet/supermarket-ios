//
//  ZJRebackCell.h
//  4_5_1日历
//
//  Created by 张吉晴 on 2017/12/3.
//  Copyright © 2017年 Power. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJCalendarItemModel;

typedef void (^ZJRebackCellInvestBlock) (NSInteger index);

typedef void (^ZJRebackCellDayInsvestBlock) (ZJCalendarItemModel *itemModel);

@interface ZJRebackCell : UITableViewCell

@property (nonatomic, copy) ZJRebackCellInvestBlock block;

@property (nonatomic, copy) ZJRebackCellDayInsvestBlock dayBlock;

@property (nonatomic, strong) NSMutableArray *statisticsArr;




@end
