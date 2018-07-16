//
//  NoEvaluationCell.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/25.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoEvaluationCell;

@protocol NoEvaluationCellDelegate <NSObject>

- (void)noEvaluationCellDid:(NoEvaluationCell *)noEvaluationCell;

@end

@interface NoEvaluationCell : UITableViewCell

@property (nonatomic, weak) id <NoEvaluationCellDelegate> delegate;

@end
