//
//  UILabel+Extend.h
//  FinancialManager
//
//  Created by xnkj on 15/10/9.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel(Extend)

- (void)refreshPropertyArray:(NSArray *)propertyArray Alignment:(NSTextAlignment)textAlignment;

//计算label的高度
- (CGFloat )adjustLabelHeightInSize:(CGSize)size fontSize:(UIFont *)font;

//计算标题的长度
- (CGFloat )caculateLabelLengthInSize:(CGSize)size fontSize:(UIFont *)font;
@end
