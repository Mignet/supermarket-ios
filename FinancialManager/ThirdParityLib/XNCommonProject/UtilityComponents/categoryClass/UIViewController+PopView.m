//
//  UIViewController+PopView.m
//  FinancialManager
//
//  Created by xnkj on 15/9/30.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "UIViewController+PopView.h"
#import "UILabel+Extend.h"
#import "objc/runtime.h"
#import "UniversalInteractWebViewController.h"

#define DEFAULTWARNPOPVIEWWIDTH  274.0f
#define DEFAULTWARNPOPTITLEWIDTH 198.0f
#define DEFAULTWARNPOPVIEWINTERVAL 65.0f
#define DEFAULTMAXHEIGHT        2000.0f

#define CURSORVIEWTAG            111111
#define ANNOUNCEBTNTAG           111112
#define MYMESSAGEBTNTAG          111113
#define CONTENTLABELTAG          111114

#define XNREVIEWTAG              @"xnreviewtag"

@implementation UIViewController(PopView)

#pragma mark - 自定义弹出提示框
- (void)showCustomWarnViewWithContent:(NSString *)content
{
    [self showCustomWarnViewWithContent:content Completed:nil];
}

- (void)showCustomWarnViewWithContent:(NSString *)content Completed:(completeBlock)completed
{
    if ([NSObject isValidateInitString:content]) {
    
        if (completed) {
            
            objc_setAssociatedObject(self, XN_RUNTIME_WARNING_BLOCK_KEY, completed, OBJC_ASSOCIATION_COPY);
        }
        
        UIView * shadowBgView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0 , SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
        
        UIView * customPopView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, DEFAULTWARNPOPVIEWWIDTH, 0)];
        
        UIImageView * customPopBackgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0 , DEFAULTWARNPOPVIEWWIDTH, 0)];
        [customPopBackgroundImg setImage:[UIImage imageNamed:@"xn_popview_bg.png"]];
        [customPopView.layer setMasksToBounds:YES];
        [customPopView.layer setCornerRadius:10.0f];
        
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0 , DEFAULTWARNPOPTITLEWIDTH, 0)];
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [titleLabel setTextColor:UIColorFromHex(0x666666)];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setText:content];
        
        
        [customPopView addSubview:customPopBackgroundImg];
        [customPopView addSubview:titleLabel];
        
        CGSize size = CGSizeZero;
        size = [titleLabel sizeThatFits:CGSizeMake(DEFAULTWARNPOPTITLEWIDTH, DEFAULTMAXHEIGHT)];
        
        __weak UIView * tmpCustomPopView = customPopView;
        [customPopBackgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(tmpCustomPopView);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(tmpCustomPopView);
            make.width.mas_equalTo(@(DEFAULTWARNPOPTITLEWIDTH));
            make.height.mas_equalTo(@(size.height));
        }];
        
        //显示
        [shadowBgView addSubview:customPopView];
        [self.view addSubview:shadowBgView];
        
        NSMutableArray * shadowBgViewArray = nil;
        if (!objc_getAssociatedObject(self, XN_RUNTIME_KEY)) {
            
            shadowBgViewArray = [NSMutableArray arrayWithObject:shadowBgView];
        }else
        {
            shadowBgViewArray = objc_getAssociatedObject(self, XN_RUNTIME_KEY);
            [shadowBgViewArray addObject:shadowBgView];
            
        }
        objc_setAssociatedObject(self, XN_RUNTIME_KEY, shadowBgViewArray, OBJC_ASSOCIATION_RETAIN);
        
        weakSelf(weakSelf)
        __weak UIView * tmpView =shadowBgView;
        [customPopView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(tmpView);
            make.width.mas_equalTo(@(DEFAULTWARNPOPVIEWWIDTH));
            make.height.mas_equalTo(@(DEFAULTWARNPOPVIEWINTERVAL + size.height));
        }];
        
        [shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakSelf.view);
        }];
        
        [self performSelector:@selector(hideBeforeCompleted) withObject:nil afterDelay:CUSTOMALERTVIEWSHOW];
    }
}

- (void)showCustomWarnViewWithContent:(NSString *)content Completed:(completeBlock)completed showTime:(NSTimeInterval )delyTime
{
    if ([NSObject isValidateInitString:content]) {
        
        if (completed) {
            
            objc_setAssociatedObject(self, XN_RUNTIME_WARNING_BLOCK_KEY, completed, OBJC_ASSOCIATION_COPY);
        }
        
        
        UIView * shadowBgView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0 , SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
        [shadowBgView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
        
        UIView * customPopView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, DEFAULTWARNPOPVIEWWIDTH, 0)];
        
        UIImageView * customPopBackgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0 , DEFAULTWARNPOPVIEWWIDTH, 0)];
        [customPopBackgroundImg setImage:[UIImage imageNamed:@"xn_popview_bg.png"]];
        [customPopView.layer setMasksToBounds:YES];
        [customPopView.layer setCornerRadius:10.0f];
        
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0 , DEFAULTWARNPOPTITLEWIDTH, 0)];
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setText:content];
        
        
        [customPopView addSubview:customPopBackgroundImg];
        [customPopView addSubview:titleLabel];
        
        CGSize size = CGSizeZero;
        size = [titleLabel sizeThatFits:CGSizeMake(DEFAULTWARNPOPTITLEWIDTH, DEFAULTMAXHEIGHT)];
        
        __weak UIView * tmpCustomPopView = customPopView;
        [customPopBackgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(tmpCustomPopView);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(tmpCustomPopView);
            make.width.mas_equalTo(@(DEFAULTWARNPOPTITLEWIDTH));
            make.height.mas_equalTo(@(size.height));
        }];
        
        //显示
        [shadowBgView addSubview:customPopView];
        [self.view addSubview:shadowBgView];
        
        NSMutableArray * shadowBgViewArray = nil;
        if (!objc_getAssociatedObject(self, XN_RUNTIME_KEY)) {
            
            shadowBgViewArray = [NSMutableArray arrayWithObject:shadowBgView];
        }else
        {
            shadowBgViewArray = objc_getAssociatedObject(self, XN_RUNTIME_KEY);
            [shadowBgViewArray addObject:shadowBgView];
            
        }
        objc_setAssociatedObject(self, XN_RUNTIME_KEY, shadowBgViewArray, OBJC_ASSOCIATION_RETAIN);
        
        weakSelf(weakSelf)
        __weak UIView * tmpView =shadowBgView;
        [customPopView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(tmpView);
            make.width.mas_equalTo(@(DEFAULTWARNPOPVIEWWIDTH));
            make.height.mas_equalTo(@(DEFAULTWARNPOPVIEWINTERVAL + size.height));
        }];
        
        [shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakSelf.view);
        }];
        
        [self performSelector:@selector(hideBeforeCompleted) withObject:nil afterDelay:delyTime];
    }
}

