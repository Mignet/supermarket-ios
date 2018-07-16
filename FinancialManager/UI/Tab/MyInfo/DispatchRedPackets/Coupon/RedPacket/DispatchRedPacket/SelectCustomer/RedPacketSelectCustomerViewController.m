//
//  RedPacketSelectCustomerViewController.m
//  FinancialManager
//
//  Created by xnkj on 6/20/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "RedPacketSelectCustomerViewController.h"
#import "RedPacketCustomerCell.h"
#import "ContactHeaderCell.h"
#import "MyCustomerDetailViewController.h"

#import "ChineseString.h"
#import "JFZDataBase.h"

#import "UINavigationItem+Extension.h"

#import "XNCSMyCustomerItemMode.h"
#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"

#define DEFAULTHEADERHEIGHT 22.0f
#define DEFAULTCELLHEIGHT 147.0f


@interface RedPacketSelectCustomerViewController ()<RedPacketCustomerCellDelegate,XNMyInformationModuleObserver>

@property (nonatomic, strong) NSString            *  redPacketMoney;
@property (nonatomic, strong) NSString            *  redPacketRid;
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@property (nonatomic, strong) XNCSMyCustomerItemMode     *  selectedCustomer;
@property (nonatomic, strong) NSIndexPath         *  selectedIndexPath;

@property (nonatomic, strong) NSMutableArray      *  customerArray;
@property (nonatomic, strong) NSArray             *  nameSortIndexArray;

@property (nonatomic, weak) IBOutlet UILabel      *  searchLabel;
@property (nonatomic, weak) IBOutlet UITextField  *  searchTextField;
@property (nonatomic, weak) IBOutlet UITableView  *  customerListTableView;
@property (nonatomic, weak) IBOutlet UILabel    *  dispatchRedPacketLabel;
@property (nonatomic, weak) IBOutlet UILabel      *  remindLabel;
@end

@implementation RedPacketSelectCustomerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil redPacketMoney:(NSString *)money redPacketId:(NSString *)redPacketRid
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.redPacketMoney = money;
        self.redPacketRid = redPacketRid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[XNMyInformationModule defaultModule] addObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[XNMyInformationModule defaultModule] removeObserver:self];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////
#pragma mark - Custom Method
///////////////////////////////////

#pragma mark - 初始化
- (void)initView
{
    self.selectedCustomer = nil;
    self.selectedIndexPath = nil;
    self.title = @"选择客户";
    
    weakSelf(weakSelf)
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        weakSelf.searchLabel.text = weakSelf.searchTextField.text;
    }];
    
    [self.customerListTableView registerNib:[UINib nibWithNibName:@"RedPacketCustomerCell" bundle:nil] forCellReuseIdentifier:@"RedPacketCustomerCell"];
    [self.customerListTableView setRowHeight:DEFAULTCELLHEIGHT];
    [self.customerListTableView setSectionHeaderHeight:DEFAULTHEADERHEIGHT];
    [self.customerListTableView setSeparatorColor:[UIColor clearColor]];
    
    //开始加载
    [self loadCustomerData];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
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
    XNCSMyCustomerItemMode * mode = nil;
    NSInteger reuserId = 0;
    [self.customerArray removeAllObjects];
    
    NSInteger objIndex = 0;
    for (NSInteger index = 0; index < sortNameArray.count; index ++) {
        
        customerCateArray = [NSMutableArray array];
        for (NSInteger subIndex = 0 ; subIndex < [[sortNameArray objectAtIndex:index] count]; subIndex ++) {
            
            reuserId = 0;
            while (reuserId < customArray.count) {
                
                if ([[[customArray objectAtIndex:reuserId] objectForKey:@"userName"] isEqualToString:[[sortNameArray objectAtIndex:index] objectAtIndex:subIndex]]) {
                    
                    mode = [XNCSMyCustomerItemMode initMyCustomerWithObject:[customArray objectAtIndex:reuserId]];
                    
                    objIndex = [customArray indexOfObject:[customArray objectAtIndex:reuserId]];
                    [customArray removeObjectAtIndex:objIndex];
                    
                    [customerCateArray addObject:mode];
                    
                    break;
                }
                reuserId ++;
            }
        }
        
        [self.customerArray addObject:customerCateArray];
    }
    
    [self.customerListTableView reloadData];
}

#pragma mark - 发送红包
- (IBAction)sendRedPacket:(UIButton *)sender
{
    
    if (!self.selectedCustomer) {
        
        [self.view showCustomWarnViewWithContent:@"请选择派发红包的用户!"];
        return;
    }
    
    [[XNMyInformationModule defaultModule] dispatchRedPacketWithRedPacketRid:self.redPacketRid redPacketMoney:self.redPacketMoney usersMobile:@[self.selectedCustomer.customerMobile]];
    [self.view showGifLoading];
}

#pragma mark - 退出键盘
- (void)tapExitKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - 键盘显示
- (void)keyboardShow:(NSNotification *)notif
{
    [self.view addGestureRecognizer:self.tapGesture];
}

#pragma mark - 键盘消失
- (void)keyboardHide:(NSNotification *)notif
{
    [self.view removeGestureRecognizer:self.tapGesture];
}

