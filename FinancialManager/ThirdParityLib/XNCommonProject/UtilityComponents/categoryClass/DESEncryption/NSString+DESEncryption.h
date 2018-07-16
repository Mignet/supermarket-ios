//
//  NSString+DESEncryption.h
//  GXQApp
//
//  Created by 王希朋 on 14-9-24.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DESEncryption)

+ (NSString *) encryptUseDES:(NSString *)plainText;
+ (NSString *) encryptUseDES:(NSString *)plainText withKey:(NSString *)key withIV:(NSString *)iv;

+ (NSString *)decryptUseDES:(NSString *)cipherText;
+ (NSString *)decryptUseDES:(NSString *)plainText withKey:(NSString *)key withIV:(NSString *)iv;

+ (NSString *)decryptDes:(NSString *)cipherText withKey:(NSString *)key;
@end
