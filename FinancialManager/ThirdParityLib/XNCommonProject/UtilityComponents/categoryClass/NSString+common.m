//
//  NSString+common.m
//  GXQApp
//
//  Created by jinfuzi on 14-2-26.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import "NSString+common.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (common)

+(NSString*)stringWithFileSize:(unsigned long long)size {
    if (size < 1000) {
        return [NSString stringWithFormat:@"%llu", size];
    } else if(size < 1000 * 1024){
        return [NSString stringWithFormat:@"%.2fKB", size / 1024.0];
    } else if(size < 1000 * 1024 * 1024){
        return [NSString stringWithFormat:@"%.2fMB", size / (1024.0 * 1024)];
    } else {
        return [NSString stringWithFormat:@"%.2fGB", size / (1024.0 * 1024 * 1024)];
    }
}

+(BOOL)isEmptyString:(NSString *)str {
    if (str) {
        const char* ch = [str cStringUsingEncoding:NSUTF8StringEncoding];
        while (*ch) {
            switch (*ch) {
                case ' ' :
                case '\n':
                case '\r':
                case '\t':
                    break;
                default:
                    return NO;
            }
            ch++;
        }
    }
    return YES;
}


+(NSString*)stringFrom:(NSString*)src withRegex:(NSString*)regex {
    NSRegularExpression* o_regex = [NSRegularExpression regularExpressionWithPattern:regex
                                                                             options:0 error:nil];
    NSTextCheckingResult* ret = [o_regex firstMatchInString:src options:0
                                                      range:NSMakeRange(0, src.length)];
    if (ret && ret.range.location != NSNotFound) {
        if (ret.numberOfRanges > 1) {
            return [src substringWithRange:[ret rangeAtIndex:1]];
        } else {
            return [src substringWithRange:ret.range];
        }
    }
    
    return nil;
}

+(int)intValueFromHexString:(NSString*)hex {
    hex = [hex lowercaseString];
    if ([hex hasPrefix:@"0x"]) {
        hex = [hex substringFromIndex:2];
    }
    int ret = 0;
    const char* ch = [hex UTF8String];
    int length = (int)hex.length;
    for (int i = length - 1; i >= 0; i--) {
        if (ch[i] >= '0' && ch[i] <= '9') {
            ret += (ch[i] - '0') * powf(16, (length - 1 - i));
        } else if(ch[i] >= 'a' && ch[i] <= 'f') {
            ret += (ch[i] - 'a' + 10) * powf(16, (length - 1 - i));
        }
    }
    return ret;
}

+(BOOL)isVersion:(NSString *)oldVersion NewerThanVersion:(NSString *)newVersion
{
    return ([oldVersion compare:newVersion options:NSNumericSearch] == NSOrderedDescending);
}

+(NSString *)stringFromArray:(NSArray *)array withDelimiter:(NSString *)delimiter {
    NSMutableString* str = [[NSMutableString alloc] init];
    for (int i = 0; i < array.count; i++) {
        NSString* s = [array objectAtIndex:i];
        [str appendString:s];
        if (i < array.count - 1) {
            [str appendString:delimiter];
        }
    }
    return str;
}

+(NSString*)urlEncodedWtihDictionary:(NSDictionary*)dictionary {
    NSMutableString* string = [[NSMutableString alloc] init];
    NSArray* keys = dictionary.allKeys;
    for (int i = 0; i < keys.count; i++) {
        NSString* key = [keys objectAtIndex:i] ;
        NSString* value = [dictionary objectForKey:key];
//        key = [key urlEncodedString];
//        value = [value urlEncodedString];
        [string appendFormat:@"%@=%@", key, value];
        if (i < keys.count - 1) {
            [string appendString:@"&"];
        }
    }
    return [NSString stringWithString:string];
}

