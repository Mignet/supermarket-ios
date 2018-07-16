//
//  BackStatisticalCell.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/27.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvestStatisticsModel, BackStatisticalCell;

@protocol BackStatisticalCellDelegate <NSObject>

- (void)backStatisticalCellDid:(BackStatisticalCell *)backStatisticalCell;

@end

//showFMRecommandViewWithTitle

@interface BackStatisticalCell : UITableViewCell

@property (nonatomic, strong) InvestStatisticsModel *investStatisticsModel;

@property (nonatomic, weak) id <BackStatisticalCellDelegate> delegate;

@end
