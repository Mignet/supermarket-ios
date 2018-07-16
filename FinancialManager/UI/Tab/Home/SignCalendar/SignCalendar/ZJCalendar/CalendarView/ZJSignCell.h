//
//  ZJSignCell.h
//  4_5_1日历
//
//  Created by 张吉晴 on 2017/11/30.
//  Copyright © 2017年 Power. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ZJSignCellPassBlock) (NSInteger year, NSInteger month);

@interface ZJSignCell : UITableViewCell

@property (nonatomic, copy) ZJSignCellPassBlock passBlock;

@property (nonatomic, strong) NSMutableArray *signCalendarArr;

@end
