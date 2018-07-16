//
//  MFProductRecommendListViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 10/12/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "MFProductRecommendListOtherViewController.h"
#import "UINavigationItem+Extension.h"
#import "ChineseString.h"
#import "MFProductRecommendCellHeader.h"

#import "ContactCell.h"
#import "XNFinancialProductModule.h"
#import "XNFinancialProductModuleObserver.h"
#import "XNRecommendListMode.h"
#import "XNFMProductListItemMode.h"
#import "XNFMAgentDetailMode.h"
#import "XNRecommendItemMode.h"

@interface MFProductRecommendListOtherViewController ()<XNFinancialProductModuleObserver>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak)IBOutlet UIView *recommondView;
@property (nonatomic, weak)IBOutlet UILabel *recommondLabel;
@property (nonatomic, weak) IBOutlet UITextField *searchTextField;
@property (nonatomic, weak)IBOutlet UILabel *descLabel;

@property (nonatomic, strong) UITapGestureRecognizer  *tapGesture;

@property (nonatomic, strong) NSMutableArray *customerArray;
@property (nonatomic, strong) NSMutableArray *sortIndexArray; //右边索引
@property (nonatomic, strong) NSMutableArray *sortLetterArray; //排序后的数组
@property (nonatomic, strong) NSMutableArray *cellStatusArray;
@property (nonatomic, strong) NSMutableArray *selectedNameArray; //被选中的数组

@property (nonatomic, strong) XNFMProductListItemMode *productMode;
@property (nonatomic, strong) XNFMAgentDetailMode *agentMode;
@property (nonatomic, assign) NSInteger nSelectTab;
@property (nonatomic, assign) BOOL isSearch; //是否搜索
@property (nonatomic, assign) BOOL isProductRecommend; //是否是产品推荐
@property (nonatomic, copy) NSString *descString;

@end

@implementation MFProductRecommendListOtherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil productListItemMode:(XNFMProductListItemMode *)mode agentDetailMode:(XNFMAgentDetailMode *)agentMode title:(NSString *)title desc:(NSString *)descString
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self.navigationItem addTitle:title target:self action:@selector(explainClick)];
        self.productMode = mode;
        self.agentMode = agentMode;
        if (self.productMode == nil)
        {
            self.isProductRecommend = NO;
        }
        else
        {
            self.isProductRecommend = YES;
        }
        _descString = descString;
        [[XNFinancialProductModule defaultModule] addObserver:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadDatas];
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

//加载数据
- (void)loadDatas
{
    //是推荐产品
    if (self.isProductRecommend)
    {
        [[XNFinancialProductModule defaultModule] fmRecommendProductWithProductId:self.productMode.productId searchValue:_searchTextField.text];
    }
    else
    {
        //机构推荐
        [[XNFinancialProductModule defaultModule] fmRecommendAgentWithAgentCode:self.agentMode.orgNo searchValue:_searchTextField.text];
    }
    
    //请求接口数据
    [self.view showGifLoading];
}

#pragma mark - 初始化
- (void)initView
{
    _descLabel.text = _descString;
    self.nSelectTab = 0;
    [self.navigationItem selectAllWithTarget:self title:@"全选" action:@selector(selectAllAction)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
    [self.tableView registerClass:[MFProductRecommendCellHeader class] forHeaderFooterViewReuseIdentifier:@"MFProductRecommendCellHeader"];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionIndexColor:UIColorFromHex(0x6c6e6d)];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
}