- (void)showCustomSpecialWarnViewWithContent:(NSString *)content Completed:(completeBlock)completed showTime:(NSTimeInterval )delyTime
{
    if ([NSObject isValidateInitString:content]) {
        
        if (completed) {
            
            objc_setAssociatedObject(self, XN_RUNTIME_WARNING_BLOCK_KEY, completed, OBJC_ASSOCIATION_COPY);
        }
        
        
        UIView * shadowBgView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0 , SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
        [shadowBgView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
        
        UIView * customPopView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, DEFAULTWARNPOPVIEWWIDTH, 0)];
        customPopView.transform =CGAffineTransformMakeRotation(M_PI/2);
        
        UIImageView * customPopBackgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0 , DEFAULTWARNPOPVIEWWIDTH, 0)];
        [customPopBackgroundImg setImage:[UIImage imageNamed:@"xn_popview_bg.png"]];
        [customPopView.layer setMasksToBounds:YES];
        [customPopView.layer setCornerRadius:10.0f];
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0 , DEFAULTWARNPOPTITLEWIDTH, 0)];
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setText:content];
        
        [customPopView addSubview:customPopBackgroundImg];
        [customPopView addSubview:titleLabel];
        
        CGSize size = CGSizeZero;
        size = [titleLabel sizeThatFits:CGSizeMake(DEFAULTWARNPOPTITLEWIDTH, DEFAULTMAXHEIGHT)];
        
        __weak UIView * tmpCustomPopView = customPopView;
        [customPopBackgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(tmpCustomPopView);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(tmpCustomPopView);
            make.width.mas_equalTo(@(DEFAULTWARNPOPTITLEWIDTH));
            make.height.mas_equalTo(@(size.height));
        }];
        
        //显示
        [shadowBgView addSubview:customPopView];
        [self.view addSubview:shadowBgView];
        
        NSMutableArray * shadowBgViewArray = nil;
        if (!objc_getAssociatedObject(self, XN_RUNTIME_KEY)) {
            
            shadowBgViewArray = [NSMutableArray arrayWithObject:shadowBgView];
        }else
        {
            shadowBgViewArray = objc_getAssociatedObject(self, XN_RUNTIME_KEY);
            [shadowBgViewArray addObject:shadowBgView];
            
        }
        objc_setAssociatedObject(self, XN_RUNTIME_KEY, shadowBgViewArray, OBJC_ASSOCIATION_RETAIN);
        
        weakSelf(weakSelf)
        __weak UIView * tmpView =shadowBgView;
        [customPopView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(tmpView);
            make.width.mas_equalTo(@(DEFAULTWARNPOPVIEWWIDTH));
            make.height.mas_equalTo(@(DEFAULTWARNPOPVIEWINTERVAL + size.height));
        }];
        
        [shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakSelf.view);
        }];
        
        [self performSelector:@selector(hideBeforeCompleted) withObject:nil afterDelay:delyTime];
    }
}


#pragma mark - 多内容提示
- (void)showCustomWarnViewWithContent:(NSString *)content SubContent:(NSString *)subContent
{
    UIView * shadowBgView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0 , SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
    [shadowBgView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    
    UIView * customPopView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, DEFAULTWARNPOPVIEWWIDTH, 0)];
    
    UIImageView * customPopBackgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0 , DEFAULTWARNPOPVIEWWIDTH, 0)];
    [customPopBackgroundImg setImage:[UIImage imageNamed:@"xn_popview_bg.png"]];
    [customPopView.layer setMasksToBounds:YES];
    [customPopView.layer setCornerRadius:10.0f];
    
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0 , DEFAULTWARNPOPTITLEWIDTH, 0)];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:content];
    
    UILabel * seperatorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0 , DEFAULTWARNPOPVIEWWIDTH, 0.5)];
    [seperatorLabel setBackgroundColor:[UIColor grayColor]];
    
    UILabel * subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0 , DEFAULTWARNPOPTITLEWIDTH, 0)];
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [subTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [subTitleLabel setText:subContent];
    
    
    [customPopView addSubview:customPopBackgroundImg];
    [customPopView addSubview:titleLabel];
    [customPopView addSubview:seperatorLabel];
    [customPopView addSubview:subTitleLabel];
    
    CGSize size = CGSizeZero;
    size = [titleLabel sizeThatFits:CGSizeMake(DEFAULTWARNPOPTITLEWIDTH, DEFAULTMAXHEIGHT)];
    
    CGSize subSize = CGSizeZero;
    subSize = [subTitleLabel sizeThatFits:CGSizeMake(DEFAULTWARNPOPTITLEWIDTH, DEFAULTMAXHEIGHT)];
    
    __weak UIView * tmpCustomPopView = customPopView;
    [customPopBackgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpCustomPopView);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading);
        make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(10);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing);
        make.height.mas_equalTo(@(size.height));
    }];
    
    __weak UILabel * tmpTitleLabel = titleLabel;
    [seperatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading);
        make.top.mas_equalTo(tmpTitleLabel.mas_bottom).offset(10);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing);
        make.height.mas_equalTo(@(0.5));
        
    }];
    
    __weak UILabel * tmpSeperatorLabel = seperatorLabel;
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing);
        make.top.mas_equalTo(tmpSeperatorLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(@(subSize.height));
    }];
    
    //显示
    [shadowBgView addSubview:customPopView];
    [self.view addSubview:shadowBgView];
    
    NSMutableArray * shadowBgViewArray = nil;
    if (!objc_getAssociatedObject(self, XN_RUNTIME_KEY)) {
        
        shadowBgViewArray = [NSMutableArray arrayWithObject:shadowBgView];
    }else
    {
        shadowBgViewArray = objc_getAssociatedObject(self, XN_RUNTIME_KEY);
        [shadowBgViewArray addObject:shadowBgView];
        
    }
    objc_setAssociatedObject(self, XN_RUNTIME_KEY, shadowBgViewArray, OBJC_ASSOCIATION_RETAIN);

    
    weakSelf(weakSelf)
    __weak UIView * tmpView =shadowBgView;
    [customPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(tmpView);
        make.width.mas_equalTo(@(DEFAULTWARNPOPVIEWWIDTH));
        make.height.mas_equalTo(@(40 + size.height+subSize.height));
    }];
    
    [shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];
    
    [self performSelector:@selector(hide) withObject:nil afterDelay:CUSTOMALERTVIEWSHOW];
}

