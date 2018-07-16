//
//  ContactHeaderCell.m
//  FinancialManager
//
//  Created by xnkj on 15/12/22.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "ContactHeaderCell.h"

@interface ContactHeaderCell()

@property (nonatomic, strong) UILabel * titleLabel;
@end

@implementation ContactHeaderCell

- (void)refreshTitle:(NSString *)title
{
    [self setBackgroundColor:UIColorFromHex(0xF9FAFB)];
    [self.textLabel setText:title];
}

@end