+(NSString*)urlEncodedCondWtihDictionary:(NSDictionary*)dictionary {
    NSMutableString* string = [[NSMutableString alloc] init];
    NSArray* keys = dictionary.allKeys;
    for (int i = 0; i < keys.count; i++) {
        NSString* key = [keys objectAtIndex:i] ;
        NSString* value = [dictionary objectForKey:key];
//        key = [key urlEncodedString];
        key = [NSString stringWithFormat:@"cond[%@]", key];
//        value = [value urlEncodedString];
        [string appendFormat:@"%@=%@", key, value];
        if (i < keys.count - 1) {
            [string appendString:@"&"];
        }
    }
    return [NSString stringWithString:string];
}
//xp
+(NSString*)urlWtihDictionary:(NSDictionary*)dictionary {
    NSMutableString* string = [[NSMutableString alloc] init];
    NSArray* keys = dictionary.allKeys;
    for (int i = 0; i < keys.count; i++) {
        NSString* key = [keys objectAtIndex:i] ;
        NSString* value = [dictionary objectForKey:key];
//        key = [key urlEncodedString];
        key = [NSString stringWithFormat:@"cond[%@]", key];
//        value = [value urlEncodedString];
        [string appendFormat:@"%@=%@", key, value];
        if (i < keys.count - 1) {
            [string appendString:@"&"];
        }
    }
    return [NSString stringWithString:string];
}

- (NSString *)urlEncodedString {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(__bridge CFStringRef)self,NULL, CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8));
	return result;
}

-(NSString*)urlDecodedString {
    char words[self.length];
    int k = 0;
    
    for (int i = 0; i < self.length; i++, k++) {
        unichar ch = [self characterAtIndex:i];
        if (ch == '%') {
            NSString* s = [self substringWithRange:NSMakeRange(i+1, 2)];
            int n = [NSString intValueFromHexString:s];
            if (n >= 128) {
                n -= 256;
            }
            words[k] = n;
            i += 2;
        } else {
            words[k] = ch;
        }
    }
    
    words[k] = 0;
    
    return [NSString stringWithUTF8String:words];
}

-(NSString *)md5HexDigest
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash uppercaseString];
}

-(NSString *)md5HexDigestWithASCIIStringEncoding
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

-(BOOL)isValidateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isPureInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

/*手机号码验证 */
-(BOOL) isValidateMobile
{
    if (![NSObject isValidateInitString:self]) {
        
        return NO;
    }
    
    if (![[self substringToIndex:1] isEqualToString:@"1"]) {
        
        return NO;
    }
    
    NSString * phoneRegex = @"^\\d{11}$";
    NSPredicate * phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    return [phoneTest evaluateWithObject:self];
}

#pragma mark - 验证登入密码是否有效
- (BOOL)isValidatePassword
{
    if (self.length >= 6 && self.length <= 20) {
        
        return YES;
    }
    
    return NO;
}

/* xp */
+(NSMutableString *)replaceAllString:(NSString *)str1 WithString:(NSString *)str2 forString:(NSMutableString *)str{
    NSRange range = [str rangeOfString:str1];
    while (range.length>0) {
        [str replaceCharactersInRange:range withString:str2];
        range = [str rangeOfString:str1];
    }
    return str;
}

//获取存储路径
+(NSString *)getFilePath:(NSString *)fileName{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:fileName];
}

- (CGSize )sizeOfStringWithFont:(CGFloat )font InRect:(CGSize )rect
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:font], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize sizeObj = ([self boundingRectWithSize:rect options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil]).size;
    
    return sizeObj;
}

- (CGSize)sizeWithStringFont:(CGFloat)font InRect:(CGSize)rect
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attr = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:font], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size = [self boundingRectWithSize:rect options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    return size;
}

#pragma mark - 计算UILabel的高度(带有行间距的情况)
-(CGFloat)getSpaceLabelHeightWithFont:(CGFloat)font withWidth:(CGFloat)width lineSpacing:(NSInteger)nLineSpace {
   
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = nLineSpace;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, 1000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}


/* xp */

#pragma mark - gxqv1.2 - xp -
/* gxqv1.2 */
-(BOOL)isValidateStr{
    if (self && ![self isEqualToString:@""] && ![self isEqualToString:@"(null)"]) {
        return true;
    }
    return false;
}

