//
//  UIImage+BlurImage.h
//  TextBlurImge
//
//  Created by 张野 on 14-4-29.
//  Copyright (c) 2014年 com.jinfuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BlurImage)
- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;
@end
