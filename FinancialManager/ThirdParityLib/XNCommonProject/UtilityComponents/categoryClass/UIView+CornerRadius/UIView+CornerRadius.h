//
//  UIView+CornerRadius.h
//  FinancialManager
//
//  Created by xnkj on 3/3/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(CornerRadius)

- (void)drawRoundCornerWithRectSize:(CGSize )size
                    backgroundColor:(UIColor *)backgroundColor
                        borderWidth:(CGFloat )borderWith
                        borderColor:(UIColor *)borderColor
                              radio:(CGFloat )radio;

- (UIImage *)getDrawRoundCornerWithRectSize:(CGSize )size
                            backgroundColor:(UIColor *)backgroundColor
                                borderWidth:(CGFloat )borderWith
                                borderColor:(UIColor *)borderColor
                                      radio:(CGFloat )radio;
@end

@interface UIImageView(CornerRadius)

- (void)drawRoundCornerRadio:(CGFloat )radio;
@end

@interface UIImage(CornerRadius)

- (UIImage *)drawRoundCornerWithRadius:(CGFloat )radius sizeToFit:(CGSize )size;
@end
