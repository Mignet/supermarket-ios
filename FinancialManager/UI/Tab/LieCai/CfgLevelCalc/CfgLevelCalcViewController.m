//
//  CfgLevelCalcViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 5/24/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "CfgLevelCalcViewController.h"
#import "UniversalInteractWebViewController.h"
#import "CustomActionSheet.h"
#import "UINavigationItem+Extension.h"
#import "RankListModule.h"
#import "RankCalcBaseDataListMode.h"
#import "RankCalcLevelMode.h"

#define DEFAULT_CELL_HEIGHT 35.0f
#define DEFAULT_OWNER_ANNUAL_TEXT 0
#define DEFAULT_DIRECT_CFG_ANNUAL_TEXT 0
#define DEFAULT_SECOND_CFG_ANNUAL_TEXT 0
#define DEFAULT_THIRD_CFG_ANNUAL_TEXT 0

@interface CfgLevelCalcViewController ()<CustomNumberKeyboardProtocol, RankListModuleObserver, CustomActionSheetDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, weak) IBOutlet UIView *topView;
@property (nonatomic, weak) IBOutlet UILabel *levelLabel;
@property (nonatomic, weak) IBOutlet UILabel *commissionLabel;

@property (nonatomic, weak) IBOutlet UIImageView *inputBackgroundImageView;
@property (nonatomic, weak) IBOutlet UIView *inputView;

@property (nonatomic, weak) IBOutlet UILabel *ownerLabel;
@property (nonatomic, weak) IBOutlet UITextField *ownerAnnualTextField;
@property (nonatomic, weak) IBOutlet UILabel *ownerIncomeLabel;

@property (nonatomic, weak) IBOutlet UIView *directCfgView;
@property (nonatomic, weak) IBOutlet UITextField *directCfgTextField;
@property (nonatomic, weak) IBOutlet UILabel *directCfgIncomeLabel;

@property (nonatomic, weak) IBOutlet UIView *secondCfgView;
@property (nonatomic, weak) IBOutlet UITextField *secondCfgTextField;
@property (nonatomic, weak) IBOutlet UILabel *secondCfgIncomeLabel;

@property (nonatomic, weak) IBOutlet UIView *thirdCfgView;
@property (nonatomic, weak) IBOutlet UITextField *thirdCfgTextField;
@property (nonatomic, weak) IBOutlet UILabel *thirdCfgIncomeLabel;

@property (nonatomic, strong) IBOutlet UIView *totalIncomeView;
@property (nonatomic, strong) IBOutlet UILabel *totalIncomeLabel;

@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@property (nonatomic, strong) CustomNumberKeyboard *customKeyboardView;
@property (nonatomic, strong) RankListModule *module;

@property (nonatomic, strong) NSMutableArray *levelArray;
@property (nonatomic, strong) NSMutableArray *levelNameArray;
@property (nonatomic, strong) NSMutableArray *annualCommisionArray;
@property (nonatomic, assign) NSInteger nSelectedOption; //选中职级类型或年化佣金率
@property (nonatomic, assign) NSInteger nLevelNo; //职级编号

@end

@implementation CfgLevelCalcViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)willDealloc
{
    return NO;
}

- (void)dealloc
{
    [self.module removeObserver:self];
    self.customKeyboardView.keyBoardDelegate = nil;
    self.customKeyboardView = nil;
}

/////////////////////
#pragma mark - 自定义方法
///////////////////////////////

#pragma mark - 自定义方法
- (void)initView
{
    self.title = @"职级收入计算器";
    [self.navigationItem addRightBarItemWithTitle:@"说明" titleColor:UIColorFromHex(0xffffff) target:self action:@selector(explainAction)];
    [self.view addSubview:self.totalIncomeView];
    weakSelf(weakSelf)
    [self.totalIncomeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.right.mas_equalTo(weakSelf.view.mas_right);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(DEFAULT_CELL_HEIGHT);
    }];

    self.ownerAnnualTextField.inputView = self.customKeyboardView;
    self.directCfgTextField.inputView = self.customKeyboardView;
    self.secondCfgTextField.inputView = self.customKeyboardView;
    self.thirdCfgTextField.inputView = self.customKeyboardView;

    self.module = [[RankListModule alloc] init];
    [self.module addObserver:self];
    [self.module requestRankCalcBaseDataList];
    [self.view showGifLoading];

}

