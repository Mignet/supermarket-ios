//
//  NSString+Digest.h
//  JinFuZiApp
//
//  Created by ganquan on 3/9/15.
//  Copyright (c) 2015 com.jinfuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Digest)

- (NSString *)md5;
- (NSString *)sha1;
- (NSString *)base64;
- (NSString *)debase64;

@end