/* 身份证号码验证 */
-(BOOL)validateIdentityCard
{
    BOOL flag;
    if (self.length <= 0) {
        flag = NO;
        return flag;
    }
    
    if ([self chk18PaperId:self]) {
        NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
        NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
        return [identityCardPredicate evaluateWithObject:self];
    }
    return NO;
}


//////////////////////////
#pragma mark - 身份证号码验证
//////////////////////////////////////////
/**
 * 功能:获取指定范围的字符串
 * 参数:字符串的开始小标
 * 参数:字符串的结束下标
 */
-(NSString *)getStringWithRange:(NSString *)str Value1:(NSInteger)value1 Value2:(NSInteger)value2;
{
    return [str substringWithRange:NSMakeRange(value1,value2)];
}

/*
 * 功能:判断是否在地区码内
 * 参数:地区码
 */
-(BOOL)areaCode:(NSString *)code
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        return NO;
    }
    
    return YES;
}

/*
 * 功能:验证身份证是否合法
 * 参数:输入的身份证号
 */

-(BOOL)chk18PaperId:(NSString *)sPaperId
{
    //判断位数
    if ([sPaperId length] != 15 && [sPaperId length] != 18) {
        return NO;
    }
    
    NSString *carid = sPaperId;
    long lSumQT = 0;
    //加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    //校验码
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    //将15位身份证号转换成18位
    NSMutableString *mString = [NSMutableString stringWithString:sPaperId];
    if ([sPaperId length] == 15) {
        [mString insertString:@"19" atIndex:6];
        
        long p = 0;
        const char *pid = [mString UTF8String];
        
        for (int i=0; i<=16; i++)
        {
            p += (pid[i]-48) * R[i];
        }
        
        int o = p%11;
        
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        
        carid = mString;
    }
    
    //判断地区码
    NSString * sProvince = [carid substringToIndex:2];
    if (![self areaCode:sProvince]) {
        return NO;
    }
    
    //判断年月日是否有效
    //年份
    int strYear = [[self getStringWithRange:carid Value1:6 Value2:4] intValue];
    //月份
    int strMonth = [[self getStringWithRange:carid Value1:10 Value2:2] intValue];
    //日
    int strDay = [[self getStringWithRange:carid Value1:12 Value2:2] intValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    //Bug Fix START 2014.12.08 App version :1.5
    //V1.5以前都存在的bug
    //当系统时间设置为12小时制时，日期格式用大写的HH会导致dateformatter不能生成date
    //这样就误判了身份证的年月日
#if 0
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
#else
    //获取系统是24小时制或者12小时制
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    if (hasAMPM) {
        //hasAMPM==TURE为12小时制，否则为24小时制
        //12小时制的日期要用小写的h
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    }
    else
    {
        //24小时制的日期要用大写的H
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
#endif
    //Bug Fix END 2014.12.08 App version :1.5
    
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    if (date == nil) {
        return NO;
    }
    
    const char *PaperId  = [carid UTF8String];
    //检验长度
    if( 18 != strlen(PaperId)) return -1;
    
    //校验数字
    for (int i=0; i<18; i++)
    {
        if (!isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i))
        {
            return NO;
        }
    }
    
    //验证最末的校验码
    for (int i=0; i<=16; i++)
    {
        lSumQT += (PaperId[i]-48) * R[i];
    }
    if (sChecker[lSumQT%11] != PaperId[17])
    {
        return NO;
    }
    
    return YES;
}
/* xp */

+ (NSString *)convertMoney:(long long)money {
//    if (money < 10000) {
//        return [NSString stringWithFormat:@"%lld元", money];
//    }
//    else /*(money < 10000 * 10000)*/ {
        return [NSString stringWithFormat:@"%.2lf万", (double)money];
//    }
}

- (NSString *)getPureDigitalString
{
    NSMutableString *pureDigitalStr = [[NSMutableString alloc] init];
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSString *tempStr;
    while (![scanner isAtEnd]) {
        // Throw away characters before the first number.
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        
        // Collect numbers.
        [scanner scanCharactersFromSet:numbers intoString:&tempStr];
        [pureDigitalStr appendString:tempStr];
        tempStr = @"";
    }
    
    return pureDigitalStr;
}

- (NSInteger)convertToHex
{
    //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
    NSInteger hexColor = strtoul([self UTF8String], 0, 16);
    return hexColor;
}

+ (BOOL)bankNumberFormatWithText:(NSString *)text shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string outText:(NSString **)outText {
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return NO;
    }
    
    text = [text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *newString = @"";
    while (text.length > 0) {
        NSString *subString = [text substringToIndex:MIN(text.length, 4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4) {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length, 4)];
    }
    
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    *outText = newString;
    if (newString.length >= 20) {
        return NO;
    }
    
    return NO;
}

-(NSString *)convertToSecurityBankCardNumber
{
    NSInteger length = [self length];
    
    return [NSString stringWithFormat:@"%@ **** **** %@",[self substringToIndex:4],[self substringFromIndex:length - 4]];
}

- (NSString *)convertToOtherSecurityBankCardNumber
{
    NSInteger length = [self length];
    
    return [NSString stringWithFormat:@"**************%@",[self substringFromIndex:length - 4]];
}

- (NSString *)convertToSecurityPhoneNumber
{
    if ([self isNumText]) {
        
        NSInteger length = [self length];
        
        if (self.length > 0) {
            
            return [NSString stringWithFormat:@"%@****%@",[self substringToIndex:3],[self substringFromIndex:length - 4]];
        }
        
        return @"";
    }
    
    return self;
}

- (NSString *) trimming {
    
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
}

- (BOOL)isNumText{
    
    if ([[self stringByTrimmingCharactersInSet: [NSCharacterSet decimalDigitCharacterSet]]trimming].length >0) {
      
        return NO;
    }else{
        return YES;
    }
}

- (NSString *)convertToSecurityUserIdentifyNumber
{
    NSInteger length = [self length];
    
    NSString * formateStr = @"";
    for (int i = 0 ; i <= length - 10; i ++ ) {
        
        formateStr = [formateStr stringByAppendingString:@"*"];
    }
    
    return [NSString stringWithFormat:@"%@*** %@ %@",[self substringToIndex:3],formateStr,[self substringFromIndex:length - 4]];
}

- (NSString *)convertToSecurityUserIdentifyLastFourNumber
{
    NSInteger length = self.length;
    return [NSString stringWithFormat:@"**** **** **** %@",[self substringFromIndex:length - 4]];
}

- (NSString *)convertToSecurityLastFourBankCardNumber
{
    NSInteger length = self.length;
    return [NSString stringWithFormat:@"**** **** **** %@",[self substringFromIndex:length - 4]];
}

- (NSString *)convertToSecurityUserName
{
    return [NSString stringWithFormat:@"*%@",[self substringFromIndex:([self rangeOfComposedCharacterSequenceAtIndex:0].location + [self rangeOfComposedCharacterSequenceAtIndex:0].length)]];
}

#pragma mark - 获取指定时间在系统时间外的时间
+ (NSString *)updateSystemTime:(NSString *)systemTime loadingTimeInterval:(NSTimeInterval)loadingTimeInterval
{
    NSTimeInterval systeTimeInterval = [NSString intervalFromDate:systemTime];
    
    NSTimeInterval interval = ([NSString intervalFromDate:[NSString stringFromDate:[NSDate date] formater:@"YYYY-MM-dd HH:mm:ss"]] -loadingTimeInterval);
    
    systeTimeInterval = systeTimeInterval + interval;
    
    NSDate * nowDate = [NSDate dateWithTimeIntervalSince1970:systeTimeInterval];
    
    NSString * timeNow = [NSString stringFromDate:nowDate formater:@"YYYY-MM-dd HH:mm:ss"];
    
    return timeNow;
}


#pragma mark - 转化为时间戳
+ (NSTimeInterval )intervalFromDate:(NSString *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate * minDate = [formatter dateFromString:date];
    
    NSInteger interval = [minDate timeIntervalSince1970];
    
    return interval;
}

#pragma mark - 时间间隔
+ (NSInteger)intervalSecondFromDate:(NSString *)oldDate
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YY-MM-dd HH:mm:ss"];
    NSDate * minDate = [formatter dateFromString:oldDate];
    
    NSInteger oldInterval = [minDate timeIntervalSince1970];
    NSInteger currentinterval = [[NSDate date] timeIntervalSince1970];

    return currentinterval - oldInterval;
}

