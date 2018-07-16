//
//  UIView+loading.m
//  FinancialManager
//
//  Created by xnkj on 15/10/16.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "UIView+loading.h"
#import "objc/runtime.h"

#import "JFGifImageView.h"

#define XN_UIVIEW_ANIMATION_LOADING_VIEW_TAG @"0x1111111111"

#define DEFAULTWARNPOPVIEWWIDTH  274.0f
#define DEFAULTWARNPOPTITLEWIDTH 198.0f
#define DEFAULTWARNPOPVIEWINTERVAL 65.0f
#define DEFAULTMAXHEIGHT        2000.0f

#define DEFAULT_ALERT_WIDTH  100.f//270.0f
#define DEFAULT_ALERT_HEIGHT 50.f//155.0f

#define XN_LOADING_VIEW          @"xn_loading_view"
#define XN_LOADING_ACTIVITY_TAG  0x00000010
#define XNREVIEWTAG              @"xnreviewtag"

@implementation UIView(loading)

#pragma mark - 加载中
- (void)showLoading
{
    [self showLoadingForTitle:@"加载中..."];
}

#pragma mark - 加载中效果
- (void)showLoadingForTitle:(NSString *)title
{
    UIView *loadingBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
    [loadingBackgroundView setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5]];
    
    NSMutableArray * loadingViewArray = nil;
    if (!objc_getAssociatedObject(self, XN_LOADING_VIEW)) {
        
        loadingViewArray = [NSMutableArray arrayWithObject:loadingBackgroundView];
    }else
    {
        loadingViewArray = objc_getAssociatedObject(self, XN_LOADING_VIEW);
        [loadingViewArray addObject:loadingBackgroundView];
        
    }
    objc_setAssociatedObject(self, XN_LOADING_VIEW, loadingViewArray, OBJC_ASSOCIATION_RETAIN);
    
    
    UIView * loadingContainerView = [[UIView alloc]init];
    UIImageView * loadingContainerBackgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tips_prompt_box.png"]];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityView setTag:XN_LOADING_ACTIVITY_TAG];
    [activityView startAnimating];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    [loadingContainerView addSubview:loadingContainerBackgroundImageView];
    [loadingContainerView addSubview:titleLabel];
    [loadingContainerView addSubview:activityView];
    [loadingBackgroundView addSubview:loadingContainerView];
    [self addSubview:loadingBackgroundView];
    
    __weak UIView * tmpSelf = self;
    [loadingBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpSelf);
    }];
    
    __weak UIView * tmpBackgroundView = loadingBackgroundView;
    [loadingContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.mas_equalTo(tmpBackgroundView);
        make.width.mas_equalTo(@(110));
        make.height.mas_equalTo(@(80));
    }];
    
    __weak UIView * tmpView = loadingContainerView;
    [loadingContainerBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpView);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpView.mas_leading);
        make.top.mas_equalTo(tmpView.mas_top).offset(52);
        make.trailing.mas_equalTo(tmpView.mas_trailing);
        make.height.mas_equalTo(21);
    }];
    
    [activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(tmpView.mas_centerX);
        make.top.mas_equalTo(tmpView.mas_top).offset(12);
        make.width.mas_equalTo(40);
    }];
}

#pragma mark - 停止加载
- (void)hideLoading
{
    NSMutableArray * loadingViewArray = objc_getAssociatedObject(self, XN_LOADING_VIEW);
    
    if ([NSObject isValidateObj:loadingViewArray] && loadingViewArray.count > 0) {
        
        UIView * loadingBackgroundView = [loadingViewArray firstObject];
        
        if ([[loadingBackgroundView viewWithTag:XN_LOADING_ACTIVITY_TAG] isKindOfClass:[UIImageView class]]) {
            
            UIImageView * indicatorView = (UIImageView *)[loadingBackgroundView viewWithTag:XN_LOADING_ACTIVITY_TAG];
            [indicatorView stopAnimating];
        }else{
       
            UIActivityIndicatorView * indicatorView = (UIActivityIndicatorView *)[loadingBackgroundView viewWithTag:XN_LOADING_ACTIVITY_TAG];
            [indicatorView stopAnimating];
        }
        
        [loadingBackgroundView removeFromSuperview];
        [loadingViewArray removeObjectAtIndex:0];
    }
}

