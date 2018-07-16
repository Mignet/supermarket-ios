//
//  MIAccountBalanceDetailListViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 2/14/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MIAccountBalanceDetailListViewController.h"
#import "MFSystemInvitedEmptyCell.h"
#import "MIMonthIncomeOtherDetailCell.h"

#import "MIAccountBalanceCommonMode.h"
#import "MIAccountBalanceDetailItemMode.h"

#define HEADER_CELL_HEIGHT (60.0f + 94.0f + 12.0f + 35.0f)
#define CELL_DEFAULT_HEIGHT 75.0f

@interface MIAccountBalanceDetailListViewController ()<MIMonthIncomeOtherDetailCellDelegate>

@property (nonatomic, copy) NSString *type; //收支类型(0=全部1=收入|2=支出)

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArray;

@end

@implementation MIAccountBalanceDetailListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(NSString *)type
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _type = type;
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
    [self.tableView registerNib:[UINib nibWithNibName:@"MIMonthIncomeOtherDetailCell" bundle:nil] forCellReuseIdentifier:@"MIMonthIncomeOtherDetailCell"];
}

- (void)reloadList:(NSArray *)datasList monthProfitDetailListMode:(MIAccountBalanceCommonMode *)listMode;
{
    _type = listMode.type;
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
        
        switch ([_type integerValue]) {
            case TotalTag:
                msg = @"暂无收支记录，快去发展客户\n或理财师赚取收益吧";
                break;
            case IncomeTag:
                msg = @"暂无收入记录，快去发展客户\n或理财师赚取收益吧";
                break;
            case outTag:
                msg = @"暂无支出记录";
                break;
            default:
                break;
        }

        [cell refreshTitle:msg];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    static NSString *cellIdentifierString = @"MIMonthIncomeOtherDetailCell";
    MIMonthIncomeOtherDetailCell *cell = (MIMonthIncomeOtherDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
    if (cell == nil)
    {
        cell = [[MIMonthIncomeOtherDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifierString];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MIAccountBalanceDetailItemMode *mode = [self.datasArray objectAtIndex:nRow];
    
    float fLastSepViewHeight = 12.0f;
    if (self.datasArray.count * 87 + 10 < SCREEN_FRAME.size.height - HEADER_CELL_HEIGHT && nRow == self.datasArray.count - 1)
    {
        //计算字的高度
        CGFloat fHeight = [mode.remark getSpaceLabelHeightWithFont:12 withWidth:SCREEN_FRAME.size.width - 24 lineSpacing:5] + 5;
        fLastSepViewHeight = SCREEN_FRAME.size.height - HEADER_CELL_HEIGHT - (self.datasArray.count - 1) * 87 - CELL_DEFAULT_HEIGHT - fHeight + 12;
    }
    
    [cell showAccountBalanceDetailDatas:mode lastSepViewHeight:fLastSepViewHeight];
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datasArray.count < 1)
    {
        return SCREEN_FRAME.size.height - HEADER_CELL_HEIGHT - 64;
    }
    
    MIAccountBalanceDetailItemMode *mode = [self.datasArray objectAtIndex:[indexPath row]];
    //计算字的高度
    CGFloat fHeight = [mode.remark getSpaceLabelHeightWithFont:12 withWidth:SCREEN_FRAME.size.width - 24 lineSpacing:5] + 5;
    
    if (self.datasArray.count * 87 + 10 < SCREEN_FRAME.size.height - HEADER_CELL_HEIGHT && [indexPath row] == self.datasArray.count - 1)
    {
        float fLastHeight = SCREEN_FRAME.size.height - HEADER_CELL_HEIGHT - (self.datasArray.count - 1) * 87;
        return fLastHeight;
    }
    
    return CELL_DEFAULT_HEIGHT + fHeight;

}

#pragma mark - MIMonthIncomeOtherDetailCellDelegate
- (void)showExplain:(MIAccountBalanceDetailItemMode *)mode
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
