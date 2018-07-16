//
//  CapacityAssessmentPopView.m
//  CapacityAssessment
//
//  Created by 张吉晴 on 2018/1/4.
//  Copyright © 2018年 张吉晴. All rights reserved.
//

#import "CapacityAssessmentPopView.h"
#import "CapacityAssessmentManager.h"
#import "UIImage+Common.h"
#import "CapacityAssessmentManager.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface CapacityAssessmentPopView ()

@property (weak, nonatomic) IBOutlet UIView *optionSupView;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (nonatomic, assign) NSInteger issueNum;

@property (nonatomic, assign) NSInteger mustNum;

@property (nonatomic, strong) NSMutableArray *selectArr;

@property (nonatomic, strong) NSArray *optionArr;



@end

@implementation CapacityAssessmentPopView

+ (instancetype)capacityAssessmentPopView
{
    CapacityAssessmentPopView *popView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CapacityAssessmentPopView class]) owner:nil options:nil] firstObject];
    return popView;
}

- (void)show:(NSArray *)optionArr withIssueNum:(NSInteger)issueNum withMustNum:(NSInteger)mustNum withView:(UIView *)view
{
    [self.selectArr removeAllObjects];
    self.optionArr = optionArr;
    
    
    // 记录
    self.issueNum = issueNum;
    self.mustNum = mustNum;
    
    // 数据操作 (移除)
    for (UIView *view in self.optionSupView.subviews) {
        [view removeFromSuperview];
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
        
        if (mustNum - 100 == i) {
            optionBtn.selected = YES;
            optionBtn.userInteractionEnabled = NO;
            NSString *optionStr = [NSString stringWithFormat:@"%ld", optionBtn.tag - 100];
            [self.selectArr addObject:optionStr];
        }
        
        [optionBtn setTitle:optionArr[i] forState:UIControlStateNormal];
        [optionBtn setTitleColor:UIColorFromHex(0X333333) forState:UIControlStateNormal];
        [optionBtn setTitleColor:UIColorFromHex(0X4E8CEF) forState:UIControlStateSelected];
        [optionBtn addTarget:self action:@selector(optionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.optionSupView addSubview:optionBtn];
    }
    
    CapacityAssessmentManager *manager = (CapacityAssessmentManager *)self.delegate;
    manager.frameHeight = popView_height + 40.f;
    
    // 显示操作
    CGFloat time = 0.f;
    if (issueNum == 1) {
        time = 1.5f;
    } else {
        time = 3.f;
    }
    
    //  对数操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{

            CGFloat nav_h = 64.f;
            if (Device_Is_iPhoneX) {
                nav_h = 93.f;
            }
            
            [UIView animateWithDuration:0.35 animations:^{
                self.alpha = 1;
                self.frame = CGRectMake(0.f, SCREEN_HEIGHT - (popView_height + 40.f + nav_h), SCREEN_WIDTH, popView_height + 40.f );
            } completion:^(BOOL finished) {
                
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"Capacity_Assessment_ViewController_Frame" object:nil];
                
            }];
    
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Capacity_Assessment_ViewController_Frame" object:nil];
            
        });
    });
    
}

- (void)optionBtnClick:(UIButton *)optionBtn
{
    if (self.issueNum == 3) { // 第三个问题
        
        if (optionBtn.selected) { // 取消选中
            
            NSString *optionStr = [NSString stringWithFormat:@"%ld", optionBtn.tag - 100];
            [self.selectArr removeObject:optionStr];
            
        } else { // 选中
        
            NSString *optionStr = [NSString stringWithFormat:@"%ld", optionBtn.tag - 100];
            [self.selectArr addObject:optionStr];
        }
        
        optionBtn.selected = !optionBtn.selected;
    }
    
    else if (self.issueNum == 6) { //
        
        if (optionBtn.selected == YES) { // 取消选中
            
            NSString *optionStr = [NSString stringWithFormat:@"%ld", optionBtn.tag - 100];
            [self.selectArr removeObject:optionStr];
            optionBtn.selected = !optionBtn.selected;
            
        } else { // 选中
            
            if (optionBtn.tag == 100) { // 都没有
                
                [self.selectArr removeAllObjects];
                [self.selectArr addObject:[NSString stringWithFormat:@"%ld", optionBtn.tag - 100]];
                
                NSArray *btns = self.optionSupView.subviews;
                
                for (UIButton *btn in btns) {
                    if (btn.tag == 100) { // 第一个
                        btn.selected = YES;
                    } else {
                        btn.selected = NO;
                    }
                }
                
            } else { // 选中其他的
                
                NSString *optionStr = [NSString stringWithFormat:@"%ld", optionBtn.tag - 100];
                [self.selectArr addObject:optionStr];
                optionBtn.selected = !optionBtn.selected;
                
                // 1.先UI取消第一个选中
                UIButton *btn = [self.optionSupView viewWithTag:100];
                btn.selected = NO;
                
                // 2.移除都没有
                [self.selectArr removeObject:@"0"];
            }
        }
    }
}

- (IBAction)confirmBtnClick
{
    if ([self.delegate respondsToSelector:@selector(capacityAssessmentPopViewDid:withOptionNum:withIssueNum:withUIShowStr:)]) {
    
        if (self.issueNum == 6) { // 最后一个问题
            
            NSString *ensure = [NSString string];
            
            for (NSInteger i = 0; i < self.selectArr.count; i ++) {
                
                if (i == 0) {
                    NSInteger num = [self.selectArr[i] integerValue];
                    ensure = [NSString stringWithFormat:@"%@", self.optionArr[num]];
                } else {
                    NSInteger num = [self.selectArr[i] integerValue];
                    ensure = [ensure stringByAppendingString:[NSString stringWithFormat:@",%@", self.optionArr[num]]];
                }
            }
            
            [self.delegate capacityAssessmentPopViewDid:self withOptionNum:self.selectArr withIssueNum:self.issueNum withUIShowStr:ensure];
            
        } else {
            
            [self.delegate capacityAssessmentPopViewDid:self withOptionNum:self.selectArr withIssueNum:self.issueNum withUIShowStr:nil];
        }
    }
    
    // 创建按钮
    [UIView animateWithDuration:.35 animations:^{
        // 改变frame
        self.alpha = 0;
        self.frame = CGRectMake(0.f, SCREEN_HEIGHT, SCREEN_WIDTH, 0.f);
    }];
    
    
    //[CapacityAssessmentManager shareInstance].frameHeight = 0;
    
    CapacityAssessmentManager *manager = (CapacityAssessmentManager *)self.delegate;
    manager.frameHeight = 0;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Capacity_Assessment_ViewController_Frame" object:nil];
}

- (void)dismiss
{
    CapacityAssessmentManager *manager = (CapacityAssessmentManager *)self.delegate;
    manager.frameHeight = 0;
    
    [UIView animateWithDuration:0.35 animations:^{
        // 改变frame
        self.alpha = 0;
        self.frame = CGRectMake(0.f, SCREEN_HEIGHT, SCREEN_WIDTH, 0.f);
    } completion:^(BOOL finished) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"Capacity_Assessment_ViewController_Frame" object:nil];
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Capacity_Assessment_ViewController_Frame" object:nil];
}

////////////////////////////////
#pragma mark - setter / getter
////////////////////////////////

- (NSMutableArray *)selectArr
{
    if (!_selectArr) {
        _selectArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectArr;
}




@end
