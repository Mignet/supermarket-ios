//
//  YetSignViewController.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/17.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "YetSignViewController.h"
#import "SignRecordViewController.h"

#define YET_SIGN_BG_SCALE ((776.f * SCREEN_FRAME.size.width) / 375.f)
#define SCALE (SCREEN_FRAME.size.width / 375.f)

@interface YetSignViewController ()

@property (weak, nonatomic)
IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHight;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyLabelTop;


@property (weak, nonatomic) IBOutlet UILabel *numDayLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numDayLabelTop;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareBtnTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareBtnH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareBtnW;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allPriceTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showViewHeigt;

@end

@implementation YetSignViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

////////////////////////////
#pragma mark - custom method
///////////////////////////

- (void)initView
{
    self.navigationItem.title = @"每日签到";
    
    //距离适配
    self.bgViewHight.constant = YET_SIGN_BG_SCALE;
    self.showViewHeigt.constant = 230.f * SCALE;
    self.moneyLabelTop.constant = 30.f * SCALE - 5.f;
    self.numDayLabelTop.constant = 15.f * SCALE - 3.f;
    self.shareBtnTop.constant = 15 * SCALE - 3.f;
    self.shareBtnH.constant = 49 * SCALE;
    self.shareBtnW.constant = 250 * SCALE;
    self.allPriceTop.constant = 15.f * SCALE - 3.f;
}

- (IBAction)shareClick
{
    
}

- (IBAction)checkSignMoneyClick
{
    SignRecordViewController *signRecordVC = [[SignRecordViewController alloc] init];
    [_UI pushViewControllerFromRoot:signRecordVC animated:YES];
}



@end
