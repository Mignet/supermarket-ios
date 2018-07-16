//
//  DropDownListViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/7/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "DropDownListView.h"
#import "DropDownListCell.h"

@interface DropDownListView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *backgroundButton;

@property (nonatomic, strong) NSMutableArray *datasArray;
@property (nonatomic, assign) NSInteger nType;
@property (nonatomic, assign) BOOL isPreSelected;
@property (nonatomic, assign) BOOL isCurSelected;
@property (nonatomic, strong) NSIndexPath *preIndexPath;
@property (nonatomic, strong) NSString *selectedString;

@end

@implementation DropDownListView

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initView];
    }
    return self;
}


//////////////////////////////
#pragma mark - Custom Methods
//////////////////////////////////////////

- (void)show:(NSMutableArray *)dataArray type:(NSInteger)nType selectedString:(NSString *)selectString
{
    if (_nType == nType)
    {
        _nType = 0;
        [self hide];
        return;
    }
    _nType = nType;
    [self.datasArray removeAllObjects];
    [self.datasArray addObject:@"全部"];
    for (NSDictionary *dic in dataArray)
    {
        [self.datasArray addObject:[dic valueForKey:@"key"]];
    }
    
    _preIndexPath = nil;
    _selectedString = selectString;
    
    float fHeight;
    if (self.datasArray.count >= 7)
    {
        fHeight = 38 * 7;
    }
    else
    {
        fHeight = 38 * self.datasArray.count;
    }
    self.hidden = NO;
    
    __block UITableView *weakTabelView = self.tableView;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakTabelView.frame = CGRectMake(0, 0, SCREEN_FRAME.size.width, fHeight);
    } completion:nil];
    
    [self.tableView reloadData];
    
}

- (void)hide
{
    __block UITableView *weakTabelView = self.tableView;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakTabelView.frame = CGRectMake(0, 0, SCREEN_FRAME.size.width, 0);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        _nType = 0;
    }];
    
}

#pragma mark - 初始化
- (void)initView
{
    _isCurSelected = YES;
    _isPreSelected = NO;
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    _backgroundButton = [[UIButton alloc] init];
    [_backgroundButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[UITableView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self addSubview:_backgroundButton];
    [self addSubview:_tableView];
    
    weakSelf(weakSelf)
    [_backgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
    }];
    
    [_tableView registerNib:[UINib nibWithNibName:@"DropDownListCell" bundle:nil] forCellReuseIdentifier:@"DropDownListCell"];
}

//////////////////////////////
#pragma mark - protocol Methods
//////////////////////////////////////////

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     if (self.datasArray.count <= 0)
     {
         return 1;
     }
     return self.datasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = [indexPath row];
    static NSString *cellIdentifierString = @"DropDownListCell";
    DropDownListCell *cell = (DropDownListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
    if (cell == nil)
    {
        cell = [[DropDownListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifierString];
    }
    
    [cell showDatas:[self.datasArray objectAtIndex:nRow]];
    
    if ([_selectedString isEqual:[self.datasArray objectAtIndex:nRow]])
    {
        _preIndexPath = indexPath;
        [cell selected:YES];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger nRow = [indexPath row];
    DropDownListCell *curCell = (DropDownListCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (![_preIndexPath isEqual:indexPath])
    {
        DropDownListCell *preCell = (DropDownListCell *)[tableView cellForRowAtIndexPath:_preIndexPath];
        [preCell selected:_isPreSelected];
        [curCell selected:_isCurSelected];
        
    }
    else
    {
        [curCell selected:_isCurSelected];
    }
    
    if (nRow == 0)
    {
        _selectedString = @"";
    }
    else
    {
       _selectedString = [self.datasArray objectAtIndex:nRow];
    }
    
    _preIndexPath = indexPath;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedString:type:)])
    {
        [self.delegate selectedString:_selectedString type:_nType];
    }
    
    [self hide];
}


///////////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

#pragma mark - NSMutableArray
- (NSMutableArray *)datasArray
{
    if (_datasArray == nil)
    {
        _datasArray = [NSMutableArray array];
    }
    return _datasArray;
}


@end
