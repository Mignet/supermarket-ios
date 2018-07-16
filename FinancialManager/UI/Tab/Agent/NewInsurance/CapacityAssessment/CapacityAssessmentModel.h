//
//  CapacityAssessmentModel.h
//  CapacityAssessment
//
//  Created by 张吉晴 on 2018/1/4.
//  Copyright © 2018年 张吉晴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CapacityAssessmentModel : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) BOOL system;

@property (nonatomic, assign) BOOL wait;

@property (nonatomic, assign) float cellHeight;

@property (nonatomic, assign) NSInteger numIssue;


+ (instancetype)capacityAssessmentModelContent:(NSString *)content isSystem:(BOOL)system isWait:(BOOL)wait issueNum:(NSInteger)issueNum;


@end
