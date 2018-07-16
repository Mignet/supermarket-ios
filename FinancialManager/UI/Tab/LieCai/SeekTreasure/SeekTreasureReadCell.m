//
//  SeekTreasureReadCell.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/20.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SeekTreasureReadCell.h"
#import "SeekTreasureReadItemModel.h"

@interface SeekTreasureReadCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *readNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;


@end

@implementation SeekTreasureReadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItemModel:(SeekTreasureReadItemModel *)itemModel
{
    _itemModel = itemModel;
    
    //标题
    self.contentLabel.text = itemModel.title;
    
    self.readNumLabel.text = [NSString stringWithFormat:@" 阅读量：%@", itemModel.readingAmount];

    //头像
    NSString *urlString = [NSString stringWithFormat:@"%@?f=png", [_LOGIC getImagePathUrlWithBaseUrl:itemModel.img]];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    
}

@end
