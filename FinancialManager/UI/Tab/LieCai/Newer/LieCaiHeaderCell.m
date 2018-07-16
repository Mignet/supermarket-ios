//
//  LieCaiHeaderCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 6/29/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "LieCaiHeaderCell.h"
#import "XNLCLevelPrivilegeMode.h"

@interface LieCaiHeaderCell()<UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIView *headView;
@property (nonatomic, weak) IBOutlet UIImageView *headImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *nextLevelTitleLabel;

@property (nonatomic, weak) IBOutlet UIImageView *yearProgressBgImageView;
@property (nonatomic, weak) IBOutlet UIProgressView *yearProgressView;
@property (nonatomic, weak) IBOutlet UIImageView *yearProgressPointImageView;
@property (nonatomic, weak) IBOutlet UILabel *yearActualAmountLabel;
@property (nonatomic, weak) IBOutlet UILabel *yearAmountLabel;

@property (nonatomic, weak) IBOutlet UIView *levelCfpView;
@property (nonatomic, weak) IBOutlet UIImageView *levelCfpProgressBgImageView;
@property (nonatomic, weak) IBOutlet UIProgressView *levelCfpProgressView;
@property (nonatomic, weak) IBOutlet UIImageView *levelCfpProgressPointImageView;
@property (nonatomic, weak) IBOutlet UILabel *levelCfpActualCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *levelCfpCountLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *headScrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

@property (nonatomic, weak) IBOutlet UILabel *redPointLabel;

@property (nonatomic, strong) NSDictionary   *levelImageDictionary;

@end

