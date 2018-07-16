//
//  GuideViewController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/17.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray * guideImageArray;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, weak) IBOutlet UIScrollView  * containerScrollView;
@property (nonatomic, weak) IBOutlet UIPageControl * pageControl;
@property (nonatomic, weak) IBOutlet UIButton      * earnMoneyBtn;
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////
#pragma mark - Custom methods
//////////////////////////////////////////////

#pragma mark - 初始化
- (void)initView
{
    self.currentPage = 0;
    self.pageControl.numberOfPages = self.guideImageArray.count;
    self.pageControl.currentPage = self.currentPage;
    self.containerScrollView.contentSize = CGSizeMake(SCREEN_FRAME.size.width * self.guideImageArray.count, 0);
    
    UIImageView * guideImg = nil;
    UIButton * enterButton = nil;
    NSInteger index = 0;
    for (NSString * imageUrl in self.guideImageArray) {
        
        guideImg = [[UIImageView alloc]initWithFrame:CGRectMake(index * SCREEN_FRAME.size.width, 0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
        [guideImg setImage:[UIImage imageNamed:imageUrl]];
        [self.containerScrollView addSubview:guideImg];
        
        if (index == self.guideImageArray.count - 1) {
            
            enterButton = [[UIButton alloc]init];
            [enterButton setBackgroundColor:[UIColor clearColor]];
            [enterButton addTarget:self action:@selector(clickEarnMoney:) forControlEvents:UIControlEventTouchUpInside];
            [self.containerScrollView addSubview:enterButton];
            
            __weak UIImageView * tmpImageView = guideImg;
            [enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.centerX.mas_equalTo(tmpImageView.mas_centerX);
                make.bottom.mas_equalTo(tmpImageView.mas_bottom).offset(- (93 * SCREEN_FRAME.size.height) / 736.0);
                make.width.mas_equalTo((SCREEN_FRAME.size.width * 180) / 414);
                make.height.mas_equalTo((SCREEN_FRAME.size.height * 43) / 736.0);
            }];
        }
        index ++;
    }
}

#pragma mark - 开始进入主页面 
- (void)clickEarnMoney:(id)sender
{
    [_UI endShowingSplashView];
}

///////////////////////////
#pragma mark - Protocol methods
//////////////////////////////////////////////

#pragma mark - uiscrollview
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = (int)(scrollView.contentOffset.x / SCREEN_FRAME.size.width);
    
    if (page != self.currentPage) {
        
        self.pageControl.currentPage = page;
        self.currentPage = page;
    }
    
    if (self.currentPage == self.guideImageArray.count - 1) {
        
        [self.earnMoneyBtn setHidden:NO];
    }else
        [self.earnMoneyBtn setHidden:YES];
}

//////////////////////////
#pragma mark - setter/getter
//////////////////////////////////////////////

#pragma mark - guideImageArray
- (NSArray *)guideImageArray
{
    if (!_guideImageArray) {
        
        _guideImageArray = [[NSArray alloc]initWithObjects:@"page1.jpg",@"page2.jpg",@"page3.jpg",@"page4.jpg", nil];
    }
    return _guideImageArray;
}

@end
