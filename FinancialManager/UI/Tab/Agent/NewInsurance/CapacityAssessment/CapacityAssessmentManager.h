//
//  CapacityAssessmentManager.h
//  CapacityAssessment
//
//  Created by 张吉晴 on 2018/1/4.
//  Copyright © 2018年 张吉晴. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CapacityAssessmentModel, CapacityAssessmentSinglePopView, CapacityAssessmentPopView, CapacityAssessmentViewController;

@interface CapacityAssessmentManager : NSObject

@property (nonatomic, strong) CapacityAssessmentSinglePopView *singlePopView;

@property (nonatomic, strong) CapacityAssessmentPopView *morePopView;


@property (nonatomic, assign) BOOL isExecute;

@property (nonatomic, weak) CapacityAssessmentViewController *assessmentVC;

// 开始智能评测
- (void)startCapacityAssessment:(CapacityAssessmentViewController *)assessmentVC;

- (NSArray <CapacityAssessmentModel *> *)getShowContentArr;

- (NSDictionary *)getParasDic;

- (void)setShowContentArr;

// 第一个问题
- (void)oneIssue;

// 第二个问题
- (void)twoIssue;

// 第三个问题
- (void)threeIssue;

// 第四个问题
- (void)fourIssue;

// 第五个问题
- (void)fiveIssue;

// 第六个问题
- (void)sixIssue;

@property (nonatomic, assign) float frameHeight;

- (void)addObjc:(CapacityAssessmentModel *)model;


@end
