//
//  CustomRemindView.m
//  FinancialManager
//
//  Created by xnkj on 05/05/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "CustomRemindView.h"
#import "UIView+CornerRadius.h"
#import "NSString+common.h"

#define DURATION 0.3f
@interface CustomRemindView()

@end

@implementation CustomRemindView

//初始化保职提示视图
- (id)initKeepLevelRemindViewWithTitle:(NSString *)title
                            desContent:(NSString *)descContent
                        detailContent:(NSString *)detailContent
{
    self = [super init];
    if (self) {
        
        self.frame = SCREEN_FRAME;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        UIImageView * contentView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"popBg.png"]];
        [contentView setUserInteractionEnabled:YES];
        
        CGFloat height = 0.0f;
        
        //banner 视图
        UIImageView * bannerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"remindBanner.png"]];
        UILabel * bannerTitleLabel = [[UILabel alloc]init];
        [bannerTitleLabel setNumberOfLines:0];
        [bannerTitleLabel setLineBreakMode:NSLineBreakByCharWrapping];
        
        NSString * titleContent = @"";
        NSArray * titleArray = [title componentsSeparatedByString:@"|"];
        for (NSString * str in titleArray) {
            
            if (titleContent.length <= 0) {
                
                titleContent = str;
                continue;
            }
            
            titleContent = [titleContent stringByAppendingFormat:@"\n%@",str];
        }
        
        [bannerTitleLabel setText:titleContent];
        [bannerTitleLabel setFont:[UIFont systemFontOfSize:32]];
        [bannerTitleLabel setTextColor:[UIColor whiteColor]];
        [bannerTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [bannerView addSubview:bannerTitleLabel];
        [contentView addSubview:bannerView];
        
        weakSelf(weakSelf)
        __weak UIView * tmpBannerView = bannerView;
        [bannerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.edges.equalTo(tmpBannerView);
        }];
        
        __weak UIView * tmpContentView = contentView;
        [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpContentView.mas_leading);
            make.top.mas_equalTo(tmpContentView.mas_top);
            make.trailing.mas_equalTo(tmpContentView.mas_trailing);
            make.height.mas_equalTo(@(SCREEN_FRAME.size.width * 0.4 * 0.85));
        }];
        height = SCREEN_FRAME.size.width * 0.4 * 0.85;
        
        //内容
        CGFloat lastTopIntervalValue = 20.0f;
        __weak UIView * lastTopView= bannerView;
        if ([NSObject isValidateInitString:descContent]) {
            
            CGFloat contentHeight = [descContent sizeOfStringWithFont:16 InRect:CGSizeMake(SCREEN_FRAME.size.width * 0.85, 10000)].height;
            UIColor * normalColor = nil;
            UIColor * specialColor = nil;
            
            UILabel * contentLabel = [[UILabel alloc]init];
            [contentLabel setNumberOfLines:0];
            [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
            
            NSMutableArray * attributeArray = [NSMutableArray array];
            
            NSArray * contentArray = [descContent componentsSeparatedByString:@"<"];
            if (contentArray.count > 2) {
                
                [contentLabel setTextAlignment:NSTextAlignmentCenter];
                normalColor = UIColorFromHex(0x323232);
                specialColor = UIColorFromHex(0x02a0f2);
            }else
            {
                [contentLabel setTextAlignment:NSTextAlignmentLeft];
                normalColor = UIColorFromHex(0x6c6e6d);
                specialColor = UIColorFromHex(0x3e4446);
            }
            
            for (NSString * str in contentArray) {
                
                if ([str containsString:@">"]) {
                    
                    contentArray = [str componentsSeparatedByString:@">"];
                    if (contentArray.count == 1) {
                        
                        [attributeArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[contentArray objectAtIndex:0],@"range",specialColor,@"color",[UIFont systemFontOfSize:16],@"font", nil]];
                    }else
                    {
                        [attributeArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[contentArray objectAtIndex:0],@"range",specialColor,@"color",[UIFont systemFontOfSize:16],@"font", nil]];
                        [attributeArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[contentArray objectAtIndex:1],@"range",normalColor,@"color",[UIFont systemFontOfSize:16],@"font", nil]];
                    }
                }else
                {
                    [attributeArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"range",normalColor,@"color",[UIFont systemFontOfSize:16],@"font", nil]];
                }
            }
            
            [contentLabel setAttributedText:[NSString getAttributeStringWithAttributeArray:attributeArray]];
            [contentLabel setTextAlignment:NSTextAlignmentCenter];
            [contentView addSubview:contentLabel];
            
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.mas_equalTo(tmpContentView.mas_leading);
                make.top.mas_equalTo(tmpBannerView.mas_bottom).offset(30);
                make.trailing.mas_equalTo(tmpContentView.mas_trailing);
                make.height.mas_equalTo(contentHeight);
            }];
            height = height + contentHeight + 30;
            lastTopView = contentLabel;
            lastTopIntervalValue = 12.0f;
        }
        
        //设置详情
        NSArray * descArray = [detailContent componentsSeparatedByString:@"|"];
        UILabel * descLabel = nil;
        for (NSString * desc in descArray) {
            
            if ([NSObject isValidateInitString:desc]) {
                
                descLabel = [[UILabel alloc]init];
                [descLabel setText:desc];
                [descLabel setTextColor:UIColorFromHex(0xa7a7a7)];
                [descLabel setTextAlignment:NSTextAlignmentCenter];
                [descLabel setFont:[UIFont systemFontOfSize:16]];
            
                [contentView addSubview:descLabel];
                
                [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.leading.mas_equalTo(tmpContentView.mas_leading);
                    make.top.mas_equalTo(lastTopView.mas_bottom).offset(lastTopIntervalValue);
                    make.trailing.mas_equalTo(tmpContentView.mas_trailing);
                    make.height.mas_equalTo(16);
                }];
                height = height + 12 + 16;
                lastTopIntervalValue = 12.0f;
                lastTopView = descLabel;
            }
        }
        
        //点击查看
        UIButton * checkBtn = [[UIButton alloc]init];
        [checkBtn setBackgroundImage:[UIImage imageNamed:@"remindBtn.png"] forState:UIControlStateNormal];
        [checkBtn setTitle:@"点击查看" forState:UIControlStateNormal];
        [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [checkBtn addTarget:self
                     action:@selector(clickCheckDetail) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:checkBtn];
        
        [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(tmpContentView.mas_centerX);
            make.top.mas_equalTo(lastTopView.mas_bottom).offset(20);
            make.width.mas_equalTo(tmpContentView.mas_width).multipliedBy(0.6);
            make.height.mas_equalTo(@(SCREEN_FRAME.size.width * 0.6 * 0.214 * 0.85));
        }];
        height = height + 20 + SCREEN_FRAME.size.width * 0.6 * 0.214 * 0.85+ 20;
        
        UIButton * cancelButton = [[UIButton alloc]init];
        [cancelButton setImage:[UIImage imageNamed:@"XN_Common_Cancel_White_icon"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:cancelButton];
        [self addSubview:contentView];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(weakSelf.mas_centerX);
            make.centerY.mas_equalTo(weakSelf.mas_centerY).offset(-40);
            make.width.mas_equalTo(weakSelf.mas_width).multipliedBy(0.85);
            make.height.mas_equalTo(height);
        }];
        
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(weakSelf.mas_centerX);
            make.centerY.mas_equalTo(tmpContentView.mas_bottom).offset(40);
            make.width.mas_equalTo(@(30));
            make.width.mas_equalTo(@(30));
        }];
    }
    return self;
}

//设置点击操作
- (void)setClickCustomRemindViewBlock:(clickRemindViewBlock)block
{
    if (block) {
        
        self.block = block;
    }
}

//设置点击查看详情
- (void)setClickCheckDetailBlock:(clickRemindCheckDetail)block
{
    if (block) {
        
        self.checkDetailBlock = block;
    }
}

//查看详情
- (void)clickCheckDetail
{
    if (self.checkDetailBlock) {
        
        self.checkDetailBlock();
        
        [self hide];
    }
}

//弹出显示
- (void)showInView:(UIViewController *)ctrl
{
    if (ctrl) {
       
        [ctrl.view addSubview:self];
    }else
    {
        [_KEYWINDOW addSubview:self];
    }
}

//隐藏
- (void)hide
{
    [UIView animateWithDuration:DURATION animations:^{
        
        self.frame = CGRectOffset(self.frame, 0, SCREEN_FRAME.size.height);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        self.frame = CGRectOffset(self.frame, 0, -SCREEN_FRAME.size.height);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        if (self.block) {
            
            self.block();
        }
    }];
}
@end
