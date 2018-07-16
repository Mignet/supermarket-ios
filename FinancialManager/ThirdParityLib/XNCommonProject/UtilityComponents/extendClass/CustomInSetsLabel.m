//
//  CustomInSetsLabel.m
//  FinancialManager
//
//  Created by xnkj on 10/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "CustomInSetsLabel.h"

@interface CustomInSetsLabel()

@property (nonatomic, assign) UIEdgeInsets insets;
@end

@implementation CustomInSetsLabel

- (id)initWithInsets:(UIEdgeInsets )insets
{
    self = [super init];
    if (self ) {
        
        self.insets = insets;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}
@end
