//
//  SeekActivityListCell.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SeekActivityListCell.h"
#import "SeekActivityItemModel.h"

@interface SeekActivityListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *bgalphaView;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UIButton *PlatformBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;


@end

@implementation SeekActivityListCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.contentView.backgroundColor = UIColorFromHex(0xEEEFF3);
    self.bgalphaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    self.PlatformBtn.layer.cornerRadius = 5.f;
    self.PlatformBtn.layer.masksToBounds = YES;
    self.PlatformBtn.layer.borderWidth = 1.f;
}

- (void)setItemModel:(SeekActivityItemModel *)itemModel
{
    _itemModel = itemModel;
    
    //头像
    NSString *urlString = [NSString stringWithFormat:@"%@?f=png", [_LOGIC getImagePathUrlWithBaseUrl:itemModel.activityImg]];//big_img_bg
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"big_img_bg"]];

    self.nameLabel.text = itemModel.activityName;
    
    self.startTimeLabel.text = [NSString stringWithFormat:@"活动开始时间：%@", itemModel.startDate];
    
    self.bgalphaView.hidden = YES;
    self.endLabel.hidden = YES;
    
    [self.PlatformBtn setTitle:itemModel.activityPlatform forState:UIControlStateNormal];
    
    //活动状态:0:进行中，1:已结束，-1:即将开始
    if ([itemModel.status isEqualToString:@"0"]) {
        self.dayNumLabel.text = [NSString stringWithFormat:@"剩余时间%@天", itemModel.leftDay];
        self.PlatformBtn.layer.borderColor = UIColorFromHex(0x4E8CEF).CGColor;
        [self.PlatformBtn setTitleColor:UIColorFromHex(0x4E8CEF) forState:UIControlStateNormal];
    } else if ([itemModel.status isEqualToString:@"1"]) {
        self.bgalphaView.hidden = NO;
        self.endLabel.hidden = NO;
        self.dayNumLabel.text = @"活动已结束";
        self.PlatformBtn.layer.borderColor = UIColorFromHex(0x4F5960).CGColor;
        [self.PlatformBtn setTitleColor:UIColorFromHex(0x4F5960) forState:UIControlStateNormal];
    
    } else if ([itemModel.status isEqualToString:@"-1"]) {
        self.dayNumLabel.text = @"活动未开始";
    }
}

@end
