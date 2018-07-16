//
//  AddressBookController.m
//  FinancialManager
//
//  Created by xnkj on 15/12/22.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "AddressBookController.h"
#import "ChineseString.h"

#import "ContactCell.h"
#import "ContactHeaderCell.h"

#import "JFZDataBase.h"

@interface AddressBookController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSString       * titleName;
@property (nonatomic, strong) NSString       * btnName;
@property (nonatomic, strong) NSString       * remindDesc;
@property (nonatomic, strong) NSMutableArray * nameArray;
@property (nonatomic, strong) NSMutableArray * telArray;
@property (nonatomic, strong) NSMutableArray * addressBookArray;
@property (nonatomic, strong) NSMutableArray * sortIndexArray;
@property (nonatomic, strong) NSMutableArray * cellStatusArray;
@property (nonatomic, strong) NSMutableArray * selectedNameArray;
@property (nonatomic, strong) NSMutableArray * allContactArray;
@property (nonatomic, strong) NSMutableArray  * nameIndexArray;
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;

@property (nonatomic, weak) IBOutlet UILabel     * remindLabel;
@property (nonatomic, weak) IBOutlet UIButton    * invitedBtn;
@property (nonatomic, weak) IBOutlet UITextField * searchTextField;
@property (nonatomic, weak) IBOutlet UILabel     * searchLabel;
@property (nonatomic, weak) IBOutlet UILabel     * selectedCustomerLabel;
@property (nonatomic, weak) IBOutlet UITableView * contactListTableView;
@end

@implementation AddressBookController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)titleName btnTitle:(NSString *)btnName remindDesc:(NSString *)desc
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.titleName = titleName;
        self.btnName = btnName;
        self.remindDesc = desc;
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
    
    [self.view showGifLoading];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getAddressBookInfo];
    
    if (IOS9_OR_LATER)
        [self resolveCNContactObjectAboveIOS9:self.allContactArray];
    else
        [self resolveCNContactObjectBelowIOS9:self.allContactArray];
    
    [self.view hideLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/////////////////////////////////////
#pragma mark - Custom Methods
///////////////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    [self setTitle:self.titleName];
    [self.invitedBtn setTitle:self.btnName forState:UIControlStateNormal];
    [self.remindLabel setText:self.remindDesc];
    
    [self.contactListTableView registerNib:[UINib nibWithNibName:@"ContactCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
    [self.contactListTableView registerClass:[ContactHeaderCell class] forHeaderFooterViewReuseIdentifier:@"ContactHeaderCell"];
    [self.contactListTableView setSeparatorColor:[UIColor clearColor]];
    
    weakSelf(weakSelf)
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        weakSelf.searchLabel.text = weakSelf.searchTextField.text;
    }];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 从通信录中获取通信人信息
- (void)getAddressBookInfo
{
    [self.nameArray removeAllObjects];
    [self.telArray removeAllObjects];
    [self.addressBookArray removeAllObjects];
    [self.sortIndexArray removeAllObjects];
    [self.selectedNameArray removeAllObjects];
    [self.cellStatusArray removeAllObjects];
    [self.allContactArray removeAllObjects];
    
    if (IOS9_OR_LATER)
        [self getAddressBookContactAbove9];
    else
        [self getAddressBookContactBelowIOS9];
}

#pragma mark - 获取通讯录版本ios9.0或以上
- (void)getAddressBookContactAbove9
{
    // 1.获取授权状态
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusRestricted) {
        
        UIAlertView *av = [[UIAlertView alloc]
                           initWithTitle:@"无法获取通讯录权限"
                           message:@"请到\"设置\"中设置通讯旅权限"
                           delegate:nil
                           cancelButtonTitle:nil
                           otherButtonTitles:@"OK", nil, nil];
        [av show];
        
        return;
    }
    
    CNContactStore * addressBook = [[CNContactStore alloc]init];
    
    CNContactFetchRequest * getAddressBookInfoRequest = [[CNContactFetchRequest alloc]initWithKeysToFetch:@[CNContactFamilyNameKey,CNContactGivenNameKey,CNContactPhoneNumbersKey]];
    weakSelf(weakSelf)
    [addressBook enumerateContactsWithFetchRequest:getAddressBookInfoRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        
        [weakSelf.allContactArray addObject:contact];
    }];
}

