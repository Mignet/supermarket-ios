//
//  ManagerFinancialStableCell.m
//  FinancialManager
//
//  Created by xnkj on 15/12/23.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "ManagerFinancialProgressCell.h"
#import "SaleProgressView.h"
#import "UIView+CornerRadius.h"
#import "XNFMProductListItemMode.h"

#define productTag 0x11111112

@interface ManagerFinancialProgressCell()

@property (nonatomic, assign) NSInteger        index;
@property (nonatomic, assign) NSInteger        section;
@property (nonatomic, strong) XNFMProductListItemMode * productParams;
@property (nonatomic, strong) NSMutableArray          * viewArray;

@property (nonatomic, weak) IBOutlet UIImageView * productLogoImageView;
@property (nonatomic, weak) IBOutlet UIImageView * productTagImageView;
@property (nonatomic, weak) IBOutlet UILabel * productNameLabel;
@property (nonatomic, weak) IBOutlet UILabel * commissionRateLabel;
@property (nonatomic, weak) IBOutlet UILabel * expectYearRateLabel;
@property (nonatomic, weak) IBOutlet UILabel * deadLineLabel;
@property (nonatomic, weak) IBOutlet UILabel * comissionTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel * expectYearRateTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel * deadLineTitleLabel;

@property (nonatomic, assign) NSTimeInterval  countDownInterval;
@property (nonatomic, strong) NSTimer     *   timer;//定时器
@property (nonatomic, weak) IBOutlet UILabel   * reTimeTitleLabel; //倒计时标题
@property (nonatomic, weak) IBOutlet UILabel   * timeLabel; //倒计时

@property (nonatomic, weak) IBOutlet SaleProgressView * recommandView;
@property (nonatomic, weak) IBOutlet UILabel          * saleStatusLabel;
@end

