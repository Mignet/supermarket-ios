//
//  CustomActionSheetCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 11/25/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "CustomActionSheetCell.h"

@interface CustomActionSheetCell ()

@property (nonatomic, weak) IBOutlet UIButton *button;

@end

@implementation CustomActionSheetCell

- (void)showDatas:(NSString *)title
{
    [self.button setTitle:title forState:UIControlStateNormal];
}

@end