///////////////////////
#pragma mark - Protocol
////////////////////////////////////////

#pragma makr - UITableViewDataSource
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.customerArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.customerArray objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  
    NSString *key = [self.nameSortIndexArray objectAtIndex:section];
    return key;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ContactHeaderCell * cell = (ContactHeaderCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ContactHeaderCell"];
    
    [cell refreshTitle:[self.nameSortIndexArray objectAtIndex:section]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RedPacketCustomerCell * cell = (RedPacketCustomerCell *)[tableView dequeueReusableCellWithIdentifier:@"RedPacketCustomerCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    [cell updateContent:[[self.customerArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    [cell updateStatus:NO];
    if (self.selectedIndexPath && self.selectedIndexPath.section == indexPath.section && self.selectedIndexPath.row == indexPath.row)
        [cell updateStatus:YES];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNCSMyCustomerItemMode * mode = [[self.customerArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    MyCustomerDetailViewController * customerDetailCtrl = [[MyCustomerDetailViewController alloc]initWithNibName:@"MyCustomerDetailViewController" bundle:nil userId:mode.customerId];
    
    [_UI pushViewControllerFromRoot:customerDetailCtrl animated:YES];
}

#pragma mark - RedPacketCustomerCellDelegate
- (void)RedPacketCustomerCell:(RedPacketCustomerCell *)cell didSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    XNCSMyCustomerItemMode * mode = [[self.customerArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (self.selectedIndexPath && self.selectedIndexPath.section == indexPath.section && self.selectedIndexPath.row == indexPath.row)
    {
        self.selectedIndexPath = nil;
        [cell updateStatus:NO];
        
        self.selectedCustomer = nil;
    }else
    {
        self.selectedIndexPath = indexPath;
        [cell updateStatus:YES];
        
        self.selectedCustomer = mode;
    }
    
    [self.customerListTableView reloadData];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.searchLabel.text.length <= 0) {
        
        [self loadCustomerData];
        return YES;
    }
    
    //根据名字或者电话号码搜索
    weakSelf(weakSelf)
    [[JFZDataBase shareDataBaseWithDBName:@"FinancialManagerDb"]
     findDataInTable:@"CustomerList" WithConditionStr:[NSString stringWithFormat:@"userName like '%@%@'",self.searchLabel.text,@"%"] orderBy:@"1" page:0 pageSize:100 success:^(id result, FMDatabase *db) {
         
         if ([NSObject isValidateObj:result] && [result count] <= 0) {
             
             [[JFZDataBase shareDataBaseWithDBName:@"FinancialManagerDb"]
              findDataInTable:@"CustomerList" WithConditionStr:[NSString stringWithFormat:@"mobile like '%@%@'",self.searchLabel.text,@"%"] orderBy:@"1" page:0 pageSize:100 success:^(id result, FMDatabase *db){
                  
                  if ([NSObject isValidateObj:result]) {
                      
                      NSMutableArray * customerNameArray = [NSMutableArray array];
                      NSMutableArray * customArray = [NSMutableArray array];
                      
                      for (NSDictionary * dic in result) {
                          
                          [customerNameArray addObject:[dic objectForKey:@"userName"]];
                          [customArray addObject:dic];
                      }
                      
                      [weakSelf sortCustomerDataWithCustomerNameArray:customerNameArray customerArray:customArray];
                  }
                  
              } failed:^(NSError *error) {
                  
              }];
         }else
         {
             NSMutableArray * customerNameArray = [NSMutableArray array];
             NSMutableArray * customArray = [NSMutableArray array];
             
             for (NSDictionary * dic in result) {
                 
                 [customerNameArray addObject:[dic objectForKey:@"userName"]];
                 [customArray addObject:dic];
             }
             
             [weakSelf sortCustomerDataWithCustomerNameArray:customerNameArray customerArray:customArray];
         }
     } failed:^(NSError *error) {
         
         NSLog(@"error:%@",error.description);
     }];
    
    return YES;
}

#pragma mark - 发红包
- (void)XNMyInfoModuleDispatchRedPacketDidReceive:(XNMyInformationModule *)module
{
    [[NSNotificationCenter defaultCenter] postNotificationName:XN_RED_PACKET_DISPATCH_SUCCESS object:nil];
    [self.view showCustomWarnViewWithContent:@"发送客户红包成功" Completed:^{
       
        [_UI popViewControllerFromRoot:YES];
    }];
}

- (void)XNMyInfoModuleDispatchRedPacketDidFailed:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

///////////////////////
#pragma mark - setter/getter
////////////////////////////////////////

#pragma mark - nameSortIndexArray
- (NSArray *)nameSortIndexArray
{
    if (!_nameSortIndexArray) {
        
        _nameSortIndexArray = [[NSArray alloc]init];
    }
    return _nameSortIndexArray;
}

#pragma mark - customerArray
- (NSMutableArray *)customerArray
{
    if (!_customerArray) {
        
        _customerArray = [[NSMutableArray alloc]init];
    }
    return _customerArray;
}

#pragma mark - tapGesture
- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapExitKeyboard)];
    }
    return _tapGesture;
}

@end
