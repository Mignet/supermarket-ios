//
//  BackClassifyCell.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/28.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BackClassifyCell;

typedef NS_ENUM(NSInteger, BackClassifyCellClickType) {

    Back_Classify_Yet_Click = 0,
    Back_Classify_Wait_Click

};

@protocol BackClassifyCellDelegate <NSObject>

- (void)backClassifyCellDid:(BackClassifyCell *)BackClassifyCell clickType:(BackClassifyCellClickType)clickType;

@end

@interface BackClassifyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *waitBtn;
@property (weak, nonatomic) IBOutlet UIButton *yetBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, weak) id <BackClassifyCellDelegate> delegate;

@end