#pragma mark - 将秒转化为时间
+ (NSString *)stringFromInterval:(NSTimeInterval )time
{
    NSString * hourStr = @"";
    NSString * minStr = @"";
    NSString * secondStr = @"";
    
    int hour = time / 3600;
    if (hour <= 9) {
        
        hourStr = [NSString stringWithFormat:@"0%d",hour];
    }else
    {
        hourStr = [NSString stringWithFormat:@"%d",hour];
    }
    
    int min = ((long long)time % 3600) / 60;
    if (min <= 9) {
        
        minStr = [NSString stringWithFormat:@"0%d",min];
    }else
    {
        minStr = [NSString stringWithFormat:@"%d",min];
    }
    
    int second = time - hour * 3600 - min * 60;
    if (second <= 9) {
        
        secondStr = [NSString stringWithFormat:@"0%d",second];
    }else
    {
        secondStr = [NSString stringWithFormat:@"%d",second];
    }
    
    
    
    return [NSString stringWithFormat:@"%@:%@:%@",hourStr,minStr,secondStr];
}

#pragma mark - 将时间字符串转化为指定的中文格式字符串
+ (NSString *)dateStringConvertToFormatStringWithDate:(NSString *)date
{
    NSDateComponents * nowComps = nil;
    NSDateComponents * chatComps = nil;
    NSDateFormatter * formater = nil;
    NSDate * chatDate = nil;
    NSCalendar *calendar = nil;
    NSString * chatDateStr = @"";
    
    formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"YYYY-MM-dd HH:mm"];
    chatDate = [formater dateFromString:date];
    
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//设置成中国阳历
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;//这句我也不明白具体时用来做什么。。。
    nowComps = [calendar components:unitFlags fromDate:[NSDate date]];
    chatComps = [calendar components:unitFlags fromDate:chatDate];
    
    //开始计算
    if (nowComps.day - chatComps.day == 1) {
        
        chatDateStr = [NSString stringWithFormat:@"昨天 %@:%@",[NSNumber numberWithInteger:chatComps.hour],[NSNumber numberWithInteger:chatComps.minute]];
    }else if(nowComps.day - chatComps.day == 2)
    {
        chatDateStr = [NSString stringWithFormat:@"前天 %@:%@",[NSNumber numberWithInteger:chatComps.hour],[NSNumber numberWithInteger:chatComps.minute]];
    }else
        chatDateStr = [[[formater stringFromDate:chatDate] componentsSeparatedByString:@" "] firstObject];
    
    return chatDateStr;
}

