//
//  SeekTreasureOptionCell.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/20.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeekTreasureOptionCell;

typedef NS_ENUM(NSInteger, SeekTreasureOptionCellBtn) {

    ActivityBtn = 0,
    DayPaperBtn,
    ManualBtn,
    InviteBtn,
    NewsPaperBtn,
    ListPaperBtn,
    CardBtn,
    CompBtn

};

@protocol SeekTreasureOptionCellDelegate <NSObject>

- (void)seekTreasureOptionCellDid:(SeekTreasureOptionCell *)seekTreasureOptionCell OptionCellBtn:(SeekTreasureOptionCellBtn)optionCellBtn;

@end

@interface SeekTreasureOptionCell : UITableViewCell

/***  代理 **/
@property (nonatomic, weak) id <SeekTreasureOptionCellDelegate> delegate;



@end
