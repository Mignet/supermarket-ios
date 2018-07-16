//
//  CustomScrollPanView.m
//  FinancialManager
//
//  Created by xnkj on 26/06/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "CustomScrollPanView.h"

@interface CustomScrollPanView()<UIGestureRecognizerDelegate>

@end

@implementation CustomScrollPanView


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([self panBack:gestureRecognizer]){
        
        return YES;
    }
    
    return NO;
}

- (BOOL)panBack:(UIGestureRecognizer *)gestureReconizer{
    
    if (gestureReconizer == self.panGestureRecognizer) {
        
        UIPanGestureRecognizer * pan = (UIPanGestureRecognizer *)gestureReconizer;
        
        CGPoint point = [pan translationInView:self];
        UIGestureRecognizerState state = gestureReconizer.state;
        
        if (UIGestureRecognizerStateBegan == state || UIGestureRecognizerStatePossible == state) {
            
            CGPoint location = [gestureReconizer locationInView: self];
            
            if (point.x > 0 && location.x < [UIScreen mainScreen].bounds.size.width && self.contentOffset.x <= 0) {
                
                return YES;
            }
        }
    }
    
    return NO;
}

@end