#pragma mark - 根据具体的格式进行转化
+ (NSString *)dateStringConvertToFormatStringWithDate:(NSString *)date formater:(NSString *)formaterStr
{
    NSDateComponents * nowComps = nil;
    NSDateComponents * chatComps = nil;
    NSDateFormatter * formater = nil;
    NSDate * chatDate = nil;
    NSCalendar *calendar = nil;
    NSString * chatDateStr = @"";
    
    formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:formaterStr];
    chatDate = [formater dateFromString:date];
    
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//设置成中国阳历
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;//这句我也不明白具体时用来做什么。。。
    nowComps = [calendar components:unitFlags fromDate:[NSDate date]];
    chatComps = [calendar components:unitFlags fromDate:chatDate];
    
    //开始计算
    if (nowComps.day - chatComps.day == 1) {
        
        chatDateStr = [NSString stringWithFormat:@"昨天 %@:%@",[NSNumber numberWithInteger:chatComps.hour],[NSNumber numberWithInteger:chatComps.minute]];
    }else if(nowComps.day - chatComps.day == 2)
    {
        chatDateStr = [NSString stringWithFormat:@"前天 %@:%@",[NSNumber numberWithInteger:chatComps.hour],[NSNumber numberWithInteger:chatComps.minute]];
    }else
        chatDateStr = [formater stringFromDate:chatDate];
    
    return chatDateStr;
}

