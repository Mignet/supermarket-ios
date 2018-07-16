//
//  XNNewUserController.m
//  FinancialManager
//
//  Created by xnkj on 15/11/10.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNNewUserController.h"

static XNNewUserController * obj = nil;

@interface XNNewUserController ()

@property (nonatomic, weak) IBOutlet UIImageView * userImageView;
@end

@implementation XNNewUserController

+ (instancetype)defaultObj
{
   static dispatch_once_t  once ;
   dispatch_once(&once, ^{
      
       obj = [[XNNewUserController alloc]initWithNibName:@"XNNewUserController" bundle:nil];
   });

    return obj;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 刷新图片
- (void)refreshGuideImage:(NSString *)imageName
{
    [self.userImageView setImage:[UIImage imageNamed:imageName]];
}

#pragma mark - 点击
- (IBAction)clickEnter:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(xnNewUserControllerDidClick)]) {
        
        [self.delegate xnNewUserControllerDidClick];
    }
}
@end
