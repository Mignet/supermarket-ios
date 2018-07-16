//
//  CustomTabBarController
//
//  Created by lhlc on 2016-9-17.
//  Copyright (c) 2016年 xnkj. All rights reserved.
//

#import "CustomTabBarController.h"

@interface CustomTabBarController ()

@property (nonatomic, strong) NSMutableArray      * marCtrls;
@property (nonatomic, strong) NSMutableArray      * marUnselImages;
@property (nonatomic, strong) NSMutableArray      * marSelImages;
@property (nonatomic, strong) NSMutableArray      * marCustomViews;
@property (nonatomic, strong) NSMutableArray      * marTabViewArray;
@property (nonatomic, strong) NSMutableArray      * marLabels;
@property (nonatomic, strong) NSMutableDictionary * marRemindImageViewDictionary;

@end

@implementation CustomTabBarController

- (instancetype)init
{
    self = [[[UINib nibWithNibName:@"CustomTabBarController" bundle:nil] instantiateWithOwner:nil options:nil] objectAtIndex:0];
    if (self) {
        
        self.marCtrls = [[NSMutableArray alloc] init];
        self.marUnselImages = [[NSMutableArray alloc] init];
        self.marSelImages = [[NSMutableArray alloc] init];
        self.marCustomViews = [[NSMutableArray alloc] init];
        self.marTabViewArray = [[NSMutableArray alloc]init];
        self.marLabels = [[NSMutableArray alloc] init];
        self.marRemindImageViewDictionary = [[NSMutableDictionary alloc]init];
        
        //设置背景图片
        [self.tabBar setBackgroundImage:[UIImage new]];
        [self.tabBar setOpaque:YES];
        [self.tabBar setHidden:NO];
        [self.tabBar setBackgroundColor:[UIColor whiteColor]];
        
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

//IOS11 中出现布局错乱
//- (void)viewWillLayoutSubviews
//{
//    CGRect tabFrame = self.tabBar.frame;
//    tabFrame.size.height = 55;
//    tabFrame.origin.y = self.view.frame.size.height - 55;
//    self.tabBar.frame = tabFrame;
//}

//////////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////////////

#pragma mark - 初始化选中和未选中的图片数组
- (NSInteger)addViewController:(UIViewController*)ctrl
                 imgUnselected:(NSString*)imgUnselected
                   imgSelected:(NSString*)imgSelected
{
    NSInteger i = [self.marCtrls indexOfObject:ctrl];
    if (i >= 0 && i < self.marCtrls.count) {
      
        [self setViewController:ctrl
                  imgUnselected:imgUnselected?imgUnselected:@""
                    imgSelected:imgSelected?imgSelected:@""];
        return i;
    }
    
    i = self.marCtrls.count;
    
    [self.marCtrls addObject:ctrl];
    [self.marUnselImages addObject:imgUnselected?imgUnselected:@""];
    [self.marSelImages addObject:imgSelected?imgSelected:@""];
    
    return i;
}

#pragma mark - 重新设置选中和未选中对应的图片
- (void)setViewController:(UIViewController*)ctrl
            imgUnselected:(NSString*)imgUnselected
              imgSelected:(NSString*)imgSelected
{
    NSInteger i = [self.marCtrls indexOfObject:ctrl];
    if (i >= 0 && i < self.marCtrls.count) {
        [self.marUnselImages replaceObjectAtIndex:i
                                       withObject:imgUnselected];
        [self.marSelImages replaceObjectAtIndex:i
                                     withObject:imgSelected];
    }
}

#pragma mark - 移除tab项目,并重新刷新
- (void)removeViewController:(UIViewController*)ctrl
{
    NSInteger i = [self.marCtrls indexOfObject:ctrl];
    if (i >= 0 && i < self.marCtrls.count) {
        [self.marCtrls removeObjectAtIndex:i];
        [self.marUnselImages removeObjectAtIndex:i];
        [self.marSelImages removeObjectAtIndex:i];
    }
    
    [self refreshView];
}

#pragma mark - 刷新试图
- (void)refreshView
{
    if (self.view == nil) {
        return ;
    }
    
    [self setViewControllers:self.marCtrls animated:NO];
    
    for (UIView* cView in self.marCustomViews) {
        [cView removeFromSuperview];
    }
    [self.marCustomViews removeAllObjects];
    [self.marLabels removeAllObjects];
    [self.marTabViewArray removeAllObjects];
    
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 49;
    tabFrame.origin.y = self.view.frame.size.height - 49;
    self.tabBar.frame = tabFrame;
    
    NSInteger i = 0;
    CGFloat nIVWidth = self.tabBar.frame.size.width/self.marCtrls.count;
    NSInteger nIVHeight = self.tabBar.frame.size.height;
    
    for (UIView* subView in self.tabBar.subviews) {
        NSString* str = [NSString stringWithUTF8String:object_getClassName(subView)];
        if ([str isEqualToString:@"UITabBarButton"]) {
            
            for (UIView * tmpView in subView.subviews) {
                
                [tmpView setHidden:YES];
            }
            
            UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, nIVWidth, nIVHeight)];
            iv.contentMode = UIViewContentModeScaleAspectFit;
            [self.marCustomViews addObject:iv];
            
            UIViewController* curCtrl = [self.marCtrls objectAtIndex:i];
            if (self.selectedViewController == nil && i == 0)
            {
                iv.image = [UIImage imageNamed:[self.marSelImages objectAtIndex:i]];
            }
            else if (curCtrl == self.selectedViewController) {
                iv.image = [UIImage imageNamed:[self.marSelImages objectAtIndex:i]];
            }
            else
            {
                iv.image = [UIImage imageNamed:[self.marUnselImages objectAtIndex:i]];
            }
        
            [subView addSubview:iv];
            [self.marTabViewArray addObject:subView];
            
            ++i;
        }
    }
}

