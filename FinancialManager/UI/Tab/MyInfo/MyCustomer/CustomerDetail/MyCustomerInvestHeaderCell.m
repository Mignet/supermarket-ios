//
//  MyCustomerInvestHeaderCell.m
//  FinancialManager
//
//  Created by xnkj on 18/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyCustomerInvestHeaderCell.h"

@interface MyCustomerInvestHeaderCell()

@property (nonatomic, weak) IBOutlet UILabel * titleLabel;
@end

@implementation MyCustomerInvestHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//更新数据
- (void)refreshTitle:(NSString *)title
{
    [self.titleLabel setText:title];
}
@end
