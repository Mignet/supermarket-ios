//
//  AchieveEvaluationCell.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/27.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AchieveEvaluationCell, XNInsuranceQquestionResultModel;

@protocol AchieveEvaluationCellDelegate <NSObject>

- (void)achieveEvaluationCellDid:(AchieveEvaluationCell *)achieveEvaluationCell withInsuranceCategroy:(NSString *)insuranceCategroy;

@end

@interface AchieveEvaluationCell : UITableViewCell

/*** 代理对象 **/
@property (nonatomic, weak) id <AchieveEvaluationCellDelegate> delegate;

@property (nonatomic, strong) XNInsuranceQquestionResultModel *questionResultModel;

@end