#pragma mark - 更新ui
- (void)updateUI
{
    weakSelf(weakSelf)
    __weak UIView *weakTopView = self.topView;
    switch (self.nLevelNo) {
        case TraineeCfgType: //见习
        case ConsultantCfgType: //顾问
        {
            //隐藏2、3级推荐理财师
            self.secondCfgView.hidden = YES;
            self.thirdCfgView.hidden = YES;
            self.secondCfgTextField.text = @"";
            self.thirdCfgTextField.text = @"";
           
            [self.inputBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakTopView.mas_bottom).offset(-20);
                make.left.mas_equalTo(weakSelf.view.mas_left);
                make.right.mas_equalTo(weakSelf.view.mas_right);
                make.height.mas_equalTo(DEFAULT_CELL_HEIGHT * 3 + 40);
            }];
            
            [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakTopView.mas_bottom);
                make.left.mas_equalTo(weakSelf.view.mas_left).offset(15);
                make.right.mas_equalTo(weakSelf.view.mas_right).offset(-15);
                make.height.mas_equalTo(DEFAULT_CELL_HEIGHT * 3);
            }];
            
        }
            break;
        case ManagerCfgType: //经理
        case MajordomoCfgType: //总监
        {
            //显示2、3级推荐理财师
            self.secondCfgView.hidden = NO;
            self.thirdCfgView.hidden = NO;
            [self.inputBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakTopView.mas_bottom).offset(-20);
                make.left.mas_equalTo(weakSelf.view.mas_left);
                make.right.mas_equalTo(weakSelf.view.mas_right);
                make.height.mas_equalTo(DEFAULT_CELL_HEIGHT * 5 + 40);
            }];
            
            [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakTopView.mas_bottom);
                make.left.mas_equalTo(weakSelf.view.mas_left).offset(15);
                make.right.mas_equalTo(weakSelf.view.mas_right).offset(-15);
                make.height.mas_equalTo(DEFAULT_CELL_HEIGHT * 5);
            }];

        }
            break;
        default:
            break;
    }
}

#pragma mark - 说明
- (void)explainAction
{
    UniversalInteractWebViewController * ctrl = [[UniversalInteractWebViewController alloc]initRequestUrl:[_LOGIC getComposeUrlWithBaseUrl:[[AppFramework getConfig].XN_REQUEST_H5_BASE_URL  stringByAppendingString:@"/pages/rank/rank_desc.html"] compose:@""] requestMethod:@"GET"];
    [ctrl setNewWebView:YES];
    
    [_UI pushViewControllerFromRoot:ctrl animated:YES];
}

