//
//  MIAccountBalanceSectionCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 2/8/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MIAccountBalanceSectionCell.h"

@interface MIAccountBalanceSectionCell()

@property (nonatomic, weak) IBOutlet UILabel *yearLabel;

@end

@implementation MIAccountBalanceSectionCell

- (void)showDatas:(NSInteger)nYear
{
    self.yearLabel.text = [NSString stringWithFormat:@"%ld年", nYear];
}

@end
