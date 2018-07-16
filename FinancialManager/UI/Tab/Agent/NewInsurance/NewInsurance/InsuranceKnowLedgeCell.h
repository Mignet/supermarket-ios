//
//  InsuranceKnowLedgeCell.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/26.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InsuranceKnowLedgeCell;

@protocol InsuranceKnowLedgeCellDelegate <NSObject>

- (void)insuranceKnowLedgeCellDid:(InsuranceKnowLedgeCell *)knowLedgeCell;

@end

@interface InsuranceKnowLedgeCell : UITableViewCell

@property (nonatomic, weak) id <InsuranceKnowLedgeCellDelegate> delegate;

- (void)startAnimation;

@end