#pragma mark - 对获取到的数据进行排序
- (void)sortCustomerData
{
    [self.sortLetterArray removeAllObjects];
    [self.sortIndexArray removeAllObjects];
    if (!_isSearch)
    {
        [self.selectedNameArray removeAllObjects];
    }
    
    //对数据进行排序，并按首字母分类
    UILocalizedIndexedCollation  *collation = [UILocalizedIndexedCollation currentCollation];
    for (XNRecommendItemMode *mode in self.customerArray)
    {
        if (mode.userName.length < 1)
        {
            mode.userName = mode.mobile;
        }
        NSInteger section = [collation sectionForObject:mode collationStringSelector:@selector(userName)];
        mode.sectionNumber = section;
    }
    
    NSInteger highSection = [[collation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++)
    {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    //分组
    for (XNRecommendItemMode *mode in self.customerArray)
    {
        [(NSMutableArray *)[sectionArrays objectAtIndex:mode.sectionNumber] addObject:mode];
    }
    
    NSMutableArray *allArray = [[NSMutableArray alloc] init];
    for (NSMutableArray *sectionArray in sectionArrays)
    {
        NSArray *sortedSection = [collation sortedArrayFromArray:sectionArray collationStringSelector:@selector(userName)];
        [allArray addObject:sortedSection];
    }
    
    //只取有数据的Array
    for (NSMutableArray *sectionArray0 in allArray)
    {
        if (sectionArray0.count)
        {
            [self.sortLetterArray addObject:sectionArray0];
        }
    }
    
    //字母索引
    for (int i = 0; i < allArray.count; i++)
    {
        if ([[allArray objectAtIndex:i] count])
        {
            [self.sortIndexArray addObject:[[collation sectionTitles] objectAtIndex:i]];
        }
    }
    
    [self initStatusArray];
    //开始排序处理
    [self.tableView reloadData];
}

#pragma mark - 初始化状态数组
- (void)initStatusArray
{
    [self.cellStatusArray removeAllObjects];
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (id obj in self.sortLetterArray)
    {
        if ([obj isKindOfClass:[NSArray class]])
        {
            tmpArray = [NSMutableArray array];
            for (XNRecommendItemMode *mode in obj)
            {
                //未推荐
                if (mode.ifRecommend == 0)
                {
                    [tmpArray addObject:@"0"];
                }
                else
                {
                    [tmpArray addObject:@"1"];
                    if (!_isSearch)
                    {
                        [self.selectedNameArray addObject:mode];
                    }
                }
            }
            
            [self.cellStatusArray addObject:tmpArray];
        }
    }
    self.recommondLabel.text = [NSString stringWithFormat:@"提交(%@)",[NSNumber numberWithInteger:self.selectedNameArray.count]];
}

#pragma mark - 解释说明
- (void)explainClick
{
    NSString *reasonString = @"该机构尚未完成数据对接，无法自动判断客户购买后理财师是否能够获得佣金。\n\n客户购买后，请理财师通过我的-报单记录-报单进行报单。我们会根据理财师的报单记录判断该客户是否为首投，为首投则有佣金，非首投则无佣金";
    [self showCustomAlertViewWithTitle:reasonString okTitle:@"关闭" okTitleColor:UIColorFromHex(0x323232) okCompleteBlock:^{
    } topPadding:23 textAlignment:NSTextAlignmentLeft];

}

#pragma mark - 全选／全不选
- (void)isSelectAll:(BOOL)isSelected
{
    NSMutableArray * tmpArray = [NSMutableArray array];
    
    [self.cellStatusArray removeAllObjects];
    NSNumber *selectNumber = [NSNumber numberWithBool:isSelected];
    
    for (id obj in self.sortLetterArray)
    {
        if ([obj isKindOfClass:[NSArray class]])
        {
            tmpArray = [NSMutableArray array];
            for (id tmpObj in obj)
            {
                [tmpArray addObject:[NSString stringWithFormat:@"%@", selectNumber]];
            }
            
            [self.cellStatusArray addObject:tmpArray];
        }
    }
    
    [self.selectedNameArray removeAllObjects];
    
    //全选
    if (isSelected)
    {
        [self.selectedNameArray addObjectsFromArray:self.customerArray];
    }

    self.recommondLabel.text = [NSString stringWithFormat:@"提交(%@)",[NSNumber numberWithInteger:self.selectedNameArray.count]];
    
    [self.tableView reloadData];
}

#pragma mark - 全选
- (void)selectAllAction
{
    [self isSelectAll:YES];
    [self.navigationItem selectAllWithTarget:self title:@"取消全选" action:@selector(selectNonAction)];
}

#pragma mark - 取消全选
- (void)selectNonAction
{
    [self isSelectAll:NO];
    [self.navigationItem selectAllWithTarget:self title:@"全选" action:@selector(selectAllAction)];
}

#pragma mark - 推荐操作
- (IBAction)recommondButtonAction:(id)sender
{
    NSString *titleString = @"";
    NSString *subTitleString = XNRecommendNon;
    
    //选中任何客户
    if (self.selectedNameArray.count > 0)
    {
        titleString = XNRecommendTitle;
        //推荐产品
        if (self.isProductRecommend)
        {
            subTitleString = XNRecommendProduct;
            //umeng统计点击次数-推荐产品_提交
            [XNUMengHelper umengEvent:@"C_Recommended_product_Submit"];
        }
        else
        {
            //推荐机构
            subTitleString = XNRecommendPlatform;
            //umeng统计点击次数- 推荐平台_提交
            [XNUMengHelper umengEvent:@"C_Recommended_platform_Submit"];
        }
    }

    weakSelf(weakSelf)
    [self showFMRecommandViewWithTitle:titleString subTitle:subTitleString otherSubTitle:@"" okTitle:@"确定" okCompleteBlock:^{
        
        NSString *selectedUserIdString = @"";
        for (int i = 0; i < weakSelf.selectedNameArray.count; i++)
        {
            XNRecommendItemMode *mode = [weakSelf.selectedNameArray objectAtIndex:i];
            selectedUserIdString = [selectedUserIdString stringByAppendingString:mode.userId];
            if (i != weakSelf.selectedNameArray.count - 1 && weakSelf.selectedNameArray.count != 1)
            {
                selectedUserIdString = [selectedUserIdString stringByAppendingString:@","];
            }
        }
        
        //是推荐产品
        if (weakSelf.isProductRecommend)
        {
            //调用推荐接口
            [[XNFinancialProductModule defaultModule] fmRecommendWithProductId:weakSelf.productMode.productId userIdString:selectedUserIdString];
            
            //umeng统计点击次数-推荐产品_提交_确定
            [XNUMengHelper umengEvent:@"C_Recommended_product_Submit_confirm"];
        }
        else
        {
            //机构推荐
            [[XNFinancialProductModule defaultModule] fmRecommendWithAgentCode:weakSelf.agentMode.orgNo userIdString:selectedUserIdString];
            
            //umeng统计点击次数- 推荐平台_提交_确定
            [XNUMengHelper umengEvent:@"C_Recommended_platform_Submit_confirm"];
        }
        
        [weakSelf.view showGifLoading];
    } cancelTitle:@"取消" cancelCompleteBlock:^{
        
    }];
}

#pragma mark - 退出键盘
- (void)exitKeyboard
{
    [self.view removeGestureRecognizer:self.tapGesture];
    [super exitKeyboard];
}

#pragma mark - 键盘显示
- (void)keyboardShow:(NSNotification *)notif
{
    [self.view addGestureRecognizer:self.tapGesture];
}

#pragma mark - 键盘隐藏
- (void)keyboardHide:(NSNotification *)notif
{
    [self exitKeyboard];
    if (self.searchTextField.text.length < 1)
    {
        _isSearch = NO;
        [self loadDatas];
    }
}

//////////////////////////////////
#pragma mark - Protocal
///////////////////////////////////////////////

#pragma mark - 搜索处理
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _isSearch = YES;
    
    if (textField.text.length < 1)
    {
        _isSearch = NO;
    }
    [self loadDatas];
    return YES;
}

#pragma makr - UITableViewDataSource
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sortIndexArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sortLetterArray objectAtIndex:section] count];
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 31.0;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MFProductRecommendCellHeader * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MFProductRecommendCellHeader"];
    
    [header refreshTitle:[self.sortIndexArray objectAtIndex:section]];
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell * cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    XNRecommendItemMode *mode = [[self.sortLetterArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSString *nameString = mode.userName;
    NSString *mobile = @"";
    if (mode)
    {
        mobile = mode.mobile;
        if ([mobile isEqualToString:nameString])
        {
            nameString = @"未认证";
        }
    }
    
    [cell refreshName:nameString tel:mobile];
    
    [cell updateStatus:NO];
    [cell showRecommendLabel:NO];
    if ([[[self.cellStatusArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] boolValue])
    {
        [cell updateStatus:YES];
    }
    
    //已推荐
    if (mode.ifRecommend != 0)
    {
        [cell showRecommendLabel:YES];
    }
    
    return cell;
}

#pragma mark - 设置右方表格的索引数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sortIndexArray;
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    XNRecommendItemMode *mode = [[self.sortLetterArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if ([[[self.cellStatusArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] boolValue])
    {
        [[self.cellStatusArray objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:@"0"];
        [cell updateStatus:NO];
        
        [self.selectedNameArray removeObject:mode];
    }
    else
    {
        [[self.cellStatusArray objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:@"1"];
        [cell updateStatus:YES];
        [self.selectedNameArray addObject:mode];
    }
    
    self.recommondLabel.text = [NSString stringWithFormat:@"提交(%@)",[NSNumber numberWithInteger:self.selectedNameArray.count]];
    
}

//////////////////////////////
#pragma mark - protocol Methods
//////////////////////////////////////////

#pragma mark - XNFinancialProductModuleObserver

#pragma mark - 产品推荐列表
- (void)XNFinancialManagerModuleRecommendProductDidReceive:(XNFinancialProductModule *)module
{
    [self.view hideLoading];
    [self.customerArray removeAllObjects];
    [self.customerArray addObjectsFromArray:module.recommendProductListMode.allFeeList];
    [self sortCustomerData];
    
}

- (void)XNFinancialManagerModuleRecommendProductDidFailed:(XNFinancialProductModule *)module
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

#pragma mark - 产品推荐
- (void)XNFinancialManagerModuleRecommendDidReceive:(XNFinancialProductModule *)module
{
    [self.view hideLoading];
    if (self.selectedNameArray.count > 0)
    {
        [self showCustomWarnViewWithContent:@"推荐成功" Completed:^{
            [_UI popViewControllerFromRoot:YES];
        }];
    }
    else
    {
        [_UI popViewControllerFromRoot:YES];
    }
    
}

- (void)XNFinancialManagerModuleRecommendDidFailed:(XNFinancialProductModule *)module
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

#pragma mark - 机构推荐列表
- (void)XNFinancialManagerModuleRecommendAgentListDidReceive:(XNFinancialProductModule *)module
{
    [self.view hideLoading];
    [self.customerArray removeAllObjects];
    [self.customerArray addObjectsFromArray:module.recommendAgentListMode.allFeeList];
    [self sortCustomerData];
}

- (void)XNFinancialManagerModuleRecommendAgentListDidFailed:(XNFinancialProductModule *)module
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

#pragma mark - 机构推荐
- (void)XNFinancialManagerModuleRecommendAgentDidReceive:(XNFinancialProductModule *)module
{
    [self.view hideLoading];
    if (self.selectedNameArray.count > 0)
    {
        [self showCustomWarnViewWithContent:@"推荐成功" Completed:^{
            [_UI popViewControllerFromRoot:YES];
        }];
    }
    else
    {
        [_UI popViewControllerFromRoot:YES];
    }
}

- (void)XNFinancialManagerModuleRecommendAgentDidFailed:(XNFinancialProductModule *)module
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

////////////////////
#pragma mark - setter/getter
////////////////////////////////////////////

#pragma mark - tapGesture
- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture)
    {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exitKeyboard)];
    }
    return _tapGesture;
}

#pragma mark - customerArray
- (NSMutableArray *)customerArray
{
    if (_customerArray == nil)
    {
        _customerArray = [[NSMutableArray alloc] init];
    }
    return _customerArray;
}

#pragma mark - sortIndexArray
- (NSMutableArray *)sortIndexArray
{
    if (_sortIndexArray == nil)
    {
        _sortIndexArray = [[NSMutableArray alloc] init];
    }
    return _sortIndexArray;
}

#pragma mark - sortLetterArray
- (NSMutableArray *)sortLetterArray
{
    if (_sortLetterArray == nil)
    {
        _sortLetterArray = [[NSMutableArray alloc] init];
    }
    return _sortLetterArray;
}

#pragma mark - cellStatusArray
- (NSMutableArray *)cellStatusArray
{
    if (_cellStatusArray == nil)
    {
        _cellStatusArray = [[NSMutableArray alloc] init];
    }
    return _cellStatusArray;
}

#pragma mark - selectedNameArray
- (NSMutableArray *)selectedNameArray
{
    if (_selectedNameArray == nil)
    {
        _selectedNameArray = [[NSMutableArray alloc] init];
    }
    return _selectedNameArray;
}

@end