#pragma mark - 加载动态gif
- (void)showGifLoading
{
    UIView *loadingBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
    
    NSMutableArray * loadingViewArray = nil;
    if (!objc_getAssociatedObject(self, XN_LOADING_VIEW)) {
        
        loadingViewArray = [NSMutableArray arrayWithObject:loadingBackgroundView];
    }else
    {
        loadingViewArray = objc_getAssociatedObject(self, XN_LOADING_VIEW);
        [loadingViewArray addObject:loadingBackgroundView];
    }
    objc_setAssociatedObject(self, XN_LOADING_VIEW, loadingViewArray, OBJC_ASSOCIATION_RETAIN);
    
    UIView * loadingContainerView = [[UIView alloc]init];
    
    UIImageView * loadingContainerBackgroundImageView = [[UIImageView alloc] init];
    
    NSMutableArray *imageArray = [NSMutableArray array];
    NSString * path = nil;
    for (int i = 1; i < 13; i ++)
    {
        path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"gif%d", i] ofType:@"png"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        [imageArray addObject:image];
    }
    loadingContainerBackgroundImageView.tag = XN_LOADING_ACTIVITY_TAG;
    loadingContainerBackgroundImageView.animationImages = imageArray;
    loadingContainerBackgroundImageView.animationDuration = 12 * 0.1;
    loadingContainerBackgroundImageView.animationRepeatCount = 0;
    [loadingContainerBackgroundImageView startAnimating];
    
    [loadingContainerView addSubview:loadingContainerBackgroundImageView];
    [loadingBackgroundView addSubview:loadingContainerView];
    [self addSubview:loadingBackgroundView];
    
    __weak UIView * tmpSelf = self;
    [loadingBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpSelf);
    }];
    
    __weak UIView * tmpBackgroundView = loadingBackgroundView;
    [loadingContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.mas_equalTo(tmpBackgroundView);
        if (IS_IPHONE6PLUS_SCREEN)
        {
            make.size.mas_equalTo(CGSizeMake(95, 95));
        }else
            make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    
    __weak UIView * tmpView = loadingContainerView;
    [loadingContainerBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpView);
    }];
}

#pragma mark - 加载动态gif
- (void)showSpecialGifLoading
{
    UIView *loadingBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
    
    NSMutableArray * loadingViewArray = nil;
    if (!objc_getAssociatedObject(self, XN_LOADING_VIEW)) {
        
        loadingViewArray = [NSMutableArray arrayWithObject:loadingBackgroundView];
    }else
    {
        loadingViewArray = objc_getAssociatedObject(self, XN_LOADING_VIEW);
        [loadingViewArray addObject:loadingBackgroundView];
    }
    objc_setAssociatedObject(self, XN_LOADING_VIEW, loadingViewArray, OBJC_ASSOCIATION_RETAIN);
    
    UIView * loadingContainerView = [[UIView alloc]init];
    
    UIImageView * loadingContainerBackgroundImageView = [[UIImageView alloc] init];
    
    NSMutableArray *imageArray = [NSMutableArray array];
    NSString * path = nil;
    for (int i = 1; i < 13; i ++)
    {
        path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"gif%d_s", i] ofType:@"png"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        [imageArray addObject:image];
    }
    loadingContainerBackgroundImageView.tag = XN_LOADING_ACTIVITY_TAG;
    loadingContainerBackgroundImageView.animationImages = imageArray;
    loadingContainerBackgroundImageView.animationDuration = 12 * 0.1;
    loadingContainerBackgroundImageView.animationRepeatCount = 0;
    [loadingContainerBackgroundImageView startAnimating];
    
    [loadingContainerView addSubview:loadingContainerBackgroundImageView];
    [loadingBackgroundView addSubview:loadingContainerView];
    [self addSubview:loadingBackgroundView];
    
    __weak UIView * tmpSelf = self;
    [loadingBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpSelf);
    }];
    
    __weak UIView * tmpBackgroundView = loadingBackgroundView;
    [loadingContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.mas_equalTo(tmpBackgroundView);
        if (IS_IPHONE6PLUS_SCREEN)
        {
            make.size.mas_equalTo(CGSizeMake(95, 95));
        }else
            make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    
    __weak UIView * tmpView = loadingContainerView;
    [loadingContainerBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpView);
    }];
}

#pragma mark - 自定义弹出提示框
- (void)showCustomWarnViewWithContent:(NSString *)content
{
    [self showCustomWarnViewWithContent:content Completed:nil];
}

