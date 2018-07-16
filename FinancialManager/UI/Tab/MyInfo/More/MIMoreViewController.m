//
//  MIMoreViewController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/24.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "MIMoreViewController.h"
#import "MIMoreCell.h"

#import "UseLoginViewController.h"
#import "FeedBackController.h"
#import "IMManager.h"
#import "CustomerChatManager.h"

#import "WeChatManager.h"
#import "UniversalInteractWebViewController.h"

#import "IMManager.h"

#import "XNUserInfo.h"
#import "XNUserModule.h"
#import "XNUserModuleObserver.h"

#import "XNUpgradeMode.h"
#import "XNCommonModule.h"
#import "XNConfigMode.h"

#define DEFAULTCELLHEIGHT 44.0f;

@interface MIMoreViewController ()<XNUserModuleObserver,UIAlertViewDelegate>

@property (nonatomic, strong) NSArray * contentArray;

@property (nonatomic, weak) IBOutlet UILabel     * versionLabel;
@property (nonatomic, weak) IBOutlet UITableView * listTableView;
@end

@implementation MIMoreViewController

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[XNUserModule defaultModule] addObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[XNUserModule defaultModule] removeObserver:self];
    
    [super viewDidDisappear:animated];
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
    [self setTitle:@"更多"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.versionLabel setText:[NSString stringWithFormat:@"版本 %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]]];
    
    [self.listTableView registerNib:[UINib nibWithNibName:@"MIMoreCell" bundle:nil] forCellReuseIdentifier:@"MIMoreCell"];
    [self.listTableView setSeparatorColor:[UIColor clearColor]];
}

//////////////////////////////
#pragma mark - protocol Methods
//////////////////////////////////////////

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[self.contentArray objectAtIndex:indexPath.row] objectForKey:@"cellHeight"] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MIMoreCell * cell = (MIMoreCell *)[tableView dequeueReusableCellWithIdentifier:@"MIMoreCell"];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell updateContent:[self.contentArray objectAtIndex:indexPath.row] topSeperatorHidden:[[[self.contentArray objectAtIndex:indexPath.row] objectForKey:@"hiddenTopSeperator"] boolValue] hideSeperator:[[[self.contentArray objectAtIndex:indexPath.row] objectForKey:@"hiddenFullSeperator"] boolValue] ];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case AbountUs:
        {
            UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:[[[XNCommonModule defaultModule] configMode] aboutMeUrl] requestMethod:@"GET"];
            [webCtrl.view setBackgroundColor:[UIColor whiteColor]];
            
            [_UI pushViewControllerFromRoot:webCtrl animated:YES];
        }
            break;
        case WXGroup:
        {
            NSString *serviceMailString = @"linghuikeji88";
            UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
            pasteBoard.string = serviceMailString;
            [self showCustomWarnViewWithContent:@"已复制"];
        }
            break;
        case WX:
        {
            UIPasteboard * pasteBoard = [UIPasteboard generalPasteboard];
            pasteBoard.string = [[[XNCommonModule defaultModule] configMode] wechatNumber];
            
            [self showCustomAlertViewWithTitle:@"猎财大师公众号已复制到剪贴板，你可在微信-公众号搜索并关注" titleFont:13 okTitle:@"去关注" okCompleteBlock:^{
                
                //跳转到微信进行关注操作
                [[WeChatManager sharedManager] openWXApp];
                
            } cancelTitle:@"取消" cancelCompleteBlock:^{
                
            }];
        }
            break;
        case EM:
        {
            NSString *serviceMailString = [[[XNCommonModule defaultModule] configMode] serviceMail];
            UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
            pasteBoard.string = serviceMailString;
            [self showCustomWarnViewWithContent:@"已复制"];
            /*
            [self showCustomAlertViewWithTitle:[NSString stringWithFormat:@"发送客服邮件\n%@", serviceMailString] titleFont:14 okTitle:@"发送" okCompleteBlock:^{
                NSString *stringURL = [NSString stringWithFormat:@"mailto:%@", serviceMailString];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
            } cancelTitle:@"取消" cancelCompleteBlock:^{
                
            }];
             */
        }
            break;
        case UPDATEINFO:
        {
            UniversalInteractWebViewController * ctrl = [[UniversalInteractWebViewController alloc]initRequestUrl:[[AppFramework getConfig].XN_REQUEST_H5_BASE_URL stringByAppendingPathComponent:@"pages/message/update_log.html"] requestMethod:@"GET"];
            
            [_UI pushViewControllerFromRoot:ctrl animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - protocol
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == RemindToUpgrade) {
        
        if (buttonIndex == 0) {
            
            
        }else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[[XNCommonModule defaultModule] upgradeMode] downloadUrl]]];
        }
    }else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[[XNCommonModule defaultModule] upgradeMode] downloadUrl]]];
    }
}



////////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

#pragma mark - contentArray
- (NSArray *)contentArray
{
    if (!_contentArray) {
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        appVersion = [NSString stringWithFormat:@"当前版本%@",appVersion];
        
        _contentArray = [[NSArray alloc]initWithObjects:
                         [NSDictionary dictionaryWithObjectsAndKeys:@"关于猎财",@"title",@"",@"content",@"44",@"cellHeight",@"0",@"hiddenTopSeperator",@"0",@"hiddenFullSeperator", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"官方微信公众号",@"title",[[[XNCommonModule defaultModule] configMode] wechatNumber],@"content",@"56",@"cellHeight",@"1",@"hiddenTopSeperator",@"1",@"hiddenFullSeperator", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"微信交流群",@"title",@"linghuikeji88",@"content",@"44",@"cellHeight",@"1",@"hiddenTopSeperator",@"1",@"hiddenFullSeperator", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"客服邮箱",@"title",[[[XNCommonModule defaultModule] configMode] serviceMail],@"content",@"44",@"cellHeight",@"1",@"hiddenTopSeperator",@"0",@"hiddenFullSeperator", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"更新日志",@"title",@"",@"content",@"56",@"cellHeight",@"1",@"hiddenTopSeperator",@"0",@"hiddenFullSeperator", nil],
                         nil];
    }
    return _contentArray;
}

@end
