//
//  MIAuthenticateViewController.m
//  FinancialManager
//
//  Created by xnkj on 6/23/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "MIAuthenticateViewController.h"
#import "UIView+CornerRadius.h"

@interface MIAuthenticateViewController ()

@property (nonatomic, weak) IBOutlet UIView  * bgView;
@end

@implementation MIAuthenticateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/////////////
#pragma mark - Custom Method
//////////////////////////////

#pragma mark - 初始化
- (void)initView
{
    [self.view setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.6]];
    
    [self.bgView drawRoundCornerWithRectSize:CGSizeMake(SCREEN_FRAME.size.width * 0.843, (SCREEN_FRAME.size.width * 0.843 * 182) / 135 * 0.813) backgroundColor:[UIColor whiteColor] borderWidth:1 borderColor:[UIColor whiteColor] radio:5];
}

#pragma mark - 去认证
- (IBAction)clickGoAuthentication:(id)sender
{
    [self clickExit:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(MIAuthenticateViewDidGoAuthenticate)]) {
        
        [self.delegate MIAuthenticateViewDidGoAuthenticate];
    }
}

#pragma mark - 退出
- (IBAction)clickExit:(id)sender
{
    [[AppFramework getGlobalHandler] removePopupView];
    [self.view removeFromSuperview];
}

@end