#pragma makr - 自定义弹出点击框（一个按钮,根据URL)
- (void)showCustomAlertViewWithUrl:(NSString *)url okTitle:(NSString *)okTitle okTitleColor:(UIColor *)okTitleColor okCompleteBlock:(completeBlock)okCompleted topPadding:(CGFloat )topPadding
{
    if (okCompleted) {
        
        objc_setAssociatedObject(self, XN_RUNTIME_OK_BLOCK_KEY, okCompleted, OBJC_ASSOCIATION_COPY);
    }
    
    UIView * shadowBgView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0 , SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
    [shadowBgView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    
    UIView * customPopView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
    
    UIImageView * customPopBackgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0 , SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
    [customPopBackgroundImg setImage:[UIImage imageNamed:@"xn_popview_bg.png"]];
    
    float fWebViewHeight = SCREEN_FRAME.size.height / 2;
    
    UniversalInteractWebViewController *webViewController = [[UniversalInteractWebViewController alloc] initRequestUrl:url requestMethod:@"GET"];
    [webViewController setNewWebView:YES];
    
    UILabel * seperatorLine = [[UILabel alloc]initWithFrame:CGRectMake(0 , 45, SCREEN_FRAME.size.width, 0.5)];
    [seperatorLine setBackgroundColor:[UIColor lightGrayColor]];
    
    if (okTitleColor == nil)
    {
        okTitleColor = UIColorFromHex(0xdc4437);
    }
    
    UIButton * okBtn = [[UIButton alloc]initWithFrame:CGRectMake(0 , 46 , SCREEN_FRAME.size.width, 45)];
    [okBtn setTitleColor:okTitleColor forState:UIControlStateNormal];
    [okBtn setTitle:okTitle forState:UIControlStateNormal];
    okBtn.backgroundColor = [UIColor whiteColor];
    okBtn.layer.borderWidth = 0.5;
    okBtn.layer.borderColor = JFZ_LINE_COLOR_GRAY.CGColor;
    [okBtn addTarget:self action:@selector(clickOk) forControlEvents:UIControlEventTouchUpInside];
    
    JCLogInfo(@"count:%ld",CFGetRetainCount((__bridge CFTypeRef)(webViewController)));
    [self addChildViewController:webViewController];
    [customPopView addSubview:customPopBackgroundImg];
    [customPopView addSubview:webViewController.view];
    JCLogInfo(@"count:%ld",CFGetRetainCount((__bridge CFTypeRef)(webViewController)));
    [customPopView addSubview:seperatorLine];
    [customPopView addSubview:okBtn];
    
    __weak UIView * tmpCustomPopView = customPopView;
    [customPopBackgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpCustomPopView);
    }];
    
    [webViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading);
        make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(topPadding);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing);
        make.height.mas_equalTo(fWebViewHeight);
    }];
    
    [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.equalTo(tmpCustomPopView);
        make.top.mas_equalTo(tmpCustomPopView.mas_bottom).offset( - 45);
        make.height.mas_equalTo(0.5);
    }];
    
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading);
        make.bottom.mas_equalTo(tmpCustomPopView.mas_bottom);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(@(45));
    }];
    
    //显示
    [shadowBgView addSubview:customPopView];
    [self.view addSubview:shadowBgView];
    
    NSMutableArray * shadowBgViewArray = nil;
    if (!objc_getAssociatedObject(self, XN_RUNTIME_KEY)) {
        
        shadowBgViewArray = [NSMutableArray arrayWithObject:shadowBgView];
    }else
    {
        shadowBgViewArray = objc_getAssociatedObject(self, XN_RUNTIME_KEY);
        [shadowBgViewArray addObject:shadowBgView];
        
    }
    objc_setAssociatedObject(self, XN_RUNTIME_KEY, shadowBgViewArray, OBJC_ASSOCIATION_RETAIN);
    
    weakSelf(weakSelf)
    __weak UIView * tmpView =shadowBgView;
    [customPopView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(tmpView);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(@(fWebViewHeight + 45 + topPadding * 2));
        make.bottom.mas_equalTo(tmpView.mas_bottom);
    }];
    
    [shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];
}

#pragma makr - 自定义弹出点击框（一个按钮)
- (void)showCustomAlertViewWithTitle:(NSString *)title okTitle:(NSString *)okTitle okTitleColor:(UIColor *)okTitleColor okCompleteBlock:(completeBlock)okCompleted topPadding:(CGFloat )topPadding textAlignment:(NSTextAlignment)textAlignment
{
    if (okCompleted) {
        
        objc_setAssociatedObject(self, XN_RUNTIME_OK_BLOCK_KEY, okCompleted, OBJC_ASSOCIATION_COPY);
    }
    
    UIView * shadowBgView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0 , SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
    [shadowBgView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    
    UIView * customPopView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, 270, 206)];
    
    UIImageView * customPopBackgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0 , 270, 206)];
    [customPopBackgroundImg setImage:[UIImage imageNamed:@"xn_popview_bg.png"]];
    [customPopView.layer setMasksToBounds:YES];
    [customPopView.layer setCornerRadius:10.0f];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0 , 270, 60)];
    [titleLabel setTextAlignment:textAlignment];
    [titleLabel setNumberOfLines:0];
    [titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    
    [titleLabel setAttributedText:[self attributeStringWithStr:title]];
    
    CGSize size = CGSizeZero;
    size = [titleLabel sizeThatFits:CGSizeMake(230, DEFAULTMAXHEIGHT)];
    
    UILabel * seperatorLine = [[UILabel alloc]initWithFrame:CGRectMake(0 , 45, 270, 0.5)];
    [seperatorLine setBackgroundColor:[UIColor lightGrayColor]];
    
    if (okTitleColor == nil)
    {
        okTitleColor = UIColorFromHex(0xdc4437);
    }
    
    UIButton * okBtn = [[UIButton alloc]initWithFrame:CGRectMake(0 , 46 , 270, 45)];
    [okBtn setTitleColor:okTitleColor forState:UIControlStateNormal];
    [okBtn setTitle:okTitle forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(clickOk) forControlEvents:UIControlEventTouchUpInside];
    
    [customPopView addSubview:customPopBackgroundImg];
    [customPopView addSubview:titleLabel];
    [customPopView addSubview:seperatorLine];
    [customPopView addSubview:okBtn];
    
    __weak UIView * tmpCustomPopView = customPopView;
    [customPopBackgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpCustomPopView);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading).offset(20);
        make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(topPadding);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing).offset(- 20);
        make.height.mas_equalTo(size.height);
    }];
    
    [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.equalTo(tmpCustomPopView);
        make.top.mas_equalTo(tmpCustomPopView.mas_bottom).offset( - 45);
        make.height.mas_equalTo(0.5);
    }];
    
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading);
        make.bottom.mas_equalTo(tmpCustomPopView.mas_bottom);
        make.width.mas_equalTo(@(270));
        make.height.mas_equalTo(@(45));
    }];
    
    //显示
    [shadowBgView addSubview:customPopView];
    [self.view addSubview:shadowBgView];
    
    NSMutableArray * shadowBgViewArray = nil;
    if (!objc_getAssociatedObject(self, XN_RUNTIME_KEY)) {
        
        shadowBgViewArray = [NSMutableArray arrayWithObject:shadowBgView];
    }else
    {
        shadowBgViewArray = objc_getAssociatedObject(self, XN_RUNTIME_KEY);
        [shadowBgViewArray addObject:shadowBgView];
        
    }
    objc_setAssociatedObject(self, XN_RUNTIME_KEY, shadowBgViewArray, OBJC_ASSOCIATION_RETAIN);
    
    weakSelf(weakSelf)
    __weak UIView * tmpView =shadowBgView;
    [customPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(tmpView);
        make.width.mas_equalTo(@(270.0));
        make.height.mas_equalTo(@(size.height + 45 + topPadding * 2));
    }];
    
    [shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];
}

#pragma mark - 创建属性字符串
- (NSMutableAttributedString *)attributeStringWithStr:(NSString *)title
{
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc]init];
    
    NSArray * strArray = [title componentsSeparatedByString:@"&&"];
    
    NSString * str = @"";
    NSDictionary * attributeDic = nil;
    for (NSString * subStr in strArray)
    {
        if ([[subStr componentsSeparatedByString:@"["] count] >= 2) {
            
            str = [[subStr componentsSeparatedByString:@"["] objectAtIndex:1];
            
            attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17.0],
                            NSFontAttributeName,[UIColor blackColor],NSForegroundColorAttributeName, nil];
        }else
        {
            str = subStr;
            
            attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0],NSFontAttributeName,JFZ_COLOR_GRAY,NSForegroundColorAttributeName, nil];
        }
        
        [attributeString appendAttributedString:[[NSAttributedString alloc]initWithString:str
                                                                               attributes:attributeDic]];
    }
    
    return attributeString;
}

