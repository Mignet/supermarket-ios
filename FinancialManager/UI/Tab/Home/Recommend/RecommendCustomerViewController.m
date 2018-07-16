//
//  RecommendCustomerViewController.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/14.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "RecommendCustomerViewController.h"

#import "RecommendMemberCell.h"
#import "RecommendHeaderView.h"
#import "XNRedPacketEmptyCell.h"

#import "XNCSMyCustomerItemMode.h"

#import "ChineseString.h"
#import "JFZDataBase.h"

#import "SignCalendarModule.h"


#define CustomerHeader_height 30.f
#define CustomerCell_height 72.f

@interface RecommendCustomerViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>


@property (nonatomic, strong) NSMutableArray *customerArr;
@property (nonatomic, strong) NSArray *nameSortIndexArray;
@property (nonatomic, strong) NSMutableArray *cellStatusArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIView *numView;

@end

@implementation RecommendCustomerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

- (void)dealloc
{
    [[SignCalendarModule defaultModule] removeObserver:self];
}

//////////////////////////
#pragma mark - custom method
//////////////////////////////

- (void)initView
{
    [[SignCalendarModule defaultModule] addObserver:self];
    
    self.navigationItem.title = @"我的客户";
    [self.navigationItem addRightBarItemWithTitle:@"全选" titleColor:[UIColor whiteColor] target:self action:@selector(allAction)];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommendMemberCell" bundle:nil] forCellReuseIdentifier:@"RecommendMemberCell"];
    self.tableView.sectionIndexColor = UIColorFromHex(0x4F5960);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XNRedPacketEmptyCell class]) bundle:nil] forCellReuseIdentifier:@"XNRedPacketEmptyCell"];
    
    //设置输入框背景颜色
    UIImage* searchBarBg = [self GetImageWithColor:UIColorFromHex(0xeff0f1) andHeight:50.f];
    
    UITextField * searchField = [self.searchBar valueForKey:@"_searchField"];
    searchField.font = [UIFont systemFontOfSize:15.f];
    [searchField setValue:[UIFont systemFontOfSize:15.f] forKeyPath:@"_placeholderLabel.font"];
    
    [searchField setValue:UIColorFromHex(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.searchBar setBackgroundImage:searchBarBg];

    //开始加载
    [self loadCustomerData];
}

/**
 *  生成图片
 *
 *  @param color  图片颜色
 *  @param height 图片高度
 *
 *  @return 生成的图片
 */
- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

// 全选
- (void)allAction
{
    [self.view endEditing:YES];
    
    if (self.customerArr.count == 0) {
        return;
    }
    
    [self.navigationItem addRightBarItemWithTitle:@"取消" titleColor:[UIColor whiteColor] target:self action:@selector(cancelAction)];
    
    [self.selectedArray removeAllObjects];
    [self.cellStatusArray removeAllObjects];
    
    for (NSArray *arr in self.customerArr) {
        NSMutableArray *upArr = [NSMutableArray arrayWithCapacity:0];
        for (XNCSMyCustomerItemMode *itemModel in arr) {
            
            [self.selectedArray addObject:itemModel];
            [upArr addObject:@"1"];
        }
        [self.cellStatusArray addObject:upArr];
    }
    
    [self.tableView reloadData];
    
    self.numLabel.text = [NSString stringWithFormat:@"确定（%@）",[NSNumber numberWithInteger:self.selectedArray.count]];
    if (self.selectedArray.count > 0) {
        self.numView.backgroundColor = UIColorFromHex(0x4E8CEF);
    } else {
        self.numView.backgroundColor = UIColorFromHex(0x999999);
    }
}

// 取消全选
- (void)cancelAction
{
    [self.view endEditing:YES];
    
    if (self.customerArr.count == 0) {
        return;
    }
    
    [self.navigationItem addRightBarItemWithTitle:@"全选" titleColor:[UIColor whiteColor] target:self action:@selector(allAction)];
    
    [self.selectedArray removeAllObjects];
    [self.cellStatusArray removeAllObjects];
    
    for (NSArray *arr in self.customerArr) {
        NSMutableArray *upArr = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i = 0; i < arr.count; i ++) {
            [upArr addObject:@"0"];
        }
        [self.cellStatusArray addObject:upArr];
    }
    [self.tableView reloadData];
    
    self.numLabel.text = [NSString stringWithFormat:@"确定（%@）",[NSNumber numberWithInteger:self.selectedArray.count]];
    if (self.selectedArray.count > 0) {
        self.numView.backgroundColor = UIColorFromHex(0x4E8CEF);
    } else {
        self.numView.backgroundColor = UIColorFromHex(0x999999);
    }
}

