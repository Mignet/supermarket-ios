//
//  GXQTabBarController.m
//  GXQApp
//
//  Created by jinfuzi on 14-2-24.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import "GXQTabBarController.h"
#import "GXQFramework.h"

@implementation UITabBarItem (Harmony)
- (void)setTitle:(NSString *)title
{
    
}

- (void)setImage:(UIImage *)image
{
    
}
@end

@implementation GXQTabBar

+ (UITabBarController*)createControllerForMe
{
    UINib* nib = [UINib nibWithNibName:@"GXQTabBar"
                                bundle:nil];
    return (UITabBarController*)[[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        imgBK = [UIImage imageNamed:[GXQFramework getConfig].imgTabBarBK];
        imgBK = [imgBK stretchableImageWithLeftCapWidth:[GXQFramework getConfig].vc.fTabBarBKLeftCap topCapHeight:[GXQFramework getConfig].vc.fTabBarBKTopCap];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(myContext, 0, [GXQFramework getConfig].vc.fTabBarDefHeight);
    CGContextScaleCTM(myContext, 1.0f, -1.0f);
    CGContextDrawImage(myContext, rect, imgBK.CGImage);
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(self.frame.size.width, [GXQFramework getConfig].vc.fTabBarDefHeight);
}

@end


@interface GXQTabBarController ()
{
    NSMutableArray* _marCtrls;
    NSMutableArray* _marUnselImages;
    NSMutableArray* _marSelImages;
    NSMutableArray* _marCustomViews;
    NSMutableArray* _marTabViewArray;
    NSMutableDictionary* _marRemindImageViewDictionary;
    NSMutableArray* _marLabels;
}
- (void)applyStyleOnLabel:(UILabel*)label selected:(BOOL)selected;

@end

@implementation GXQTabBarController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _marCtrls = [[NSMutableArray alloc] init];
        _marUnselImages = [[NSMutableArray alloc] init];
        _marSelImages = [[NSMutableArray alloc] init];
        _marCustomViews = [[NSMutableArray alloc] init];
        _marTabViewArray = [[NSMutableArray alloc]init];
        _marRemindImageViewDictionary = [[NSMutableDictionary alloc]init];
        _marLabels = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 注意，下面的代码很重要
    // 可以有效地解决播放器退出后黑屏需要重绘的问题，以后需要针对NavigationController深度定制的缺陷来解决
    UIViewController* ctrlSelected = self.selectedViewController;
    if (_marCtrls.count > 1) {
        [super setSelectedViewController:ctrlSelected];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    if (IOS7_EARLIER && (self.navigationController != nil)) {
        UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:0];
        if ([vc isKindOfClass:[UITabBarController class]]) {
            UIView *v = [self getWrapperView:self.view name:@"UIViewControllerWrapperView"];
            CGRect rect = v.frame;
            rect.size.height += rect.origin.y;
            rect.origin.y = 0;
            v.frame = rect;
        }
    }
}

//////////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////////////

#pragma mark - 刷新试图
- (void)refreshView
{
    if (self.view == nil) {
        return ;
    }
    [self setViewControllers:_marCtrls animated:NO];
    
    for (UIView* cView in _marCustomViews) {
        [cView removeFromSuperview];
    }
    [_marCustomViews removeAllObjects];
    [_marLabels removeAllObjects];
    
    GXQTabBar* tabBar = (GXQTabBar*)self.tabBar;
    NSInteger nIVWidth = SCREEN_FRAME.size.width/_marCtrls.count;
    NSInteger nIVHeight = tabBar.frame.size.height;
    NSInteger i = 0;
    for (UIView* subView in tabBar.subviews) {
        NSString* str = [NSString stringWithUTF8String:object_getClassName(subView)];
        if ([str isEqualToString:@"UITabBarButton"]) {
            
            CGRect rcFrame = subView.bounds;
            
            rcFrame.origin.y -= (nIVHeight-rcFrame.size.height);
            rcFrame.origin.x -= (nIVWidth-rcFrame.size.width)/2;
            rcFrame.size.width = nIVWidth;
            rcFrame.size.height = nIVHeight;
            
            UIImageView* iv = [[UIImageView alloc] initWithFrame:rcFrame];
            iv.contentMode = UIViewContentModeScaleAspectFit;
            [_marCustomViews addObject:iv];
            
            UIViewController* curCtrl = [_marCtrls objectAtIndex:i];
            if (self.selectedViewController == nil && i == 0)
            {
                iv.image = [UIImage imageNamed:[_marSelImages objectAtIndex:i]];
            }
            else if (curCtrl == self.selectedViewController) {
                iv.image = [UIImage imageNamed:[_marSelImages objectAtIndex:i]];
            }
            else
            {
                iv.image = [UIImage imageNamed:[_marUnselImages objectAtIndex:i]];
            }
            
            [subView addSubview:iv];
            [_marTabViewArray addObject:subView];
            
            if (_sampleLabel) {
                UILabel* lb = [[UILabel alloc] init];
                lb.backgroundColor = [UIColor clearColor];
                lb.textAlignment = NSTextAlignmentCenter;
                if (curCtrl.title && ![curCtrl.title isEqualToString:@""]) {
                    lb.text = curCtrl.title;
                }
                else if ([curCtrl isKindOfClass:[UINavigationController class]])
                {
                    UINavigationController* navi = (UINavigationController*)curCtrl;
                    if (navi.viewControllers && navi.viewControllers.count) {
                        lb.text = ((UIViewController*)[navi.viewControllers objectAtIndex:0]).title;
                    }
                }
                
                BOOL bSelected = (self.selectedViewController == nil && i == 0)
                || curCtrl == self.selectedViewController;
                [self applyStyleOnLabel:lb selected:bSelected];
                
                [_marLabels addObject:lb];
                [subView addSubview:lb];
            }
            
            ++i;
        }
    }
}

- (UIView*)getItemView:(NSInteger)index
{
    if (_marCustomViews == nil ||
        index < 0 ||
        index > _marCustomViews.count)
    {
        return nil;
    }
    
    return (UIView*)[_marCustomViews objectAtIndex:index];
}

- (NSInteger)addViewController:(UIViewController*)ctrl
                 imgUnselected:(NSString*)imgUnselected
                   imgSelected:(NSString*)imgSelected
{
    NSInteger i = [_marCtrls indexOfObject:ctrl];
    if (i >= 0 && i < _marCtrls.count) {
        [self setViewController:ctrl
                  imgUnselected:imgUnselected?imgUnselected:@""
                    imgSelected:imgSelected?imgSelected:@""];
        return i;
    }
    
    i = _marCtrls.count;
    
    [_marCtrls addObject:ctrl];
    [_marUnselImages addObject:imgUnselected?imgUnselected:@""];
    [_marSelImages addObject:imgSelected?imgSelected:@""];
    
    return i;
}

- (void)removeViewController:(UIViewController*)ctrl
{
    NSInteger i = [_marCtrls indexOfObject:ctrl];
    if (i >= 0 && i < _marCtrls.count) {
        [_marCtrls removeObjectAtIndex:i];
        [_marUnselImages removeObjectAtIndex:i];
        [_marSelImages removeObjectAtIndex:i];
    }
}

- (void)setViewController:(UIViewController*)ctrl
            imgUnselected:(NSString*)imgUnselected
              imgSelected:(NSString*)imgSelected
{
    NSInteger i = [_marCtrls indexOfObject:ctrl];
    if (i >= 0 && i < _marCtrls.count) {
        [_marUnselImages replaceObjectAtIndex:i
                                   withObject:imgUnselected];
        [_marSelImages replaceObjectAtIndex:i
                                 withObject:imgSelected];
    }
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    NSInteger i = [_marCtrls indexOfObject:selectedViewController];
    if (i < 0 || i >= _marCtrls.count) {
        return ;
    }
    if (_marCustomViews == nil || _marCustomViews.count == 0) {
        return ;
    }
   
    static NSInteger lastIndex = 0;
    UIImageView* iv = [_marCustomViews objectAtIndex:i];
    iv.image = [UIImage imageNamed:[_marSelImages objectAtIndex:i]];
    if (_sampleLabel) {
        [self applyStyleOnLabel:[_marLabels objectAtIndex:i] selected:YES];
    }
    
    if (lastIndex != i) {
        UIImageView* ivLast = [_marCustomViews objectAtIndex:lastIndex];
        ivLast.image = [UIImage imageNamed:[_marUnselImages objectAtIndex:lastIndex]];
        if (_sampleLabel) {
            [self applyStyleOnLabel:[_marLabels objectAtIndex:lastIndex] selected:NO];
        }
    }
    lastIndex = i;

    
    [super setSelectedViewController:selectedViewController];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    self.selectedViewController = [_marCtrls objectAtIndex:selectedIndex];
    
}

- (NSUInteger)selectedIndex
{
    return [_marCtrls indexOfObject:self.selectedViewController];
}

- (void)applyStyleOnLabel:(UILabel*)label selected:(BOOL)selected
{
    if (_sampleLabel == nil) {
        return ;
    }
    if (!selected || !_sampleLabelSelected) {
        label.frame = _sampleLabel.frame;
        label.textColor = _sampleLabel.textColor;
        label.font = _sampleLabel.font;
    }
    else
    {
        label.frame = _sampleLabelSelected.frame;
        label.textColor = _sampleLabelSelected.textColor;
        label.font = _sampleLabelSelected.font;
    }
}

- (UIView *)getWrapperView:(UIView *)destView name:(NSString *)className {
    
    for (UIView *tempView in destView.subviews) {
        if ([tempView isKindOfClass:NSClassFromString(className)]) {
            return tempView;
        }
        else {
            return [self getWrapperView:tempView name:className];
        }
    }
    
    return nil;
}

#pragma mark - 添加圆点提示
- (void)addRemindDot:(NSString *)dotImageName atIndex:(NSInteger )index
{
    UIImageView * DotImageView = [_marRemindImageViewDictionary valueForKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:index]]];
    
    if (![NSObject isValidateObj:DotImageView]) {
    
        GXQTabBar* tabBar = (GXQTabBar*)self.tabBar;
        NSInteger nIVWidth = SCREEN_FRAME.size.width/_marCtrls.count;
        NSInteger nIVHeight = tabBar.frame.size.height;
        UIView * subView = nil;
        for (NSInteger i = 0 ; i < _marTabViewArray.count ; i ++) {
            
            subView = [_marTabViewArray objectAtIndex:i];
            if (index == i){
                    
                CGRect rcFrame = subView.bounds;
                
                rcFrame.origin.y -= (nIVHeight-rcFrame.size.height);
                rcFrame.origin.x -= (nIVWidth-rcFrame.size.width)/2;
                rcFrame.size.width = nIVWidth;
                rcFrame.size.height = nIVHeight;
                
                UIImageView* iv = [[UIImageView alloc] initWithFrame:rcFrame];
                [iv setImage:[UIImage imageNamed:dotImageName]];
                iv.contentMode = UIViewContentModeScaleAspectFit;
                [_marRemindImageViewDictionary setObject:iv forKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:index]]];
                
                [subView addSubview:iv];
            }
        }
    }
}

- (void)removeRemindDotAtIndex:(NSInteger )index
{
    UIImageView * DotImageView = [_marRemindImageViewDictionary valueForKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:index]]];
    
    if ([NSObject isValidateObj:DotImageView]) {
    
       [DotImageView removeFromSuperview];
       [_marRemindImageViewDictionary removeObjectForKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:index]]];
    }
}

//////////////////////////////
#pragma mark - Protocal
///////////////////////////////////////////////

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    CATransition* animation = [CATransition animation];
    [animation setDuration:0.2f];
    [animation setType:kCATransitionFade];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [[self.view layer]addAnimation:animation forKey:@"switchView"];
}

@end