#pragma mark - 弹出选择弹出框
- (void)showCustomAlertViewWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(CGFloat )font okTitle:(NSString *)okTitle okTitleColor:(UIColor *)okTitleColor okCompleteBlock:(completeBlock)okCompleted cancelTitle:(NSString *)cancelTitle cancelCompleteBlock:(completeBlock )cancelCompleted  topPadding:(CGFloat )topPadding textAlignment:(NSTextAlignment)textAlignment
{
    if (okCompleted) {
        
        objc_setAssociatedObject(self, XN_RUNTIME_OK_BLOCK_KEY, okCompleted, OBJC_ASSOCIATION_COPY);
    }
    
    if (cancelCompleted) {
        
        objc_setAssociatedObject(self, XN_RUNTIME_CANCEL_BLOCK_KEY, cancelCompleted, OBJC_ASSOCIATION_COPY);
    }

    UIView * shadowBgView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0 , SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
    [shadowBgView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    
    UIView * customPopView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, 270, 206)];
    
    UIImageView * customPopBackgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0 , 270, 206)];
    [customPopBackgroundImg setImage:[UIImage imageNamed:@"xn_popview_bg.png"]];
    [customPopView.layer setCornerRadius:10.0f];
    [customPopView.layer setMasksToBounds:YES];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0 , 270, 60)];
    [titleLabel setTextAlignment:textAlignment];
    [titleLabel setNumberOfLines:0];
    [titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [titleLabel setFont:[UIFont systemFontOfSize:font]];
    titleLabel.textColor = titleColor;
    [titleLabel setText:title];
    
    CGSize size = CGSizeZero;
    size = [titleLabel sizeThatFits:CGSizeMake(230, DEFAULTMAXHEIGHT)];
    
    UILabel * seperatorLine = [[UILabel alloc]initWithFrame:CGRectMake(0 , 45, 270, 0.5)];
    [seperatorLine setBackgroundColor:[UIColor lightGrayColor]];
    
    if (okTitleColor == nil)
    {
        okTitleColor = UIColorFromHex(0xdc4437);
    }
    
    UIButton * okBtn = [[UIButton alloc]initWithFrame:CGRectMake(0 , 46 , 135, 45)];
    [okBtn setTitleColor:MONEYCOLOR forState:UIControlStateNormal];
    [okBtn setTitle:okTitle forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(clickOk) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * middleSeperatorLine = [[UILabel alloc]initWithFrame:CGRectMake(134.5, 45, 0.5, 60)];
    [middleSeperatorLine setBackgroundColor:[UIColor lightGrayColor]];
    
    UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(135 , 46 , 135, 45)];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    [customPopView addSubview:customPopBackgroundImg];
    [customPopView addSubview:titleLabel];
    [customPopView addSubview:seperatorLine];
    [customPopView addSubview:okBtn];
    [customPopView addSubview:middleSeperatorLine];
    [customPopView addSubview:cancelBtn];
    
    __weak UIView * tmpCustomPopView = customPopView;
    [customPopBackgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpCustomPopView);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading).offset(20);
        make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(topPadding);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing).offset(- 20);
        make.height.mas_equalTo(size.height);
    }];
    
    __weak UILabel * tmpTitleLabel = titleLabel;
    [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.equalTo(tmpCustomPopView);
        make.top.mas_equalTo(tmpTitleLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(0.5);
    }];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading);
        make.bottom.mas_equalTo(tmpCustomPopView.mas_bottom);
        make.width.mas_equalTo(@(135.0));
        make.height.mas_equalTo(@(45));
    }];
    
    __weak UILabel * tmpSeperatorLineLabel = seperatorLine;
    [middleSeperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(tmpCustomPopView.mas_centerX);
        make.top.mas_equalTo(tmpSeperatorLineLabel.mas_bottom).offset(0);
        make.width.mas_equalTo(@(0.5));
        make.height.mas_equalTo(@(45));
    }];
    
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading).offset(135.0);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing);
        make.bottom.mas_equalTo(tmpCustomPopView.mas_bottom);
        make.height.mas_equalTo(@(45));
    }];
    
    //显示
    [shadowBgView addSubview:customPopView];
    [self.view addSubview:shadowBgView];
    
    NSMutableArray * shadowBgViewArray = nil;
    if (!objc_getAssociatedObject(self, XN_RUNTIME_KEY)) {
        
        shadowBgViewArray = [NSMutableArray arrayWithObject:shadowBgView];
    }else
    {
        shadowBgViewArray = objc_getAssociatedObject(self, XN_RUNTIME_KEY);
        [shadowBgViewArray addObject:shadowBgView];
        
    }
    objc_setAssociatedObject(self, XN_RUNTIME_KEY, shadowBgViewArray, OBJC_ASSOCIATION_RETAIN);
    
    weakSelf(weakSelf)
    __weak UIView * tmpView =shadowBgView;
    [customPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(tmpView);
        make.width.mas_equalTo(@(270.0));
        make.height.mas_equalTo(@(size.height + 45 + topPadding * 2));
    }];
    
    [shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];
}


- (void)showCustomAlertViewWithTitle:(NSString *)title okTitle:(NSString *)okTitle okTitleColor:(UIColor *)okTitleColor okCompleteBlock:(completeBlock)okCompleted
{
    [self showCustomAlertViewWithTitle:title okTitle:okTitle okTitleColor:okTitleColor okCompleteBlock:okCompleted topPadding:10 textAlignment:NSTextAlignmentCenter];
}