#pragma mark - 获取通讯录版本IOS9.0以下
- (void)getAddressBookContactBelowIOS9
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    //判断是否允许访问通讯录
    [self checkAddressBookAuthorizationStatus:addressBook];
    
    if (self.allContactArray.count <= 0)
        [self.allContactArray addObjectsFromArray:(__bridge_transfer NSArray*)
         ABAddressBookCopyArrayOfAllPeople(addressBook)];
}

-(bool)checkAddressBookAuthorizationStatus:(ABAddressBookRef )addressBook
{
    //取得授权状态
    ABAuthorizationStatus authStatus =
    ABAddressBookGetAuthorizationStatus();
    
    if (authStatus != kABAuthorizationStatusAuthorized)
    {
        ABAddressBookRequestAccessWithCompletion
        (addressBook, ^(bool granted, CFErrorRef error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (error)
                     NSLog(@"Error: %@", (__bridge NSError *)error);
                 else if (!granted) {
                     UIAlertView *av = [[UIAlertView alloc]
                                        initWithTitle:@"无法获取通讯录权限"
                                        message:@"请到\"设置\"中设置通讯录权限"
                                        delegate:nil
                                        cancelButtonTitle:nil
                                        otherButtonTitles:@"OK", nil, nil];
                     [av show];
                 }
                 else
                 {
                     //还原 ABAddressBookRef
                     ABAddressBookRevert(addressBook);
                 }
             });
         });
    }
    
    return authStatus == kABAuthorizationStatusAuthorized;
}

#pragma mark - 解析联系人信息对象-ios9
- (void)resolveCNContactObjectAboveIOS9:(NSArray *)array
{
    NSString * tel = nil;
    NSString * name = nil;
    
    [self.nameArray removeAllObjects];
    [self.telArray removeAllObjects];
    [self.addressBookArray removeAllObjects];
    [self.sortIndexArray removeAllObjects];
    [self.nameArray removeAllObjects];
    [self.nameIndexArray removeAllObjects];
    
    for (CNContact * object in array) {
        
        tel = @"";
        name = @"";
        
        tel = [[[object.phoneNumbers firstObject] value] stringValue];
        if (![tel isValidateStr]) {
            
            continue;
        }
        
        name = object.givenName;
        if (![name isValidateStr]) {
            
            name = object.familyName;
        }else if (![object.familyName isValidateStr])
        {
            name = [object.familyName stringByAppendingString:object.givenName];
        }else
            continue;
        
        if ([name isEqualToString:@""]) {
            
            continue;
        }
        
        //过滤掉客户列表中的客户
        __block BOOL isExistCustomer = NO;
        [[JFZDataBase shareDataBaseWithDBName:@"FinancialManagerDb"] findSingleDataInTable:@"CustomerList" WithKey:@"customerMobile" value:[tel stringByReplacingOccurrencesOfString:@"-" withString:@""] condition:JFZDataBaseConditionEqual conditionStr:nil orderBy:nil success:^(id result, FMDatabase *db) {
            
            if ([NSObject isValidateObj:result])
            {
                isExistCustomer = YES;
            }
            
        } failed:^(NSError *error) {
            
            NSLog(@"error:%@",error.description);
        }];
        
        if (!isExistCustomer){
            
            [self.nameArray addObject:name];
            [self.telArray addObject:tel];
            [self.addressBookArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:name,ADDRESSBOOK_CONTRACT_NAME,tel,ADDRESSBOOK_CONTRACT_TEL, nil]];
        }
    }
    
    //开始排序显示
    self.sortIndexArray = [ChineseString IndexArray:self.nameArray];
    self.nameArray = [ChineseString LetterSortArray:self.nameArray];
    
    [self sortNameIndexDictionary];
    
    [self initStatusArray];
    
    [self.contactListTableView reloadData];
}