#pragma mark - 计算收入值
- (void)updateIncomeCalc
{
    CGFloat fAnnualCommision = [[self.commissionLabel.text stringByReplacingOccurrencesOfString:@"%" withString:@""] floatValue];
    
    NSInteger nOwnerAnnual = DEFAULT_OWNER_ANNUAL_TEXT;
    NSInteger nDirectCfgAnnual = DEFAULT_DIRECT_CFG_ANNUAL_TEXT;
    NSInteger nSecondCfgAnnual = DEFAULT_SECOND_CFG_ANNUAL_TEXT;
    NSInteger nThirdCfgAnnual = DEFAULT_THIRD_CFG_ANNUAL_TEXT;
    
    if (self.ownerAnnualTextField.text.length > 0)
    {
        nOwnerAnnual = [self.ownerAnnualTextField.text integerValue];
    }
    
    if (self.directCfgTextField.text.length > 0)
    {
        nDirectCfgAnnual = [self.directCfgTextField.text integerValue];
    }
    
    if (self.secondCfgTextField.text.length > 0)
    {
        nSecondCfgAnnual = [self.secondCfgTextField.text integerValue];
    }
    
    if (self.thirdCfgTextField.text.length > 0)
    {
        nThirdCfgAnnual = [self.thirdCfgTextField.text integerValue];
    }
    
    CGFloat fOwnerIncome = (nOwnerAnnual * 10000 * fAnnualCommision) / 100;
    CGFloat fDirectCfgIncome = 0.0f;
    CGFloat fSecondCfgIncome = 0.0f;
    CGFloat fThirdCfgIncome = 0.0f;
    self.ownerIncomeLabel.text = [NSString stringWithFormat:@"%d", (int)fOwnerIncome];
    
    switch (self.nLevelNo) {
        case TraineeCfgType: //见习
        case ConsultantCfgType: //顾问
        {
            fDirectCfgIncome = (nDirectCfgAnnual * 10000 * fAnnualCommision) / 100 * 1.6;
            self.directCfgIncomeLabel.text = [NSString stringWithFormat:@"%d", (int)fDirectCfgIncome];
            self.totalIncomeLabel.text = [NSString stringWithFormat:@"%d", (int)(fOwnerIncome + fDirectCfgIncome)];
        }
            break;
        case ManagerCfgType: //经理
        {
            fDirectCfgIncome = (nDirectCfgAnnual * 10000 * fAnnualCommision) / 100 * 2.2;
            fSecondCfgIncome = (nSecondCfgAnnual * 10000 * fAnnualCommision) / 100 * 0.3;
            fThirdCfgIncome = (nThirdCfgAnnual * 10000 * fAnnualCommision) / 100 * 0.3;
            self.directCfgIncomeLabel.text = [NSString stringWithFormat:@"%d", (int)fDirectCfgIncome];
            self.secondCfgIncomeLabel.text = [NSString stringWithFormat:@"%d", (int)fSecondCfgIncome];
            self.thirdCfgIncomeLabel.text = [NSString stringWithFormat:@"%d", (int)fThirdCfgIncome];
            self.totalIncomeLabel.text = [NSString stringWithFormat:@"%d", (int)(fOwnerIncome + fDirectCfgIncome + fSecondCfgIncome + fThirdCfgIncome)];
            
        }
            break;
        case MajordomoCfgType: //总监
        {
            fDirectCfgIncome = (nDirectCfgAnnual * 10000 * fAnnualCommision) / 100 * 2.6;
            fSecondCfgIncome = (nSecondCfgAnnual * 10000 * fAnnualCommision) / 100 * 0.5;
            fThirdCfgIncome = (nThirdCfgAnnual * 10000 * fAnnualCommision) / 100 * 0.5;
            self.directCfgIncomeLabel.text = [NSString stringWithFormat:@"%d", (int)fDirectCfgIncome];
            self.secondCfgIncomeLabel.text = [NSString stringWithFormat:@"%d", (int)fSecondCfgIncome];
            self.thirdCfgIncomeLabel.text = [NSString stringWithFormat:@"%d", (int)fThirdCfgIncome];
            self.totalIncomeLabel.text = [NSString stringWithFormat:@"%d", (int)(fOwnerIncome + fDirectCfgIncome + fSecondCfgIncome + fThirdCfgIncome)];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 退出键盘
- (void)exitKeyboard:(UIGestureRecognizer *)gesture
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - 键盘将要显示
- (void)keyboardShow:(NSNotification *)notifx
{
    [self.view addGestureRecognizer:self.tapGesture];
    
    if ([self.ownerAnnualTextField isFirstResponder])
    {
        self.customKeyboardView.value = self.ownerAnnualTextField.text;
    }
    
    if ([self.directCfgTextField isFirstResponder])
    {
        self.customKeyboardView.value = self.directCfgTextField.text;
    }
    
    if ([self.secondCfgTextField isFirstResponder])
    {
        self.customKeyboardView.value = self.secondCfgTextField.text;
    }
    
    if ([self.thirdCfgTextField isFirstResponder])
    {
        self.customKeyboardView.value = self.thirdCfgTextField.text;
    }
    
    CGRect keyboardBounds;
    [[notifx.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notifx.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notifx.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // 键盘的位置和大小
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    weakSelf(weakSelf)
    [self.totalIncomeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.top.mas_equalTo(weakSelf.view.mas_bottom).offset(-keyboardBounds.size.height - 35);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.height.mas_equalTo(35);
    }];
    
    CGFloat finterval = 0;
    
    if (IOS_IPHONE4_SCREEN)
    {
        switch (self.nLevelNo) {
            case TraineeCfgType: //见习
            case ConsultantCfgType: //顾问
            {
                finterval = 0;
            }
                break;
            default:
            {
                finterval = keyboardBounds.size.height + 35 - (self.view.size.height - self.secondCfgView.frame.origin.y - DEFAULT_CELL_HEIGHT * 4);
                [self.mainScrollView setContentSize:CGSizeMake(self.view.size.width, self.view.size.height + keyboardBounds.size.height)];
            }
                break;
        }
    }
    
    // 动画改变位置
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        if (finterval > 0)
        {
            [self.mainScrollView setContentOffset:CGPointMake(0, finterval)];
        }
        [weakSelf.view layoutIfNeeded];
    }];
    
}

#pragma mark - 键盘将要消失
- (void)keyboardHide:(NSNotification *)notif
{
    [self.view removeGestureRecognizer:self.tapGesture];
    
    CGRect keyboardBounds;
    [[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 键盘的位置和大小
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    weakSelf(weakSelf)
    
    [self.totalIncomeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(35);
    }];
    
    // 动画改变位置
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        
        [self.mainScrollView setContentOffset:CGPointMake(0, 0)];
        [self.mainScrollView setContentSize:CGSizeZero];
        
        [weakSelf.view layoutIfNeeded];
    }];
    
}

#pragma mark - 选择职级
- (IBAction)levelAction:(id)sender
{
    [self exitKeyboard:nil];
    self.ownerAnnualTextField.text = @"";
    self.directCfgTextField.text = @"";
    self.secondCfgTextField.text = @"";
    self.thirdCfgTextField.text = @"";
    self.nSelectedOption = LevelSelectedType;
    CustomActionSheet *levelActionSheet = [[CustomActionSheet alloc] initWithTitle:@"请选择职级类型" list:self.levelNameArray];
    levelActionSheet.delegate = self;
    [levelActionSheet showInView:self];
}

#pragma mark - 选择年化佣金
- (IBAction)annualCommisionAction:(id)sender
{
    [self exitKeyboard:nil];
    self.nSelectedOption = AnnualCommisionSelectedType;
    CustomActionSheet *annualCommisionActionSheet = [[CustomActionSheet alloc] initWithTitle:@"请选择佣金率" list:self.annualCommisionArray];
    annualCommisionActionSheet.delegate = self;
    [annualCommisionActionSheet showInView:self];
}

/////////////////////
#pragma mark - Protocal
//////////////////////////////////

#pragma mark - RankListModuleObserver
- (void)xnRankListModuleGetRankCalcBaseDataListDidSuccess:(RankListModule *)module
{
    [self.view hideLoading];
    self.levelArray = [[[module.rankCalcBaseDataListMode.crmCfgLevelList reverseObjectEnumerator] allObjects] mutableCopy];
    
    for (RankCalcLevelMode *mode in self.levelArray)
    {
        [self.levelNameArray addObject:mode.levelName];
    }
    
    RankCalcLevelMode *mode = self.levelArray.firstObject;
    self.levelLabel.text = mode.levelName;
    self.nLevelNo = mode.levelWeight;
    
    NSMutableArray *commisionArray = [NSMutableArray array];
    for (NSString *str in module.rankCalcBaseDataListMode.feeTypeList)
    {
        NSString *commision = [NSString stringWithFormat:@"%@%@", str, @"%"];
        [commisionArray addObject:commision];
    }
    
    self.annualCommisionArray = [[[commisionArray reverseObjectEnumerator] allObjects] mutableCopy];
    
    self.commissionLabel.text = [self.annualCommisionArray firstObject];
    //先刷新UI
    [self updateUI];
    //计算初始值
    [self updateIncomeCalc];
}

- (void)xnRankListModuleGetRankCalcBaseDataListDidFailed:(RankListModule *)module
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

#pragma mark - CustomActionSheetDelegate
- (void)didSelectIndex:(NSInteger)index
{
    switch (self.nSelectedOption) {
        case LevelSelectedType: //职级类型
        {
            RankCalcLevelMode *mode = [self.levelArray objectAtIndex:index];
            self.levelLabel.text = mode.levelName;
            self.ownerLabel.text = [NSString stringWithFormat:@"%@自己出单", mode.levelName];
            self.nLevelNo = mode.levelWeight;
            [self updateUI];
        }
            break;
        case AnnualCommisionSelectedType: //年化佣金率
        {
            self.commissionLabel.text = [self.annualCommisionArray objectAtIndex:index];
        }
            break;
        default:
            break;
    }
    [self updateIncomeCalc];
}

#pragma mark - 输入框获得焦点
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.customKeyboardView.value = textField.text;
}

