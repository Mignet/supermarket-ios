//
//  MIPullListController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/22.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "MIPullListController.h"

#import "MIPullListCell.h"

#define DEFAULTCELLHEIGHT 44.0f

@interface MIPullListController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSString *  selectedType;
@property (nonatomic, assign) NSInteger   currentSelectIndex;

@property (nonatomic, strong) NSArray * typeArray;
@property (nonatomic, strong) NSMutableDictionary * statusDictionary;
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@property (nonatomic, strong) UITableView * typeListTableView;

@property (nonatomic, weak) IBOutlet UIView      * tapView;
@end

@implementation MIPullListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.currentSelectIndex = 0;
    [self.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    [self.tapView addGestureRecognizer:self.tapGesture];
    
    [self.view addSubview:self.typeListTableView];
    
    weakSelf(weakSelf)
    [self.typeListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.bottom.mas_equalTo(weakSelf.view.mas_top);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.height.mas_equalTo(DEFAULTCELLHEIGHT * weakSelf.typeArray.count);
    }];
    
    [self.typeListTableView setSeparatorColor:[UIColor clearColor]];
    [self.typeListTableView registerNib:[UINib nibWithNibName:@"MIPullListCell" bundle:nil] forCellReuseIdentifier:@"MIPullListCell"];

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 默认选中的操作
- (void)setSelectedIndex:(NSInteger )Index
{
    for (int i = 0 ; i < self.typeArray.count ; i ++) {
        
        [self.statusDictionary setObject:[NSNumber numberWithBool:i==Index?NO:YES] forKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]];
    }
    
    [self.typeListTableView reloadData];
}

#pragma mark - 点击退出
- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    if (self.exitBlock) {
        
        [self hide];
    }
}

#pragma mark - 设置选中回调block
- (void)setClickSelectedTypeBlock:(selectedTypeBlock)block
{
    if (block) {
        
        self.selectedBlock = nil;
        self.selectedBlock = block;
        
        [self hide];
    }
}

#pragma mark - 设置退出block
- (void)setClickExitTypeSelectBlock:(exitTypeSelectBlock)block
{
    if (block) {
        
        self.exitBlock = nil;
        self.exitBlock = block;
    }
}

#pragma mark - 显示内容数组
- (void)setShowContent:(NSArray *)contentArray
{
    if (contentArray) {
        
        self.typeArray = contentArray;
        
        for (int i = 0 ; i < self.typeArray.count ; i ++) {
            
            [self.statusDictionary setObject:[NSNumber numberWithBool:i==0?NO:YES] forKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]];
        }
        
        [self.typeListTableView reloadData];
    }
}

#pragma mark - 显示列表
- (void)show
{
    [self.view layoutIfNeeded];
    
    weakSelf(weakSelf)
    [self.typeListTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.top.mas_equalTo(weakSelf.view.mas_top);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        if (IS_WIDTH_SCREEN())
        {
            make.height.mas_equalTo(DEFAULTCELLHEIGHT * weakSelf.typeArray.count);
        }
        else
        {
            make.height.mas_equalTo(DEFAULTCELLHEIGHT * weakSelf.typeArray.count - 25);
        }
        
    }];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 隐藏列表
- (void)hide
{
    [self.view layoutIfNeeded];
    
    weakSelf(weakSelf)
    [self.typeListTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.bottom.mas_equalTo(weakSelf.view.mas_top);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.height.mas_equalTo(DEFAULTCELLHEIGHT * weakSelf.typeArray.count);
    }];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        self.exitBlock(self.selectedType,self.currentSelectIndex);
    }];
}

//////////////////////////////
#pragma mark - protocol Methods
//////////////////////////////////////////

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.typeArray.count;
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
    return DEFAULTCELLHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MIPullListCell * cell = (MIPullListCell *)[tableView dequeueReusableCellWithIdentifier:@"MIPullListCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    BOOL status = [[self.statusDictionary objectForKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:indexPath.row]]] boolValue];
    [cell updateTitle:[self.typeArray objectAtIndex:indexPath.row] Status:status];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentSelectIndex = indexPath.row;
    self.selectedType = [self.typeArray objectAtIndex:indexPath.row];
    
    for (NSString * key in self.statusDictionary.allKeys) {
        
        [self.statusDictionary setObject:[NSNumber numberWithBool:YES] forKey:key];
    }
    
    [self.statusDictionary setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:indexPath.row]]];
    
    if (self.selectedBlock) {
        
        self.selectedBlock(self.selectedType,self.currentSelectIndex);
    }
    
    [self.typeListTableView reloadData];
    
    [self hide];
}

///////////////////
#pragma mark - setter/getter
////////////////////////////////////////////

#pragma mark - typeArray
- (NSArray *)typeArray
{
    if (!_typeArray) {
        
        _typeArray = [[NSArray alloc]init];
    }
    return _typeArray;
}
     
#pragma mark - statusDictionary
- (NSMutableDictionary *)statusDictionary{

    if (!_statusDictionary) {
        
        _statusDictionary = [[NSMutableDictionary alloc]init];
    }
    return _statusDictionary;
}

#pragma mark - TapGesture
- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    }
    return _tapGesture;
}

#pragma mark - typeListTableView
- (UITableView *)typeListTableView
{
    if (!_typeListTableView) {
        
        _typeListTableView = [[UITableView alloc]init];
        _typeListTableView.dataSource = self;
        _typeListTableView.delegate = self;
    }
    return _typeListTableView;
}

@end
