//
//  LaunchViewController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/17.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "AdViewController.h"
#import "UniversalInteractWebViewController.h"
#import "UIImageView+WebCache.h"

@interface AdViewController ()

@property (nonatomic, strong) NSString     * jumpUrl;
@property (nonatomic, strong) NSString     * imageUrl;

@property (nonatomic, assign)  NSInteger     timerCount;
@property (nonatomic, strong)  NSTimer     * timer;

@property (nonatomic, weak) IBOutlet UIImageView * launchImg;
@property (nonatomic, weak) IBOutlet UIButton    * exitAdButton;

@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.timer invalidate];
}

////////////////////////////////////
#pragma mark - Custom Method
//////////////////////////////////////////////////

#pragma mark - 初始化
- (void)initView
{
    self.timerCount = 5;
    
    NSDictionary * openAdvisementDictionary = [_LOGIC readDicDataFromFileName:@"openAdvertisement.plist"];
    
    self.imageUrl = [[[openAdvisementDictionary objectForKey:@"datas"] firstObject] objectForKey:XN_ADVERTISEMENT_OPENING_IMGURL];
    self.jumpUrl = [[[openAdvisementDictionary objectForKey:@"datas"] firstObject] objectForKey:XN_ADVERTISEMENT_OPENING_LINKURL];
    
    [self.launchImg setImage:[_LOGIC getImageFromLocalBox:@"openAdImage.png"]];
    
    [self.timer setFireDate:[NSDate distantPast]];
}

#pragma mark - 定时处理
- (void)timerHandle
{
    self.timerCount -- ;
    
    if (self.timerCount < 0) {
        
        [self.timer setFireDate:[NSDate distantFuture]];
        [self.timer invalidate];
        
        [_UI endShowingSplashView];
        return;
    }
    [self.exitAdButton setTitle:[NSString stringWithFormat:@"跳过(%@s)",[NSNumber numberWithInteger:self.timerCount]] forState:UIControlStateNormal];
}

#pragma mark - 跳转到广告
- (IBAction)clickAd:(id)sender
{
    if ([NSObject isValidateInitString:self.jumpUrl]) {
    
        NSString * jumpUrl = self.jumpUrl;
        
        [self.timer invalidate];
        
        UniversalInteractWebViewController * webView = [[UniversalInteractWebViewController alloc]initRequestUrl:jumpUrl requestMethod:@"GET"];
        webView.needNewSwitchViewAnimation = YES;
        [_UI pushViewControllerFromHomeViewControllerForController:webView hideNavigationBar:NO animated:YES];
        
        [self performSelector:@selector(endShowingSplashView) withObject:nil afterDelay:0.1f];
    }
}

//结束启动
- (void)endShowingSplashView
{
    [_UI endShowingSplashView];
}

#pragma mark - 逃过
- (IBAction)clickIgnore:(id)sender
{
    [self.timer invalidate];

    [_UI endShowingSplashView];
}

////////////////////////////////////
#pragma mark - setter/getter
//////////////////////////////////////////////////

#pragma mark - timer
- (NSTimer *)timer
{
    if (!_timer) {
        
        _timer = [NSTimer timerWithTimeInterval:1.0f
                                         target:self
                                       selector:@selector(timerHandle)
                                       userInfo:nil
                                        repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
@end