#pragma mark - 解析联系人信息对象-ios9以下
- (void)resolveCNContactObjectBelowIOS9:(NSArray *)array
{
    NSString * tel = @"";
    NSString * name = @"";
    
    [self.nameArray removeAllObjects];
    [self.telArray removeAllObjects];
    [self.addressBookArray removeAllObjects];
    [self.sortIndexArray removeAllObjects];
    [self.nameArray removeAllObjects];
    [self.nameIndexArray removeAllObjects];
    
    ABRecordRef people;
    ABMultiValueRef phoneNumbers;
    CFTypeRef lastName;
    CFTypeRef firstName;
    for (int i = 0 ; i < array.count ; i ++ ) {
        
        name = @"";
        tel = @"";
        
        people = (__bridge ABRecordRef)([array objectAtIndex:i]);
        
        phoneNumbers = ABRecordCopyValue(people,kABPersonPhoneProperty);
        
        if (![NSObject isValidateObj:(__bridge id)phoneNumbers]) {
            
            continue;
        }
        for (NSInteger j = 0; j < ABMultiValueGetCount(phoneNumbers); j ++ ) {
            
            tel = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phoneNumbers, j));
            if ([NSObject isValidateObj:tel]) {
                
                break;
            }
        }
        
        lastName = ABRecordCopyValue(people, kABPersonFirstNameProperty);
        firstName = ABRecordCopyValue(people, kABPersonLastNameProperty);
        
        if ([NSObject isValidateInitString:(__bridge id)lastName]) {
            
            name = (__bridge NSString *)lastName;
        }
        
        if ([NSObject isValidateInitString:(__bridge id)firstName]) {
            
            name = [name stringByAppendingString:(__bridge NSString *)firstName];
        }
        
        if ([name isEqualToString:@""]) {
            
            continue;
        }
        
        //过滤掉客户列表中的客户
        __block BOOL isExistCustomer = NO;
        [[JFZDataBase shareDataBaseWithDBName:@"FinancialManagerDb"] findSingleDataInTable:@"CustomerList" WithKey:@"customerMobile" value:[tel stringByReplacingOccurrencesOfString:@"-" withString:@""] condition:JFZDataBaseConditionEqual conditionStr:nil orderBy:nil success:^(id result, FMDatabase *db) {
            
            if ([NSObject isValidateObj:result])
            {
                isExistCustomer = YES;
            }
            
        } failed:^(NSError *error) {
            
            NSLog(@"error:%@",error.description);
        }];
        
        if (!isExistCustomer) {
            
            [self.nameArray addObject:name];
            [self.telArray addObject:tel];
            [self.addressBookArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:name,ADDRESSBOOK_CONTRACT_NAME,tel,ADDRESSBOOK_CONTRACT_TEL, nil]];
        }
    }
    
    //开始排序显示
    self.sortIndexArray = [ChineseString IndexArray:self.nameArray];
    self.nameArray = [ChineseString LetterSortArray:self.nameArray];
    
    [self sortNameIndexDictionary];
    
    [self initStatusArray];
    
    [self.contactListTableView reloadData];
}

#pragma mark - 设置名字显示下标
- (void)sortNameIndexDictionary
{
    NSInteger index = 0;
    NSString * str = @"";
    NSMutableArray * arr_ = nil;
    for (NSInteger i = 0 ; i < self.nameArray.count; i ++ ) {
        
        arr_ = [NSMutableArray array];
        str = @"________________";
        
        for (NSInteger j = 0 ; j < [[self.nameArray objectAtIndex:i] count]; j ++ ) {
            
            if ([str isEqualToString:[[self.nameArray objectAtIndex:i] objectAtIndex:j]]) {
                
                index ++;
                
                str = [[self.nameArray objectAtIndex:i] objectAtIndex:j];
                [arr_ addObject:[NSNumber numberWithInteger:index]];
                
                continue;
            }
            
            str = [[self.nameArray objectAtIndex:i] objectAtIndex:j];
            index = 0;
            [arr_ addObject:[NSNumber numberWithInteger:index]];
            
        }
        
        [self.nameIndexArray addObject:arr_];
    }
}

