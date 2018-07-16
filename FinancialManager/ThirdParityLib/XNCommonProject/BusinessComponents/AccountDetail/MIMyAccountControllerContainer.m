//
//  DispatchRedPacketContainerViewController.m
//  FinancialManager
//
//  Created by xnkj on 6/20/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "MIMyAccountControllerContainer.h"
#import "MIMyAccountController.h"

#import "XNMyAccountDetailType.h"
#import "XNAccountModule.h"

#import "ScrollViewExitView.h"

#define DEFAULTTAG 0x111111
#define DEFAULTTITLEHEIGHT 50.0f
#define NEWWIDTH (SCREEN_FRAME.size.width / self.titleArray.count)
#define DEFAULTTITLEWIDTH (self.titleArray.count>=4?80 * (SCREEN_FRAME.size.width / 320):NEWWIDTH)

@interface MIMyAccountControllerContainer ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSString            * profitType;
@property (nonatomic, strong) NSString            * timeType;
@property (nonatomic, strong) NSString            * time;
@property (nonatomic, assign) NSInteger           selectedIndex;
@property (nonatomic, strong) NSMutableArray      * titleArray;
@property (nonatomic, strong) NSMutableArray      * titleLengthArray;
@property (nonatomic, strong) NSMutableArray      * contentCtrlArray;
@property (nonatomic, strong) NSMutableArray      * titleObjArray;

@property (nonatomic, strong) ScrollViewExitView  * scrollExitView;

@property (nonatomic, strong) UIView              * cursorView;
@property (nonatomic, strong) UIView              * screenEdgePanGestureView;

@property (nonatomic, weak) IBOutlet UIScrollView * titleContainerScrollView;
@property (nonatomic, weak) IBOutlet UIScrollView * headContainerScrollView;
@property (nonatomic, weak) IBOutlet UIScrollView * contentContainerScrollView;
@end

@implementation MIMyAccountControllerContainer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////
#pragma mark - Custom Method
//////////////////////////////////////