@implementation ManagerFinancialProgressCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark - 刷新
- (void)refreshDataWithParams:(XNFMProductListItemMode *)params section:(NSInteger)section index:(NSInteger)index
{
    self.section = section;
    self.index = index;
    self.productParams = params;
    
    //显示logo和产品名
    NSString *urlString = [NSString stringWithFormat:@"%@?f=png", [_LOGIC getImagePathUrlWithBaseUrl:params.productLogo]];
    [self.productLogoImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    [self.productNameLabel setText:params.productName];
    
    //产品标签
    [self.productTagImageView setHidden:YES];
    if (params.ifRookie == 1) {
        
        [self.productTagImageView setHidden:NO];
    }
    
    //设置年化率
    NSArray * expectYearRate_Property = nil;
    if (params.isFlow == 1) {
        
        expectYearRate_Property = @[@{@"range":[NSString stringWithFormat:@"%.2f",params.fixRate],
                                      @"color": UIColorFromHex(0xfd5d5d),
                                      @"font": [UIFont fontWithName:@"DINOT" size:18]},
                                    @{@"range": @"%",
                                      @"color": UIColorFromHex(0xfd5d5d),
                                      @"font": [UIFont fontWithName:@"DINOT" size:11]}];
    }else
    {
        expectYearRate_Property  = @[@{@"range":[NSString stringWithFormat:@"%.2f~%.2f",params.flowMinRate,params.flowMaxRate],
                                       @"color": UIColorFromHex(0xfd5d5d),
                                       @"font": [UIFont fontWithName:@"DINOT" size:18]},
                                     @{@"range": @"%",
                                       @"color": UIColorFromHex(0xfd5d5d),
                                       @"font": [UIFont fontWithName:@"DINOT" size:11]}];
    }
    [self.expectYearRateLabel refreshPropertyArray:expectYearRate_Property Alignment:NSTextAlignmentLeft];
    
    //佣金率
    NSArray * commissionRate_Property = @[@{@"range":[NSString stringWithFormat:@"%.2f",params.feeRatio],
                                            @"color": UIColorFromHex(0x666666),
                                            @"font": [UIFont fontWithName:@"DINOT" size:14]},
                                          @{@"range": @"%",
                                            @"color": UIColorFromHex(0x666666),
                                            @"font": [UIFont fontWithName:@"DINOT" size:11]}];
    [self.commissionRateLabel refreshPropertyArray:commissionRate_Property Alignment:NSTextAlignmentLeft];
    
    //期限
    NSArray * deadLine_Property = nil;
    NSArray * deadLineArray = [params.deadLine componentsSeparatedByString:@","];
    if (params.isFixedDeadline == 1) {
        
        deadLine_Property = @[@{@"range":[[NSString stringWithFormat:@"%@",[deadLineArray objectAtIndex:0]] stringByReplacingOccurrencesOfString:@" " withString:@""],
                                @"color": UIColorFromHex(0x3e4446),
                                @"font": [UIFont fontWithName:@"DINOT" size:18]},
                              @{@"range": [[deadLineArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""],
                                @"color": UIColorFromHex(0x3e4446),
                                @"font": [UIFont systemFontOfSize:11]}];
    }else
    {
        NSString * unitOne = [deadLineArray objectAtIndex:1];
        NSString * unitTwo = [deadLineArray objectAtIndex:3];
        if ([[deadLineArray objectAtIndex:1] isEqualToString:[deadLineArray objectAtIndex:3]]) {
            
            unitOne = @"";
            unitTwo = [deadLineArray objectAtIndex:1];
        }
        deadLine_Property = @[@{@"range":[[NSString stringWithFormat:@"%@",[deadLineArray objectAtIndex:0]] stringByReplacingOccurrencesOfString:@" " withString:@""],
                                @"color": UIColorFromHex(0x3e4446),
                                @"font": [UIFont fontWithName:@"DINOT" size:18]},
                              @{@"range": [[NSString stringWithFormat:@"%@~",unitOne] stringByReplacingOccurrencesOfString:@" " withString:@""],
                                @"color": UIColorFromHex(0x3e4446),
                                @"font": [UIFont fontWithName:@"DINOT" size:11]},
                              @{@"range":[[NSString stringWithFormat:@"%@",[deadLineArray objectAtIndex:2]] stringByReplacingOccurrencesOfString:@" " withString:@""],
                                @"color": UIColorFromHex(0x3e4446),
                                @"font": [UIFont fontWithName:@"DINOT" size:18]},
                              @{@"range": [unitTwo stringByReplacingOccurrencesOfString:@" " withString:@""],
                                @"color": UIColorFromHex(0x3e4446),
                                @"font": [UIFont systemFontOfSize:11]}];
        
    }
    [self.deadLineLabel refreshPropertyArray:deadLine_Property Alignment:NSTextAlignmentLeft];
    
    //创建产品标签
    [self createProductTagWithParams:params];
    
    NSTimeInterval saleStartTimeInterval = [NSString intervalFromDate:params.saleStartTime];
    NSTimeInterval currentTimerInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval serverTimerInterval = currentTimerInterval - params.intervalSecondFromServerTimerToLocalTimer;
    
    if (saleStartTimeInterval - serverTimerInterval > 0) {
        
        [self.saleStatusLabel setHidden:YES];
        [self.reTimeTitleLabel setHidden:NO];
        [self.timeLabel setHidden:NO];
        [self.recommandView showSaleProgressWithProgressValue:0 backgroundImageName:@"XN_FinancialManager_cell_progress_Icon.png"];
        
        //倒计时处理
        [self handleCountDown:params];
        
        return;
    }
    
    [self.timer invalidate];
    self.timer = nil;
    [self.saleStatusLabel setHidden:NO];
    [self.reTimeTitleLabel setHidden:YES];
    [self.timeLabel setHidden:YES];
    
    if (params.saleStatus == 1) {
    
        CGFloat  progressValue =  (params.buyedTotalMoney / params.buyTotalMoney) > 1? 1:(params.buyedTotalMoney / params.buyTotalMoney);
        
        [self.recommandView showSaleProgressWithProgressValue:progressValue backgroundImageName:@"XN_FinancialManager_cell_progress_Icon.png"];
        
        //显示具体售罄的值
        NSString *  progressValueStr = @"0";
        NSInteger progressIntValue = 0;
        if (((int)params.buyTotalMoney) > 0) {
    
            self.saleStatusLabel.hidden = NO;
            
            progressIntValue = (int)((params.buyedTotalMoney / params.buyTotalMoney)* 100) > 100? 100:(int)((params.buyedTotalMoney / params.buyTotalMoney)* 100);
            progressValueStr = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:progressIntValue]];
            
            [self.saleStatusLabel setText:[NSString stringWithFormat:@"%@%@",progressValueStr,@"%"]];
        }
    }else
    {
        [self.saleStatusLabel setText:@""];
        [self.recommandView showSaleProgressWithProgressValue:0 backgroundImageName:@"XN_FinancialManager_Product_sellout_icon.png"];
    }
}

