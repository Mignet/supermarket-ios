//
//  RedPacketSelectCustomerViewController.m
//  FinancialManager
//
//  Created by xnkj on 6/20/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "RedPacketSelectCfgViewController.h"
#import "RedPacketCfgCell.h"
#import "ContactHeaderCell.h"
#import "MyCfgDetailViewController.h"

#import "ChineseString.h"
#import "JFZDataBase.h"

#import "UINavigationItem+Extension.h"


#import "XNCSCfgItemMode.h"
#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"

#define DEFAULTHEADERHEIGHT 22.0f
#define DEFAULTCELLHEIGHT 102.0f


@interface RedPacketSelectCfgViewController ()<RedPacketCfgCellDelegate,XNMyInformationModuleObserver>

@property (nonatomic, strong) NSString            *  redPacketMoney;
@property (nonatomic, strong) NSString            *  redPacketRid;
@property (nonatomic, strong) XNCSCfgItemMode     *  selectedCfg;
@property (nonatomic, strong) NSIndexPath         *  selectedIndexPath;
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;


@property (nonatomic, strong) NSMutableArray      *  cfgArray;
@property (nonatomic, strong) NSArray             *  nameSortIndexArray;

@property (nonatomic, weak) IBOutlet UILabel      *  searchLabel;
@property (nonatomic, weak) IBOutlet UITextField  *  searchTextField;
@property (nonatomic, weak) IBOutlet UITableView  *  customerListTableView;
@property (nonatomic, weak) IBOutlet UILabel    *  dispatchRedPacketLabel;
@property (nonatomic, weak) IBOutlet UILabel      *  remindLabel;
@end

@implementation RedPacketSelectCfgViewController

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
#pragma mark - 自定义方法
///////////////////////////////////

//初始化
- (void)initView
{
    self.selectedIndexPath = nil;
    
    weakSelf(weakSelf)
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        weakSelf.searchLabel.text = weakSelf.searchTextField.text;
    }];
    
    [self.customerListTableView registerNib:[UINib nibWithNibName:@"RedPacketCfgCell" bundle:nil] forCellReuseIdentifier:@"RedPacketCfgCell"];
    [self.customerListTableView setRowHeight:DEFAULTCELLHEIGHT];
    [self.customerListTableView setSectionHeaderHeight:DEFAULTHEADERHEIGHT];
    [self.customerListTableView setSeparatorColor:[UIColor clearColor]];
    
    //开始加载
    [self loadCfgData];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

//开始排序
- (void)loadCfgData
{
    NSString * sql = @"select * from CfgList";
    
    weakSelf(weakSelf)
    [[JFZDataBase shareDataBaseWithDBName:@"FinancialManagerCfgDb"] getDataFromDataBaseWithSQL:sql success:^(id result, FMDatabase *db) {
        
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

//排序并初始化
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
    XNCSCfgItemMode * mode = nil;
    NSInteger reuserId = 0;
    [self.cfgArray removeAllObjects];
    
    NSInteger objIndex = 0;
    for (NSInteger index = 0; index < sortNameArray.count; index ++) {
        
        customerCateArray = [NSMutableArray array];
        for (NSInteger subIndex = 0 ; subIndex < [[sortNameArray objectAtIndex:index] count]; subIndex ++) {
            
            reuserId = 0;
            while (reuserId < customArray.count) {
                
                if ([[[customArray objectAtIndex:reuserId] objectForKey:@"userName"] isEqualToString:[[sortNameArray objectAtIndex:index] objectAtIndex:subIndex]]) {
                    
                    mode = [XNCSCfgItemMode initCSCfgItemWithParams:[customArray objectAtIndex:reuserId]];
                   
                    objIndex = [customArray indexOfObject:[customArray objectAtIndex:reuserId]];
                    [customArray removeObjectAtIndex:objIndex];
                    
                    
                    [customerCateArray addObject:mode];
                    
                    break;
                }
                reuserId ++;
            }
        }
        
        [self.cfgArray addObject:customerCateArray];
    }
    
    [self.customerListTableView reloadData];
}

//发送红包
- (IBAction)sendRedPacket:(UIButton *)sender
{
    
    if (!self.selectedCfg) {
        
        [self.view showCustomWarnViewWithContent:@"请选择派发红包的用户!"];
        return;
    }
    
    [[XNMyInformationModule defaultModule] dispatchRedPacketForCfgWithRedPacketRid:self.redPacketRid usersMobile:@[self.selectedCfg.mobile]];
    [self.view showGifLoading];
}

//退出键盘
- (void)tapExitKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

//键盘显示
- (void)keyboardShow:(NSNotification *)notif
{
    [self.view addGestureRecognizer:self.tapGesture];
}

//键盘消失
- (void)keyboardHide:(NSNotification *)notif
{
    [self.view removeGestureRecognizer:self.tapGesture];
}

///////////////////////
#pragma mark - 组件回调
////////////////////////////////////////

#pragma makr - UITableViewDataSource
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cfgArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.cfgArray objectAtIndex:section] count];
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
    RedPacketCfgCell * cell = (RedPacketCfgCell *)[tableView dequeueReusableCellWithIdentifier:@"RedPacketCfgCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    [cell updateContent:[[self.cfgArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    [cell updateStatus:NO];
    if (self.selectedIndexPath && self.selectedIndexPath.section == indexPath.section && self.selectedIndexPath.row == indexPath.row)
        [cell updateStatus:YES];
    
    return cell;
}

