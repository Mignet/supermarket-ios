//
//  MyAccountBookAddItemViewController.m
//  FinancialManager
//
//  Created by xnkj on 19/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyAccountBookAddItemViewController.h"

#import "MyAccountBookInvestItemMode.h"
#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"

@interface MyAccountBookAddItemViewController ()<XNMyInformationModuleObserver,UITextFieldDelegate>

@property (nonatomic, assign) BOOL editAccountBookItem;//是否更新账本还是添加账本
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@property (nonatomic, strong) MyAccountBookInvestItemMode * investItemMode;

@property (nonatomic, weak) IBOutlet UITextField * directionTextField;
@property (nonatomic, weak) IBOutlet UITextField * investMoneyTextField;
@property (nonatomic, weak) IBOutlet UITextField * investProfitTextField;
@property (nonatomic, weak) IBOutlet UILabel     * placeHodeLabel;
@property (nonatomic, weak) IBOutlet UILabel     * leaveCharLabel;
@property (nonatomic, weak) IBOutlet UIButton    * exitKeyBoardButton;
@property (nonatomic, weak) IBOutlet UITextView  * contentTextView;
@end

@implementation MyAccountBookAddItemViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil accountBookItem:(MyAccountBookInvestItemMode *)mode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.investItemMode = mode;
        self.editAccountBookItem = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[XNMyInformationModule defaultModule]removeObserver:self];
}

//////////////////
#pragma mark - 自定义方法
////////////////////////////////////

//初始化
- (void)initView
{
    self.title = @"记一笔";
    
    [[XNMyInformationModule defaultModule] addObserver:self];
    
    weakSelf(weakSelf)
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextViewTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        [weakSelf updateRemark];
    }];
    
    //更新内容
    if (self.editAccountBookItem) {
        
        [self updateUI];
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

//更新内容
- (void)updateUI
{
    self.investMoneyTextField.text = self.investItemMode.investAmt;
    self.investProfitTextField.text = self.investItemMode.investProfit;
    self.directionTextField.text = self.investItemMode.direction;
    self.contentTextView.text = self.investItemMode.remark;
    
    [self updateRemark];
}

//更新记录remark数据输出
- (void)updateRemark
{
    if (self.contentTextView.text.length > 0) {
        
        [self.placeHodeLabel setHidden:YES];
    }else
        [self.placeHodeLabel setHidden:NO];
    
    if(self.contentTextView.text.length <= 120 ) {
        
        [self.leaveCharLabel setText:[NSString stringWithFormat:@"还可以输入%@个字",@(120 - self.contentTextView.text.length)]];
        //添加markedTextRange来避免中文输入中提示文字的影响导致substringToIndex越界的问题
    }else if(self.contentTextView.markedTextRange == nil)
    {
        self.contentTextView.text = [self.contentTextView.text substringToIndex:120];
        [self.leaveCharLabel setText:[NSString stringWithFormat:@"还可以输入0个字"]];
    }
}

//提交
- (IBAction)clickSubmit:(id)sender
{
    if (![NSObject isValidateInitString:self.directionTextField.text]) {
        
        [self.view showCustomWarnViewWithContent:@"请输入投资去向"];
        return;
    }
    
    if (![NSObject isValidateInitString:self.investMoneyTextField.text]) {
        
        [self.view showCustomWarnViewWithContent:@"请输入投资本金"];
        return;
    }
    
    [[XNMyInformationModule defaultModule] requestAccountBookEditWithDetailId:self.editAccountBookItem?self.investItemMode.investId:@"" investAmt:self.investMoneyTextField.text investDirection:self.directionTextField.text profit:self.investProfitTextField.text remark:self.contentTextView.text status:YES];
  
    [self.view showGifLoading];
}

//键盘显示
- (void)keyboardShow:(NSNotification *)notif
{
    [self.exitKeyBoardButton setHidden:NO];
}

//键盘隐藏
- (void)keyboardHide:(NSNotification *)notif
{
    [self.exitKeyBoardButton setHidden:YES];
}

//退出键盘
- (IBAction)exitKeyboard:(UIButton *)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

///////////////////
#pragma mark - 组件回调
/////////////////////////////////////////

//UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString * strMoney = @"";
    if ([textField isEqual:self.investMoneyTextField]) {
        
        strMoney = self.investMoneyTextField.text;
    }else if([textField isEqual:self.investProfitTextField])
    {
        strMoney = self.investProfitTextField.text;
    }
    
    //
    NSString * number = @"^[0-9]*$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    if ([string isEqualToString:@" "] || (![numberPre evaluateWithObject:string] && ![string isEqualToString:@"."])) {
        
        return NO;
    }
    
    if ([NSObject isValidateInitString:strMoney]) {
        
        NSArray * content = [strMoney componentsSeparatedByString:@"."];
        
        if (content.count > 1 && [string isEqualToString:@"."]) {
            
            return NO;
        }
        
        if (content.count >= 2 && [[content lastObject] length] >= 2) {
            
            if ([textField isEqual:self.investMoneyTextField]) {
                
                self.investMoneyTextField.text = [NSString stringWithFormat:@"%@.%@",[[strMoney componentsSeparatedByString:@"."] objectAtIndex:0],[[[strMoney componentsSeparatedByString:@"."] lastObject] substringToIndex:1]];
            }else if([textField isEqual:self.investProfitTextField])
            {
                self.investProfitTextField.text = [NSString stringWithFormat:@"%@.%@",[[strMoney componentsSeparatedByString:@"."] objectAtIndex:0],[[[strMoney componentsSeparatedByString:@"."] lastObject] substringToIndex:1]];
            }
        }
    }
    else
    {
        if ([string hasPrefix:@"."])
        {
            return NO;
        }
    }
    
    return YES;
}

///////////////////
#pragma mark - 网络请求
/////////////////////////////////////////

//上传投资
- (void)XNMyInfoModuleAccountBookEditDidReceive:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    
    [self showCustomWarnViewWithContent:self.editAccountBookItem?@"更新成功":@"提交成功" Completed:^{
       
        [_UI popViewControllerFromRoot:YES];
    }];
}

- (void)XNMyInfoModuleAccountBookEditDidFailed:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

///////////////////
#pragma mark - Setter/getter
/////////////////////////////////////////

#pragma mark - tapGesture
- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exitKeyboard)];
    }
    return _tapGesture;
}
@end
