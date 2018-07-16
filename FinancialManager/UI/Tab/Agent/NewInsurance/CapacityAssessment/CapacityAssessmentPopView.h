//
//  CapacityAssessmentPopView.h
//  CapacityAssessment
//
//  Created by 张吉晴 on 2018/1/4.
//  Copyright © 2018年 张吉晴. All rights reserved.


#import <UIKit/UIKit.h>

@class CapacityAssessmentPopView;

@protocol CapacityAssessmentPopViewDelegate <NSObject>

- (void)capacityAssessmentPopViewDid:(CapacityAssessmentPopView *)popView withOptionNum:(NSArray *)optionArr withIssueNum:(NSInteger)issueNum withUIShowStr:(NSString *)str;

@end

@interface CapacityAssessmentPopView : UIView

+ (instancetype)capacityAssessmentPopView;

- (void)show:(NSArray *)optionArr withIssueNum:(NSInteger)issueNum withMustNum:(NSInteger)mustNum withView:(UIView *)view;

/*** 代理对象 **/
@property (nonatomic, weak) id <CapacityAssessmentPopViewDelegate> delegate;

- (void)dismiss;

@end
