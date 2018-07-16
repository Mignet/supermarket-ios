//
//  CapacityAssessmentSinglePopView.m
//  CapacityAssessment
//
//  Created by 张吉晴 on 2018/1/5.
//  Copyright © 2018年 张吉晴. All rights reserved.
//

#import "CapacityAssessmentSinglePopView.h"
#import "CapacityAssessmentManager.h"
#import "UIImage+Common.h"
#import "CapacityAssessmentManager.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface CapacityAssessmentSinglePopView ()

@property (weak, nonatomic) IBOutlet UIView *superView;

@property (nonatomic, assign) NSInteger issueNum;

@end

@implementation CapacityAssessmentSinglePopView

+ (instancetype)capacityAssessmentSinglePopView
{
    CapacityAssessmentSinglePopView *singlePopView = [[[NSBundle mainBundle] loadNibNamed:@"CapacityAssessmentSinglePopView" owner:nil options:nil] firstObject];
    return singlePopView;
}

- (void)show:(NSArray *)optionArr withIssueNum:(NSInteger)issueNum withView:(UIView *)view
{
    // 记录
    self.issueNum = issueNum;
    
    // 数据操作 (移除)
    for (UIView *subView in self.superView.subviews) {
        [subView removeFromSuperview];
    }

    // 添加选项按钮
    CGFloat space_x = 15.f;
    CGFloat space_y = 20.f;
    CGFloat optionBtn_w = 0;
    CGFloat optionBtn_h = 35.f;
    
    if (optionArr.count >= 3) {
        optionBtn_w = (SCREEN_WIDTH - (15.f * 4.f)) / 3.f;
    } else if (optionArr.count == 2) {
        optionBtn_w = (SCREEN_WIDTH - (15.f * 3.f)) / 2.f;
    } else {
        optionBtn_w = 250.f;
    }
    
    // 计算弹框的高度
    CGFloat popView_height = 0.f;
    if (optionArr.count <= 3) {
        popView_height = space_y * 2 + optionBtn_h;
    } else {
        
        if (optionArr.count % 3 == 0) {
            
            NSInteger num = optionArr.count / 3;
            
            popView_height = (num + 1) * space_y + num * optionBtn_h;
            
        } else {
            
            NSInteger num = optionArr.count / 3 + 1;
            
            popView_height = (num + 1) * space_y + num * optionBtn_h;
        }
    }
    
    
    
    self.frame = CGRectMake(0.f, SCREEN_HEIGHT, SCREEN_WIDTH, popView_height);
    
    
    for (NSInteger i = 0; i < optionArr.count; i ++) {
        
        UIButton *optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSInteger row = i / 3;
        NSInteger lie = i % 3;
        
        optionBtn.frame = CGRectMake(space_x + (optionBtn_w + space_x) * lie, space_y + (optionBtn_h + space_y) * row, optionBtn_w, optionBtn_h);
        
        optionBtn.tag = 100 + i;
        optionBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:14];
        
        UIImage *defaultImg = [UIImage resizableImage:@"chose_option_btn_nor"];
        UIImage *selectImg = [UIImage resizableImage:@"chose_option_btn_sele"];
        
        [optionBtn setBackgroundImage:defaultImg forState:UIControlStateNormal];
        [optionBtn setBackgroundImage:selectImg forState:UIControlStateSelected];
        
        [optionBtn setTitle:optionArr[i] forState:UIControlStateNormal];
        
        [optionBtn setTitleColor:UIColorFromHex(0X333333) forState:UIControlStateNormal];
        [optionBtn setTitleColor:UIColorFromHex(0X4E8CEF) forState:UIControlStateSelected];
        
        [optionBtn addTarget:self action:@selector(singleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.superView addSubview:optionBtn];
    }
    
    CapacityAssessmentManager *manager = (CapacityAssessmentManager *)self.delegate;
    manager.frameHeight = popView_height;
    
    // 显示操作
    CGFloat time = 0.f;
    if (issueNum == 1) {
        time = 1.5f;
    } else {
        time = 3.f;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CGFloat nav_h = 64.f;
            if (Device_Is_iPhoneX) {
                nav_h = 93.f;
            }
            
            // 创建按钮
            [UIView animateWithDuration:0.35 animations:^{
                // 改变frame
                self.frame = CGRectMake(0.f, SCREEN_HEIGHT - popView_height - nav_h, SCREEN_WIDTH, popView_height);
            } completion:^(BOOL finished) {
                
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"Capacity_Assessment_ViewController_Frame" object:nil];
                
            }];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Capacity_Assessment_ViewController_Frame" object:nil];
            
        });
    });
}

- (void)singleBtnClick:(UIButton *)optionBtn
{
    optionBtn.selected = !optionBtn.selected;
    
    if ([self.delegate respondsToSelector:@selector(capacityAssessmentSinglePopViewDid:withParamsKey:withOptionStr:withOptionNum:withIssueNum:)]) {
        
        if (self.issueNum == 1) { // 第一个问题
            NSInteger optionNum = optionBtn.tag - 100;
            NSString *optionStr = optionBtn.titleLabel.text;
            
            [self.delegate capacityAssessmentSinglePopViewDid:self withParamsKey:@"sex" withOptionStr:optionStr withOptionNum:optionNum withIssueNum:self.issueNum];
        }
        
        else if (self.issueNum == 2) { // 第二个问题
            
            NSInteger optionNum = optionBtn.tag - 100;
            NSString *optionStr = optionBtn.titleLabel.text;
            
            [self.delegate capacityAssessmentSinglePopViewDid:self withParamsKey:@"age" withOptionStr:optionStr withOptionNum:optionNum withIssueNum:self.issueNum];
        }
        
        else if (self.issueNum == 4) { // 第四个问题
            
            NSInteger optionNum = optionBtn.tag - 100;
            NSString *optionStr = optionBtn.titleLabel.text;
            
            [self.delegate capacityAssessmentSinglePopViewDid:self withParamsKey:@"yearIncome" withOptionStr:optionStr withOptionNum:optionNum withIssueNum:self.issueNum];
        }
        
        else if (self.issueNum == 5) { // 第五个问题
            
            NSInteger optionNum = optionBtn.tag - 100;
            NSString *optionStr = optionBtn.titleLabel.text;
            
            [self.delegate capacityAssessmentSinglePopViewDid:self withParamsKey:@"familyLoan" withOptionStr:optionStr withOptionNum:optionNum withIssueNum:self.issueNum];
        }
    }
    
    [self dismiss];
}

- (void)dismiss
{
    CapacityAssessmentManager *manager = (CapacityAssessmentManager *)self.delegate;
    manager.frameHeight = 0;
    
    // 创建按钮
    [UIView animateWithDuration:.35 animations:^{
        // 改变frame
        self.frame = CGRectMake(0.f, SCREEN_HEIGHT, SCREEN_WIDTH, 0.f);

    } completion:^(BOOL finished) {
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"Capacity_Assessment_ViewController_Frame" object:nil];
        
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Capacity_Assessment_ViewController_Frame" object:nil];
}



@end
