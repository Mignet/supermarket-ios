//
//  ZJCalendarModel.h
//  4_5_1日历
//
//  Created by 张吉晴 on 2017/12/1.
//  Copyright © 2017年 Power. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZJCalendarItemModel;

@interface ZJCalendarModel : NSObject

/*** 索引 **/
@property (nonatomic, assign) NSInteger index;

/*** 当前是否显示 **/
@property (nonatomic, assign) BOOL isShow;

/*** 年 **/
@property (nonatomic, assign) NSInteger year;

/*** 月 **/
@property (nonatomic, assign) NSInteger month;

/*** 本月数据 **/
@property (nonatomic, strong) NSArray <ZJCalendarItemModel *> *dataArray;

@end
