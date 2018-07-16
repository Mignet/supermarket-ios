//
//  CustomTextField.m
//  FinancialManager
//
//  Created by xnkj on 03/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

//控制placeholder的位置，但是光标位置不变
- (CGRect )placeholderRectForBounds:(CGRect)bounds
{
    CGRect insert = CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 20, bounds.size.height);
    
    return insert;
}

//修改文本展示区域
- (CGRect )textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y - 10, bounds.size.width - 20, bounds.size.height);//更好理解些
    return inset;
}

//改变光标的位置,以及光标最右到什么位置，placeholder的位置也会改变
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width - 20, bounds.size.height);//更好理解些
    return inset;
}
@end
