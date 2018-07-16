//
//  AgentInfoCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 10/17/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "AgentInfoCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+CornerRadius.h"

#import "XNCommonModule.h"
#import "XNConfigMode.h"
#import "XNAgentActivityItemMode.h"

#define productTag 0x11111111

@interface AgentInfoCell()

@property (nonatomic, weak) IBOutlet UIView *mainView;
@property (nonatomic, weak) IBOutlet UIImageView *hotImageView;
@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;
@property (nonatomic, weak) IBOutlet UIImageView *soldOutImageView;
@property (nonatomic, weak) IBOutlet UILabel *platformDescLabel;
@property (nonatomic, weak) IBOutlet UILabel *annualLabel;
@property (nonatomic, weak) IBOutlet UILabel *securityLevelLabel;
@property (nonatomic, weak) IBOutlet UILabel *commissionLabel;

@property (nonatomic, strong) NSMutableArray *viewArray;

@end

@implementation AgentInfoCell

#pragma mark - 展示数据
- (void)showDatas:(XNFMAgentListItemMode *)mode
{
    __weak UIView *weakMainView = self.mainView;
    __weak UIImageView *weakHotImageView = self.hotImageView;

    if (!mode.listRecommend)
    {
        //不推荐
        self.hotImageView.hidden = YES;
        [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakMainView.mas_top).offset(15);
            make.left.mas_equalTo(weakMainView.mas_left).offset(10);
            make.width.mas_equalTo(71);
            make.height.mas_equalTo(31);
        }];
    }
    else
    {
        //推荐
        self.hotImageView.hidden = NO;
        [self.hotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakMainView.mas_top).offset(20);
            make.left.mas_equalTo(weakMainView.mas_left).offset(10);
            make.width.mas_equalTo(29);
            make.height.mas_equalTo(16);
        }];
        [self.logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakMainView.mas_top).offset(15);
            make.left.mas_equalTo(weakHotImageView.mas_right).offset(7);
            make.width.mas_equalTo(71);
            make.height.mas_equalTo(31);
        }];
    }

    NSString *urlString = [NSString stringWithFormat:@"%@%@?f=png", [XNCommonModule defaultModule].configMode.imgServerUrl, mode.platformlistIco];
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    
    //查看是否存在机构标签，如果存在则创建
    [self createOrgTagWithParams:mode];
    
    self.soldOutImageView.hidden = YES;
    if ([mode.usableProductNums integerValue] <= 0)
    {
        self.soldOutImageView.hidden = NO;
    }
    
    NSString *orgAdvantageString = [mode.orgAdvantage stringByReplacingOccurrencesOfString:@"," withString:@"｜"];
    self.platformDescLabel.text = orgAdvantageString;

    //年化率
    NSArray *annual_Property = @[@{@"range":mode.averageRate,
                                   @"color": UIColorFromHex(0xfd5d5d),
                                   @"font": [UIFont fontWithName:@"DINOT" size:22]},
                                 @{@"range": @"%",
                                   @"color": UIColorFromHex(0xfd5d5d),
                                   @"font": [UIFont fontWithName:@"DINOT" size:15]}];
    [self.annualLabel refreshPropertyArray:annual_Property Alignment:NSTextAlignmentLeft];
    
    self.securityLevelLabel.text = mode.grade;
    
    //佣金率
    NSArray *commissionRate_Property = @[@{@"range":mode.orgFeeRatio,
                                           @"color": UIColorFromHex(0x666666),
                                           @"font":[UIFont fontWithName:@"DINOT" size:16]},
                                         @{@"range": @"%",
                                           @"color": UIColorFromHex(0x666666),
                                           @"font": [UIFont fontWithName:@"DINOT" size:10]}];
    [self.commissionLabel refreshPropertyArray:commissionRate_Property Alignment:NSTextAlignmentLeft];
}

#pragma mark - 创建机构标签
- (void)createOrgTagWithParams:(XNFMAgentListItemMode *)params
{
    for (UIView * tmpView in self.viewArray)
    {
        [tmpView removeFromSuperview];
    }
    
    if (!params.orgTag || params.orgTag.length <= 0)
    {
        return;
    }
    NSArray *array = [params.orgTag componentsSeparatedByString:@","];
    NSMutableArray *productTagArray = [array mutableCopy];
    if ([productTagArray.lastObject isEqual:@""])
    {
        [productTagArray removeLastObject];
    }
    CGFloat left = 10;
    for (int i = 0 ; i < productTagArray.count; i ++ )
    {
        UIView * tmpView = [self createTag:params desc:[productTagArray objectAtIndex:i]];
        [self addSubview:tmpView];
        
        UILabel * tmpLabel = [tmpView viewWithTag:productTag];
        [tmpLabel setTextColor:UIColorFromHex(0x4e8cef)];
        
        [tmpLabel sizeToFit];
        CGSize size = tmpLabel.size;
        
        __weak UIImageView *weakHotImageView = self.hotImageView;
        __weak UIImageView *weakLogoImageView = self.logoImageView;
        
        [tmpView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(weakLogoImageView.mas_trailing).offset(left);
            make.top.mas_equalTo(weakHotImageView.mas_top);
            make.width.mas_equalTo(size.width + 10);
            make.height.mas_equalTo(16);
        }];
        [tmpView drawRoundCornerWithRectSize:CGSizeMake(size.width + 10, 16) backgroundColor:[UIColor whiteColor] borderWidth:0.5 borderColor:UIColorFromHex(0x4e8cef) radio:3];
        
        [self.viewArray addObject:tmpView];
        
        left = left + size.width + 15;
    }
    
}

#pragma mark - 创建标签
- (UIView *)createTag:(XNFMAgentListItemMode *)params desc:(NSString *)desc
{
    UIView *descView = [[UIView alloc] init];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setBackgroundColor:[UIColor clearColor]];
    [descLabel setTag:productTag];
    [descLabel setFont:[UIFont systemFontOfSize:10]];
    [descLabel setTextAlignment:NSTextAlignmentCenter];
    [descLabel setText:desc];
    [descLabel setTextColor:UIColorFromHex(0x4e8cef)];
    
    [descView addSubview:descLabel];
    
    __weak UIView * tmpView = descView;
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpView);
    }];
    
    return descView;
}

#pragma mark - setter/getter
- (NSMutableArray *)viewArray
{
    if (!_viewArray)
    {
        _viewArray = [[NSMutableArray alloc] init];
    }
    return _viewArray;
}


@end
