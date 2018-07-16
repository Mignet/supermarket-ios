//
//  SelectProductListViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/4/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "SelectProductListViewController.h"
#import "SPShortTermProductListViewController.h"
#import "SPLongTermProductListViewController.h"
#import "CustomScrollPanView.h"

#define TITLE_WIDTH (SCREEN_FRAME.size.width / 2) - 1
#define TITLE_HEIGHT 43.0f
#define JFZ_COLOR_SELECTED UIColorFromHex(0x4e8cef)
#define JFZ_COLOR_UNSELECTED UIColorFromHex(0x4f5960)

@interface SelectProductListViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *titleContainerScrollView;
@property (nonatomic, weak) IBOutlet CustomScrollPanView *listScrollView;
@property (nonatomic, strong) UIView *cursorView;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *titleTabMutableArray;
@property (nonatomic, strong) NSArray *listCtrlArray;
@property (nonatomic, strong) NSMutableArray *listContentMutableArray;

@end

@implementation SelectProductListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
}

/////////////////
#pragma mark - 自定义
/////////////////////////////////

//初始化
- (void)initView
{
    self.title = @"网贷精选";
    [self initTabScrollView];
}

- (void)initTabScrollView
{
    [self.view layoutIfNeeded];
    
    [_titleContainerScrollView addSubview:self.cursorView];
    [_titleContainerScrollView setContentSize:CGSizeMake(SCREEN_FRAME.size.width / 4 * self.titleArray.count, 0)];
    
    //添加滑动标题
    UIButton *btn = nil;
    UIButton *lastBtn = nil;
    weakSelf(weakSelf)
    
    __weak UIScrollView *weakTitleContainerScrollView = _titleContainerScrollView;
    for (int i = 0; i < self.titleArray.count; i++)
    {
        btn = [[UIButton alloc] initWithFrame:CGRectMake(i * TITLE_WIDTH, 0, TITLE_WIDTH, TITLE_HEIGHT)];
        [btn setTag:i];
        [btn.titleLabel setFont:i ==0 ? [UIFont systemFontOfSize:14]:[UIFont systemFontOfSize:14]];
        [btn setTitle:[self.titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:i==0?JFZ_COLOR_SELECTED:JFZ_COLOR_UNSELECTED forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [_titleContainerScrollView addSubview:btn];
        [self.titleTabMutableArray addObject:btn];
        
        __weak UIButton *weakLastBtn = lastBtn;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0)
            {
                make.left.mas_equalTo(weakTitleContainerScrollView.mas_left);
            }
            else if (i == weakSelf.listCtrlArray.count - 1)
            {
                make.left.mas_equalTo(weakLastBtn.mas_right);
                make.right.mas_equalTo(weakTitleContainerScrollView.mas_right);
            }
            else
            {
                make.leading.mas_equalTo(weakLastBtn.mas_trailing);
            }
            make.top.mas_equalTo(weakTitleContainerScrollView.mas_top);
            make.width.mas_equalTo(TITLE_WIDTH);
            make.height.mas_equalTo(TITLE_HEIGHT);
        }];
        lastBtn = btn;
        
        if (i == 0)
        {
            __weak UIButton *weakButton = btn;
            __weak UIScrollView *weakTitleContainerScrollView = _titleContainerScrollView;
            [self.cursorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(weakButton.mas_centerX);
                make.bottom.mas_equalTo(weakButton.mas_bottom).offset(1.5);
                make.width.equalTo(weakTitleContainerScrollView.mas_width).multipliedBy(0.25);
                make.height.mas_equalTo(2);
            }];
        }
        
    }
    
    //添加滑动内容列表
    UIViewController *ctrl = nil;
    UIViewController *lastCtrl = nil;
    Class classCtrl;
    
    __weak UIScrollView *weakScrollView = self.listScrollView;
    for (int i = 0; i < self.listCtrlArray.count; i++)
    {
        classCtrl = NSClassFromString([self.listCtrlArray objectAtIndex:i]);
        ctrl = [[classCtrl alloc] initWithNibName:[self.listCtrlArray objectAtIndex:i] bundle:nil];
        ctrl.view.frame = CGRectMake(i * SCREEN_FRAME.size.width, 0, SCREEN_FRAME.size.width, self.listScrollView.frame.size.height);
        [_listScrollView addSubview:ctrl.view];
        
        [self addChildViewController:ctrl];
        [self.listContentMutableArray addObject:ctrl];
        
        __weak UIViewController *weakLastCtrl = lastCtrl;
        [ctrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0)
            {
                make.leading.mas_equalTo(weakScrollView.mas_leading);
            }
            else if (i == weakSelf.listCtrlArray.count - 1)
            {
                make.leading.mas_equalTo(weakLastCtrl.view.mas_trailing);
                make.trailing.mas_equalTo(weakScrollView.mas_trailing);
            }
            else
            {
                make.leading.mas_equalTo(weakLastCtrl.view.mas_trailing);
            }
            
            make.top.mas_equalTo(weakScrollView.mas_top);
            make.bottom.mas_equalTo(weakScrollView.mas_bottom);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.equalTo(weakScrollView);
        }];
        lastCtrl = ctrl;
    }
    
    UILabel * bottomSeperatorLine = [[UILabel alloc]init];
    [bottomSeperatorLine setBackgroundColor:UIColorFromHex(0xefefef)];
    [_titleContainerScrollView addSubview:bottomSeperatorLine];
    [bottomSeperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakTitleContainerScrollView.mas_leading);
        make.trailing.mas_equalTo(weakTitleContainerScrollView.mas_trailing);
        make.height.mas_equalTo(@(0.5));
        make.bottom.mas_equalTo(weakTitleContainerScrollView.mas_bottom);
    }];

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
}

