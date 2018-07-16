//
//  SeekTreasureHeaderView.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/20.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeekTreasureHeaderView;

typedef NS_ENUM(NSInteger, SeekTreasureHeaderViewType) {

    SeekTreasureActivity = 0,
    SeekTreasureOption,
    SeekTreasureRead,
    NewInsuranceProduct
    
};

@protocol SeekTreasureHeaderViewDelegate <NSObject>

- (void)seekTreasureHeaderViewDid:(SeekTreasureHeaderView *)HeaderView HeaderViewType:(SeekTreasureHeaderViewType)headerViewType;

@end

@interface SeekTreasureHeaderView : UITableViewHeaderFooterView

+ (instancetype)seekTreasureHeaderViewType:(SeekTreasureHeaderViewType)seekType;

/***  代理对象 **/
@property (nonatomic, weak) id <SeekTreasureHeaderViewDelegate> delegate;
@property (nonatomic, assign) SeekTreasureHeaderViewType seekType;

@end