#pragma mark - 初始化状态数组
- (void)initStatusArray
{
    NSMutableArray * tmpArray = [NSMutableArray array];
    
    [self.cellStatusArray removeAllObjects];
    for (id obj in self.nameArray) {
        
        if ([obj isKindOfClass:[NSArray class]]) {
            
            tmpArray = [NSMutableArray array];
            for (id tmp in obj) {
                
                [tmpArray addObject:@"0"];
            }
            [self.cellStatusArray addObject:tmpArray];
        }
    }
}

#pragma mark - 根据名字找到对应字典对象
- (NSArray *)findAddressContactFromName:(NSString *)name
{
    NSMutableArray * array = [NSMutableArray array];

    for (NSDictionary * obj in self.addressBookArray) {
        
        if ([[obj objectForKey:ADDRESSBOOK_CONTRACT_NAME] isEqualToString:name]) {
            
            [array addObject:obj];
        }
    }
    
    return array;
}

#pragma mark - 搜索联系方式--ios9/上支持
- (void)searchContactInfoAboveIOS9:(NSString *)content
{
    NSString * tel = nil;
    NSString * name = nil;
    CNContact * contact = nil;
    
    NSMutableArray * searchArray = [NSMutableArray array];
    for (int i = 0 ; i < self.allContactArray.count ; i ++) {
        
        contact = [self.allContactArray objectAtIndex:i];
        
        tel = [[[[contact.phoneNumbers firstObject] value] stringValue] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        name = contact.givenName;
        if (![name isValidateStr]) {
            
            name = contact.familyName;
        }else if ([contact.familyName isValidateStr])
        {
            name = [contact.familyName stringByAppendingString:contact.givenName];
        }
        
        if ([tel containsString:content] || [name containsString:content]) {
            
            [searchArray addObject:contact];
        }
    }
    
    [self resolveCNContactObjectAboveIOS9:searchArray];
}

#pragma mark - 搜索联系方式--ios9/上支持
- (void)searchContactInfoBelowIOS9:(NSString *)content
{
    NSString * tel = nil;
    NSString * name = nil;
    
    NSMutableArray * searchArray = [NSMutableArray array];
    
    ABRecordRef people;
    ABMultiValueRef phoneNumbers;
    CFTypeRef lastName;
    CFTypeRef firstName;
    for (int i = 0 ; i <  self.allContactArray.count ; i ++ ) {
        
        name = @"";
        tel = @"";
        
        people = (__bridge ABRecordRef)([self.allContactArray objectAtIndex:i]);
        
        phoneNumbers = ABRecordCopyValue(people,kABPersonPhoneProperty);
        
        if (![NSObject isValidateObj:(__bridge id)phoneNumbers]) {
            
            continue;
        }
        for (NSInteger j = 0; j < ABMultiValueGetCount(phoneNumbers); j ++ ) {
            
            tel = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phoneNumbers, j));
            if ([NSObject isValidateObj:tel]) {
                
                break;
            }
        }
        
        tel = [tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        lastName = ABRecordCopyValue(people, kABPersonFirstNameProperty);
        firstName = ABRecordCopyValue(people, kABPersonLastNameProperty);
        
        if ([NSObject isValidateObj:(__bridge id)lastName]) {
            
            name = (__bridge NSString *)lastName;
        }
        
        if ([NSObject isValidateObj:(__bridge id)firstName]) {
            
            name = [name stringByAppendingString:(__bridge NSString *)firstName];
        }
        
        if ([tel rangeOfString:content].length > 0 || [name rangeOfString:content].length > 0) {
            
            [searchArray addObject:(__bridge id _Nonnull)(people)];
        }
    }
    
    [self resolveCNContactObjectBelowIOS9:searchArray];
}


#pragma mark - 发送邀请
- (IBAction)invitedCustomer
{
    if ([self.selectedNameArray count] <= 0) {
        
        [self showCustomWarnViewWithContent:@"您未选中理财师!"];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AddressBookControllerDidSendContact:)]) {
        
        [self.delegate AddressBookControllerDidSendContact:self.selectedNameArray];
    }
    [_UI popViewControllerFromRoot:YES];
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

//////////////////////////////////
#pragma mark - Protocal
///////////////////////////////////////////////

