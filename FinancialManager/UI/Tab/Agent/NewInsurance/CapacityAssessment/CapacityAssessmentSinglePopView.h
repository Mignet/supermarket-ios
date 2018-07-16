//
//  CapacityAssessmentSinglePopView.h
//  CapacityAssessment
//
//  Created by 张吉晴 on 2018/1/5.
//  Copyright © 2018年 张吉晴. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CapacityAssessmentSinglePopView;

@protocol CapacityAssessmentSinglePopViewDelegate <NSObject>

- (void)capacityAssessmentSinglePopViewDid:(CapacityAssessmentSinglePopView *)singlePopView withParamsKey:(NSString *)paramsKey withOptionStr:(NSString *)optionStr withOptionNum:(NSInteger)optionNum withIssueNum:(NSInteger)issueNum;

@end

@interface CapacityAssessmentSinglePopView : UIView

+ (instancetype)capacityAssessmentSinglePopView;

- (void)show:(NSArray *)optionArr withIssueNum:(NSInteger)issueNum withView:(UIView *)view;

@property (nonatomic, weak) id <CapacityAssessmentSinglePopViewDelegate> delegate;

- (void)dismiss;



@end