- (void)showCustomWarnViewWithContent:(NSString *)content Completed:(completeBlock)completed
{
    if (completed) {
        
        objc_setAssociatedObject(self, XN_RUNTIME_WARNING_BLOCK_KEY, completed, OBJC_ASSOCIATION_COPY);
    }
    
    
    UIView * shadowBgView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0 , SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
    [shadowBgView setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]];
    
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
    [self addSubview:shadowBgView];
    
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
        
        make.edges.equalTo(weakSelf);
    }];
    
    [self performSelector:@selector(hideBeforeCompleted) withObject:nil afterDelay:CUSTOMALERTVIEWSHOW];
}

- (void)showCustomAlertView:(NSString *)contentString image:(NSString *)imageString
{
    [self showCustomAlertView:contentString image:imageString Completed:nil];
    
}

- (void)showCustomAlertView:(NSString *)content image:(NSString *)imageString Completed:(completeBlock)completed
{
    if (completed) {
        
        objc_setAssociatedObject(self, XN_RUNTIME_WARNING_BLOCK_KEY, completed, OBJC_ASSOCIATION_COPY);
    }
    
    
    UIView * shadowBgView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0 , SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
    [shadowBgView setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]];
    
    UIView * customPopView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, DEFAULT_ALERT_WIDTH, DEFAULT_ALERT_HEIGHT)];
    
    UIImageView *customPopBackgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0 , DEFAULT_ALERT_WIDTH, DEFAULT_ALERT_HEIGHT)];
    [customPopBackgroundImg setImage:[UIImage imageNamed:@"XN_Alert_bg"]];
    [customPopView.layer setMasksToBounds:YES];
    [customPopView.layer setCornerRadius:10.0f];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    imageView.image = [UIImage imageNamed:imageString];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0 , DEFAULT_ALERT_WIDTH, 0)];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:content];
    
    [customPopView addSubview:customPopBackgroundImg];
    [customPopView addSubview:imageView];
    [customPopView addSubview:titleLabel];
    
    CGSize size = CGSizeZero;
    size = [titleLabel sizeThatFits:CGSizeMake(DEFAULT_ALERT_WIDTH, DEFAULTMAXHEIGHT)];
    
    __weak UIView *tmpCustomPopView = customPopView;
    [customPopBackgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tmpCustomPopView);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tmpCustomPopView.mas_top).offset(DEFAULT_ALERT_HEIGHT / 5);
        make.centerX.equalTo(tmpCustomPopView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
//    __weak UIImageView *tmpImageView = imageView;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(tmpImageView.mas_bottom).offset(5);
        make.centerY.equalTo(tmpCustomPopView.mas_centerY);
        make.centerX.equalTo(tmpCustomPopView.mas_centerX);
        make.width.mas_equalTo(@(DEFAULT_ALERT_WIDTH));
        make.height.mas_equalTo(@(size.height));
    }];
    
    //显示
    [shadowBgView addSubview:customPopView];
    [self addSubview:shadowBgView];
    
    NSMutableArray * shadowBgViewArray = nil;
    if (!objc_getAssociatedObject(self, XN_RUNTIME_KEY))
    {
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
        make.width.mas_equalTo(@(DEFAULT_ALERT_WIDTH));
        make.height.mas_equalTo(@(DEFAULTWARNPOPVIEWINTERVAL));// + size.height + 32));
    }];
    
    [shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self performSelector:@selector(hideBeforeCompleted) withObject:nil afterDelay:CUSTOMALERTVIEWSHOW];
}

#pragma mark - 隐藏弹出框
- (void)hide
{
    NSMutableArray * popViewArray = objc_getAssociatedObject(self, XN_RUNTIME_KEY);
    
    if ([NSObject isValidateObj:popViewArray] && popViewArray.count > 0) {
        
        [[popViewArray firstObject] removeFromSuperview];
        [popViewArray removeObjectAtIndex:0];
    }
}

#pragma mark - 自定义提示框，提示后的完成操作
- (void)hideBeforeCompleted
{
    [self hide];
    
    completeBlock block = objc_getAssociatedObject(self , XN_RUNTIME_WARNING_BLOCK_KEY);
    
    if (block)
    {
        block();
        objc_setAssociatedObject(self, XN_RUNTIME_WARNING_BLOCK_KEY, NULL, OBJC_ASSOCIATION_COPY);
    }
}

@end
