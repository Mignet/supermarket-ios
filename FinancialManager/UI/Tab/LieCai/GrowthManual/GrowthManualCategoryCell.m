//
//  GrowthManualCategoryCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/31/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "GrowthManualCategoryCell.h"
#import "XNGrowthManualCategoryItemMode.h"

@interface GrowthManualCategoryCell ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *readCountLabel;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;

@end

@implementation GrowthManualCategoryCell



- (void)showDatas:(XNGrowthManualCategoryItemMode *)mode
{
    self.nameLabel.text = mode.title;
    self.readCountLabel.text = [NSString stringWithFormat:@"阅读量：%@", mode.readingAmount];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[_LOGIC getImagePathUrlWithBaseUrl:mode.img]] placeholderImage:[UIImage imageNamed:@""]];
}

@end
