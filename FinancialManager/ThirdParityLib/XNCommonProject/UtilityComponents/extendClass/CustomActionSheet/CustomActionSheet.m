//
//  CustomActionSheet.m
//  FinancialManager
//
//  Created by ancye.Xie on 11/25/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "CustomActionSheet.h"
#import "CustomActionSheetCell.h"

#define CELL_DEFAULT_HEIGHT (((35.0 * SCREEN_FRAME.size.width) / 375) + 10)


@interface CustomActionSheet ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *listArray;


@end

@implementation CustomActionSheet

- (id)initWithTitle:(NSString *)title list:(NSArray *)array
{
    self = [super init];
    if (self)
    {
        self.title = title;
        self.listArray = array;
        [self initView];
    }
    return self;
}


- (void)initView
{
    self.frame = CGRectMake(0, 0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width - 50, 45)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(headerView.frame) - 24, 10, 14, 14)];
    imageView.image = [UIImage imageNamed:@"XN_LieCai_Cfg_Level_Calc_Close_icon"];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(headerView.frame) - 54, 0, 54, 54)];
    [button addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, CGRectGetWidth(headerView.frame), 16)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = UIColorFromHex(0x3e4446);
    label.text = self.title;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(headerView.frame), CGRectGetWidth(headerView.frame), CELL_DEFAULT_HEIGHT * self.listArray.count) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(25, (SCREEN_FRAME.size.height - CGRectGetHeight(_tableView.frame) - 120) / 2, SCREEN_FRAME.size.width - 50, CGRectGetHeight(_tableView.frame) + 55 + 5)];
    _mainView.backgroundColor = [UIColor whiteColor];
    _mainView.layer.masksToBounds = YES;
    _mainView.layer.cornerRadius = 10;
    
    [self addSubview:_mainView];
    [_mainView addSubview:headerView];
    [headerView addSubview:imageView];
    [headerView addSubview:button];
    [headerView addSubview:label];
    [_mainView addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"CustomActionSheetCell" bundle:nil] forCellReuseIdentifier:@"CustomActionSheetCell"];
    
}

#pragma mark - 取消操作
- (void)cancelClick
{
    __weak UIView *weakMainView = _mainView;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        CGRect originRect = weakMainView.frame;
        originRect.origin.y = SCREEN_FRAME.size.height;
        weakMainView.frame = originRect;
    } completion:^(BOOL finished) {
        if (finished)
        {
            for (UIView *view in weakMainView.subviews)
            {
                [view removeFromSuperview];
            }
            [weakMainView removeFromSuperview];
        }
    }];
}

#pragma mark - 展示区域
- (void)showInView:(UIViewController *)controller
{
    if (controller)
    {
        [controller.view addSubview:self];
    }
    else
    {
        [_KEYWINDOW addSubview:self];
    }
//    [self showCancelAnimate];
}

#pragma mark - 点击空白地方，消失的动画
- (void)showCancelAnimate
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    self.userInteractionEnabled = YES;
    
    weakSelf(weakSelf)
    __weak UIView *weakMainView = _mainView;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        CGRect originRect = weakMainView.frame;
        originRect.origin.y = SCREEN_FRAME.size.height - CGRectGetHeight(weakMainView.frame);
        weakMainView.frame = originRect;
    } completion:^(BOOL finished) {
        
    }];
}


///////////////////////
#pragma mark - @protocol
//////////////////////////////////////////

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //点击事件是否在uiview上还是在uitableview上
    if([touch.view isKindOfClass:[self class]])
    {
        return YES;
    }
    return NO;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_DEFAULT_HEIGHT;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = [indexPath row];
    static NSString *cellIdentifier = @"CustomActionSheetCell";
    CustomActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[CustomActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell showDatas:[self.listArray objectAtIndex:nRow]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self cancelClick];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectIndex:)])
    {
        [self.delegate didSelectIndex:indexPath.row];
    }
}

///////////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

- (NSArray *)listArray
{
    if (!_listArray)
    {
        _listArray = [NSArray array];
    }
    return _listArray;
}

@end
