//
//  UIImage+XLUI.m
//  XXXXXX
//
//  Created by JinFuZi on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Common.h"

@implementation UIImage (Common)

+(UIImage*)createEmptyImageOfSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}

+ (UIImage *)imageFromLayer: (CALayer *)theLayer; {
    // draw a view's contents into an image context
    UIGraphicsBeginImageContext(theLayer.frame.size);
    CGContextRef  context = UIGraphicsGetCurrentContext();
    
    [theLayer  renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

// 从一个源图片中按九宫格拉伸到指定大小的图片
-(UIImage*)stretchToImageWithCapInsets:(UIEdgeInsets)capInsets 
                                  newSize:(CGSize)newSize
{
    if (self == nil) {
        return nil;
    }
    UIGraphicsBeginImageContext(newSize);
    
    CGImageRef imgSrcRef = [self CGImage];
    
    // 画左上角
    if (capInsets.left > 0 && capInsets.top > 0) {
        CGImageRef partRef = 
        CGImageCreateWithImageInRect(imgSrcRef,
                                     CGRectMake(0, 
                                                0,
                                                capInsets.left,
                                                capInsets.top));
        UIImage* imgPart = [UIImage imageWithCGImage:partRef];
        [imgPart drawInRect:CGRectMake(0, 0, capInsets.left, capInsets.top)];
        
        CFRelease(partRef);
    }
    
    // 画右上角
    if (capInsets.right > 0 && capInsets.top > 0) {
        CGImageRef partRef = 
        CGImageCreateWithImageInRect(imgSrcRef, 
                                     CGRectMake(self.size.width-capInsets.right, 
                                                0, 
                                                capInsets.right,
                                                capInsets.top));
        UIImage* imgPart = [UIImage imageWithCGImage:partRef];
        [imgPart drawInRect:CGRectMake(newSize.width-capInsets.right, 
                                       0, 
                                       capInsets.right, 
                                       capInsets.top)];
        
        CFRelease(partRef);
    }
    
    // 画左下角
    if (capInsets.left > 0 && capInsets.bottom > 0) {
        CGImageRef partRef = 
        CGImageCreateWithImageInRect(imgSrcRef,
                                     CGRectMake(0, 
                                                self.size.height-capInsets.bottom,
                                                capInsets.left,
                                                capInsets.bottom));
        UIImage* imgPart = [UIImage imageWithCGImage:partRef];
        [imgPart drawInRect:CGRectMake(0, 
                                       newSize.height-capInsets.bottom, 
                                       capInsets.left, 
                                       capInsets.bottom)];
        
        CFRelease(partRef);
    }
    
    // 画右下角
    if (capInsets.right > 0 && capInsets.bottom > 0) {
        CGImageRef partRef = 
        CGImageCreateWithImageInRect(imgSrcRef,
                                     CGRectMake(self.size.width-capInsets.right, 
                                                self.size.height-capInsets.bottom,
                                                capInsets.right,
                                                capInsets.bottom));
        UIImage* imgPart = [UIImage imageWithCGImage:partRef];
        [imgPart drawInRect:CGRectMake(newSize.width-capInsets.right, 
                                       newSize.height-capInsets.bottom, 
                                       capInsets.right, 
                                       capInsets.bottom)];
        
        CFRelease(partRef);
    }
    
    // 画顶部
    if (capInsets.top > 0) {
        CGImageRef partRef = 
        CGImageCreateWithImageInRect(imgSrcRef,
                                     CGRectMake(capInsets.left, 
                                                0,
                                                self.size.width-capInsets.left-capInsets.right,
                                                capInsets.top));
        UIImage* imgPart = [UIImage imageWithCGImage:partRef];
        [imgPart drawInRect:CGRectMake(capInsets.left, 
                                       0, 
                                       newSize.width-capInsets.left-capInsets.right, 
                                       capInsets.top)];
        
        CFRelease(partRef);
    }
    
    // 画左部
    if (capInsets.left > 0) {
        CGImageRef partRef = 
        CGImageCreateWithImageInRect(imgSrcRef,
                                     CGRectMake(0, 
                                                capInsets.top,
                                                capInsets.left,
                                                self.size.height-capInsets.top-capInsets.bottom));
        UIImage* imgPart = [UIImage imageWithCGImage:partRef];
        [imgPart drawInRect:CGRectMake(0, 
                                       capInsets.top,
                                       capInsets.left,
                                       newSize.height-capInsets.top-capInsets.bottom)];
        
        CFRelease(partRef);
    }
    
    // 画右部
    if (capInsets.right > 0) {
        CGImageRef partRef = 
        CGImageCreateWithImageInRect(imgSrcRef,
                                     CGRectMake(self.size.width-capInsets.right, 
                                                capInsets.top,
                                                capInsets.right,
                                                self.size.height-capInsets.top-capInsets.bottom));
        UIImage* imgPart = [UIImage imageWithCGImage:partRef];
        [imgPart drawInRect:CGRectMake(newSize.width-capInsets.right, 
                                       capInsets.top,
                                       capInsets.right,
                                       newSize.height-capInsets.top-capInsets.bottom)];
        
        CFRelease(partRef);
    }
    
    // 画底部
    if (capInsets.bottom > 0) {
        CGImageRef partRef = 
        CGImageCreateWithImageInRect(imgSrcRef,
                                     CGRectMake(capInsets.left, 
                                                self.size.height-capInsets.bottom,
                                                self.size.width-capInsets.left-capInsets.right,
                                                capInsets.bottom));
        UIImage* imgPart = [UIImage imageWithCGImage:partRef];
        [imgPart drawInRect:CGRectMake(capInsets.left, 
                                       newSize.height-capInsets.bottom,
                                       newSize.width-capInsets.left-capInsets.right,
                                       capInsets.bottom)];
        
        CFRelease(partRef);
    }
    
    // 画中部
    {
        CGImageRef partRef = 
        CGImageCreateWithImageInRect(imgSrcRef,
                                     CGRectMake(capInsets.left, 
                                                capInsets.top,
                                                self.size.width-capInsets.left-capInsets.right,
                                                self.size.height-capInsets.top-capInsets.bottom));
        UIImage* imgPart = [UIImage imageWithCGImage:partRef];
        [imgPart drawInRect:CGRectMake(capInsets.left, 
                                       capInsets.top,
                                       newSize.width-capInsets.left-capInsets.right,
                                       newSize.height-capInsets.top-capInsets.bottom)];
        
        CFRelease(partRef);
    }
    
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    // new size
    [self drawInRect:CGRectMake(0,0,size.width,size.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

+ (UIImage *)imageNamedWithSystemScreen:(NSString *)name {
    NSString *imageName = name;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if (screenSize.height == 568) {
        imageName = [NSString stringWithFormat:@"%@-568h", name];
    }
    
    return [UIImage imageNamed:imageName];
}

+(UIImage *)scaleImage:(UIImage *)image toKb:(NSInteger)kb{
   
    if (!image) {
        return image;
    }
    if (kb<1) {
        return image;
    }
    
    kb*=1024;
    
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > kb && compression > maxCompression) {
        
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }

    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

+(UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size{
    UIImage * resultImage = image;
    UIGraphicsBeginImageContext(size);
    [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)resizableImage:(NSString *)imageName {
     UIImage *image = [UIImage imageNamed:imageName];
     // 取图片中部的1 x 1进行拉伸
     UIEdgeInsets insets = UIEdgeInsetsMake(image.size.height/2, image.size.width/2, image.size.height/2 + 1, image.size.width/2 + 1);
     return [image resizableImageWithCapInsets:insets];
}



@end