#pragma mark - 动态时间转化
+ (NSString *)dateStringConverForDynamicToFormatStringWithDate:(NSString *)date formater:(NSString *)formaterStr
{
    NSDateComponents * nowComps = nil;
    NSDateComponents * chatComps = nil;
    NSDateFormatter * formater = nil;
    NSDate * chatDate = nil;
    NSCalendar *calendar = nil;
    NSString * chatDateStr = @"";
    
    formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:formaterStr];
    chatDate = [formater dateFromString:date];
    
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//设置成中国阳历
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;//这句我也不明白具体时用来做什么。。。
    nowComps = [calendar components:unitFlags fromDate:[NSDate date]];
    chatComps = [calendar components:unitFlags fromDate:chatDate];
    
    //开始计算
    if ((nowComps.day - chatComps.day == 0) && (nowComps.month == chatComps.month) && (nowComps.year == chatComps.year)) {
        
        chatDateStr = chatComps.minute > 9?[NSString stringWithFormat:@"今天 %@:%@",[NSNumber numberWithInteger:chatComps.hour],[NSNumber numberWithInteger:chatComps.minute]]:[NSString stringWithFormat:@"今天 %@:%@",[NSNumber numberWithInteger:chatComps.hour],[NSString stringWithFormat:@"0%@",[NSNumber numberWithInteger:chatComps.minute]]];
    }else if((nowComps.day - chatComps.day == 1) && (nowComps.month == chatComps.month) && (nowComps.year == chatComps.year))
    {
        chatDateStr = chatComps.minute > 9?[NSString stringWithFormat:@"昨天 %@:%@",[NSNumber numberWithInteger:chatComps.hour],[NSNumber numberWithInteger:chatComps.minute]]:[NSString stringWithFormat:@"昨天 %@:%@",[NSNumber numberWithInteger:chatComps.hour],[NSString stringWithFormat:@"0%@",[NSNumber numberWithInteger:chatComps.minute]]];
    }else
        chatDateStr = [formater stringFromDate:chatDate];
    
    return chatDateStr;
}

#pragma mark - 字符串转化为时间
+ (NSDate *)dateFromString:(NSString *)date formater:(NSString *)formaterStr
{
    NSDateFormatter * formater = nil;
    NSDate * chatDate = nil;
    
    formater = [[NSDateFormatter alloc]init];
    
    NSTimeZone * zone = [NSTimeZone systemTimeZone];

//    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
//    [formater setTimeZone:GTMzone];
    [formater setTimeZone:zone];
    [formater setDateFormat:formaterStr];
    chatDate = [formater dateFromString:date];
    
    return chatDate;
}

#pragma mark - 日期转化为字符串
+ (NSString *)stringFromDate:(NSDate *)date formater:(NSString *)formaterStr
{
    NSDateFormatter * formater = nil;
    NSString * chatDateStr = @"";
    
    formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:formaterStr];
    chatDateStr = [formater stringFromDate:date];
    
    return chatDateStr;
}

#pragma mark - 指定日期前几天内的日期数组
+ (NSArray *)dateStringForDays:(NSInteger )days fromDate:(NSDate *)date minDate:(NSDate *)minDate
{
    NSDate * currentDate = nil;
    NSString * currentDateStr = @"";
    NSMutableArray * dateArray = [NSMutableArray array];
    for (int i = 0 ; i < days; i++) {
        
        currentDate = [NSDate dateWithTimeIntervalSinceNow:-24*60*60*i];
       
        if ([currentDate compare:minDate] == NSOrderedAscending) {
            
            break;
        }
       
        currentDateStr = [NSString stringFromDate:currentDate formater:@"yyyy-MM-dd"]; //注意：YYYY-MM-dd是按照周来算的年份，而我们要使用yyyy-MM-dd来计算
        [dateArray addObject:currentDateStr];
    }
    
    return dateArray;
}

