//
//  CustomerServiceController.m
//  FinancialManager
//
//  Created by xnkj on 15/10/27.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "CustomerServiceController.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

@interface CustomerServiceController ()

@property (nonatomic, assign) BOOL       isCustomerServer;
@property (nonatomic, strong) NSString * phoneNumber;
@property (nonatomic, strong) NSString * phoneTitle;
@property (nonatomic, weak) IBOutlet UILabel * phoneTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel * phoneLabel;
@property (nonatomic, weak) IBOutlet UILabel * workTimeLabel;
@property (nonatomic, weak) IBOutlet UIButton * confirmButton;

@property (nonatomic, weak) IBOutlet UIView  * phoneView;
@end

@implementation CustomerServiceController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil customerServer:(BOOL)customerServer phoneNumber:(NSString *)phoneNumber phoneTitle:(NSString *)phoneTitle
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.isCustomerServer = customerServer;
        self.phoneNumber = phoneNumber;
        self.phoneTitle = phoneTitle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.6]];
    [self.confirmButton setTitleColor:MONEYCOLOR forState:UIControlStateNormal];
    
    self.phoneLabel.text = self.phoneNumber;
    self.phoneTitleLabel.text = self.phoneTitle;
    
    [self.view addSubview:self.phoneView];
    if (self.isCustomerServer) {
        
        weakSelf(weakSelf)
        [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.center.mas_equalTo(weakSelf.view);
            make.width.mas_equalTo(282);
            make.height.mas_equalTo(172);
        }];
    }else
    {
        [self.workTimeLabel setHidden:YES];
        weakSelf(weakSelf)
        [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.mas_equalTo(weakSelf.view);
            make.width.mas_equalTo(282);
            make.height.mas_equalTo(152);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 取消
- (IBAction)clickCancel:(id)sender
{
    [self.view removeFromSuperview];
}

#pragma mark - 拨打
- (IBAction)clickPhone:(id)sender
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt:%@",self.phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    [self.view removeFromSuperview];
}
@end
