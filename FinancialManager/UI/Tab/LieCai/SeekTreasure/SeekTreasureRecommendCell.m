//
//  SeekTreasureRecommendCell.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/20.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SeekTreasureRecommendCell.h"
#import "SeekTreasureReadItemModel.h"

@interface SeekTreasureRecommendCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;


@end

@implementation SeekTreasureRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItemModel:(SeekTreasureReadItemModel *)itemModel
{
    _itemModel = itemModel;
    
//    //图片
    NSString *urlString = [NSString stringWithFormat:@"%@?f=png", [_LOGIC getImagePathUrlWithBaseUrl:itemModel.img]];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"big_img_bg.png"]];
}

@end
