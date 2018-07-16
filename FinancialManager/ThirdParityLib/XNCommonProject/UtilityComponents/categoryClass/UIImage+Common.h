//
//  UIImage+XLUI.h
//  XXXXXX
//
//  Created by JinFuZi on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Common)

+ (UIImage*)createEmptyImageOfSize:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
- (UIImage *)imageWithSize:(CGSize)size;

// 从一个源图片中按九宫格拉伸到指定大小的图片
-(UIImage*)stretchToImageWithCapInsets:(UIEdgeInsets)capInsets
                                  newSize:(CGSize)newSize;

+ (UIImage *)imageFromLayer: (CALayer *)theLayer;

+ (UIImage *)imageNamedWithSystemScreen:(NSString *)name;

//压缩图片到指定大小
+(UIImage *)scaleImage:(UIImage *)image toKb:(NSInteger)kb;

+(UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size;

// 设置图片不拉伸
+ (UIImage *)resizableImage:(NSString *)imageName;




@end
