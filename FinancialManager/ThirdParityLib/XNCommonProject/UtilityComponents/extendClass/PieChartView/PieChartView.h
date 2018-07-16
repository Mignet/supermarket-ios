//
//  PieChartView.h
//  FinancialManager
//
//  Created by ancye.Xie on 11/23/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieChartView : UIView

- (id)initWithFrame:(CGRect)frame withStrokeWidth:(CGFloat)width bgColor:(UIColor *)color percentArray:(NSArray *)perArray isAnimation:(BOOL)animation;

@end
