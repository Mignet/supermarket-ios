//
//  SafeFooterCell.m
//  FinancialManager
//
//  Created by xnkj on 5/18/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "SafeFooterCell.h"

@interface SafeFooterCell()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

@implementation SafeFooterCell

- (void)showDatas:(NSString *)title
{
    _titleLabel.text = title;
}

@end
