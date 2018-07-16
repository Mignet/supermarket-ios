//
//  SeekTreasureActivityCell.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/20.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeekTreasureActivityCell;

@protocol SeekTreasureActivityCellDelegate <NSObject>

- (void)seekTreasureActivityCellDid:(SeekTreasureActivityCell *)activityCell withStringUrl:(NSString *)stringUrl;

@end

@interface SeekTreasureActivityCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *urlArr;

/*** 代理对象 **/
@property (nonatomic, weak) id <SeekTreasureActivityCellDelegate> delegate;

@end
