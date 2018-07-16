//
//  MIMonthIncomeDetailListViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 11/24/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "MIMonthIncomeDetailListViewController.h"
#import "MFSystemInvitedEmptyCell.h"
#import "MIMonthIncomeDetailCell.h"
#import "MIMonthIncomeOtherDetailCell.h"

#import "MIAccountBalanceCommonMode.h"
#import "MIMonthProfixItemMode.h"

#define HEADER_CELL_HEIGHT (60.0f + 94.0f + 12.0f + 35.0f)
#define CELL_DEFAULT_HEIGHT 125.0f - 25.0f
@interface MIMonthIncomeDetailListViewController ()<MIMonthIncomeDetailCellDelegate>

@property (nonatomic, assign) NSInteger type; //收益类型（已发放／待发放）

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArray;

@end

@implementation MIMonthIncomeDetailListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil profitType:(NSInteger)profitType
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _type = profitType;

    }
    return self;
}

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"MFSystemInvitedEmptyCell" bundle:nil] forCellReuseIdentifier:@"MFSystemInvitedEmptyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MIMonthIncomeDetailCell" bundle:nil] forCellReuseIdentifier:@"MIMonthIncomeDetailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MIMonthIncomeOtherDetailCell" bundle:nil] forCellReuseIdentifier:@"MIMonthIncomeOtherDetailCell"];
}

- (void)reloadList:(NSArray *)datasList monthProfitDetailListMode:(MIAccountBalanceCommonMode *)listMode
{
    _type = [listMode.type integerValue];
    [self.datasArray removeAllObjects];
    [self.datasArray addObjectsFromArray:datasList];
    [self.tableView reloadData];
}

///////////////////
#pragma mark - protocol
//////////////////////////////////////

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
    if (self.datasArray.count <= 0)
    {
        MFSystemInvitedEmptyCell * cell = (MFSystemInvitedEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"MFSystemInvitedEmptyCell"];
        
        NSString *msg = @"";
        if (_type == 2)
        {
            msg = @"暂无已发放记录";
        }
        else
        {
            msg = @"暂无待发放记录";
        }
        [cell refreshTitle:msg];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    MIMonthProfixItemMode *mode = [self.datasArray objectAtIndex:nRow];
    //收益类型：1销售佣金，2推荐津贴，3活动奖励，4团队leader奖励,5投资返现红包
    if ([mode.profixType integerValue] == SaleCommissionType)
    {
        static NSString *cellIdentifierString = @"MIMonthIncomeDetailCell";
        MIMonthIncomeDetailCell *cell = (MIMonthIncomeDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
        if (cell == nil)
        {
            cell = [[MIMonthIncomeDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifierString];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell showDatas:mode];
        return cell;
    }
    
    static NSString *cellIdentifierString = @"MIMonthIncomeOtherDetailCell";
    MIMonthIncomeOtherDetailCell *cell = (MIMonthIncomeOtherDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
    if (cell == nil)
    {
        cell = [[MIMonthIncomeOtherDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifierString];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showDatas:mode];
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datasArray.count < 1)
    {
         return SCREEN_FRAME.size.height - HEADER_CELL_HEIGHT - 64;
    }
    
    MIMonthProfixItemMode *mode = [self.datasArray objectAtIndex:[indexPath row]];
    //计算字的高度
    CGFloat fHeight = [mode.desc getSpaceLabelHeightWithFont:12 withWidth:SCREEN_FRAME.size.width - 24 lineSpacing:5] + 5;
    
    if ([mode.profixType integerValue] == SaleCommissionType)
    {
        return CELL_DEFAULT_HEIGHT + fHeight;
    }

    return CELL_DEFAULT_HEIGHT - 25 + fHeight;
}

#pragma mark - MIMonthIncomeDetailCellDelegate
- (void)showExplain:(MIMonthProfixItemMode *)mode
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showExplain:)])
    {
        [self.delegate showExplain:mode];
    }
}

///////////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

#pragma mark - NSMutableArray
- (NSMutableArray *)datasArray
{
    if (!_datasArray)
    {
        _datasArray = [[NSMutableArray alloc] init];
    }
    return _datasArray;
}


@end
