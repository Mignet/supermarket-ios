//
//  NSData+Base64.h
//  GXQApp
//
//  Created by 王希朋 on 14-9-24.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

//#import <Foundation/Foundation.h>
//
//@interface NSData (Base64)
//
//@end


#import <Foundation/Foundation.h>
@interface NSData (Base64)

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;
@end
