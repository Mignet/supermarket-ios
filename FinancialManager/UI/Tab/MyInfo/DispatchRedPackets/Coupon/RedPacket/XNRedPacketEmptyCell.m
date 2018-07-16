//
//  CICustomerInvestEmptyCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 12/1/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNRedPacketEmptyCell.h"

@interface XNRedPacketEmptyCell()

@property (nonatomic, weak) IBOutlet UILabel * titleLabel;
@property (nonatomic, weak) IBOutlet UILabel * subTitleLabel;
@end

@implementation XNRedPacketEmptyCell

- (void)showTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    self.titleLabel.text = title;
    self.subTitleLabel.text = subTitle;
}
@end
