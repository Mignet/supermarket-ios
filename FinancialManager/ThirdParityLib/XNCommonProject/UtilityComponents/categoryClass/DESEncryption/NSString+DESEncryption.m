//
//  NSString+DESEncryption.m
//  GXQApp
//
//  Created by 王希朋 on 14-9-24.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import "NSString+DESEncryption.h"
#import <CommonCrypto/CommonCryptor.h>
#import "NSData+Base64.h"

@implementation NSString (DESEncryption)

//加密dubug
const NSString *key = @"K47XSXE8";
const NSString *iv = @"87654321";
+ (NSString *) encryptUseDES:(NSString *)plainText
{
    NSData* ivData = [iv dataUsingEncoding: NSUTF8StringEncoding];
    Byte *ivBytes = (Byte *)[ivData bytes];
    NSString *ciphertext = nil;
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          ivBytes,
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [data base64EncodedString];
    }
    return ciphertext;
}

+ (NSString *) encryptUseDES:(NSString *)plainText withKey:(NSString *)key withIV:(NSString *)iv {
    NSData* ivData = [iv dataUsingEncoding: NSUTF8StringEncoding];
    Byte *ivBytes = (Byte *)[ivData bytes];
    NSString *ciphertext = nil;
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          ivBytes,
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [data base64EncodedString];
    }
    return ciphertext;
}

+ (NSString *)decryptUseDES:(NSString *)cipherText
{
    NSData* ivData = [iv dataUsingEncoding: NSUTF8StringEncoding];
    Byte *ivBytes = (Byte *)[ivData bytes];
    NSString *plaintext = nil;
    //    NSData *cipherdata = [Base64 decode:cipherText];
    NSData *cipherdata = [NSData dataWithBase64EncodedString:cipherText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          ivBytes,
                                          [cipherdata bytes], [cipherdata length],
                                          buffer, 1024,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    return plaintext;
}

+ (NSString *)decryptUseDES:(NSString *)cipherText withKey:(NSString *)key withIV:(NSString *)iv {
    NSData* ivData = [iv dataUsingEncoding: NSUTF8StringEncoding];
    Byte *ivBytes = (Byte *)[ivData bytes];
    NSString *plaintext = nil;
    //    NSData *cipherdata = [Base64 decode:cipherText];
    NSData *cipherdata = [NSData dataWithBase64EncodedString:cipherText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          ivBytes,
                                          [cipherdata bytes], [cipherdata length],
                                          buffer, 1024,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    return plaintext;
}


+ (NSString *)decryptDes:(NSString *)cipherText withKey:(NSString *)key
{
    NSString *plaintext = nil;
    NSData *cipherdata = [cipherText dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          NULL,
                                          [cipherdata bytes], [cipherdata length],
                                          buffer, 1024,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    return plaintext;
}

@end
