//
//  MFSystemInvitedController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/29.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "CSIMSelectUserController.h"
#import "CSIMCustomerCell.h"
#import "MFSystemInvitedEmptyCell.h"

#import "MJRefresh.h"

#import "XNCSMyCustomerItemMode.h"
#import "XNCSMyCustomerListMode.h"
#import "XNCustomerServerModule.h"
#import "XNCustomerServerModuleObserver.h"

#define DEFAULTINDEX      @"0"
#define DEFAULTPAGESIZE   @"30"
#define DEFAULTCELLHEIGHT 147

@interface CSIMSelectUserController ()<UITextFieldDelegate>

@property (nonatomic, assign) BOOL             requestFinished;
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;

@property (nonatomic, strong) NSMutableArray * customsArray;
@property (nonatomic, strong) NSMutableArray * statusArray;
@property (nonatomic, strong) NSMutableArray * selectedCustomArray;

@property (nonatomic, weak) IBOutlet UILabel     * inputSearchLabel;
@property (nonatomic, weak) IBOutlet UITextField * inputSearchTextField;
@property (nonatomic, weak) IBOutlet UITableView * customerListTableView;
@property (nonatomic, weak) IBOutlet UIView      * footerView;
@property (nonatomic, weak) IBOutlet UILabel     * selectedCustomerCountLabel;
@end

@implementation CSIMSelectUserController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil selectedUser:(NSArray *)array
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self.selectedCustomArray addObjectsFromArray:array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     [[XNCustomerServerModule defaultModule] addObserver:self];
    [self.customerListTableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[XNCustomerServerModule defaultModule] removeObserver:self];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////
#pragma mark - Custom Methods
/////////////////////////////////////

#pragma mark - 初始化
- (void)initView
{
    [self setTitle:@"新建互动"];
    [self setRequestFinished:NO];
    
    [self.view addSubview:self.footerView];
    [self.view addSubview:self.customerListTableView];
    
    weakSelf(weakSelf)
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        weakSelf.inputSearchLabel.text = weakSelf.inputSearchTextField.text;
    }];
    
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.height.mas_equalTo(60);
    }];
    
    __weak UIView * tmpFooterView = self.footerView;
    [self.customerListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.top.mas_equalTo(weakSelf.view.mas_leading).offset(77);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        
        
        make.bottom.mas_equalTo(tmpFooterView.mas_top).offset(- 10);
    }];
    
    [self.customerListTableView setSeparatorColor:[UIColor clearColor]];
    [self.customerListTableView registerNib:[UINib nibWithNibName:@"CSIMCustomerCell" bundle:nil] forCellReuseIdentifier:@"CSIMCustomerCell"];
    [self.customerListTableView registerNib:[UINib nibWithNibName:@"MFSystemInvitedEmptyCell" bundle:nil] forCellReuseIdentifier:@"MFSystemInvitedEmptyCell"];
    
    self.customerListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.requestFinished = NO;
         [[XNCustomerServerModule defaultModule] getCustomerListForCustomerName:weakSelf.inputSearchTextField.text customerType:@"" pageIndex:DEFAULTINDEX pageSize:DEFAULTPAGESIZE sort:@"1" order:@"1"];

    }];
    self.customerListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
         [[XNCustomerServerModule defaultModule] getCustomerListForCustomerName:weakSelf.inputSearchTextField.text customerType:@"" pageIndex:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[[[XNCustomerServerModule defaultModule] myCustomerListMode] pageIndex] integerValue] + 1]] pageSize:DEFAULTPAGESIZE sort:@"1" order:@""];
    }];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 发送邀请
- (IBAction)clickSendInvited:(UIButton *)sender
{
    //拼接用户名
    if (self.selectedCustomArray.count <= 0) {
        
        [self showCustomWarnViewWithContent:@"请选择互动的对象"];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(CSIMSelectUserController:didSelectUser:)]) {
        
        [self.delegate CSIMSelectUserController:self didSelectUser:self.selectedCustomArray];
        
        [_UI popViewControllerFromRoot:YES];
    }
}