#pragma mark - 初始化
- (void)initView
{
    self.title = @"账户明细";
    self.selectedIndex = 0;
    [self.scrollExitView scrollView:self.contentContainerScrollView didLeftScrollNavigationController:self.navigationController];
    
    [self buildView];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 构建视图
- (void)buildView
{
    [self.headContainerScrollView addSubview:self.cursorView];
    [self.titleContainerScrollView setContentSize:CGSizeMake(DEFAULTTITLEWIDTH * self.titleArray.count, 0)];
    
    weakSelf(weakSelf)
    //构建title
    UIButton * titleButton = nil;
    UIButton * lastTitleButton = nil;
    for (NSInteger i = 0; i < self.titleArray.count; i++ ) {
        
        titleButton = [[UIButton alloc]initWithFrame:CGRectMake(i *  DEFAULTTITLEWIDTH, 0, DEFAULTTITLEWIDTH, DEFAULTTITLEHEIGHT)];
        [titleButton setTag:i+DEFAULTTAG];
        [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
        [titleButton.titleLabel setFont:i==self.selectedIndex?[UIFont systemFontOfSize:14]:[UIFont systemFontOfSize:12]];
        [titleButton setTitle:[self.titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [titleButton setTitleColor:i==self.selectedIndex?UIColorFromHex(0x323232):UIColorFromHex(0xb0b0b0) forState:UIControlStateNormal];
        [titleButton addTarget:self action:@selector(selectedOption:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleContainerScrollView addSubview:titleButton];
        [self.titleObjArray addObject:titleButton];
        
        __weak UIScrollView * tmpTitleScrollView = self.titleContainerScrollView;
        __weak UIButton     * tmpLastButton = lastTitleButton;
        [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (i == 0)
            {
                make.leading.mas_equalTo(tmpTitleScrollView.mas_leading);
            }else if(i == [weakSelf.titleArray  count] - 1)
            {
                make.leading.mas_equalTo(tmpLastButton.mas_trailing);
                make.trailing.mas_equalTo(tmpTitleScrollView.mas_trailing);
            }else
            {
                make.leading.mas_equalTo(tmpLastButton.mas_trailing);
            }
            
            make.top.mas_equalTo(tmpTitleScrollView.mas_top);
            make.bottom.mas_equalTo(tmpTitleScrollView.mas_bottom);
            make.width.mas_equalTo([self.titleLengthArray objectAtIndex:i]);
        }];
        lastTitleButton = titleButton;
        
        if (i == self.selectedIndex) {
            
            tmpLastButton = lastTitleButton;
            __weak UIScrollView * tmpScrollView = self.headContainerScrollView;
            [self.cursorView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.mas_equalTo(tmpLastButton.mas_centerX);
                make.bottom.mas_equalTo(tmpScrollView.mas_bottom);
                make.width.mas_equalTo(DEFAULTTITLEWIDTH * 0.8);
                make.height.mas_equalTo(@(2));
            }];
        }

    }
    
    //构建内容视图
    UIViewController * lastCtrl = nil;
    for (NSInteger i = 0 ; i < self.contentCtrlArray.count ; i ++ ) {
        
        UIViewController * ctrl = [self.contentCtrlArray objectAtIndex:i];
        ctrl.view.frame = CGRectMake(i * SCREEN_FRAME.size.width , 0, SCREEN_FRAME.size.width, self.contentContainerScrollView.frame.size.height);
        [self.contentContainerScrollView addSubview:ctrl.view];
        [self addChildViewController:ctrl];
        
        __weak UIViewController * tmpLastCtrl = lastCtrl;
        __weak UIScrollView     * tmpCtrlContainerScrollView = self.contentContainerScrollView;
        [ctrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (i == 0)
                make.leading.mas_equalTo(tmpCtrlContainerScrollView.mas_leading);
            else if(i == weakSelf.contentCtrlArray.count - 1)
            {
                make.leading.mas_equalTo(tmpLastCtrl.view.mas_trailing);
                make.trailing.mas_equalTo(tmpCtrlContainerScrollView.mas_trailing);
            }
            else
                make.leading.mas_equalTo(tmpLastCtrl.view.mas_trailing);
            
            make.top.mas_equalTo(tmpCtrlContainerScrollView.mas_top);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.equalTo(tmpCtrlContainerScrollView);
            make.bottom.mas_equalTo(tmpCtrlContainerScrollView.mas_bottom);
        }];
        lastCtrl = ctrl;
    }
    
    //默认跳转到指定的位置
    [self.contentContainerScrollView setContentOffset:CGPointMake(SCREEN_FRAME.size.width * self.selectedIndex, 0)];
    
    [self.view layoutIfNeeded];
}

#pragma mark - 选中操作
- (void)selectedOption:(UIButton *)sender
{
    for (UIButton * titleButton in self.titleObjArray) {
        
        if ([titleButton isEqual:sender]) {
            
            [titleButton setTitleColor:UIColorFromHex(0x323232) forState:UIControlStateNormal];
            [titleButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        }else
        {
            [titleButton setTitleColor:UIColorFromHex(0xb0b0b0) forState:UIControlStateNormal];
            [titleButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        }

    }
    
    NSInteger index = [self.titleObjArray indexOfObject:sender];
    
    __weak UIScrollView * tmpScrollView = self.headContainerScrollView;
    __weak UIButton * titleButtonTmp = sender;
    [self.cursorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(titleButtonTmp.mas_centerX);
        make.bottom.mas_equalTo(tmpScrollView.mas_bottom);
        make.width.mas_equalTo(DEFAULTTITLEWIDTH * 0.8);
        make.height.mas_equalTo(@(2));
    }];
    
    [UIView animateWithDuration:VIEWANIMATIONDURATION animations:^{
    
        [self.view layoutIfNeeded];
        [self.contentContainerScrollView setContentOffset:CGPointMake(index*SCREEN_FRAME.size.width, 0)];
        [self.titleContainerScrollView setContentOffset:CGPointMake((sender.frame.origin.x - SCREEN_FRAME.size.width + [[self.titleLengthArray objectAtIndex:index] integerValue]) > 0?(sender.frame.origin.x - SCREEN_FRAME.size.width + [[self.titleLengthArray objectAtIndex:index] integerValue]) : 0,0)];

    }];
}

///////////////////
#pragma mark - protocol
//////////////////////////////////////

#pragma mark - uiscrollview
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.scrollExitView scrollViewDidScrollViewOffSet:scrollView.contentOffset];
    
    if ([scrollView isEqual:self.contentContainerScrollView]) {
        
        NSInteger index = (int)scrollView.contentOffset.x / SCREEN_FRAME.size.width;
        
        UIButton * sender = [self.titleObjArray objectAtIndex:index];
        for (UIButton * titleButton in self.titleObjArray) {
            
            if ([titleButton isEqual:sender]) {
                
                [titleButton setTitleColor:UIColorFromHex(0x323232) forState:UIControlStateNormal];
                [titleButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
            }else
            {
                [titleButton setTitleColor:UIColorFromHex(0xb0b0b0) forState:UIControlStateNormal];
                [titleButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
            }
        }
        
        [self.view layoutIfNeeded];
        
        __weak UIScrollView * tmpScrollView = self.headContainerScrollView;
        __weak UIButton * btnTmp = sender;
        [self.cursorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(btnTmp.mas_centerX);
            make.bottom.mas_equalTo(tmpScrollView.mas_bottom);
            make.width.mas_equalTo(DEFAULTTITLEWIDTH * 0.8);
            make.height.mas_equalTo(@(2));
        }];
        
        [UIView animateWithDuration:VIEWANIMATIONDURATION animations:^{
        
            [self.titleContainerScrollView setContentOffset:CGPointMake((btnTmp.frame.origin.x - SCREEN_FRAME.size.width + [[self.titleLengthArray objectAtIndex:index] integerValue]) > 0?(btnTmp.frame.origin.x - SCREEN_FRAME.size.width + [[self.titleLengthArray objectAtIndex:index] integerValue]) : 0,0)];

            [self.view layoutIfNeeded];
        }];
    }
}

///////////////////
#pragma mark - setter/getter
//////////////////////////////////////

#pragma mark - titleArray
- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        
        _titleArray = [[NSMutableArray alloc]init];
        
        MIMyAccountController * ctrl = nil;
        for (XNMyAccountDetailType * obj in [[XNAccountModule defaultModule] myAccountDetailTypeArray]) {
            
            ctrl = [[MIMyAccountController alloc] initWithNibName:@"MIMyAccountController" bundle:nil];
            [self.contentCtrlArray addObject:ctrl];
            
            [_titleArray addObject:obj.typeName];
            
            [self.titleLengthArray addObject:[NSNumber numberWithInteger:([obj.typeName sizeWithStringFont:14 InRect:CGSizeMake(200, DEFAULTTITLEHEIGHT)].width + 20)]];
        }
    }
    return _titleArray;
}

#pragma mark - titleLengthArray
- (NSMutableArray *)titleLengthArray
{
    if (!_titleLengthArray) {
        
        _titleLengthArray = [[NSMutableArray alloc]init];
    }
    return _titleLengthArray;
}

#pragma mark - titleObjArray
- (NSMutableArray *)titleObjArray
{
    if (!_titleObjArray) {
        
        _titleObjArray = [[NSMutableArray alloc]init];
    }
    return _titleObjArray;
}

#pragma mark - contentCtrlArray
- (NSArray *)contentCtrlArray
{
    if (!_contentCtrlArray) {
        
        _contentCtrlArray = [[NSMutableArray alloc]init];
    }
    return _contentCtrlArray;
}

#pragma mark -cursorView
- (UIView *)cursorView
{
    if (!_cursorView) {
        
        _cursorView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, SCREEN_FRAME.size.width / 4, 2)];
        [_cursorView setBackgroundColor:MONEYCOLOR];
    }
    return _cursorView;
}

#pragma mark - scrollExitView
- (ScrollViewExitView *)scrollExitView
{
    if (!_scrollExitView) {
        
        _scrollExitView = [[ScrollViewExitView alloc] init];
    }
    return _scrollExitView;
}
@end
