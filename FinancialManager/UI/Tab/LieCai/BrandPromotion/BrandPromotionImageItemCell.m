//
//  BrandPromotionImageItemCell.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/28.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "BrandPromotionImageItemCell.h"
#import "XNLCBrandListItem.h"
#import "XNLCBrandListItemManager.h"

#define BARandomColor      [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0f];

@interface BrandPromotionImageItemCell ()

@property (weak, nonatomic) IBOutlet UIImageView *brandImgView;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;


@end


@implementation BrandPromotionImageItemCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setBrandItem:(XNLCBrandListItem *)brandItem
{
    _brandItem = brandItem;
    
    // 图片
    NSString *urlString = [NSString stringWithFormat:@"%@?f=png", [_LOGIC getImagePathUrlWithBaseUrl:brandItem.smallImage]];
    [self.brandImgView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    

    if (brandItem == [[XNLCBrandListItemManager shareInstance] getChooseBrandListItem]) {
        
        self.chooseBtn.selected = YES;
    
    } else {
        
        self.chooseBtn.selected = brandItem.isChoose;
    }
}
- (IBAction)chooseBtnClick:(UIButton *)sender
{
    if (sender.selected) { // 取消选中
        
        self.brandItem.isChoose = NO;
        
        [[XNLCBrandListItemManager shareInstance] setChooseBrandListItem:nil];
        
    } else { // 选中
        
        [[XNLCBrandListItemManager shareInstance] getChooseBrandListItem].isChoose = NO;
        
        self.brandItem.isChoose = YES;
        
        [[XNLCBrandListItemManager shareInstance] setChooseBrandListItem:self.brandItem];
        
    }

    sender.selected = !sender.selected;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewBrandPromotionImageController_reloadCollectionView" object:nil];
    
}

@end