#pragma mark - 自定义弹出点击框
- (void)showCustomAlertViewWithTitle:(NSString *)title titleFont:(CGFloat )font okTitle:(NSString *)okTitle okCompleteBlock:(completeBlock)okCompleted cancelTitle:(NSString *)cancelTitle cancelCompleteBlock:(completeBlock )cancelCompleted
{
    
    if (okCompleted) {
        
        objc_setAssociatedObject(self, XN_RUNTIME_OK_BLOCK_KEY, okCompleted, OBJC_ASSOCIATION_COPY);
    }
    
    if (cancelCompleted) {
        
        objc_setAssociatedObject(self, XN_RUNTIME_CANCEL_BLOCK_KEY, cancelCompleted, OBJC_ASSOCIATION_COPY);
    }
    
    UIView * shadowBgView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0 , SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
    [shadowBgView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    
    UIView * customPopView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, 272, 128)];
    
    UIImageView * customPopBackgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0 , 272, 128)];
    [customPopBackgroundImg setImage:[UIImage imageNamed:@"xn_popview_bg.png"]];
    [customPopView.layer setMasksToBounds:YES];
    [customPopView.layer setCornerRadius:8.0f];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25 , 24 , 222, 50)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:font]];
    [titleLabel setTextColor:UIColorFromHex(0x666666)];
    [titleLabel setValue:@(18) forKey:@"lineSpacing"];
    [titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [titleLabel setNumberOfLines:0];
    [titleLabel setText:title];
    
    UILabel * seperatorLine = [[UILabel alloc]initWithFrame:CGRectMake(0 , 80, 272, 0.5)];
    [seperatorLine setBackgroundColor:[UIColor lightGrayColor]];
    
    UILabel * middleSeperatorLine = [[UILabel alloc]initWithFrame:CGRectMake(136, 80, 0.5, 47)];
    [middleSeperatorLine setBackgroundColor:[UIColor lightGrayColor]];
    
    UIButton * okBtn = [[UIButton alloc]initWithFrame:CGRectMake(0 , 46 , 136, 47)];
    [okBtn setTitleColor:MONEYCOLOR forState:UIControlStateNormal];
    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [okBtn setTitle:okTitle forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(clickOk) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(136 , 46 , 136, 47)];
    [cancelBtn setTitleColor:UIColorFromHex(0x999999) forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    [customPopView addSubview:customPopBackgroundImg];
    [customPopView addSubview:titleLabel];
    [customPopView addSubview:seperatorLine];
    [customPopView addSubview:okBtn];
    [customPopView addSubview:middleSeperatorLine];
    [customPopView addSubview:cancelBtn];
    
    __weak UIView * tmpCustomPopView = customPopView;
    [customPopBackgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpCustomPopView);
    }];
    
    //计算label高度
    CGFloat height = [title getSpaceLabelHeightWithFont:font withWidth:222 lineSpacing:18];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading).offset(25);
        make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(16);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing).offset(-25);
        make.height.mas_equalTo(height);
    }];
    
    [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.equalTo(tmpCustomPopView);
        make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(height + 32);
        make.height.mas_equalTo(0.5);
    }];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading);
        make.bottom.mas_equalTo(tmpCustomPopView.mas_bottom);
        make.width.mas_equalTo(@(136.0));
        make.height.mas_equalTo(@(51));
    }];
    
    [middleSeperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(tmpCustomPopView.mas_centerX);
        make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(height + 32);
        make.width.mas_equalTo(@(0.5));
        make.height.mas_equalTo(@(51));
    }];
    
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading).offset(136.0);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing);
        make.bottom.mas_equalTo(tmpCustomPopView.mas_bottom);
        make.height.mas_equalTo(@(51));
    }];
    
    //显示
    [shadowBgView addSubview:customPopView];
    [self.view addSubview:shadowBgView];
    
    NSMutableArray * shadowBgViewArray = nil;
    if (!objc_getAssociatedObject(self, XN_RUNTIME_KEY)) {
        
        shadowBgViewArray = [NSMutableArray arrayWithObject:shadowBgView];
    }else
    {
        shadowBgViewArray = objc_getAssociatedObject(self, XN_RUNTIME_KEY);
        [shadowBgViewArray addObject:shadowBgView];
        
    }
    objc_setAssociatedObject(self, XN_RUNTIME_KEY, shadowBgViewArray, OBJC_ASSOCIATION_RETAIN);
    
    weakSelf(weakSelf)
    __weak UIView * tmpView =shadowBgView;
    [customPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(tmpView);
        make.width.mas_equalTo(@(272));
        make.height.mas_equalTo(@(height + 83));
    }];
    
    [shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];
}

#pragma mark - 弹出预览提示框
- (void)showCUstomInformationAlertWithTitle:(NSString *)title announcementContent:(NSArray *)announcedPropertyArray myMessageContent:(NSArray *)msgPropertyArray okTitle:(NSString *)okTitle okCompleteBlock:(completeBlock)okCompleted
{
    if (okCompleted) {
        
        objc_setAssociatedObject(self, XN_RUNTIME_OK_BLOCK_KEY, okCompleted, OBJC_ASSOCIATION_COPY);
    }
    
    if (announcedPropertyArray) {
        
        objc_setAssociatedObject(self, XN_RUNTIME_ANNOUNCE_PROPERTY_KEY, announcedPropertyArray, OBJC_ASSOCIATION_RETAIN);
    }
    
    if (msgPropertyArray) {
        
        objc_setAssociatedObject(self, XN_RUNTIME_MYMESSAGE_PROPERTY_KEY, msgPropertyArray, OBJC_ASSOCIATION_RETAIN);
    }
    
    UIView * shadowBgView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0 , SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
    [shadowBgView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    
    UIButton * exitButton = [[UIButton alloc]init];
    [exitButton setBackgroundColor:[UIColor clearColor]];
    [exitButton addTarget:self action:@selector(hideReview) forControlEvents:UIControlEventTouchUpInside];
    
    [shadowBgView addSubview:exitButton];
    
    __weak UIView * tmpView = shadowBgView;
    [exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpView);
    }];
    
    UIView * customPopView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, 352, 260)];
    
    UIImageView * customPopBackgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0 , 352, 260)];
    [customPopBackgroundImg setImage:[UIImage imageNamed:@"xn_popview_bg.png"]];
    [customPopView.layer setMasksToBounds:YES];
    [customPopView.layer setCornerRadius:10.0f];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0 ,352, 45)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:title];
    
    UILabel * seperatorLine = [[UILabel alloc]initWithFrame:CGRectMake(0 , 45, 352, 0.5)];
    [seperatorLine setBackgroundColor:[UIColor lightGrayColor]];
    
    UIView * contentContainer = [[UIView alloc]init];
    [contentContainer setBackgroundColor:[UIColor whiteColor]];
    UIImageView * contentBackgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"XN_FiancialManage_Bubble.png"]];
    
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 91, 316, 20)];
    [contentLabel setTag:CONTENTLABELTAG];
    [contentLabel refreshPropertyArray:announcedPropertyArray Alignment:NSTextAlignmentCenter];
    CGSize  size = [contentLabel sizeThatFits:CGSizeMake(209 * (320.0 / SCREEN_FRAME.size.width) , 1000)];
    
    [contentContainer addSubview:contentBackgroundImageView];
    [contentContainer addSubview:contentLabel];
    
    UILabel * bottomSeperatoreLine = [[UILabel alloc]initWithFrame:CGRectMake(0 , 210, 352,0.5)];
    [bottomSeperatoreLine setBackgroundColor:[UIColor lightGrayColor]];
    
    UIButton * okBtn = [[UIButton alloc]initWithFrame:CGRectMake(0 , 46 , 135, 45)];
    [okBtn setTitleColor:UIColorFromHex(0xd64a3d) forState:UIControlStateNormal];
    [okBtn setTitle:okTitle forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(clickReviewOk) forControlEvents:UIControlEventTouchUpInside];
    
    [customPopView addSubview:customPopBackgroundImg];
    [customPopView addSubview:titleLabel];
    [customPopView addSubview:seperatorLine];
    [customPopView addSubview:contentContainer];
    [customPopView addSubview:bottomSeperatoreLine];
    [customPopView addSubview:okBtn];
    
    __weak UIView * tmpCustomPopView = customPopView;
    [customPopBackgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpCustomPopView);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading);
        make.top.mas_equalTo(tmpCustomPopView.mas_top);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing);
        make.height.mas_equalTo(@(45));
    }];
    
    [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.equalTo(tmpCustomPopView);
        make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(45);
        make.height.mas_equalTo(0.5);
    }];
    
    //计算内容的高度
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading).offset(32);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing).offset(-55);
        make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(68);
        make.height.mas_equalTo(size.height + 20);
    }];
    
    __weak UILabel * tmpUpSeperatorLine = seperatorLine;
    [contentContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading);
        make.top.mas_equalTo(tmpUpSeperatorLine.mas_bottom);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing);
        make.height.mas_equalTo(size.height + 60);
    }];
    
    __weak UIView * tmpContainer = contentContainer;
    [contentBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpContainer.mas_leading).offset(15);
        make.top.mas_equalTo(tmpContainer.mas_top).offset(20);
        make.trailing.mas_equalTo(tmpContainer.mas_trailing).offset(-43);
        make.bottom.mas_equalTo(tmpContainer).offset(-20);
    }];
    
    
    [bottomSeperatoreLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading);
        make.top.mas_equalTo(tmpContainer.mas_bottom);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing);
        make.height.mas_equalTo(0.5);
    }];
    
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading);
        make.bottom.mas_equalTo(tmpCustomPopView.mas_bottom);
        make.width.mas_equalTo(SCREEN_FRAME.size.width - 24);
        make.height.mas_equalTo(@(45));
    }];
    
    
    //显示
    [shadowBgView addSubview:customPopView];
    [self.view addSubview:shadowBgView];
    
    objc_setAssociatedObject(self, XNREVIEWTAG, shadowBgView, OBJC_ASSOCIATION_RETAIN);

    
    weakSelf(weakSelf)
    tmpView =shadowBgView;
    [customPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(tmpView);
        make.width.mas_equalTo(SCREEN_FRAME.size.width - 24);
        make.height.mas_equalTo(155+size.height);
    }];
    
    [shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];
    
}