#pragma mark - 筛选用户
- (NSInteger )indexOfUser:(NSString *)msgId
{
    NSDictionary * tmpDic = nil;
    for (int i = 0 ; i < self.selectedCustomArray.count; i ++ ) {
        
        tmpDic = [self.selectedCustomArray objectAtIndex:i];
        if ([[tmpDic objectForKey:@"customerId"] isEqualToString:msgId]) {
            
            return i;
        }
    }
    return -1;
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

//////////////////////////////
#pragma mark - protocol Methods
//////////////////////////////////////////

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.customsArray.count <= 0 && self.requestFinished) {
        
        return 1;
    }
    
    return self.customsArray.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNCSMyCustomerItemMode * mode = [self.customsArray objectAtIndex:indexPath.row];
    if ([NSObject isValidateInitString:mode.nearEndDate]) {
        
        return DEFAULTCELLHEIGHT + 18;
    }
    
    return DEFAULTCELLHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.customsArray.count <= 0 && self.requestFinished) {
        
        MFSystemInvitedEmptyCell * cell = (MFSystemInvitedEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"MFSystemInvitedEmptyCell"];
        
        [cell refreshTitle:@"您还没有客户"];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    CSIMCustomerCell * cell = (CSIMCustomerCell *)[tableView dequeueReusableCellWithIdentifier:@"CSIMCustomerCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setIndexPath:indexPath];
    
    if (indexPath.row == self.customsArray.count - 1) {
        
        [cell setBottomHiden:NO];
    }else
        [cell setBottomHiden:YES];
    
    [cell updateStatus:[[self.statusArray objectAtIndex:indexPath.row] isEqualToString:@"0"]?false:true];
    
    [cell updateContent:[self.customsArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.customsArray.count > 0) {
        
        CSIMCustomerCell * cell = (CSIMCustomerCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        BOOL selected = NO;
        XNCSMyCustomerItemMode * mode = (XNCSMyCustomerItemMode *)[self.customsArray objectAtIndex:indexPath.row];
        if (![NSObject isValidateInitString:mode.easeMobAccount]) {
            
            [self.view showCustomWarnViewWithContent:@"账号暂未激活,请联系该客户登录T呗激活账号!"];
            return;
        }
        
        if ([[self.statusArray objectAtIndex:indexPath.row] boolValue]) {
            
            [self.statusArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
            
            [self.selectedCustomArray removeObjectAtIndex:[self indexOfUser:mode.customerId]];
        }else
        {
            [self.statusArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
            [self.selectedCustomArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:mode.customerId,@"customerId",mode.customerName,@"userName",mode.customerMobile,@"userMobile",mode.easeMobAccount,@"mobAccount", nil]];
            selected = YES;
        }
        
        [cell updateStatus:selected];
        
        NSInteger selectedCount = 0;
        for (NSString * val in self.statusArray) {
            
            if ([val isEqualToString:@"1"]) {
                
                selectedCount ++;
            }
        }
        [self.selectedCustomerCountLabel setText:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:selectedCount]]];
    }
}

#pragma mark - 搜索对应的回调
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.inputSearchTextField.text.length <= 0) {
        
        [_KEY_WINDOW showCustomWarnViewWithContent:@"搜索内容不能为空"];
        return NO;
    }
    
    [self.customerListTableView.mj_header beginRefreshing];
    [self tapExitKeyboard];
    [self.view showGifLoading];
    
    return YES;
}

#pragma mark - 我的客户列表
- (void)XNCustomerServerModuleCustomerListDidReceive:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    [self.customerListTableView.mj_header endRefreshing];
    [self.customerListTableView.mj_footer endRefreshing];
    
    if ([module.myCustomerListMode.pageIndex integerValue] == 1)
    {
        [self.statusArray removeAllObjects];
        [self.customsArray removeAllObjects];
    }
    
    [self.customsArray addObjectsFromArray:module.myCustomerListMode.dataArray];
    
    if ([module.myCustomerListMode.pageIndex integerValue] >= [module.myCustomerListMode.pageCount integerValue]) {
        
        [self.customerListTableView.mj_footer endRefreshingWithNoMoreData];
    }else
        [self.customerListTableView.mj_footer resetNoMoreData];
    
    BOOL isSelected = NO;
    for (int i = 0 ; i < self.customsArray.count; i ++ ) {
        
        for (NSDictionary * dic in self.selectedCustomArray) {
            
            isSelected = NO;
            if ([[dic objectForKey:@"customerId"] isEqualToString:[[self.customsArray objectAtIndex:i] customerId]]) {
                
                isSelected = YES;
                break;
            }
        }
        
        [self.statusArray addObject:isSelected?@"1":@"0"];
    }
    
    [self.customerListTableView reloadData];
    
}

- (void)XNCustomerServerModuleCustomerListDidFailed:(XNCustomerServerModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    [self.customerListTableView.mj_header endRefreshing];
    [self.customerListTableView.mj_footer endRefreshing];
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    
}

//////////////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

#pragma mark - customsArray
- (NSMutableArray *)customsArray
{
    if (!_customsArray) {
        
        _customsArray = [[NSMutableArray alloc]init];
    }
    
    return _customsArray;
}

#pragma mark - statusArray
- (NSMutableArray *)statusArray
{
    if (!_statusArray) {
        
        _statusArray = [[NSMutableArray alloc]init];
    }
    return _statusArray;
}

#pragma mark - selectedCustomArray
- (NSMutableArray *)selectedCustomArray
{
    if (!_selectedCustomArray) {
        
        _selectedCustomArray = [[NSMutableArray alloc]init];
    }
    return _selectedCustomArray;
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