#pragma mark - CustomNumberKeyboardProtocol
- (void)CustomNumberKeyboardValueDidChangeWithChangeStr:(NSString * _Nonnull)changeStr lastChar:(NSString * _Nonnull)lastChar
{
    JCLogInfo(@"changeStr:%@,lastChar:%@",changeStr,lastChar);
    
    //自己出单
    if (self.ownerAnnualTextField.isFirstResponder)
    {
        if ([lastChar isEqualToString:@"."] || changeStr.length > 5)
        {
            self.customKeyboardView.value = self.ownerAnnualTextField.text;
            return;
        }
        
        self.ownerAnnualTextField.text = changeStr;
    }
    
    //直接推荐理财师出单
    if (self.directCfgTextField.isFirstResponder)
    {
        if ([lastChar isEqualToString:@"."] || changeStr.length > 5)
        {
            self.customKeyboardView.value = self.directCfgTextField.text;
            return;
        }
        
        self.directCfgTextField.text = changeStr;
    }
    
    //二级推荐理财师出单
    if (self.secondCfgTextField.isFirstResponder)
    {
        if ([lastChar isEqualToString:@"."] || changeStr.length > 5)
        {
            self.customKeyboardView.value = self.secondCfgTextField.text;
            return;
        }
        
        self.secondCfgTextField.text = changeStr;
    }
    
    //三级推荐理财师出单
    if (self.thirdCfgTextField.isFirstResponder)
    {
        if ([lastChar isEqualToString:@"."] || changeStr.length > 5)
        {
            self.customKeyboardView.value = self.thirdCfgTextField.text;
            return;
        }
        
        self.thirdCfgTextField.text = changeStr;
    }

    [self updateIncomeCalc];
}