#pragma mark - 计算倒计时
- (void)handleCountDown:(XNFMProductListItemMode *)params
{
    NSTimeInterval saleStartTimeInterval = [NSString intervalFromDate:params.saleStartTime];
    NSTimeInterval currentTimerInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval serverTimerInterval = currentTimerInterval - params.intervalSecondFromServerTimerToLocalTimer;
    
    self.countDownInterval = 0;
    [self.timeLabel setText:@""];
    self.countDownInterval = saleStartTimeInterval - serverTimerInterval;
    
    [self.timer invalidate];
    self.timer = nil;
    
    NSString * countDownStr = [NSString stringFromInterval:self.countDownInterval];
    [self.timeLabel setText:countDownStr];
    
    if (!self.timer) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(countDown) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark - 时时倒计时
- (void)countDown
{
    if (self.countDownInterval <= 0) {
        
        [self.timer invalidate];
        self.timer = nil;
        
        self.productParams.saleStartTime = @"2010-07-21";
        [self refreshDataWithParams:self.productParams section:self.section index:self.index];
        return;
    }
    
    NSString * countDownStr = [NSString stringFromInterval:self.countDownInterval];
    
    [self.timeLabel setText:countDownStr];
    
    self.countDownInterval = self.countDownInterval - 1;
}

//创建产品标签
- (void)createProductTagWithParams:(XNFMProductListItemMode *)params
{
    for (UIView * tmpView in self.viewArray)
    {
        [tmpView removeFromSuperview];
    }
    
    if (!params.tagArray || params.tagArray.count <= 0)
    {
        return;
    }

    CGFloat left = [self.productNameLabel.text sizeWithStringFont:12 InRect:CGSizeMake((219 * SCREEN_FRAME.size.width) / 375, 18)].width + 18;
    for (int i = 0 ; i < params.tagArray.count; i ++ )
    {
        UIView * tmpView = [self createTagWithDesc:[params.tagArray objectAtIndex:i]];
        [self addSubview:tmpView];
        
        UILabel * tmpLabel = [tmpView viewWithTag:productTag];
        [tmpLabel setTextColor:UIColorFromHex(0xfd5d5d)];
        
        [tmpLabel sizeToFit];
        CGSize size = tmpLabel.size;
        
        __weak UIImageView *tmpProductLogoImageView = self.productLogoImageView;
        __weak UILabel * tmpProductNameLabel = self.productNameLabel;
        [tmpView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(tmpProductLogoImageView.mas_trailing).offset(left);
            make.top.mas_equalTo(tmpProductNameLabel.mas_top).offset(2);
            make.width.mas_equalTo(size.width + 10);
            make.height.mas_equalTo(16);
        }];
        [tmpView drawRoundCornerWithRectSize:CGSizeMake(size.width + 10, 16) backgroundColor:[UIColor whiteColor] borderWidth:0.5 borderColor:UIColorFromHex(0xfd5d5d) radio:3];
        
        [self.viewArray addObject:tmpView];
        
        left = left + size.width + 15;
    }
    
}

//创建标签
- (UIView *)createTagWithDesc:(NSString *)desc
{
    UIView *descView = [[UIView alloc] init];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setBackgroundColor:[UIColor clearColor]];
    [descLabel setTag:productTag];
    [descLabel setFont:[UIFont systemFontOfSize:10]];
    [descLabel setTextAlignment:NSTextAlignmentCenter];
    [descLabel setText:desc];
    [descLabel setTextColor:UIColorFromHex(0xfd5d5d)];
    
    [descView addSubview:descLabel];
    
    __weak UIView * tmpView = descView;
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpView);
    }];
    
    return descView;
}

///////////////////////////
#pragma mark - setter/getter
////////////////////////////////////////

//viewArray
- (NSMutableArray *)viewArray
{
    if (!_viewArray)
    {
        _viewArray = [[NSMutableArray alloc] init];
    }
    return _viewArray;
}
@end