#pragma mark - 选中标题操作
- (void)selectedTab:(UIButton *)sender
{
    for (UIButton *btn in self.titleTabMutableArray)
    {
        if ([btn isEqual:sender])
        {
            [btn setTitleColor:JFZ_COLOR_SELECTED forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        }
        else
        {
            [btn setTitleColor:JFZ_COLOR_UNSELECTED forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        }
    }
    
    NSInteger index = [self.titleTabMutableArray indexOfObject:sender];
    
    __weak UIButton *weakButton = sender;
    __weak UIScrollView *weakScrollView = _titleContainerScrollView;
    [self.cursorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakButton.mas_centerX);
        make.bottom.mas_equalTo(weakButton.mas_bottom).offset(1.5);
        make.width.equalTo(weakScrollView.mas_width).multipliedBy(0.25);
        make.height.mas_equalTo(2);
    }];
    
    [UIView animateWithDuration:VIEWANIMATIONDURATION animations:^{
        [self.view layoutIfNeeded];
        [self.listScrollView setContentOffset:CGPointMake(index * SCREEN_FRAME.size.width, 0)];
    }];
    
}

//////////////////////////////
#pragma mark - protocol Methods
//////////////////////////////////////////

#pragma mark - UIScrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.listScrollView])
    {
        
        NSInteger index = (NSInteger)scrollView.contentOffset.x / SCREEN_FRAME.size.width;
        UIButton *sender = [self.titleTabMutableArray objectAtIndex:index];
        for (UIButton *btn in self.titleTabMutableArray)
        {
            if ([btn isEqual:sender])
            {
                [btn setTitleColor:JFZ_COLOR_SELECTED forState:UIControlStateNormal];
            }
            else
            {
                [btn setTitleColor:JFZ_COLOR_UNSELECTED forState:UIControlStateNormal];
            }
        }
        
        __weak UIButton *weakButton = sender;
        __weak UIScrollView *weakScrollView = _titleContainerScrollView;
        [self.cursorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakButton.mas_centerX);
            make.bottom.mas_equalTo(weakButton.mas_bottom).offset(1.5);
            make.width.equalTo(weakScrollView.mas_width).multipliedBy(0.25);
            make.height.mas_equalTo(2);
        }];
        
        [UIView animateWithDuration:0.3f animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

///////////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

- (UIView *)cursorView
{
    if (!_cursorView)
    {
        _cursorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width / 4, 2)];
        _cursorView.backgroundColor = JFZ_COLOR_SELECTED;
    }
    return _cursorView;
}

- (NSArray *)titleArray
{
    if (!_titleArray)
    {
        _titleArray = [[NSArray alloc] initWithObjects:@"日进斗金", @"年年有余", nil];
    }
    return _titleArray;
}

- (NSMutableArray *)titleTabMutableArray
{
    if (!_titleTabMutableArray)
    {
        _titleTabMutableArray = [[NSMutableArray alloc] init];
    }
    return _titleTabMutableArray;
}

- (NSArray *)listCtrlArray
{
    if (!_listCtrlArray)
    {
        _listCtrlArray = [[NSArray alloc] initWithObjects:@"SPShortTermProductListViewController", @"SPLongTermProductListViewController",nil];
    }
    return _listCtrlArray;
}

- (NSMutableArray *)listContentMutableArray
{
    if (!_listContentMutableArray)
    {
        _listContentMutableArray = [[NSMutableArray alloc] init];
    }
    return _listContentMutableArray;
}


@end