//////////////////////
#pragma mark - setter/getter
///////////////////////////////////

#pragma mark - customKeyboardView
- (CustomNumberKeyboard *)customKeyboardView
{
    if (!_customKeyboardView)
    {
        _customKeyboardView = [CustomNumberKeyboard defaultCustomNumberKeyboard];
        _customKeyboardView.frame = CGRectMake(0 , 0, SCREEN_FRAME.size.width, (250.0 * SCREEN_FRAME.size.width) /375.0);
        _customKeyboardView.keyBoardDelegate = self;
    }
    
    return _customKeyboardView;
}

#pragma mark - levelArray
- (NSMutableArray *)levelArray
{
    if (!_levelArray)
    {
        _levelArray = [NSMutableArray array];
    }
    return _levelArray;
}

#pragma mark - levelNameArray
- (NSMutableArray *)levelNameArray
{
    if (!_levelNameArray)
    {
        _levelNameArray = [NSMutableArray array];
    }
    return _levelNameArray;
}

#pragma mark - annualCommisionArray
- (NSMutableArray *)annualCommisionArray
{
    if (!_annualCommisionArray)
    {
        _annualCommisionArray = [NSMutableArray array];
    }
    return _annualCommisionArray;
}

#pragma mark - tapGesture
- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture)
    {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitKeyboard:)];
    }
    return _tapGesture;
}

@end
