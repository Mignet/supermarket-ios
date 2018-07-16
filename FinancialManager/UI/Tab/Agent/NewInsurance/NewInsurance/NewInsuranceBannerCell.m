//
//  NewInsuranceBannerCell.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/25.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "NewInsuranceBannerCell.h"

#import "CustomAdScrollView.h"
#import "XNHomeBannerMode.h"

#define ADSCROLLVIEWHEIGHT (125 * SCREEN_FRAME.size.width) / 375.0

@interface NewInsuranceBannerCell ()

@property (weak, nonatomic) IBOutlet UIButton *severeBtn;
@property (weak, nonatomic) IBOutlet UIButton *accidentBtn;
@property (weak, nonatomic) IBOutlet UIButton *childrenBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreInsuranceBtn;

@property (nonatomic, strong) CustomAdScrollView *adScrollView;

@end

@implementation NewInsuranceBannerCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (IBAction)btnClick:(UIButton *)sender
{
    if (sender == self.severeBtn) { // 重疾险
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(newInsuranceBannerCellDid:ClickType:withUrl:)]) {
            [self.delegate newInsuranceBannerCellDid:self ClickType:Severe_Illness_Click withUrl:nil];
        }
    }
    
    else if (sender == self.accidentBtn) { // 意外险
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(newInsuranceBannerCellDid:ClickType:withUrl:)]) {
            [self.delegate newInsuranceBannerCellDid:self ClickType:Accident_Click withUrl:nil];
        }
    }
    
    else if (sender == self.childrenBtn) { // 儿童险
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(newInsuranceBannerCellDid:ClickType:withUrl:)]) {
            [self.delegate newInsuranceBannerCellDid:self ClickType:Children_Click withUrl:nil];
        }
    }
    
    else if (sender == self.moreInsuranceBtn) { // 更多保险
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(newInsuranceBannerCellDid:ClickType:withUrl:)]) {
            [self.delegate newInsuranceBannerCellDid:self ClickType:More_Insurance withUrl:nil];
        }
    }
}

- (void)setUrlArr:(NSMutableArray *)urlArr
{
    if (urlArr.count > 0) {
        [self.adSupView addSubview:self.adScrollView];
    } else {
        [self.adScrollView removeFromSuperview];
    }
    
    _urlArr = urlArr;
    NSMutableArray *adObjectArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *bannerUrlArray = [NSMutableArray arrayWithCapacity:0];
    
    for (XNHomeBannerMode *itemModel in urlArr) {
        [adObjectArray addObject:itemModel.linkUrl];
        //图片
        NSString *urlString = [NSString stringWithFormat:@"%@?f=png", [_LOGIC getImagePathUrlWithBaseUrl:itemModel.imgUrl]];
        [bannerUrlArray addObject:urlString];
    }
    
    [self.adScrollView refreshAdScrollViewWithAdObjectArray:adObjectArray urlArray:bannerUrlArray];
}

#pragma mark - adScrollView
- (CustomAdScrollView *)adScrollView
{
    if (!_adScrollView) {
        
        _adScrollView = [[CustomAdScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width, ADSCROLLVIEWHEIGHT) pageAlignBottom:10.0f pageAlignment:2];
        
        _adScrollView.autoPlay = YES;
        _adScrollView.interminal = 0.5f;
        _adScrollView.scrollDirection = CustomAdScrollRightDirection;
        
        weakSelf(weakSelf)
        [_adScrollView setClickedImgBlock:^(id object) {
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(newInsuranceBannerCellDid:ClickType:withUrl:)]) {
                [weakSelf.delegate newInsuranceBannerCellDid:weakSelf ClickType:Banner_Click withUrl:object];
            }
            
        }];
    }
    return _adScrollView;
}





@end
