//
//  PopContainerViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/18/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "PopContainerViewController.h"
#import "PopViewController.h"

#define HEADERHEIGHT ((200 * SCREEN_FRAME.size.width) / 375.0 + 40)
#define CELLHEIGHT 44.0f

@interface PopContainerViewController ()<PopViewControllerDelegate>

@property (nonatomic, strong) PopViewController *popViewController;
@property (nonatomic, strong) NSMutableArray *datasArray;
@property (nonatomic, assign) BOOL isShowLastDefaultCell;
@property (nonatomic, assign) float fTopPadding;
@property (nonatomic, assign) float fLeftPadding;

@end

@implementation PopContainerViewController

- (id)initWithDatas:(BOOL)isShowLastCell topPadding:(float)topPadding leftPadding:(float)leftPadding datas:(NSArray *)dataArray
{
    self = [super init];
    if (self)
    {
        [self.datasArray removeAllObjects];
        [self.datasArray addObjectsFromArray:dataArray];
        self.isShowLastDefaultCell = isShowLastCell;
        self.fTopPadding = topPadding;
        self.fLeftPadding = leftPadding;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/////////////////
#pragma mark - 自定义
/////////////////////////////////

//初始化
- (void)initView
{
    [self hidden];
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    UIButton * existButton = [[UIButton alloc]init];
    [existButton setBackgroundColor:[UIColor clearColor]];
    [existButton addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:existButton];
    
    weakSelf(weakSelf)
    [existButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];
    
    [self.view addSubview:self.popViewController.view];
    
    NSInteger nCount = self.datasArray.count;
    if (self.isShowLastDefaultCell)
    {
        nCount += 1;
    }
    
    float fHeight = nCount * CELLHEIGHT;
    if (fHeight > self.view.size.height - 55 - 64 - HEADERHEIGHT - 10)
    {
        fHeight = self.view.size.height - 55 - 64 - HEADERHEIGHT - 10;
    }
    
    [self.popViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view.mas_top);
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(weakSelf.fLeftPadding);
        make.width.mas_equalTo(SCREEN_FRAME.size.width / 2);
        make.height.mas_equalTo(fHeight);
    }];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)updateDatas:(NSArray *)dataArray selectedArray:(NSArray *)selectedArray
{
    [self.popViewController updateDatas:dataArray selectedArray:selectedArray];
}

#pragma mark - 取消
- (void)hidden
{
    self.view.hidden = YES;

    if (self.delegate && [self.delegate respondsToSelector:@selector(popContainerViewControllerHidden)])
    {
        [self.delegate popContainerViewControllerHidden];
    }
}

#pragma mark - PopViewControllerDelegate
- (void)popViewControllerClick:(NSArray *)selectedArray
{
    [self hidden];
    //筛选操作
    if (self.delegate && [self.delegate respondsToSelector:@selector(popContainerViewControllerClick:)])
    {
        [self.delegate popContainerViewControllerClick:selectedArray];
    }
}

////////////////////////
#pragma mark - setter/etter
///////////////////////////////////////

#pragma mark -popViewController
- (PopViewController *)popViewController
{
    if (!_popViewController)
    {
        _popViewController = [[PopViewController alloc] initWithNibName:@"PopViewController" bundle:nil showLastCell:self.isShowLastDefaultCell];
        _popViewController.delegate = self;
    }
    return _popViewController;
}

#pragma mark - datasArray
- (NSMutableArray *)datasArray
{
    if (!_datasArray)
    {
        _datasArray = [[NSMutableArray alloc] init];
    }
    return _datasArray;
}

@end
