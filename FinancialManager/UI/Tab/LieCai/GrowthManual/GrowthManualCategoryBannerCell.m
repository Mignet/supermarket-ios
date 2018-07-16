//
//  GrowthManualCategoryBannerCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/1/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "GrowthManualCategoryBannerCell.h"
#import "CustomAdScrollView.h"

@interface GrowthManualCategoryBannerCell ()

@property (nonatomic, weak) IBOutlet UIView *bannerView;
@property (nonatomic, weak) IBOutlet UIImageView *bannerImageView;

@end

@implementation GrowthManualCategoryBannerCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showBanner:(NSString *)img
{
    [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:[_LOGIC getImagePathUrlWithBaseUrl:img]] placeholderImage:[UIImage imageNamed:@""]];
   
}

@end
