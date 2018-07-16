//
//  UIView+CornerRadius.m
//  FinancialManager
//
//  Created by xnkj on 3/3/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "UIView+CornerRadius.h"
#import <CoreGraphics/CoreGraphics.h>

#define XDIRECTION @"x"
#define YDIRECTION @"y"

@implementation UIView(CornerRadius)

#pragma mark - 绘制圆角
- (void)drawRoundCornerWithRectSize:(CGSize )size
                    backgroundColor:(UIColor *)backgroundColor
                        borderWidth:(CGFloat )borderWith
                        borderColor:(UIColor *)borderColor
                              radio:(CGFloat )radio
{
    
    UIImage * image = [self getDrawRoundCornerWithRectSize:(CGSize )size
                                               backgroundColor:backgroundColor
                                                   borderWidth:borderWith
                                                   borderColor:borderColor
                                                         radio:radio];
    
    UIImageView * bgImageView = [[UIImageView alloc]initWithImage:image];
    
    [self insertSubview:bgImageView atIndex:0];

    
//    weakSelf(weakSelf)
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//       
//        UIImage * image = [weakSelf getDrawRoundCornerWithRectSize:(CGSize )size
//                                               backgroundColor:backgroundColor
//                                                   borderWidth:borderWith
//                                                   borderColor:borderColor
//                                                         radio:radio];
//        
//        UIImageView * bgImageView = [[UIImageView alloc]initWithImage:image];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//           
//            [weakSelf insertSubview:bgImageView atIndex:0];
//        });
//    });
}

- (UIImage *)getDrawRoundCornerWithRectSize:(CGSize )size
                            backgroundColor:(UIColor *)backgroundColor
                                borderWidth:(CGFloat )borderWith
                                borderColor:(UIColor *)borderColor
                                      radio:(CGFloat )radio
{
    CGSize sizeToFit = CGSizeMake(size.width,size.height);
    CGFloat halfBorderWidth = borderWith / 2.0;
    
    UIGraphicsBeginImageContextWithOptions(sizeToFit, false, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat width = sizeToFit.width;
    CGFloat height = sizeToFit.height;
    
    //绘制圆角
    CGContextMoveToPoint(context, width - halfBorderWidth, radio + halfBorderWidth);  // 开始坐标右边开始
    CGContextAddArcToPoint(context, width - halfBorderWidth, height - halfBorderWidth, width - radio - halfBorderWidth, height - halfBorderWidth, radio);  // 右下角角度
    CGContextAddArcToPoint(context, halfBorderWidth, height - halfBorderWidth, halfBorderWidth, height - radio - halfBorderWidth, radio); // 左下角角度
    CGContextAddArcToPoint(context, halfBorderWidth, halfBorderWidth, width - halfBorderWidth, halfBorderWidth, radio); // 左上角
    CGContextAddArcToPoint(context, width - halfBorderWidth, halfBorderWidth, width - halfBorderWidth, radio + halfBorderWidth, radio); // 右上角
    
    //填充颜色
    CGContextSetLineWidth(context, borderWith);
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIImage * outPutImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outPutImage;
}

@end

@implementation UIImageView(CornerRadius)

- (void)drawRoundCornerRadio:(CGFloat )radio
{
    self.image = [self.image drawRoundCornerWithRadius:radio sizeToFit:self.bounds.size];
}
@end


@implementation UIImage(CornerRadius)

- (UIImage *)drawRoundCornerWithRadius:(CGFloat )radius sizeToFit:(CGSize )size
{
    UIGraphicsBeginImageContextWithOptions(size, false, [[UIScreen mainScreen] scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPathRef  path = [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)] CGPath];
    
    CGContextAddPath(context, path);
    
    //对图片进行剪切
    CGContextClip(context);
    
    [self drawInRect:CGRectMake(0 , 0, size.width, size.height)];
    
    CGContextDrawPath(context, kCGPathFill);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
