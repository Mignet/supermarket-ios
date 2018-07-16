//
//  FeedBackController.m
//  FinancialManager
//
//  Created by xnkj on 15/10/27.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "FeedBackController.h"

#import "UINavigationItem+Extension.h"

#import "XNRelatedModule.h"
#import "XNRelatedModuleObserver.h"

@interface FeedBackController ()<UITextViewDelegate,XNRelatedModuleObserver>

@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;

@property (nonatomic, weak) IBOutlet UILabel     * placeHodeLabel;
@property (nonatomic, weak) IBOutlet UILabel     * leaveCharLabel;
@property (nonatomic, weak) IBOutlet UITextView  * contentTextView;
@end

@implementation FeedBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[XNRelatedModule defaultModule] addObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[XNRelatedModule defaultModule] removeObserver:self];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////
#pragma mark - Custom Method
////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.title = @"意见反馈";
    [self.navigationItem  addCommitButtonItemWithTarget:self action:@selector(clickFeedBack:)];
    
    weakSelf(weakSelf)
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextViewTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        if (weakSelf.contentTextView.text.length > 0) {
            
            [weakSelf.placeHodeLabel setHidden:YES];
        }else
            [weakSelf.placeHodeLabel setHidden:NO];
       
        if(weakSelf.contentTextView.text.length <= 200 ) {
            
            [weakSelf.leaveCharLabel setText:[NSString stringWithFormat:@"还可以输入%@个字",@(200 - weakSelf.contentTextView.text.length)]];
            //添加markedTextRange来避免中文输入中提示文字的影响导致substringToIndex越界的问题
        }else if(weakSelf.contentTextView.markedTextRange == nil)
        {
            weakSelf.contentTextView.text = [weakSelf.contentTextView.text substringToIndex:200];
             [weakSelf.leaveCharLabel setText:[NSString stringWithFormat:@"还可以输入0个字"]];
        }
    }];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 键盘显示
- (void)keyboardShow:(NSNotification *)notif
{
    [self.view addGestureRecognizer:self.tapGesture];
}

#pragma mark - 键盘隐藏
- (void)keyboardHide:(NSNotification *)notif
{
    [self.view removeGestureRecognizer:self.tapGesture];
}

#pragma mark - 提交反馈内容
- (void)clickFeedBack:(UIButton *)sender
{
    if (self.contentTextView.text.length <= 0) {
        
        [self showCustomWarnViewWithContent:@"请输入内容"];
        return;
    }
    
    [[XNRelatedModule defaultModule] feedBackContent:self.contentTextView.text];
    [self.view showLoadingForTitle:@"请稍后..."];
    [_KEY_WINDOW endEditing:YES];
}

#pragma mark - 退出键盘
- (void)exitKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

///////////////////
#pragma mark - Protocol
/////////////////////////////////////////

#pragma mark - 
- (void)XNMyInfoModuleFeedBackDidReceive:(XNRelatedModule *)module
{
    [self.view hideLoading];
    
    [self showCustomWarnViewWithContent:@"提交成功!" Completed:^{
       
        [_UI popViewControllerFromRoot:YES];
    }];
}

- (void)XNMyInfoModuleFeedBackDidFailed:(XNRelatedModule *)module
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
