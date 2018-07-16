//
//  ScrollViewExitView.m
//  FinancialManager
//
//  Created by xnkj on 2016/8/15.
//  Copyright © 2016年 xiaoniu. All rights reserved.
//

#import "ScrollViewExitView.h"

@interface ScrollViewExitView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) id scrollTarget;
@property (nonatomic) SEL  action;
@end

@implementation ScrollViewExitView

- (id)init
{
    self = [super init];
    if (self) {
        
        self.isAddGestureHandle = NO;
    }
    return self;
}

- (void)scrollView:(UIScrollView *)scrollView didLeftScrollNavigationController:(UINavigationController *)navigation
{
    self.scrollView = scrollView;
    
    NSMutableArray *_targets = [navigation.interactivePopGestureRecognizer valueForKey:@"_targets"];
    /**
     *  获取naviGesture的唯一对象，它是一个叫UIGestureRecognizerTarget的私有类，它有一个属性叫_target
     */
    id gestureRecognizerTarget = [_targets firstObject];
    /**
     *  获取_target:_UINavigationInteractiveTransition，它有一个方法叫handleNavigationTransition:
     */
    id navigationInteractiveTransition = [gestureRecognizerTarget valueForKey:@"_target"];
    /**
     *  通过打印，从控制台获取出来它的方法签名。
     */
    SEL handleTransition = NSSelectorFromString(@"handleNavigationTransition:");
    
    
    self.scrollTarget = navigationInteractiveTransition;
    self.action = handleTransition;
    
    
    if (!self.isAddGestureHandle && self.scrollView.contentOffset.x <= 0) {
        
        self.isAddGestureHandle = YES;
        [self.scrollView.panGestureRecognizer addTarget:self.scrollTarget action:self.action];
    }
}

- (void)scrollViewDidScrollViewOffSet:(CGPoint)offSet
{
    if (offSet.x <= 0) {
        
        if (!self.isAddGestureHandle) {
            
            self.isAddGestureHandle = YES;
            [self.scrollView.panGestureRecognizer addTarget:self.scrollTarget action:self.action];
        }
    }else
    {
        if (self.isAddGestureHandle) {
            
            self.isAddGestureHandle = NO;
            [self.scrollView.panGestureRecognizer removeTarget:self.scrollTarget action:self.action];
        }
    }
}
@end
