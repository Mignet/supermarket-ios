//
//  BundHeaderCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/17/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "BundHeaderCell.h"

#define BANNERHEIGHT ((200 * SCREEN_FRAME.size.width) / 375.0)

@interface BundHeaderCell ()

@property (nonatomic, weak) IBOutlet UIView *bannerView;
@property (nonatomic, weak) IBOutlet UIImageView *bannerImageView;

@property (nonatomic, weak) IBOutlet UILabel *bundTypeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *bundTypeImageView;
@property (nonatomic, weak) IBOutlet UILabel *rateDescLabel;
@property (nonatomic, weak) IBOutlet UIImageView *rateDescImageView;

@end

@implementation BundHeaderCell

- (void)showDatas:(NSString *)selectedPeriodString
{
    self.rateDescLabel.text = selectedPeriodString;
    weakSelf(weakSelf)
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top);
        make.leading.mas_equalTo(weakSelf.mas_leading);
        make.trailing.mas_equalTo(weakSelf.mas_trailing);
        make.height.mas_equalTo(BANNERHEIGHT);
    }];
}

- (IBAction)clickAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bundHeaderCellDidClick:)])
    {
        [self.delegate bundHeaderCellDidClick:btn.tag];
    }
    
}



@end
