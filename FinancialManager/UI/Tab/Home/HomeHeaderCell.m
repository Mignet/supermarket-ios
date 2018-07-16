//
//  HomeHeaderCell.m
//  FinancialManager
//
//  Created by xnkj on 5/12/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "HomeHeaderCell.h"
#import "CustomAdScrollView.h"
#import "UIImageView+WebCache.h"
#import "NSString+common.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

#import "XNFMProductCategoryStatisticMode.h"
#import "XNFinancialManagerModule.h"
#import "XNFinancialManagerModuleObserver.h"
#import "XNHomeAchievementModel.h"

#define ADSCROLLVIEWHEIGHT (200 * SCREEN_FRAME.size.width) / 375.0

@interface HomeHeaderCell()

@property (nonatomic, strong) NSString         * profit;
@property (nonatomic, assign) float              width;
@property (nonatomic, assign) BOOL                isShowProductCate;
@property (nonatomic, strong) CustomAdScrollView   * adScrollView;

@property (nonatomic, strong) IBOutlet UILabel      * commissionLabel;

@property (nonatomic, weak) IBOutlet UIView       * bannerView;
@property (nonatomic, weak) IBOutlet UIView       * containerView;

/*** 佣金发放总额 **/
@property (weak, nonatomic) IBOutlet UILabel *accountsLabel;

/*** 安全运营天数 **/
@property (weak, nonatomic) IBOutlet UILabel *operationDayLabel;

/*** 网贷按钮icon **/
@property (weak, nonatomic) IBOutlet UIImageView *proImgIcon;

/*** 基金按钮icon **/
@property (weak, nonatomic) IBOutlet UIImageView *fundImgIcon;

/*** 保险按钮icon **/
@property (weak, nonatomic) IBOutlet UIImageView *insuranceImgIcon;

/*** 公益按钮icon**/
@property (weak, nonatomic) IBOutlet UIImageView *publicImgIcon;

@end

@implementation HomeHeaderCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.bannerView addSubview:self.adScrollView];
    
    // 配置图标
    [self setUpIcon];
    
    __weak UIView * tmpBannerView = self.bannerView;
    [self.adScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tmpBannerView);
    }];
}

- (void)setUpIcon
{
    self.proImgIcon.image = [UIImage imageNamed:[_SKIN getproImgIcon]];
    self.fundImgIcon.image = [UIImage imageNamed:[_SKIN getfundImgIcon]];
    self.insuranceImgIcon.image = [UIImage imageNamed:[_SKIN getinsuranceImgIcon]];
    self.publicImgIcon.image = [UIImage imageNamed:[_SKIN getpublicImgIcon]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)refreshAdScrollViewWithAdObjectArray:(NSArray *)adObjectArray urlArray:(NSArray *)bannerUrlArray commissionAmount:(NSString *)commission
{
    [self.adScrollView refreshAdScrollViewWithAdObjectArray:adObjectArray urlArray:bannerUrlArray];

    self.accountsLabel.text = [NSObject isValidateInitString:commission]?commission:@"";
}

- (void)setSafeOperationTime:(NSString *)safeOperationTime
{
    _safeOperationTime = safeOperationTime;
    
    if (safeOperationTime.length > 0) {
        self.operationDayLabel.text = safeOperationTime;
    } else {
        self.operationDayLabel.text = @"";
    }
}

//点击
- (IBAction)clickAction:(id)sender
{
    UIButton *btn = sender;
    
    if ([self.delegate respondsToSelector:@selector(XNHomeHeaderCellDidClickAction:)]) {
        
        [self.delegate XNHomeHeaderCellDidClickAction:btn.tag];
    }
}

///////////////////
#pragma mark - setter/getter
//////////////////////////////////

#pragma mark - adScrollView
- (CustomAdScrollView *)adScrollView
{
    if (!_adScrollView) {
        
        _adScrollView = [[CustomAdScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width, ADSCROLLVIEWHEIGHT) pageAlignBottom:10.f pageAlignment:1];
        
        _adScrollView.autoPlay = YES;
        _adScrollView.interminal = 0.5f;
        _adScrollView.scrollDirection = CustomAdScrollRightDirection;
        
        weakSelf(weakSelf)
        [_adScrollView setClickedImgBlock:^(id object) {
            
            //umeng统计点击次数－banner
            [XNUMengHelper umengEvent:@"S_banner"];
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(XNHomeHeaderCellDidClickWithUrl:)]) {
                
                [weakSelf.delegate XNHomeHeaderCellDidClickWithUrl:object];
            }
        }];
    }
    return _adScrollView;
}

@end