#pragma makr - UITableViewDataSource
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sortIndexArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.nameArray objectAtIndex:section] count];
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.0;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [self.sortIndexArray objectAtIndex:section];
    return key;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ContactHeaderCell * cell = (ContactHeaderCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ContactHeaderCell"];
    
    [cell refreshTitle:[self.sortIndexArray objectAtIndex:section]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell * cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSArray * telArray = [self findAddressContactFromName:[[self.nameArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    NSInteger index = [[[self.nameIndexArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue];
    
    [cell refreshName:[[self.nameArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] tel:[[telArray objectAtIndex:index] objectForKey:ADDRESSBOOK_CONTRACT_TEL]];
    
    [cell updateStatus:NO];
    if ([[[self.cellStatusArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] boolValue])
        [cell updateStatus:YES];
    
    return cell;
}

#pragma mark -设置右方表格的索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
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
    ContactCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSInteger index = [[[self.nameIndexArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue];
    
    if ([[[self.cellStatusArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] boolValue])
    {
        [[self.cellStatusArray objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:@"0"];
        [cell updateStatus:NO];
        
        NSDictionary * obj = [[self findAddressContactFromName:[[self.nameArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]] objectAtIndex:index];
//        
//        for(NSDictionary * obj in [self findAddressContactFromName:[[self.nameArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]])
            [self.selectedNameArray removeObject:obj];
    }else
    {
        [[self.cellStatusArray objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:@"1"];
        [cell updateStatus:YES];
        
        NSDictionary * obj = [[self findAddressContactFromName:[[self.nameArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]] objectAtIndex:index];
        
        [self.selectedNameArray addObject:obj];
    }
    [self.selectedCustomerLabel setText:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:self.selectedNameArray.count]]];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.searchTextField.text.length <= 0) {
        
        if (IOS9_OR_LATER)
            [self resolveCNContactObjectAboveIOS9:self.allContactArray];
        else
            [self resolveCNContactObjectBelowIOS9:self.allContactArray];
        
        return NO;
    }
    
    if (IOS9_OR_LATER)
        [self searchContactInfoAboveIOS9:self.searchTextField.text];
    else
        [self searchContactInfoBelowIOS9:self.searchTextField.text];
    return YES;
}


//////////////////////////////////
#pragma mark - setter/getter
////////////////////////////////////////////////

#pragma mark - addressBookArray
- (NSMutableArray *)addressBookArray
{
    if (!_addressBookArray) {
        
        _addressBookArray = [[NSMutableArray alloc]init];
    }
    return _addressBookArray;
}

#pragma mark - addressBookArray
- (NSMutableArray *)nameArray
{
    if (!_nameArray) {
        
        _nameArray = [[NSMutableArray alloc]init];
    }
    return _nameArray;
}

#pragma mark - telArray
- (NSMutableArray *)telArray
{
    if (!_telArray) {
        
        _telArray = [[NSMutableArray alloc]init];
    }
    return _telArray;
}

#pragma mark - sortIndexArray
- (NSMutableArray *)sortIndexArray
{
    if (!_sortIndexArray) {
        
        _sortIndexArray = [[NSMutableArray alloc]init];
    }
    return _sortIndexArray;
}

#pragma mark - cellStatusArray
- (NSMutableArray *)cellStatusArray
{
    if (!_cellStatusArray) {
        
        _cellStatusArray = [[NSMutableArray alloc]init];
    }
    return _cellStatusArray;
}

#pragma mark - selectNameArray
- (NSMutableArray *)selectedNameArray
{
    if (!_selectedNameArray) {
        
        _selectedNameArray = [[NSMutableArray alloc]init];
    }
    return _selectedNameArray;
}

#pragma mark - allContactArray
- (NSMutableArray *)allContactArray
{
    if (!_allContactArray) {
        
        _allContactArray = [[NSMutableArray alloc]init];
    }
    return _allContactArray;
}

#pragma mark - nameIndexArray
- (NSMutableArray *)nameIndexArray
{
    if (!_nameIndexArray) {
        
        _nameIndexArray = [[NSMutableArray alloc]init];
    }
    return _nameIndexArray;
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
