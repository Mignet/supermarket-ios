//
//  XNLoadFailedController.m
//  FinancialManager
//
//  Created by xnkj on 15/10/28.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "UIViewController+XNLoadFailedController.h"
#import "objc/runtime.h"

#define XN_UIVIEWCONTROLLER_LOADING_FAILED_BACKGROUND_TAG @"0x100001"

@implementation UIViewController(XNLoadFailedController)

#pragma mark - 加载中
- (void)showLoadingTarget:(id)target withTitle:(NSString *)title
{
    UIView *loadingBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
    [loadingBackgroundView setBackgroundColor:[UIColor whiteColor]];
    
    NSDictionary * dic = [NSDictionary dictionaryWithObject:loadingBackgroundView forKey:NSStringFromClass([target class])];
    
    NSMutableArray * viewControllersArray = objc_getAssociatedObject(self, XN_UIVIEWCONTROLLER_LOADING_FAILED_BACKGROUND_TAG);
    if (viewControllersArray.count > 0) {
        
        [viewControllersArray addObject:dic];
        objc_setAssociatedObject(self, XN_UIVIEWCONTROLLER_LOADING_FAILED_BACKGROUND_TAG, viewControllersArray, OBJC_ASSOCIATION_RETAIN);
    }else
    {
        viewControllersArray = [NSMutableArray arrayWithObject:dic];
        objc_setAssociatedObject(self, XN_UIVIEWCONTROLLER_LOADING_FAILED_BACKGROUND_TAG, viewControllersArray, OBJC_ASSOCIATION_RETAIN);
    }

    
    UILabel * titleLabel = [[UILabel alloc]init];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor darkGrayColor]];
    [titleLabel setText:title];
    
    [loadingBackgroundView addSubview:titleLabel];
    
    [self.view addSubview:loadingBackgroundView];
    
    __weak UIView * tmpSelf = self.view;
    [loadingBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpSelf);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(tmpSelf.mas_centerX);
        make.centerY.mas_equalTo(tmpSelf.mas_centerY);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(21);
    }];
}

#pragma mark - 针对指定页面的网络加载处理
- (void)showNetworkLoadingFailedDidReloadTarget:(id)target Action:(SEL)action
{
    UIView *loadingBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
    [loadingBackgroundView setBackgroundColor:UIColorFromHex(0xeae7e7)];
    
    NSDictionary * dic = [NSDictionary dictionaryWithObject:loadingBackgroundView forKey:NSStringFromClass([target class])];
    
    NSMutableArray * viewControllersArray = objc_getAssociatedObject(self, XN_UIVIEWCONTROLLER_LOADING_FAILED_BACKGROUND_TAG);
    if (viewControllersArray.count > 0) {
        
        [viewControllersArray addObject:dic];
        objc_setAssociatedObject(self, XN_UIVIEWCONTROLLER_LOADING_FAILED_BACKGROUND_TAG, viewControllersArray, OBJC_ASSOCIATION_RETAIN);
    }else
    {
        viewControllersArray = [NSMutableArray arrayWithObject:dic];
        objc_setAssociatedObject(self, XN_UIVIEWCONTROLLER_LOADING_FAILED_BACKGROUND_TAG, viewControllersArray, OBJC_ASSOCIATION_RETAIN);
    }
    
    UIImageView * centerImageView = [[UIImageView alloc]init];
    [centerImageView setImage:[UIImage imageNamed:@"XN_Default_No_Message_icon.png"]];
    
    UIButton * reLoadBtn = [[UIButton alloc]init];
    [reLoadBtn setBackgroundColor:[UIColor clearColor]];
    [reLoadBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [loadingBackgroundView addSubview:centerImageView];
    [loadingBackgroundView addSubview:reLoadBtn];
    [self.view addSubview:loadingBackgroundView];
    
    __weak UIView * tmpSelf = self.view;
    [loadingBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpSelf);
    }];
    
    [centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.mas_equalTo(tmpSelf);
        make.width.mas_equalTo(@(75));
        make.height.mas_equalTo(@(75));
    }];
    
    [reLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpSelf);
    }];
}

#pragma mark - 是否存在target的加载失败页面
- (BOOL)isExistNetworkLoadingFailedTarget:(id)target
{
    NSMutableArray * viewControllersArray = objc_getAssociatedObject(self, XN_UIVIEWCONTROLLER_LOADING_FAILED_BACKGROUND_TAG);
    
    NSDictionary * dic = nil;
    for (NSInteger index = 0; index < viewControllersArray.count ; index ++) {
        
        dic = [viewControllersArray objectAtIndex:index];
        
        if ([NSObject isValidateObj:[dic objectForKey:NSStringFromClass([target class])]]) {
            
            return YES;
        }
    }

    return NO;
}

#pragma mark - 为指定试图移除加载
- (void)hideLoadingTarget:(id)target
{
    NSMutableArray * viewControllersArray = objc_getAssociatedObject(self, XN_UIVIEWCONTROLLER_LOADING_FAILED_BACKGROUND_TAG);
    
    NSDictionary * dic = nil;
    NSMutableArray * tmpObj = [NSMutableArray array];
    for (NSInteger index = 0; index < viewControllersArray.count ; index ++) {
        
        dic = [viewControllersArray objectAtIndex:index];
        
        if ([NSObject isValidateObj:[dic objectForKey:NSStringFromClass([target class])]]) {
            
            [tmpObj addObject:dic];
        }
    }
    
    for (NSDictionary * dic in tmpObj) {
        
        [[dic objectForKey:NSStringFromClass([target class])] removeFromSuperview];
        [viewControllersArray removeObject:dic];
    }
}

@end