#pragma mark - RedPacketCustomerCellDelegate
- (void)RedPacketCfgCell:(RedPacketCfgCell *)cell didSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    XNCSCfgItemMode * mode = [[self.cfgArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (self.selectedIndexPath && self.selectedIndexPath.section == indexPath.section && self.selectedIndexPath.row == indexPath.row)
    {
        self.selectedIndexPath = nil;
        [cell updateStatus:NO];
        
        self.selectedCfg = nil;
    }else
    {
        self.selectedIndexPath = indexPath;
        [cell updateStatus:YES];
        
        self.selectedCfg = mode;
    }
    [self.customerListTableView reloadData];
}

//理财师详情
- (void)RedPacketCfgCell:(RedPacketCfgCell *)cell didClickDetailAtIndexPath:(NSIndexPath *)indexPath
{
    XNCSCfgItemMode * mode = [[self.cfgArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    MyCfgDetailViewController * cfgDetailCtrl = [[MyCfgDetailViewController alloc]initWithNibName:@"MyCfgDetailViewController" bundle:nil userId:mode.userId];
    
    [_UI pushViewControllerFromRoot:cfgDetailCtrl animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.searchLabel.text.length <= 0) {
        
        [self loadCfgData];
        return YES;
    }
    
    //根据名字或者电话号码搜索
    weakSelf(weakSelf)
    [[JFZDataBase shareDataBaseWithDBName:@"FinancialManagerCfgDb"]
     findDataInTable:@"CfgList" WithConditionStr:[NSString stringWithFormat:@"userName like '%@%@'",self.searchLabel.text,@"%"] orderBy:@"1" page:0 pageSize:100 success:^(id result, FMDatabase *db) {
         
         if ([NSObject isValidateObj:result] && [result count] <= 0) {
             
             [[JFZDataBase shareDataBaseWithDBName:@"FinancialManagerCfgDb"]
              findDataInTable:@"CfgList" WithConditionStr:[NSString stringWithFormat:@"mobile like '%@%@'",self.searchLabel.text,@"%"] orderBy:@"1" page:0 pageSize:100 success:^(id result, FMDatabase *db){
                  
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

///////////////////////
#pragma mark - 网络回调
////////////////////////////////////////

//发红包
- (void)XNMyInfoModuleCfgDispatchRedPacketInfoDidReceive:(XNMyInformationModule *)module
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XN_RED_PACKET_DISPATCH_SUCCESS object:nil];
    [self.view showCustomWarnViewWithContent:@"发送客户红包成功" Completed:^{
       
        [_UI popViewControllerFromRoot:YES];
    }];
}

- (void)XNMyInfoModuleCfgDispatchRedPacketInfoDidFailed:(XNMyInformationModule *)module
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
- (NSMutableArray *)cfgArray
{
    if (!_cfgArray) {
        
        _cfgArray = [[NSMutableArray alloc]init];
    }
    return _cfgArray;
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
