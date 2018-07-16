//
//  ProductBannerCell.m
//  FinancialManager
//
//  Created by xnkj on 18/09/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "ProductBannerCell.h"
#import "CustomAdScrollView.h"

#import "XNFMProductCategoryStatisticMode.h"

@interface ProductBannerCell()

@property (nonatomic, strong) XNFMProductCategoryStatisticMode      * mode;
@property (nonatomic, strong) CustomAdScrollView  * adScrollView;

@property (nonatomic, weak) IBOutlet UIView * bannerView;
@end

@implementation ProductBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/////////////////
#pragma mark - custom Method
////////////////////////////////////

#pragma mark - 
- (void)refreshBanner:(XNFMProductCategoryStatisticMode *)mode
{
    if(![self.mode isEqual:mode])
    {
        self.mode = mode;
        
        [self.adScrollView removeFromSuperview];
        [self.bannerView addSubview:self.adScrollView];
        
        __weak UIView * tmpBannerView = self.bannerView;
        [self.adScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpBannerView.mas_leading);
            make.top.mas_equalTo(tmpBannerView.mas_top);
            make.width.mas_equalTo(tmpBannerView);
            make.height.mas_equalTo(tmpBannerView);
        }];

        
        [self.adScrollView refreshAdScrollViewWithAdObjectArray:@[mode] urlArray:@[[_LOGIC getImagePathUrlWithBaseUrl:mode.cateLog]]];
    }
}

////////////////
#pragma mark - setter/getter
////////////////////////////////////

#pragma mark - adScrollView
- (CustomAdScrollView *)adScrollView
{
    if (!_adScrollView) {
        
        _adScrollView = [[CustomAdScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width, [NSObject isValidateInitString:self.mode.cateLog]?((SCREEN_FRAME.size.width * 100) / 360):0.0)];
        
        _adScrollView.autoPlay = YES;
        _adScrollView.interminal = 0.5f;
        _adScrollView.scrollDirection = CustomAdScrollRightDirection;
        
        weakSelf(weakSelf)
        [_adScrollView setClickedImgBlock:^(id object) {
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(productBannerCellDidClick:)]) {
                
                [weakSelf.delegate productBannerCellDidClick:object];
            }
        }];
    }
    return _adScrollView;
}

@end
