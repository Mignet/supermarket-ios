//
//  RollOutSucceedViewController.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/22.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "RollOutSucceedViewController.h"

@interface RollOutSucceedViewController ()

@property (weak, nonatomic) IBOutlet UILabel *rollOutDescribeLabel;

@end

@implementation RollOutSucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

////////////////////////
#pragma mark - custom method
////////////////////////////

- (void)initView
{
    self.navigationItem.title = @"转出成功";
    
    self.rollOutDescribeLabel.text = [NSString stringWithFormat:@"成功转出%@元至猎财大师账户余额", self.transferBouns];
}

@end
