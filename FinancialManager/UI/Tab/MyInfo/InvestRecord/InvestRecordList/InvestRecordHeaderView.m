//
//  InvestRecordHeaderView.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/19.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "InvestRecordHeaderView.h"

@interface InvestRecordHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;

@end

@implementation InvestRecordHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setHeaderStr:(NSString *)headerStr
{
    _headerStr = headerStr;
    
    self.headerTitleLabel.text = headerStr;
}

@end