#pragma mark - 重写selectedViewController,从而更新选中和未选中的图片展示
- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    NSInteger i = [self.marCtrls indexOfObject:selectedViewController];
    
    if (i < 0 || i >= self.marCtrls.count) {
        return ;
    }
    
    if (self.marCustomViews == nil || self.marCustomViews.count == 0) {
        return ;
    }
    
    static NSInteger lastIndex = 0;
    UIImageView* iv = [self.marCustomViews objectAtIndex:i];
    iv.image = [UIImage imageNamed:[self.marSelImages objectAtIndex:i]];
    
    if (lastIndex != i) {
        UIImageView* ivLast = [self.marCustomViews objectAtIndex:lastIndex];
        ivLast.image = [UIImage imageNamed:[self.marUnselImages objectAtIndex:lastIndex]];
    }
    lastIndex = i;
    
    [super setSelectedViewController:selectedViewController];
}

#pragma mark - 重写selectedIndex
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    
    self.selectedViewController = [self.marCtrls objectAtIndex:selectedIndex];
}

#pragma mark - 适配ios7以下的
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

#pragma mark- 获取指定下标的视图
- (UIView*)getItemView:(NSInteger)index
{
    if (self.marCustomViews == nil ||
        index < 0 ||
        index > self.marCustomViews.count)
    {
        return nil;
    }
    
    return (UIView*)[_marCustomViews objectAtIndex:index];
}

#pragma mark - 添加圆点提示
- (void)addNormalDotImageName:(NSString *)imageName selectedDotImageName:(NSString *)selectedImageName atIndex:(NSInteger )index
{
    UIViewController * currentCtrl = [self.marCtrls objectAtIndex:index];
    
    [self setViewController:currentCtrl imgUnselected:imageName imgSelected:selectedImageName];
    [self refreshView];
}

- (void)replaceRemindDotAtIndex:(NSInteger )index withNormalImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    UIViewController * currentCtrl = [self.marCtrls objectAtIndex:index];
    
    [self setViewController:currentCtrl imgUnselected:imageName imgSelected:selectedImageName];
        
    [self refreshView];
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

