//
//  GXQNavigationController.m
//  GXQApp
//
//  Created by 振增 黄 on 14-6-19.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import "GXQNavigationController.h"

@interface GXQNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate> {
    NSMutableArray *observerArray;
}
@end

@implementation GXQNavigationController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        observerArray = [NSMutableArray array];
    }
    return self;
}


- (void)setInteractivePopGestureDelegate {
    __weak GXQNavigationController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
        weakSelf.systemDelegate = weakSelf;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setInteractivePopGestureDelegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)willDealloc
{
    return NO;
}

-(void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
    [super setViewControllers:viewControllers animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }

    [super pushViewController:viewController animated:animated];
}

- (void)addObserver:(id)observer {
    [observerArray addObject:observer];
}

- (void)removeObserver:(id)observer {
    [observerArray removeObject:observer];
}

- (id)notifyWithSelector:(SEL)selector withObject:(id)params {
    id iRet = nil;
    for (id object in observerArray) {
        if ([object respondsToSelector:selector]) {
            iRet = [object performSelector:selector withObject:params];
        }
    }
    
    return iRet;
}


#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    // Enable the gesture again once the new controller is shown
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //[self setInteractivePopGestureDelegate];
        NSNumber *iRet = @(YES);
        if ([viewController respondsToSelector:@selector(GXQNavigationControllerSupportedInteractivePopGestureRecognizer)]) {
            iRet = [viewController performSelector:@selector(GXQNavigationControllerSupportedInteractivePopGestureRecognizer) withObject:nil];
        }
        if (self.viewControllers.count > 1 && iRet.boolValue) {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
        else {
            self.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
       if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        
        if (self.viewControllers.count > 1) {
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        return YES;
    }
}


@end