#pragma mark - 弹出推荐视图
- (void)showFMRecommandViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle subTitleLeftPadding:(CGFloat )leftPadding otherSubTitle:(NSString *)otherSubTitle okTitle:(NSString *)okTitle okCompleteBlock:(completeBlock)okCompleted cancelTitle:(NSString *)cancelTitle cancelCompleteBlock:(completeBlock )cancelCompleted
{
    if (okCompleted) {
        
        objc_setAssociatedObject(self, XN_RUNTIME_OK_BLOCK_KEY, okCompleted, OBJC_ASSOCIATION_COPY);
    }
    
    if (cancelCompleted) {
        
        objc_setAssociatedObject(self, XN_RUNTIME_CANCEL_BLOCK_KEY, cancelCompleted, OBJC_ASSOCIATION_COPY);
    }
    
    UIView * shadowBgView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0 , SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
    [shadowBgView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    
    UIView * customPopView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, 270, 106)];
    
    UIImageView * customPopBackgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0 , 270, 106)];
    [customPopBackgroundImg setImage:[UIImage imageNamed:@"xn_popview_bg.png"]];
    [customPopView.layer setMasksToBounds:YES];
    [customPopView.layer setCornerRadius:10.0f];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0 , 270, 60)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setText:title];
    
    UILabel * subTitleLabel = nil;
    UILabel * otherSubTitleLabel = nil;
    
    subTitleLabel = [[UILabel alloc]init];
    [subTitleLabel setTextAlignment:NSTextAlignmentLeft];
    [subTitleLabel setTextColor:UIColorFromHex(0x646464)];
    [subTitleLabel setFont:[UIFont systemFontOfSize:15]];
    [subTitleLabel setText:subTitle];
    [subTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [subTitleLabel setNumberOfLines:0];
    
    if ([NSObject isValidateInitString:otherSubTitle]) {
        
        otherSubTitleLabel = [[UILabel alloc]init];
        [otherSubTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [otherSubTitleLabel setTextColor:[UIColor redColor]];
        [otherSubTitleLabel setFont:[UIFont systemFontOfSize:16]];
        [otherSubTitleLabel setText:otherSubTitle];
    }
    
    UILabel * seperatorLine = [[UILabel alloc]initWithFrame:CGRectMake(0 , 45, 270, 0.5)];
    [seperatorLine setBackgroundColor:[UIColor lightGrayColor]];
    
    UIButton * okBtn = [[UIButton alloc]initWithFrame:CGRectMake(0 , 46 , 135, 45)];
    [okBtn setTitleColor:MONEYCOLOR forState:UIControlStateNormal];
    [okBtn setTitle:okTitle forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(clickOk) forControlEvents:UIControlEventTouchUpInside];
    
    BOOL cancelExist = NO;
    UIButton * cancelBtn = nil;
    UILabel * middleSeperatorLine = nil;
    if ([NSObject isValidateObj:cancelTitle] && [NSObject isValidateInitString:cancelTitle]) {
        
        cancelExist = YES;
        cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(135 , 46 , 135, 45)];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
        
        middleSeperatorLine = [[UILabel alloc]initWithFrame:CGRectMake(134.5, 45, 0.5, 60)];
        [middleSeperatorLine setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    [customPopView addSubview:customPopBackgroundImg];
    [customPopView addSubview:titleLabel];
    [customPopView addSubview:subTitleLabel];
    if ([NSObject isValidateInitString:otherSubTitle]) {
        
        [customPopView addSubview:otherSubTitleLabel];
    }
    [customPopView addSubview:seperatorLine];
    [customPopView addSubview:okBtn];
    [customPopView addSubview:middleSeperatorLine];
    [customPopView addSubview:cancelBtn];
    
    __weak UIView * tmpCustomPopView = customPopView;
    [customPopBackgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpCustomPopView);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading);
        make.top.mas_equalTo(tmpCustomPopView.mas_top);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing);
        make.height.mas_equalTo(@(60));
    }];
    
    CGFloat height = 13;
    CGSize size = [subTitleLabel sizeThatFits:CGSizeMake(211, 2000)];
    if (![NSObject isValidateInitString:otherSubTitle]) {
        
        height = size.height;
    }
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading).offset(leftPadding);
        make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(52);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing).offset(-leftPadding);
        //        make.height.mas_equalTo(height);
        make.height.mas_equalTo(height + 25);
    }];
    //    height = 52 + height + 12;
    height = 52 + height + 36;
    
    if ([NSObject isValidateInitString:otherSubTitle]) {
        
        
        [otherSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpCustomPopView.mas_leading).offset(32);
            make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(height);
            make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing).offset(-32);
            make.height.mas_equalTo(13);
        }];
        
        height = height + 13 + 20;
    }else
        height = height + 20;
    
    
    [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.equalTo(tmpCustomPopView);
        make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(height);
        make.height.mas_equalTo(0.5);
    }];
    
    height = height + 0.5;
   
    if (cancelExist){
       
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpCustomPopView.mas_leading);
            make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(height);
            make.width.mas_equalTo(@(135.0));
            make.height.mas_equalTo(@(45));
        }];
        
        [middleSeperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(tmpCustomPopView.mas_centerX);
            make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(height);
            make.width.mas_equalTo(@(0.5));
            make.height.mas_equalTo(@(45));
        }];
    }
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading).offset(cancelExist?135.0:0);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing);
        make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(height);
        make.height.mas_equalTo(@(45));
    }];
    
    height = height + 45;
    
    //显示
    [shadowBgView addSubview:customPopView];
    [self.view addSubview:shadowBgView];
    
    NSMutableArray * shadowBgViewArray = nil;
    if (!objc_getAssociatedObject(self, XN_RUNTIME_KEY)) {
        
        shadowBgViewArray = [NSMutableArray arrayWithObject:shadowBgView];
    }else
    {
        shadowBgViewArray = objc_getAssociatedObject(self, XN_RUNTIME_KEY);
        [shadowBgViewArray addObject:shadowBgView];
        
    }
    objc_setAssociatedObject(self, XN_RUNTIME_KEY, shadowBgViewArray, OBJC_ASSOCIATION_RETAIN);
    
    weakSelf(weakSelf)
    __weak UIView * tmpView =shadowBgView;
    [customPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(tmpView);
        make.width.mas_equalTo(@(270.0));
        make.height.mas_equalTo(height);
    }];
    
    [shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];
}

