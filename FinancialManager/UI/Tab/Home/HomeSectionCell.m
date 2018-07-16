//
//  HomeSectionCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 6/23/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "HomeSectionCell.h"

@interface HomeSectionCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel * subTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;

@end

@implementation HomeSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showTitle:(NSString *)title subTitle:(NSString *)subTitle footerTitle:(NSString *)footerTitle hiddenIcon:(BOOL)isHiddenIcon
{
    self.titleLabel.text = title;
    self.subTitleLabel.text = subTitle;
    self.valueLabel.text = footerTitle;
    self.iconImageView.hidden = isHiddenIcon;
}

@end
