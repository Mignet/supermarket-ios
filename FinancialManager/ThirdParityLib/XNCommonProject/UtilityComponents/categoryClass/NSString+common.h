//
//  NSString+common.h
//  GXQApp
//
//  Created by jinfuzi on 14-2-26.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (common)

+(NSString*)stringWithFileSize:(unsigned long long)size;

+(BOOL)isEmptyString:(NSString *)str;

+(NSString*)stringFrom:(NSString*)src withRegex:(NSString*)regex;

+(int)intValueFromHexString:(NSString*)str;

+(BOOL)isVersion:(NSString *)oldVersion NewerThanVersion:(NSString *)newVersion;

+(NSString*)stringFromArray:(NSArray*)array withDelimiter:(NSString*)delimiter;

+(NSString*)urlEncodedWtihDictionary:(NSDictionary*)dictionary;

+(NSString*)urlEncodedCondWtihDictionary:(NSDictionary*)dictionary;

+(NSString*)urlWtihDictionary:(NSDictionary*)dictionary;//xp

-(NSString*)urlEncodedString;

-(NSString*)urlDecodedString;

-(NSString *)md5HexDigest;

-(NSString *)md5HexDigestWithASCIIStringEncoding;

-(NSString *)convertToSecurityBankCardNumber;
- (NSString *)convertToOtherSecurityBankCardNumber;
- (NSString *)convertToSecurityPhoneNumber;
- (NSString *)convertToSecurityUserIdentifyNumber;
- (NSString *)convertToSecurityUserIdentifyLastFourNumber;
- (NSString *)convertToSecurityLastFourBankCardNumber;
- (NSString *)convertToSecurityUserName;

-(CGSize )sizeOfStringWithFont:(CGFloat )font InRect:(CGSize)rect;
- (CGSize)sizeWithStringFont:(CGFloat)font InRect:(CGSize)rect;
//计算UILabel的高度(带有行间距的情况)
-(CGFloat)getSpaceLabelHeightWithFont:(CGFloat)font withWidth:(CGFloat)width lineSpacing:(NSInteger)nLineSpace;

-(BOOL) isValidateMobile;
-(BOOL)isValidatePassword;
-(BOOL)isValidateEmail;

/* xp */
+(NSMutableString *)replaceAllString:(NSString *)str1 WithString:(NSString *)str2 forString:(NSMutableString *)str;

//获取存储路径
+(NSString *)getFilePath:(NSString *)fileName;

#pragma mark - gxqv1.2 - xp -
//有效字符串
-(BOOL)isValidateStr;
//有效身份证
-(BOOL)validateIdentityCard;

+ (NSString *)convertMoney:(long long)money;


- (NSString *)getPureDigitalString; /* 获取字符串中的纯数字子串 */

- (NSInteger)convertToHex;

- (BOOL)isPureInt;

+ (BOOL)bankNumberFormatWithText:(NSString *)text shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string outText:(NSString **)outText;

+ (NSString *)updateSystemTime:(NSString *)systemTime loadingTimeInterval:(NSTimeInterval)loadingTimeInterval;
+ (NSString *)stringFromInterval:(NSTimeInterval )time;
+ (NSTimeInterval )intervalFromDate:(NSString *)date;
+ (NSInteger)intervalSecondFromDate:(NSString *)oldDate;
+ (NSString *)dateStringConvertToFormatStringWithDate:(NSString *)date;
+ (NSString *)dateStringConvertToFormatStringWithDate:(NSString *)date formater:(NSString *)formaterStr;
+ (NSString *)dateStringConverForDynamicToFormatStringWithDate:(NSString *)date formater:(NSString *)formaterStr;
+ (NSDate *)dateFromString:(NSString *)date formater:(NSString *)formaterStr;
+ (NSString *)stringFromDate:(NSDate *)date formater:(NSString *)formaterStr;
+ (NSArray *)dateStringForDays:(NSInteger )days fromDate:(NSDate *)date minDate:(NSDate *)minDate;
+ (NSArray *)dayCountInYear:(NSInteger)year month:(NSInteger )month;
//获取指定字符串对应时间的时间戳字符串
+ (NSString *)convertFromNormalDateString:(NSString *)date format:(NSString *)format;

//money转化单位
+ (NSString *)convertUnits:(NSString *)string;

//删除空格
+ (NSString *)trimString:(NSString *)string;

//创建属性字符串
+ (NSAttributedString *)getAttributeStringWithAttributeArray:(NSArray *)attributeArray;
+ (NSAttributedString *)getAttributeStringWithAttributeArray:(NSArray *)attributeArray alignment:(NSTextAlignment)alignment;

//对url进行编码和解码
+ (NSString *)encodeToPercentEscapeString: (NSString *) input;
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input;

//判断字符是否是汉字
- (BOOL)isChinese;

//是否包含汉字
- (BOOL)includeChinese;
@end
