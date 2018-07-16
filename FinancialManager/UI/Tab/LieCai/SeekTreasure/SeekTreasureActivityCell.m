//
//  SeekTreasureActivityCell.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/20.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SeekTreasureActivityCell.h"
#import "CustomAdScrollView.h"
#import "SeekTreasureHotActivityItemModel.h"

@interface SeekTreasureActivityCell ()

@property (nonatomic, strong) CustomAdScrollView   * adScrollView;

@property (weak, nonatomic) IBOutlet UIView *activityView;


@end

@implementation SeekTreasureActivityCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
     [self.activityView addSubview:self.adScrollView];
}


////////
#pragma mark - setter / getter
/////////////
#pragma mark - adScrollView
- (CustomAdScrollView *)adScrollView
{
    if (!_adScrollView) {
        CGFloat height = 175.f * (SCREEN_FRAME.size.width) / 375.f;
        _adScrollView = [[CustomAdScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_FRAME.size.width - 20.f, height) pageAlignBottom:10.f pageAlignment:1];
        
        _adScrollView.autoPlay = YES;
        _adScrollView.interminal = 0.5f;
        _adScrollView.scrollDirection = CustomAdScrollRightDirection;
        
        weakSelf(weakSelf)
        [_adScrollView setClickedImgBlock:^(id object) {
        
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(seekTreasureActivityCellDid:withStringUrl:)]) {
                [weakSelf.delegate seekTreasureActivityCellDid:weakSelf withStringUrl:object];
            }
        }];
    }
    return _adScrollView;
}

- (void)setUrlArr:(NSMutableArray *)urlArr
{
    _urlArr = urlArr;
    
    NSMutableArray *adObjectArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *bannerUrlArray = [NSMutableArray arrayWithCapacity:0];
    
    for (SeekTreasureHotActivityItemModel *itemModel in urlArr) {
        
        [adObjectArray addObject:itemModel.linkUrl];
        
        //图片
        NSString *urlString = [NSString stringWithFormat:@"%@?f=png", [_LOGIC getImagePathUrlWithBaseUrl:itemModel.activityImg]];
        [bannerUrlArray addObject:urlString];
        
    }
    
    [self.adScrollView refreshAdScrollViewWithAdObjectArray:adObjectArray urlArray:bannerUrlArray];

}


@end
