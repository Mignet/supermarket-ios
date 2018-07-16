//
//  InsuranceRecommendItemCell.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/28.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "InsuranceRecommendItemCell.h"
#import "QquestionResultRecomListItem.h"

@interface InsuranceRecommendItemCell ()

@property (weak, nonatomic) IBOutlet UIImageView *referImgView;

@end

@implementation InsuranceRecommendItemCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.referImgView.layer.cornerRadius = 5;
    self.referImgView.layer.masksToBounds = YES;
}

//////////////////////////////
#pragma mark - setter / getter
//////////////////////////////

- (void)setRecomListItem:(QquestionResultRecomListItem *)recomListItem
{
    _recomListItem = recomListItem;
    
    // 图片
    NSString *urlString = [NSString stringWithFormat:@"%@?f=png", [_LOGIC getImagePathUrlWithBaseUrl:recomListItem.categoryImage]];

    [self.referImgView sd_setImageWithURL:[NSURL URLWithString:urlString]];
}



@end
