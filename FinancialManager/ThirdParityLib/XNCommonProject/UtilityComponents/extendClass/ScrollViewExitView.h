//
//  ScrollViewExitView.h
//  FinancialManager
//
//  Created by xnkj on 2016/8/15.
//  Copyright © 2016年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScrollViewExitView : NSObject

@property (nonatomic, assign) BOOL isAddGestureHandle;

- (void)scrollView:(UIScrollView *)scrollView didLeftScrollNavigationController:(UINavigationController *)navigation;
- (void)scrollViewDidScrollViewOffSet:(CGPoint)offSet;
@end
