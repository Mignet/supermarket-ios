//
//  CapacityAssessmentCell.h
//  CapacityAssessment
//
//  Created by 张吉晴 on 2018/1/4.
//  Copyright © 2018年 张吉晴. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CapacityAssessmentModel, CapacityAssessmentCell;

@protocol CapacityAssessmentCellDelegate <NSObject>

- (void)capacityAssessmentCellDid:(CapacityAssessmentCell *)assessmentCell;

@end

@interface CapacityAssessmentCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, strong) CapacityAssessmentModel *assessmentModel;

@property (nonatomic, weak) id <CapacityAssessmentCellDelegate> delegate;

@end