#pragma mark - 转换单位
+ (NSString *)convertUnits:(NSString *)string
{
    NSString *convertString = @"";
    
    if ([string doubleValue] >= 1000000 && [string integerValue] != 0)
    {
        CGFloat value = [string floatValue];
        value = value / 10000;
        NSString * str_Value = [NSString stringWithFormat:@"%f",value];
        
        NSInteger index = str_Value.length;
        if ([[str_Value componentsSeparatedByString:@"."] count] > 1) {
            
            index = [str_Value rangeOfString:@"."].location + 3;
        }
        
        convertString = [NSString stringWithFormat:@"%@万",[str_Value substringToIndex:index]];
    }
    else
    {
        convertString = [NSString  stringWithFormat:@"%.2f", [string doubleValue]];
    }
    return convertString;
}

#pragma mark - 删除空格
+ (NSString *)trimString:(NSString *)string
{
    NSMutableString *mStr = [string mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef)mStr);
    NSString *result = [mStr copy];
    
    return result;
}

//创建属性字符串
+ (NSAttributedString *)getAttributeStringWithAttributeArray:(NSArray *)attributeArray
{
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc]init];
    
    NSDictionary * attributeDic = nil;
    for (NSDictionary * dic in attributeArray) {
        
        attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                        (id)[dic valueForKey:@"color"], NSForegroundColorAttributeName,
                        (id)[dic valueForKey:@"font"], kCTFontAttributeName,
                        nil];
        
        [attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:[dic valueForKey:@"range"] attributes:attributeDic]];
    }
    
    return attributeString;
}

+ (NSAttributedString *)getAttributeStringWithAttributeArray:(NSArray *)attributeArray alignment:(NSTextAlignment)alignment
{
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc]init];
    
    NSDictionary * attributeDic = nil;
    for (NSDictionary * dic in attributeArray) {

        attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                            (id)[dic valueForKey:@"color"], NSForegroundColorAttributeName,
                            (id)[dic valueForKey:@"font"], kCTFontAttributeName,
                            nil];
        
        [attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:[dic valueForKey:@"range"] attributes:attributeDic]];
    }
    
    NSMutableParagraphStyle *styleAlignment = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [styleAlignment setAlignment:alignment];
    NSDictionary *attr = [NSDictionary dictionaryWithObject:styleAlignment forKey:NSParagraphStyleAttributeName];
    [attributeString addAttributes:attr range:NSMakeRange(0, [attributeString length])];
    
    return attributeString;
}

#pragma mark - 计算某年某月的日期数组
+ (NSArray *)dayCountInYear:(NSInteger)year month:(NSInteger )month
{
    if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12))
        return [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31", nil];
    
    if((month == 4) || (month == 6) || (month == 9) || (month == 11))
        return [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30", nil];
    
    if((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3) || year % 100 == 0)
    {
        return [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28", nil];
    }
    
    return [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29", nil];
}

//获取指定字符串对应时间的时间戳字符串
+ (NSString *)convertFromNormalDateString:(NSString *)date format:(NSString *)format
{
    NSDate * currentDate = [NSString dateFromString:date formater:format];
    
    NSString * timerIntervalStr = [NSString stringWithFormat:@"%@",[NSNumber numberWithUnsignedLongLong:[currentDate timeIntervalSince1970]]];
    
    return timerIntervalStr;
}

#pragma mark - 对url进行编码
+ (NSString *)encodeToPercentEscapeString: (NSString *) input

{
    
    NSString *outputStr =
    
    (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                 
                                                                 NULL, /* allocator */
                                                                 
                                                                 (__bridge CFStringRef)input,
                                                                 
                                                                 NULL, /* charactersToLeaveUnescaped */
                                                                 
                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                 
                                                                 kCFStringEncodingUTF8);
    
    return outputStr;
    
}

#pragma mark - 解码
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input

{
    
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    
    [outputStr replaceOccurrencesOfString:@"+"
     
                               withString:@""
     
                                  options:NSLiteralSearch
     
                                    range:NSMakeRange(0,[outputStr length])];
    
    return
    
    [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//判断字符是否是纯汉字
- (BOOL)isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

//是否包含汉字
- (BOOL)includeChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

@end