- (void)showCustomAlertViewWithTitle:(NSString *)title
                            subTitle:(NSString *)subTitle
                subTitleLeftPadding:(CGFloat )leftPadding
                  otherSubTitle:(NSString *)otherSubTitle
                             okTitle:(NSString *)okTitle okCompleteBlock:(completeBlock)okCompleted
                         cancelTitle:(NSString *)cancelTitle cancelCompleteBlock:(completeBlock )cancelCompleted
{
    if (okCompleted) {
        
        objc_setAssociatedObject(self, XN_RUNTIME_OK_BLOCK_KEY, okCompleted, OBJC_ASSOCIATION_COPY);
    }
    
    if (cancelCompleted) {
        
        objc_setAssociatedObject(self, XN_RUNTIME_CANCEL_BLOCK_KEY, cancelCompleted, OBJC_ASSOCIATION_COPY);
    }
    
    UIView * shadowBgView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0 , SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
    [shadowBgView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    
    UIView * customPopView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, 270, 106)];
    
    UIImageView * customPopBackgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0 , 270, 106)];
    [customPopBackgroundImg setImage:[UIImage imageNamed:@"xn_popview_bg.png"]];
    [customPopView.layer setMasksToBounds:YES];
    [customPopView.layer setCornerRadius:10.0f];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0 , 270, 60)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setText:title];
    
    UILabel * subTitleLabel = nil;
    UILabel * otherSubTitleLabel = nil;
    
    subTitleLabel = [[UILabel alloc]init];
    [subTitleLabel setTextAlignment:NSTextAlignmentLeft];
    [subTitleLabel setTextColor:UIColorFromHex(0x646464)];
    [subTitleLabel setFont:[UIFont systemFontOfSize:15]];
    [subTitleLabel setText:subTitle];
    [subTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [subTitleLabel setNumberOfLines:0];
    
    if ([NSObject isValidateInitString:otherSubTitle]) {
        
        otherSubTitleLabel = [[UILabel alloc]init];
        [otherSubTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [otherSubTitleLabel setTextColor:[UIColor redColor]];
        [otherSubTitleLabel setFont:[UIFont systemFontOfSize:16]];
        [otherSubTitleLabel setText:otherSubTitle];
    }
    
    UILabel * seperatorLine = [[UILabel alloc]initWithFrame:CGRectMake(0 , 45, 270, 0.5)];
    [seperatorLine setBackgroundColor:[UIColor lightGrayColor]];
    
    UIButton * okBtn = [[UIButton alloc]initWithFrame:CGRectMake(0 , 46 , 135, 45)];
    [okBtn setTitleColor:MONEYCOLOR forState:UIControlStateNormal];
    [okBtn setTitle:okTitle forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(clickOk) forControlEvents:UIControlEventTouchUpInside];
    
    BOOL cancelExist = NO;
    UIButton * cancelBtn = nil;
    UILabel * middleSeperatorLine = nil;
    if ([NSObject isValidateObj:cancelTitle] && [NSObject isValidateInitString:cancelTitle]) {
        
        cancelExist = YES;
        cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(135 , 46 , 135, 45)];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
        
        middleSeperatorLine = [[UILabel alloc]initWithFrame:CGRectMake(134.5, 45, 0.5, 60)];
        [middleSeperatorLine setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    [customPopView addSubview:customPopBackgroundImg];
    [customPopView addSubview:titleLabel];
    [customPopView addSubview:subTitleLabel];
    if ([NSObject isValidateInitString:otherSubTitle]) {
        
        [customPopView addSubview:otherSubTitleLabel];
    }
    [customPopView addSubview:seperatorLine];
    [customPopView addSubview:okBtn];
    [customPopView addSubview:middleSeperatorLine];
    [customPopView addSubview:cancelBtn];
    
    __weak UIView * tmpCustomPopView = customPopView;
    [customPopBackgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpCustomPopView);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading);
        make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(24);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing);
        make.height.mas_equalTo(@(26));
    }];
    
    CGSize size = [subTitleLabel sizeThatFits:CGSizeMake(211, 2000)];
    CGFloat height = size.height;
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading).offset(leftPadding);
        make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(60);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing).offset(-leftPadding);
        make.height.mas_equalTo(height);
    }];

    height = 60 + height + 24;
    if ([NSObject isValidateInitString:otherSubTitle]) {
        
        
        [otherSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpCustomPopView.mas_leading).offset(32);
            make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(height);
            make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing).offset(-32);
            make.height.mas_equalTo(13);
        }];
        
        height = height + 13 + 20;
    }else
        height = height;
    
    
    [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.equalTo(tmpCustomPopView);
        make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(height);
        make.height.mas_equalTo(0.5);
    }];
    
    height = height + 0.5;
    
    if (cancelExist){
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpCustomPopView.mas_leading);
            make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(height);
            make.width.mas_equalTo(@(135.0));
            make.height.mas_equalTo(@(45));
        }];
        
        [middleSeperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(tmpCustomPopView.mas_centerX);
            make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(height);
            make.width.mas_equalTo(@(0.5));
            make.height.mas_equalTo(@(45));
        }];
    }
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading).offset(cancelExist?135.0:0);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing);
        make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(height);
        make.height.mas_equalTo(@(45));
    }];
    
    height = height + 45;
    
    //显示
    [shadowBgView addSubview:customPopView];
    [self.view addSubview:shadowBgView];
    
    NSMutableArray * shadowBgViewArray = nil;
    if (!objc_getAssociatedObject(self, XN_RUNTIME_KEY)) {
        
        shadowBgViewArray = [NSMutableArray arrayWithObject:shadowBgView];
    }else
    {
        shadowBgViewArray = objc_getAssociatedObject(self, XN_RUNTIME_KEY);
        [shadowBgViewArray addObject:shadowBgView];
        
    }
    objc_setAssociatedObject(self, XN_RUNTIME_KEY, shadowBgViewArray, OBJC_ASSOCIATION_RETAIN);
    
    weakSelf(weakSelf)
    __weak UIView * tmpView =shadowBgView;
    [customPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(tmpView);
        make.width.mas_equalTo(@(270.0));
        make.height.mas_equalTo(height);
    }];
    
    [shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];
}

#pragma mark - 弹出推荐视图
- (void)showFMRecommandViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle otherSubTitle:(NSString *)otherSubTitle okTitle:(NSString *)okTitle okCompleteBlock:(completeBlock)okCompleted cancelTitle:(NSString *)cancelTitle cancelCompleteBlock:(completeBlock )cancelCompleted
{
    [self showFMRecommandViewWithTitle:title subTitle:subTitle subTitleLeftPadding:30.0f otherSubTitle:otherSubTitle okTitle:okTitle okCompleteBlock:okCompleted cancelTitle:cancelTitle cancelCompleteBlock:cancelCompleted];
}