@implementation LieCaiHeaderCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showDatas:(XNLCLevelPrivilegeMode *)levelMode unreadSaleGoodNews:(BOOL)isUnReadSaleGoodNews
{
    //有未读喜报
    if ([levelMode.jobGradeDesc isEqualToString:@"--"]) {
        
        self.headImageView.image = [UIImage imageNamed:@"XN_liecai_no_level.png"];
    }else
    {
        self.headImageView.image = [UIImage imageNamed:[self.levelImageDictionary objectForKey:levelMode.jobGradeDesc]];
    }

    self.headScrollView.delegate = self;
    self.redPointLabel.hidden = !isUnReadSaleGoodNews;
    self.titleLabel.text = [NSString stringWithFormat:@"本月职级：%@", levelMode.jobGradeDesc];
    self.nextLevelTitleLabel.text = levelMode.cfpLevelTitleNew;
    self.yearActualAmountLabel.text = levelMode.yearpurAmountActualNew;
    
    UIImage *progressImage = [UIImage imageNamed:@"XN_LieCai_Level_progress.png"];
    UIImage *trackImage = [UIImage imageNamed:@"XN_LieCai_Level_track_progress.png"];
    UIImageView *yearTrackImageView = [self.yearProgressView.subviews firstObject];
    yearTrackImageView.image = trackImage;
    UIImageView *yearProgressImageView = [self.yearProgressView.subviews lastObject];
    yearProgressImageView.image = progressImage;
    
    UIImageView *levelTrackImageView = [self.levelCfpProgressView.subviews firstObject];
    levelTrackImageView.image = trackImage;
    UIImageView *levelProgressImageView = [self.levelCfpProgressView.subviews lastObject];
    levelProgressImageView.image = progressImage;
    
    //动态更新进度
    if ([NSObject isValidateInitString:levelMode.yearpurAmountMaxNew]) {
        
        NSArray *propertyArray = @[@{@"range": levelMode.yearpurAmountMaxNew,
                                     @"color": UIColorFromHex(0xB5CBF7),
                                     @"font": [UIFont fontWithName:@"DINOT" size:14]},
                                   @{@"range": @"元",
                                     @"color": UIColorFromHex(0xB5CBF7),
                                     @"font": [UIFont systemFontOfSize:10]}];
        
        NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
        
        self.yearAmountLabel.attributedText = string;
    }else
        self.yearAmountLabel.attributedText = nil;
    
    float fYearAmountPercent = 0.0f;
    if ([NSObject isValidateInitString:levelMode.yearpurAmountMaxNew]) {
        
        if ([levelMode.yearpurAmountActualNew compare:levelMode.yearpurAmountMaxNew options:NSNumericSearch] == NSOrderedDescending || [levelMode.yearpurAmountActualNew compare:levelMode.yearpurAmountMaxNew options:NSNumericSearch] == NSOrderedSame) {
            
            fYearAmountPercent = 1.0f;
        }else
        {
           fYearAmountPercent = [levelMode.yearpurAmountActualNew floatValue] / [levelMode.yearpurAmountMaxNew floatValue];
        }
    }
    self.yearProgressView.progress = fYearAmountPercent;
    
    [self.yearProgressPointImageView setHidden:NO];
    if ([levelMode.yearpurAmountMaxNew isEqualToString:@""]) {
        
        [self.yearProgressPointImageView setHidden:YES];
    }
    
    float fLeft = fYearAmountPercent * self.yearProgressView.bounds.size.width;
   
    __weak UIImageView *weakYearProgressBgImageView = self.yearProgressBgImageView;
    __weak UIProgressView *weakYearProgressView = self.yearProgressView;
    [self.yearProgressPointImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(weakYearProgressView.mas_centerY);
        if ([levelMode.yearpurAmountActualNew compare:levelMode.yearpurAmountMaxNew options:NSNumericSearch] == NSOrderedDescending || [levelMode.yearpurAmountActualNew compare:levelMode.yearpurAmountMaxNew options:NSNumericSearch] == NSOrderedSame)
        {
            make.right.mas_equalTo(weakYearProgressView.mas_right).offset(5);
        }
        else if([levelMode.yearpurAmountActualNew integerValue] <= 0)
        {
            make.centerX.mas_equalTo(weakYearProgressView.mas_left).offset(5);
        }else
        {
            make.centerX.mas_equalTo(weakYearProgressView.mas_left).offset(fLeft);
        }
        
        make.width.mas_equalTo(@(21.5));
        make.height.mas_equalTo(@(21.5));
    }];
    
    [self.yearActualAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(weakYearProgressBgImageView.mas_top);
        if ([levelMode.yearpurAmountActualNew compare:levelMode.yearpurAmountMaxNew options:NSNumericSearch] == NSOrderedDescending || [levelMode.yearpurAmountActualNew compare:levelMode.yearpurAmountMaxNew options:NSNumericSearch] == NSOrderedSame)
        {
            make.right.mas_equalTo(weakYearProgressView.mas_right);
        }
        else if([levelMode.yearpurAmountActualNew integerValue] <= 0)
        {
            make.centerX.mas_equalTo(weakYearProgressView.mas_left).offset(5);
        }else
        {
            make.left.mas_equalTo(weakYearProgressView.mas_left).offset(fLeft - 2);
        }
    }];
    
    weakSelf(weakSelf)
    self.levelCfpView.hidden = NO;
    if ([levelMode.lowerLevelCfpMaxNew integerValue] == 0 && ![levelMode.lowerLevelCfpMaxNew isEqualToString:@""])
    {
        self.levelCfpView.hidden = YES;
        [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.mas_top);
            make.left.mas_equalTo(weakSelf.mas_left);
            make.right.mas_equalTo(weakSelf.mas_right);
            make.height.mas_equalTo(155);
        }];
        
        return;
    }
    
    //显示直接下级理财师
    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top);
        make.left.mas_equalTo(weakSelf.mas_left);
        make.right.mas_equalTo(weakSelf.mas_right);
        make.height.mas_equalTo(328);
    }];
    self.levelCfpActualCountLabel.text = levelMode.lowerLevelCfpActualNew;
    
    if ([NSObject isValidateInitString:levelMode.lowerLevelCfpActualNew]) {

        NSArray *propertyArray2 = @[@{@"range": levelMode.lowerLevelCfpMaxNew,
                                     @"color": UIColorFromHex(0xB5CBF7),
                                     @"font": [UIFont fontWithName:@"DINOT" size:14]},
                                   @{@"range": [NSString stringWithFormat:@"名%@", levelMode.lowerLevelCfp],
                                     @"color": UIColorFromHex(0xB5CBF7),
                                     @"font": [UIFont systemFontOfSize:10]}];
        
        NSAttributedString *string2 = [NSString getAttributeStringWithAttributeArray:propertyArray2];
        
        self.levelCfpCountLabel.attributedText = string2;
    }else
    {
        self.levelCfpCountLabel.attributedText = nil;
    }
    
    float fLevelCfpPercent = 0.0f;
    if ([NSObject isValidateInitString:levelMode.lowerLevelCfpMaxNew]) {
        
        if ([levelMode.lowerLevelCfpActualNew compare:levelMode.lowerLevelCfpMaxNew options:NSNumericSearch] == NSOrderedDescending || [levelMode.lowerLevelCfpActualNew compare:levelMode.lowerLevelCfpMaxNew options:NSNumericSearch] == NSOrderedSame) {
            
            fLevelCfpPercent = 1.0f;
        }else
        {
            fLevelCfpPercent = [levelMode.lowerLevelCfpActualNew floatValue] / [levelMode.lowerLevelCfpMaxNew floatValue];
        }
    }
    self.levelCfpProgressView.progress = fLevelCfpPercent;
    
    float fLevelLeft = fLevelCfpPercent * self.levelCfpProgressView.bounds.size.width;
    
    [self.levelCfpProgressPointImageView setHidden:NO];
    if ([levelMode.lowerLevelCfpMaxNew isEqualToString:@""]) {
        
        [self.levelCfpProgressPointImageView setHidden:YES];
    }
    
    __weak UIImageView *weakLevelCfpProgressBgImageView = self.levelCfpProgressBgImageView;
    __weak UIProgressView *weakLevelCfpProgressView = self.levelCfpProgressView;
    [self.levelCfpProgressPointImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakLevelCfpProgressView.mas_centerY);
        if ([levelMode.lowerLevelCfpActualNew compare:levelMode.lowerLevelCfpMaxNew options:NSNumericSearch] == NSOrderedDescending || [levelMode.lowerLevelCfpActualNew compare:levelMode.lowerLevelCfpMaxNew options:NSNumericSearch] == NSOrderedSame)
        {
            make.right.mas_equalTo(weakLevelCfpProgressView.mas_right).offset(5);
        }
        else if([levelMode.lowerLevelCfpActualNew integerValue] <= 0)
        {
            make.centerX.mas_equalTo(weakLevelCfpProgressView.mas_left).offset(5);
        }else
        {
            make.centerX.mas_equalTo(weakLevelCfpProgressView.mas_left).offset(fLevelLeft);
        }
        
        make.width.mas_equalTo(@(21.5));
        make.height.mas_equalTo(@(21.5));
    }];

    [self.levelCfpActualCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
      
        make.bottom.mas_equalTo(weakLevelCfpProgressBgImageView.mas_top);
        if ([levelMode.lowerLevelCfpActualNew compare:levelMode.lowerLevelCfpMaxNew options:NSNumericSearch] == NSOrderedDescending || [levelMode.lowerLevelCfpActualNew compare:levelMode.lowerLevelCfpMaxNew options:NSNumericSearch] == NSOrderedSame)
        {
            make.right.mas_equalTo(weakLevelCfpProgressView.mas_right).offset(-2);
        }
        else if([levelMode.lowerLevelCfpActualNew integerValue] <= 0)
        {
            make.centerX.mas_equalTo(weakLevelCfpProgressView.mas_left).offset(5);
        }else
        {
            make.centerX.mas_equalTo(weakLevelCfpProgressView.mas_left).offset(fLevelLeft);
        }
    }];
}

#pragma mark - 职级特权说明
- (IBAction)explainAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(levelExplainAction)])
    {
        [self.delegate levelExplainAction];
    }
}

#pragma mark -
- (IBAction)gotoPageAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToPageAction:)])
    {
        [self.delegate jumpToPageAction:btn.tag];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.pageControl.currentPage = page;
}

////////////////////
#pragma mark - setter/getter
/////////////////////////////////

#pragma mark - levelImageArray
- (NSDictionary *)levelImageDictionary
{
    if (!_levelImageDictionary) {
        
        _levelImageDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"XN_MyInfo_jx_Level_icon.png",@"见习",@"XN_MyInfo_gw_Level_icon.png",@"顾问",@"XN_MyInfo_jl_Level_icon.png",@"经理",@"XN_MyInfo_zj_Level_icon.png",@"总监", nil];
    }
    return _levelImageDictionary;
}

@end