// 推荐
- (IBAction)sureClick
{
    if (self.selectedArray.count <= 0) {
        //[self showCustomWarnViewWithContent:@"请选择要推荐的理财师"];
        return;
    }
    
    NSString *userId = [NSString string];
    for (NSInteger i = 0; i < self.selectedArray.count; i ++) {
        XNCSMyCustomerItemMode *itemModel = self.selectedArray[i];
        if (i == 0) {
            userId = [userId stringByAppendingString:itemModel.customerId];
        } else {
            userId = [userId stringByAppendingString:[NSString stringWithFormat:@",%@", itemModel.customerId]];
        }
    }
    
    [[SignCalendarModule defaultModule] recommendWithProductOrgId:self.productOrgId userIdString:userId withType:@"2" IdType:self.IdType];
}

#pragma mark - 开始排序
- (void)loadCustomerData
{
    NSString * sql = @"select * from CustomerList";
    
    weakSelf(weakSelf)
    [[JFZDataBase shareDataBaseWithDBName:@"FinancialManagerDb"] getDataFromDataBaseWithSQL:sql success:^(id result, FMDatabase *db) {
        
        NSMutableArray * customerNameArray = [NSMutableArray array];
        NSMutableArray * customArray = [NSMutableArray array];
        
        for (NSDictionary * dic in result) {
            [customerNameArray addObject:[dic objectForKey:@"userName"]];
            [customArray addObject:dic];
        }
        
        [weakSelf sortCustomerDataWithCustomerNameArray:customerNameArray customerArray:customArray];
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark - 排序并初始化
- (void)sortCustomerDataWithCustomerNameArray:(NSArray *)customerNmArray customerArray:(NSArray *)customerAlianArray
{
    //从数据库中获取到客户数据
    NSMutableArray * customArray = [NSMutableArray arrayWithArray:customerAlianArray];
    NSMutableArray * customerNameArray = [NSMutableArray arrayWithArray:customerNmArray];
    NSArray        * sortNameArray = [NSArray array];
    
    //开始排序显示
    self.nameSortIndexArray = [ChineseString IndexArray:customerNameArray];
    sortNameArray = [ChineseString LetterSortArray:customerNameArray];
    
    NSMutableArray * customerCateArray = nil;
    NSMutableArray * upArr = nil;
    
    XNCSMyCustomerItemMode * mode = nil;
    NSInteger reuserId = 0;
    
    [self.customerArr removeAllObjects];
    [self.cellStatusArray removeAllObjects];
    
    NSInteger objIndex = 0;
    for (NSInteger index = 0; index < sortNameArray.count; index ++) {
        
        customerCateArray = [NSMutableArray array];
        upArr = [NSMutableArray arrayWithCapacity:0];
        
        for (NSInteger subIndex = 0 ; subIndex < [[sortNameArray objectAtIndex:index] count]; subIndex ++) {
            
            reuserId = 0;
            while (reuserId < customArray.count) {
                
                if ([[[customArray objectAtIndex:reuserId] objectForKey:@"userName"] isEqualToString:[[sortNameArray objectAtIndex:index] objectAtIndex:subIndex]]) {
                    
                    mode = [XNCSMyCustomerItemMode initMyCustomerWithObject:[customArray objectAtIndex:reuserId]];
                    
                    objIndex = [customArray indexOfObject:[customArray objectAtIndex:reuserId]];
                    [customArray removeObjectAtIndex:objIndex];
                    
                    [customerCateArray addObject:mode];
                    [upArr addObject:@"0"];
                    
                    break;
                }
                reuserId ++;
            }
        }
        
        [self.customerArr addObject:customerCateArray];
        [self.cellStatusArray addObject:upArr];
    }
    
    [self.tableView reloadData];
}

////////////////////////////
#pragma mark - protocol method
//////////////////////////////////

#pragma makr - UITableViewDataSource
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.customerArr.count == 0 ? 1 : self.customerArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.customerArr.count == 0 ? 1 : [[self.customerArr objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.customerArr.count == 0) {
        XNRedPacketEmptyCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:@"XNRedPacketEmptyCell"];
        [emptyCell showTitle:@"当前没有我的客户" subTitle:nil];
        return emptyCell;
    }
    
    RecommendMemberCell *customerCell = [tableView dequeueReusableCellWithIdentifier:@"RecommendMemberCell"];
    
    if (indexPath.section < self.customerArr.count) {
        
        NSArray *groupArr = [self.customerArr objectAtIndex:indexPath.section];
        
        if (indexPath.row < groupArr.count) {
            customerCell.customerItem = [groupArr objectAtIndex:indexPath.row];
        }
    }
    
   

    [customerCell updateStatus:NO];
    if ([[[self.cellStatusArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] boolValue]) {
        [customerCell updateStatus:YES];
    }
    
    return customerCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.customerArr.count == 0 ? (SCREEN_FRAME.size.height - 100.f - 64 - 49) : CustomerCell_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CustomerHeader_height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.customerArr.count == 0) {
        return [[UIView alloc] init];
    }
    
    RecommendHeaderView *headerView = [RecommendHeaderView recommendHeaderView];
    [headerView setTitle:[self.nameSortIndexArray objectAtIndex:section]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    if (self.customerArr.count == 0) {
        return;
    }
    
    RecommendMemberCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    XNCSMyCustomerItemMode *itemModel = [[self.customerArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if ([[[self.cellStatusArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] boolValue])
    {
        [[self.cellStatusArray objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:@"0"];
        [cell updateStatus:NO];
        
        [self.selectedArray removeObject:itemModel];
    }
    else
    {
        [[self.cellStatusArray objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:@"1"];
        [cell updateStatus:YES];
        [self.selectedArray addObject:itemModel];
    }
    
    self.numLabel.text = [NSString stringWithFormat:@"确定（%@）",[NSNumber numberWithInteger:self.selectedArray.count]];
    if (self.selectedArray.count > 0) {
        self.numView.backgroundColor = UIColorFromHex(0x4E8CEF);
    } else {
        self.numView.backgroundColor = UIColorFromHex(0x999999);
    }
}

#pragma mark - 搜索框 协议方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *customerName = [NSString stringWithFormat:@"%@%%", searchText];
    NSString *customerMobile = [NSString stringWithFormat:@"%@%%", searchText];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM CustomerList WHERE userName LIKE '%@' or mobile LIKE '%@'", customerName, customerMobile]; // customerMobile  or mobile LIKE '%@'

    // Mobile
    weakSelf(weakSelf)
    [[JFZDataBase shareDataBaseWithDBName:@"FinancialManagerDb"] getDataFromDataBaseWithSQL:sql success:^(id result, FMDatabase *db) {
        
        NSMutableArray * customerNameArray = [NSMutableArray array];
        NSMutableArray * customArray = [NSMutableArray array];
        
        for (NSDictionary * dic in result) {
            [customerNameArray addObject:[dic objectForKey:@"userName"]];
            [customArray addObject:dic];
        }
        [weakSelf sortCustomerDataWithCustomerNameArray:customerNameArray customerArray:customArray];
    } failed:^(NSError *error) {
        
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

//右边索引 字节数(如果不实现 就不显示右侧索引)
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.nameSortIndexArray;
}

// 网络请求回调
- (void)recommendMemberDidReceive:(SignCalendarModule *)module
{
    [self.view hideLoading];
    if (self.selectedArray.count > 0)
    {
        NSString *msg = [NSString string];
        if ([self.IdType isEqualToString:@"2"]) {
            msg = @"平台已成功推荐给客户";
        } else {
            msg = @"产品已成功推荐给客户";
        }
        
        [self showCustomWarnViewWithContent:@"推荐成功" Completed:^{
            [_UI popViewControllerFromRoot:YES];
        }];
    }
    else
    {
        [_UI popViewControllerFromRoot:YES];
    }
}

- (void)recommendMemberDidFailed:(SignCalendarModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic)
    {
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

//////////////////////////
#pragma mark - setter / getter
//////////////////////////////

- (NSMutableArray *)customerArr
{
    if (!_customerArr) {
        _customerArr = [NSMutableArray arrayWithCapacity:0];
    }

    return _customerArr;
}

- (NSArray *)nameSortIndexArray
{
    if (!_nameSortIndexArray) {
        _nameSortIndexArray = [NSArray array];
    }
    return _nameSortIndexArray;
}

- (NSMutableArray *)cellStatusArray
{
    if (!_cellStatusArray) {
        _cellStatusArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _cellStatusArray;
}

- (NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectedArray;
}


@end