#pragma mark - 预览按钮跳转
- (void)switchReviewOperation:(UIButton *)sender
{
    UIButton * announceBtn = (UIButton *)[self.view viewWithTag:ANNOUNCEBTNTAG];
    UIButton * myMsgBtn    =  (UIButton *)[self.view viewWithTag:MYMESSAGEBTNTAG];
    UIView * cursorView = [self.view viewWithTag:CURSORVIEWTAG];
    UILabel * contentLabel = (UILabel *)[self.view viewWithTag:CONTENTLABELTAG];
    
    if ([announceBtn isEqual:sender]) {
        
        [announceBtn setTitleColor:UIColorFromHex(0x373737) forState:UIControlStateNormal];
        [myMsgBtn setTitleColor:UIColorFromHex(0xb5b5b5) forState:UIControlStateNormal];
        
        NSArray * property = objc_getAssociatedObject(self, XN_RUNTIME_ANNOUNCE_PROPERTY_KEY);
        
        [contentLabel refreshPropertyArray:property Alignment:NSTextAlignmentCenter];
    }else
    {
        [announceBtn setTitleColor:UIColorFromHex(0xb5b5b5) forState:UIControlStateNormal];
        [myMsgBtn setTitleColor:UIColorFromHex(0x373737) forState:UIControlStateNormal];
        
        NSArray * property = objc_getAssociatedObject(self, XN_RUNTIME_MYMESSAGE_PROPERTY_KEY);
        
        [contentLabel refreshPropertyArray:property Alignment:NSTextAlignmentCenter];
    }
    
    __weak UIButton * tmpBtn = sender;
    [cursorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(tmpBtn.mas_centerX);
        make.top.mas_equalTo(tmpBtn.mas_bottom);
        make.width.mas_equalTo(@(84));
        make.height.mas_equalTo(@(3));
    }];
    
    [UIView animateWithDuration:VIEWANIMATIONDURATION animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 单击ok按钮操作
- (void)clickOk
{
    [self hide];
    
    completeBlock block = objc_getAssociatedObject(self, XN_RUNTIME_OK_BLOCK_KEY);
    
    if (block)
        block();
}

#pragma mark - 单击ok，退出review
- (void)clickReviewOk
{
    [self hideReview];
    
    completeBlock block = objc_getAssociatedObject(self, XN_RUNTIME_OK_BLOCK_KEY);
    
    if (block)
        block();
}

#pragma mark - 取消操作
- (void)clickCancel
{
    [self hide];
    
    completeBlock block = objc_getAssociatedObject(self , XN_RUNTIME_CANCEL_BLOCK_KEY);
    
    if (block)
        block();
}

#pragma mark - 隐藏弹出框
- (void)hide
{
    NSMutableArray * popViewArray = objc_getAssociatedObject(self, XN_RUNTIME_KEY);
    
    if (popViewArray.count > 0) {
        
        for (UIView * tmpView  in popViewArray) {
            
            [tmpView removeFromSuperview];
        }
        [popViewArray removeAllObjects];
    }
}

#pragma mark - 隐藏预览
- (void)hideReview
{
    UIView * popViewArray = objc_getAssociatedObject(self, XNREVIEWTAG);
    
    [popViewArray removeFromSuperview];
    popViewArray = nil;
}

#pragma mark - 自定义提示框，提示后的完成操作
- (void)hideBeforeCompleted
{
    [self hide];
    
    completeBlock block = objc_getAssociatedObject(self , XN_RUNTIME_WARNING_BLOCK_KEY);
    
    if (block)
        block();
}

- (void)hideGifView
{
    [self hide];
}

- (void)showGifViewWithContent:(NSString *)content
{
    if ([NSObject isValidateInitString:content])
    {
        
        UIView * shadowBgView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0 , SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
        [shadowBgView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
        
        UIView * customPopView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, DEFAULTWARNPOPVIEWWIDTH, 0)];
        
        UIImageView * customPopBackgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0 , DEFAULTWARNPOPVIEWWIDTH, 0)];
        [customPopBackgroundImg setImage:[UIImage imageNamed:@"xn_popview_bg.png"]];
        [customPopView.layer setMasksToBounds:YES];
        [customPopView.layer setCornerRadius:10.0f];
        
        UIImageView *gitImageView = [[UIImageView alloc] init];
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(DEFAULTWARNPOPVIEWWIDTH / 3 , 0 , DEFAULTWARNPOPVIEWWIDTH * 2 / 3, 0)];
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        //        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setText:content];
        titleLabel.textColor = JFZ_COLOR_BLACK;
        
        [customPopView addSubview:customPopBackgroundImg];
        [customPopView addSubview:gitImageView];
        [customPopView addSubview:titleLabel];
        
        CGSize size = CGSizeZero;
        size = [titleLabel sizeThatFits:CGSizeMake(DEFAULTWARNPOPTITLEWIDTH, DEFAULTMAXHEIGHT)];
        
        __weak UIView * tmpCustomPopView = customPopView;
        [customPopBackgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(tmpCustomPopView);
        }];
        
        [gitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(tmpCustomPopView.mas_centerY);
            make.left.mas_equalTo(tmpCustomPopView.mas_left).offset(DEFAULTWARNPOPVIEWWIDTH / 3 - 50);
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(25);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(tmpCustomPopView.mas_centerY);
            make.right.mas_equalTo(tmpCustomPopView.mas_right);
            make.width.mas_equalTo(DEFAULTWARNPOPVIEWWIDTH * 2 / 3 + 20);
            make.height.mas_equalTo(@(size.height));
        }];
        
        //显示
        [shadowBgView addSubview:customPopView];
        [self.view addSubview:shadowBgView];
        
        NSMutableArray * shadowBgViewArray = nil;
        if (!objc_getAssociatedObject(self, XN_RUNTIME_KEY)) {
            
            shadowBgViewArray = [NSMutableArray arrayWithObject:shadowBgView];
        }else
        {
            shadowBgViewArray = objc_getAssociatedObject(self, XN_RUNTIME_KEY);
            [shadowBgViewArray addObject:shadowBgView];
            
        }
        objc_setAssociatedObject(self, XN_RUNTIME_KEY, shadowBgViewArray, OBJC_ASSOCIATION_RETAIN);
        
        weakSelf(weakSelf)
        __weak UIView * tmpView =shadowBgView;
        [customPopView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(tmpView);
            make.width.mas_equalTo(@(DEFAULTWARNPOPVIEWWIDTH));
            make.height.mas_equalTo(@(DEFAULTWARNPOPVIEWINTERVAL + size.height));
        }];
        
        [shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakSelf.view);
        }];
        
        //动画
        NSMutableArray *imageArray = [NSMutableArray array];
        for (int i = 1; i < 13; i ++)
        {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", i]];
            [imageArray addObject:image];
        }
        gitImageView.animationImages = imageArray;
        gitImageView.animationDuration = 12 * 0.1;
        gitImageView.animationRepeatCount = 0;
        [gitImageView startAnimating];
        
    }
}

@end
