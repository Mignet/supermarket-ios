//
//  InvestClassifyCell.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/28.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvestClassifyCell;

typedef NS_ENUM(NSInteger, InvestClassifyCellClickType) {

    Invest_Classify_Cell_Loans = 0,
    Invest_Classify_Cell_Insurance
};

@protocol InvestClassifyCellDelegate <NSObject>

- (void)investClassifyCellDid:(InvestClassifyCell *)investClassifyCell clickType:(InvestClassifyCellClickType)clickType;

@end

@interface InvestClassifyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *loansBtn;
@property (weak, nonatomic) IBOutlet UIButton *insuranceBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;

/*** 代理 **/
@property (nonatomic, weak) id <InvestClassifyCellDelegate> delegate;

@end
