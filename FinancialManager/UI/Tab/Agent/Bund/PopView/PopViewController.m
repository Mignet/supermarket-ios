//
//  PopViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/18/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "PopViewController.h"
#import "PopCell.h"

@interface PopViewController ()

@property (nonatomic, strong) NSMutableArray *datasArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (nonatomic, assign) BOOL isShowLastDefaultCell;

@end

@implementation PopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil showLastCell:(BOOL)isShowLastCell
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.isShowLastDefaultCell = isShowLastCell;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"PopCell" bundle:nil] forCellReuseIdentifier:@"PopCell"];
}

- (void)updateDatas:(NSArray *)dataArray selectedArray:(NSArray *)selectedArray
{
    [self.selectedArray removeAllObjects];
    [self.selectedArray addObjectsFromArray:selectedArray];
    [self.datasArray removeAllObjects];
    [self.datasArray addObjectsFromArray:dataArray];
    if (self.isShowLastDefaultCell)
    {
        [self.datasArray addObject:@"筛选"];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.datasArray.count > 0)
    {
        return self.datasArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = indexPath.row;
    static NSString *cellIdentifierString = @"PopCell";
    PopCell *cell = (PopCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
    
    BOOL isSelected = NO;
    if ([self.selectedArray containsObject:[self.datasArray objectAtIndex:nRow]])
    {
        isSelected = YES;
    }
    
    if (self.datasArray.count > 0)
    {
        
        BOOL isShowLastCell = NO;
        if (self.isShowLastDefaultCell && nRow == self.datasArray.count - 1)
        {
            isShowLastCell = YES;
        }
        [cell showDatas:[self.datasArray objectAtIndex:nRow] selected:isSelected showLastDefaultCell:isShowLastCell];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = [indexPath row];
    NSString *title = [self.datasArray objectAtIndex:nRow];
    
    if (!self.isShowLastDefaultCell)
    {
        [self.selectedArray removeAllObjects];
        [self.selectedArray addObject:title];
        //筛选操作
        if (self.delegate && [self.delegate respondsToSelector:@selector(popViewControllerClick:)])
        {
            [self.delegate popViewControllerClick:self.selectedArray];
        }
        return;
    }
    
    if ([self.selectedArray containsObject:title])
    {
        [self.selectedArray removeObject:title];
    }
    else
    {
        [self.selectedArray addObject:title];
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    
    if (nRow == self.datasArray.count - 1)
    {
        //筛选操作
        if (self.delegate && [self.delegate respondsToSelector:@selector(popViewControllerClick:)])
        {
            [self.delegate popViewControllerClick:self.selectedArray];
        }
    }

}

////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

#pragma mark - datasArray
- (NSMutableArray *)datasArray
{
    if (!_datasArray)
    {
        _datasArray = [[NSMutableArray alloc] init];
    }
    return _datasArray;
}

- (NSMutableArray *)selectedArray
{
    if (!_selectedArray)
    {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    return _selectedArray;
}

@end
