//
//  CapacityAssessmentModel.m
//  CapacityAssessment
//
//  Created by 张吉晴 on 2018/1/4.
//  Copyright © 2018年 张吉晴. All rights reserved.
//

#import "CapacityAssessmentModel.h"
#import "CapacityAssessmentManager.h"

@interface CapacityAssessmentModel ()


@end


@implementation CapacityAssessmentModel

+ (instancetype)capacityAssessmentModelContent:(NSString *)content isSystem:(BOOL)system isWait:(BOOL)wait issueNum:(NSInteger)issueNum
{
    CapacityAssessmentModel *pd = [[CapacityAssessmentModel alloc] init];
    
    pd.system = system;
    pd.numIssue = issueNum;
    
    if (wait == YES) { // 需等待
        
        pd.content = @"正在输入...";
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Capacity_Assessment_ViewController_LoadData" object:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                pd.content = content;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Capacity_Assessment_ViewController_LoadData" object:nil];
            });
        });
    }
    
    else { // 无需等待
        
        pd.content = content;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Capacity_Assessment_ViewController_LoadData" object:nil];
    }
    
    return pd;
    
}

@end
