//
//  UILabel+Extend.m
//  FinancialManager
//
//  Created by xnkj on 15/10/9.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "UILabel+Extend.h"
#import <CoreText/CoreText.h>

#import "objc/runtime.h"

@implementation UILabel(Extend)

+ (void)load
{
    Class currentClass = [self class];
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
       
        SEL oldSetTextSelector = NSSelectorFromString(@"setText:");
        SEL newSetTextSelector = NSSelectorFromString(@"newSetText:");
        
        Method oldSetTextMethod = class_getInstanceMethod(currentClass, oldSetTextSelector);
        Method newSetTextMethod = class_getInstanceMethod(currentClass, newSetTextSelector);
        
        BOOL result = class_addMethod(currentClass, newSetTextSelector, method_getImplementation(newSetTextMethod), method_getTypeEncoding(oldSetTextMethod));
        if (result) {
            
            class_replaceMethod(currentClass, oldSetTextSelector, method_getImplementation(newSetTextMethod), method_getTypeEncoding(oldSetTextMethod));
        }else
            method_exchangeImplementations(oldSetTextMethod, newSetTextMethod);
    });
}

#pragma mark - 检查uilabel中settext中的字符串是否为空
- (void)newSetText:(NSString *)text
{
    [self setHidden:NO];
    NSString * str = text;
    if (![NSObject isValidateObj:text]) {
        
        str = @"";
        [self setHidden:YES];
    }
    
    [self newSetText:str];
}

#pragma mark - 刷新属性内容数组
- (void)refreshPropertyArray:(NSArray *)propertyArray Alignment:(NSTextAlignment)textAlignment
{
    NSDictionary* attrs = nil;
    NSString * contentSting = @"";
    NSMutableArray * rangeMutaArray = [NSMutableArray array];
    
    //为每一run设置一个属性
    NSInteger index = 0;
    for (NSDictionary * dic in propertyArray) {
        
        attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                 (id)[dic valueForKey:@"color"], kCTForegroundColorAttributeName,
                 (id)[dic valueForKey:@"font"], kCTFontAttributeName,
                 nil];
       
        [rangeMutaArray addObject:[NSValue valueWithRange: NSMakeRange(index, [[dic objectForKey:@"range"] length])]];
        index = index + [[dic objectForKey:@"range"] length];
        contentSting = [contentSting stringByAppendingString:[dic objectForKey:@"range"]];
    }
   
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:contentSting];

    //为每一run设置一个属性
    index = 0;
    for (NSDictionary * dic in propertyArray) {
        
        attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                 (id)[dic valueForKey:@"color"], kCTForegroundColorAttributeName,
                 (id)[dic valueForKey:@"font"], kCTFontAttributeName,
                 nil];
        
        [attributeString addAttribute:NSForegroundColorAttributeName value:[dic valueForKey:@"color"] range:[[rangeMutaArray objectAtIndex:index] rangeValue]];
        [attributeString addAttribute:NSFontAttributeName value:[dic valueForKey:@"font"] range:[[rangeMutaArray objectAtIndex:index] rangeValue]];
        index ++;
    }
    
    [self setAttributedText:attributeString];
    
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByTruncatingTail;
    self.textAlignment = textAlignment;
}

#pragma mark - 调整label的高度
- (CGFloat )adjustLabelHeightInSize:(CGSize )size fontSize:(UIFont *)font
{
    [self setFont:font];
    [self setNumberOfLines:0];
    [self setLineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize aturalSize = [self sizeThatFits:size];
    
    return aturalSize.height;
}

#pragma mark - 计算字符串长度
- (CGFloat )caculateLabelLengthInSize:(CGSize )size fontSize:(UIFont *)font
{
    [self setFont:font];
    
    [self sizeToFit];
    
    
    return self.size.width;

}

@end
