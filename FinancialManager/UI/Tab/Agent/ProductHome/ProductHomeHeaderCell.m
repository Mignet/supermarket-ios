//
//  ProductHeaderCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 2/24/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "ProductHomeHeaderCell.h"
#import "CustomAdScrollView.h"

@interface ProductHomeHeaderCell()

@property (nonatomic, weak) IBOutlet UIView *bannerView;

@property (nonatomic, strong) CustomAdScrollView  * adScrollView;

@end

@implementation ProductHomeHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.bannerView addSubview:self.adScrollView];
    __weak UIView *weakBannerView = self.bannerView;
    [self.adScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakBannerView);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshAdScrollViewWithAdObjectArray:(NSArray *)adObjectArray urlArray:(NSArray *)bannerUrlArray
{
    [self.adScrollView refreshAdScrollViewWithAdObjectArray:adObjectArray urlArray:bannerUrlArray];
}

///////////////////
#pragma mark - setter/getter
//////////////////////////////////

#pragma mark - adScrollView
- (CustomAdScrollView *)adScrollView
{
    if (!_adScrollView)
    {
        _adScrollView = [[CustomAdScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width, ((125 * SCREEN_FRAME.size.width) / 375))];
        
        _adScrollView.autoPlay = YES;
        _adScrollView.interminal = 0.5f;
        _adScrollView.scrollDirection = CustomAdScrollRightDirection;
        
        weakSelf(weakSelf)
        [_adScrollView setClickedImgBlock:^(id object) {
            
            //umeng统计点击次数－banner
            [XNUMengHelper umengEvent:@"C_banner"];
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(XNProductHeaderCellDidClickWithUrl:)])
            {
                [weakSelf.delegate XNProductHeaderCellDidClickWithUrl:object];
            }
        }];
    }
    return _adScrollView;
}

@end
