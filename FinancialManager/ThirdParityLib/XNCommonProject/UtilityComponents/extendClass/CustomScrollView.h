//
//  CustomScrollView.h
//  FinancialManager
//
//  Created by xnkj on 5/17/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomScrollViewDelegate <NSObject>
@optional

- (void)CustomScrollViewDidScrollToIndex:(NSInteger)index;
@end

@interface CustomScrollView : UIView

@property (nonatomic, assign) id<CustomScrollViewDelegate> delegate;
@property (nonatomic, strong) UIColor * pageIndicatorTintColor;
@property (nonatomic, strong) UIColor * currentPageIndicatorTintColor;

- (void)refreshAdScrollViewWithAdUrlObjectArray:(NSArray*)adUrlObjectArr;
- (UIImage *)getCurrentShowImage;
@end
