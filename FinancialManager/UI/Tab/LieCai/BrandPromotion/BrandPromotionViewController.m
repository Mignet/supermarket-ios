//
//  BrandPromotionViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/4/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "BrandPromotionViewController.h"
#import "CustomTapGestureRecognizer.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "WeChatManager.h"

#import "BPInviteCFPViewController.h"
#import "BPInviteCustomerViewController.h"

#define TITLE_WIDTH (SCREEN_FRAME.size.width / 2) - 1
#define TITLE_HEIGHT 43.0f
#define JFZ_COLOR_SELECTED UIColorFromHex(0x4e8cef)
#define JFZ_COLOR_UNSELECTED UIColorFromHex(0x4f5960)

@interface BrandPromotionViewController ()<UIScrollViewDelegate, BPInviteCFPViewControllerDelegate, BPInviteCustomerViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *titleContainerScrollView;
@property (nonatomic, weak) IBOutlet UIScrollView *listScrollView;
@property (nonatomic, strong) UIView *cursorView;

@property (nonatomic, strong) IBOutlet UIView *popView;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIButton *gotoWeChatButton;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *titleTabMutableArray;
@property (nonatomic, strong) NSArray *listCtrlArray;
@property (nonatomic, strong) NSMutableArray *listContentMutableArray;
@property (nonatomic, strong) NSDictionary *sharedDictionary;

@end

@implementation BrandPromotionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////

//初始化操作
- (void)initView
{
    self.title = @"个人推广";
    
    self.popView.hidden = YES;
    [self.view addSubview:self.popView];
    weakSelf(weakSelf)
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view);
    }];
    
    self.cancelButton.layer.borderWidth = 0.5f;
    self.cancelButton.layer.borderColor = UIColorFromHex(0xefefef).CGColor;
    self.gotoWeChatButton.layer.borderWidth = 0.5f;
    self.gotoWeChatButton.layer.borderColor = UIColorFromHex(0xefefef).CGColor;
    
    [self initTabScrollView];

}

//初始化
- (void)initTabScrollView
{
    [self.view layoutIfNeeded];
    [_titleContainerScrollView addSubview:self.cursorView];
    [_titleContainerScrollView setContentSize:CGSizeMake(SCREEN_FRAME.size.width / 4 * self.titleArray.count, 0)];
    
    //添加滑动标题
    UIButton *btn = nil;
    UIButton *lastBtn = nil;
    weakSelf(weakSelf)
    for (int i = 0; i < self.titleArray.count; i++)
    {
        btn = [[UIButton alloc] initWithFrame:CGRectMake(i * TITLE_WIDTH, 0, TITLE_WIDTH, TITLE_HEIGHT)];
        [btn setTag:i];
        [btn.titleLabel setFont:i ==0 ? [UIFont systemFontOfSize:14]:[UIFont systemFontOfSize:14]];
        [btn setTitle:[self.titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:i==0?JFZ_COLOR_SELECTED:JFZ_COLOR_UNSELECTED forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [_titleContainerScrollView addSubview:btn];
        [self.titleTabMutableArray addObject:btn];
        
        __weak UIScrollView *weakTitleContainerScrollView = _titleContainerScrollView;
        __weak UIButton *weakLastBtn = lastBtn;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0)
            {
                make.left.mas_equalTo(weakTitleContainerScrollView.mas_left);
            }
            else if (i == weakSelf.listCtrlArray.count - 1)
            {
                make.left.mas_equalTo(weakLastBtn.mas_right);
                make.right.mas_equalTo(weakTitleContainerScrollView.mas_right);
            }
            else
            {
                make.leading.mas_equalTo(weakLastBtn.mas_trailing);
            }
            make.top.mas_equalTo(weakTitleContainerScrollView.mas_top);
            make.width.mas_equalTo(TITLE_WIDTH);
            make.height.mas_equalTo(TITLE_HEIGHT);
        }];
        lastBtn = btn;

        if (i == 0)
        {
            __weak UIButton *weakButton = btn;
            __weak UIScrollView *weakTitleContainerScrollView = _titleContainerScrollView;
            [self.cursorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(weakButton.mas_centerX);
                make.bottom.mas_equalTo(weakButton.mas_bottom).offset(1.5);
                make.width.equalTo(weakTitleContainerScrollView.mas_width).multipliedBy(0.25);
                make.height.mas_equalTo(2);
            }];
        }
        
    }
    
    //添加滑动内容列表
    UIViewController *ctrl = nil;
    UIViewController *lastCtrl = nil;
    Class classCtrl;
    for (int i = 0; i < self.listCtrlArray.count; i++)
    {
        classCtrl = NSClassFromString([self.listCtrlArray objectAtIndex:i]);
        ctrl = [[classCtrl alloc] initWithNibName:[self.listCtrlArray objectAtIndex:i] bundle:nil];
        ctrl.view.frame = CGRectMake(i * SCREEN_FRAME.size.width, 0, SCREEN_FRAME.size.width, self.listScrollView.frame.size.height);
        [_listScrollView addSubview:ctrl.view];
        
        [self addChildViewController:ctrl];
        [self.listContentMutableArray addObject:ctrl];
        
        __weak UIViewController *weakLastCtrl = lastCtrl;
        __weak UIScrollView *weakScrollView = self.listScrollView;
        [ctrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0)
            {
                make.leading.mas_equalTo(weakScrollView.mas_leading);
            }
            else if (i == weakSelf.listCtrlArray.count - 1)
            {
                make.leading.mas_equalTo(weakLastCtrl.view.mas_trailing);
                make.trailing.mas_equalTo(weakScrollView.mas_trailing);
            }
            else
            {
                make.leading.mas_equalTo(weakLastCtrl.view.mas_trailing);
            }
            
            make.top.mas_equalTo(weakScrollView.mas_top);
            make.bottom.mas_equalTo(weakScrollView.mas_bottom);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.equalTo(weakScrollView);
        }];
        lastCtrl = ctrl;
        
        if (i == 0)
        {
            BPInviteCFPViewController *controller = (BPInviteCFPViewController *)ctrl;
            controller.delegate = self;
        }
        else
        {
            BPInviteCustomerViewController *controller = (BPInviteCustomerViewController *)ctrl;
            controller.delegate = self;
        }
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
}

#pragma mark - 选中标题操作
- (void)selectedTab:(UIButton *)sender
{
    for (UIButton *btn in self.titleTabMutableArray)
    {
        if ([btn isEqual:sender])
        {
            [btn setTitleColor:JFZ_COLOR_SELECTED forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        }
        else
        {
            [btn setTitleColor:JFZ_COLOR_UNSELECTED forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        }
    }
    
    NSInteger index = [self.titleTabMutableArray indexOfObject:sender];
    
    __weak UIButton *weakButton = sender;
    __weak UIScrollView *weakScrollView = _titleContainerScrollView;
    [self.cursorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakButton.mas_centerX);
        make.bottom.mas_equalTo(weakButton.mas_bottom).offset(1.5);
        make.width.equalTo(weakScrollView.mas_width).multipliedBy(0.25);
        make.height.mas_equalTo(2);
    }];
    
    [UIView animateWithDuration:VIEWANIMATIONDURATION animations:^{
        [self.view layoutIfNeeded];
        [self.listScrollView setContentOffset:CGPointMake(index * SCREEN_FRAME.size.width, 0)];
    }];
    
}

#pragma mark - 弹框中的按钮操作
- (IBAction)shareButtonAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0: //考虑一下
        {
            self.popView.hidden = YES;
        }
            break;
        case 1: //去微信分享
        {
            NSString *content = [self.sharedDictionary objectForKey:@"content"];
            UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
            pasteBoard.string = content;
            //合并图片
            [self mergePicture];
            
            [[WeChatManager sharedManager] openWXApp];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 合并图片
- (void)mergePicture
{
    NSString *urlString = [_LOGIC getImagePathUrlWithBaseUrl:[self.sharedDictionary objectForKey:@"qrcode"]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    UIImage *qrcodeImage = [UIImage imageWithData:data];
    
    for (NSString *picUrlString in [self.sharedDictionary objectForKey:@"selectedPicUrlsArray"])
    {
        CGFloat fWidth = 145.f;//CGImageGetWidth(imgRef) * 2 / 5;
        CGFloat fHeight = 145;//CGImageGetHeight(imgRef) * 2 / 5;
        
        //底部图片
        NSData *datas = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_LOGIC getImagePathUrlWithBaseUrl:picUrlString]]];
        UIImage *backImage = [UIImage imageWithData:datas];
        CGImageRef backImgRef = backImage.CGImage;
        CGFloat fBackImgWidth = CGImageGetWidth(backImgRef);
        CGFloat fBackImgHeigh = CGImageGetHeight(backImgRef);
        
        UIGraphicsBeginImageContext(CGSizeMake(fBackImgWidth, fBackImgHeigh));
        [backImage drawInRect:CGRectMake(0, 0, fBackImgWidth, fBackImgHeigh)];
        
        CGFloat fYPoint = fBackImgHeigh - (fBackImgHeigh * 73 / 667) - fWidth;
      
        [qrcodeImage drawInRect:CGRectMake((fBackImgWidth - fWidth)/2, fYPoint, fWidth, fHeight)];
        
        UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
        
        
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(resultImage, nil, nil, nil);
    }
    
}

//////////////////////////////
#pragma mark - protocol Methods
//////////////////////////////////////////

#pragma mark - UIScrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.listScrollView])
    {
        
        NSInteger index = (NSInteger)scrollView.contentOffset.x / SCREEN_FRAME.size.width;
        UIButton *sender = [self.titleTabMutableArray objectAtIndex:index];
        for (UIButton *btn in self.titleTabMutableArray)
        {
            if ([btn isEqual:sender])
            {
                [btn setTitleColor:JFZ_COLOR_SELECTED forState:UIControlStateNormal];
            }
            else
            {
                [btn setTitleColor:JFZ_COLOR_UNSELECTED forState:UIControlStateNormal];
            }
        }
        
        __weak UIButton *weakButton = sender;
        __weak UIScrollView *weakScrollView = _titleContainerScrollView;
        [self.cursorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakButton.mas_centerX);
            make.bottom.mas_equalTo(weakButton.mas_bottom).offset(1.5);
            make.width.equalTo(weakScrollView.mas_width).multipliedBy(0.25);
            make.height.mas_equalTo(2);
        }];
        
        [UIView animateWithDuration:0.3f animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - BPInviteCFPViewControllerDelegate
- (void)BPInviteCFPViewControllerDidSharedWithParams:(NSDictionary *)paramsDic
{
    NSArray *selectedArray = [paramsDic objectForKey:@"selectedPicsArray"];
    if (selectedArray.count <= 0)
    {
        [self.view showCustomWarnViewWithContent:@"您至少选择一张图片"];
        return;
    }
    self.sharedDictionary = paramsDic;
    self.popView.hidden = NO;
}

#pragma mark - BPInviteCustomerViewControllerDelegate
- (void)BPInviteCustomerViewControllerDidSharedWithParams:(NSDictionary *)paramsDic
{
    NSArray *selectedArray = [paramsDic objectForKey:@"selectedPicsArray"];
    if (selectedArray.count <= 0)
    {
        [self.view showCustomWarnViewWithContent:@"您至少选择一张图片"];
        return;
    }
    self.sharedDictionary = paramsDic;
    self.popView.hidden = NO;
}

///////////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

- (UIView *)cursorView
{
    if (!_cursorView)
    {
        _cursorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width / 4, 2)];
        _cursorView.backgroundColor = JFZ_COLOR_SELECTED;
    }
    return _cursorView;
}

- (NSArray *)titleArray
{
    if (!_titleArray)
    {
        _titleArray = [[NSArray alloc] initWithObjects:@"推荐理财师", @"邀请客户", nil];
    }
    return _titleArray;
}

- (NSMutableArray *)titleTabMutableArray
{
    if (!_titleTabMutableArray)
    {
        _titleTabMutableArray = [[NSMutableArray alloc] init];
    }
    return _titleTabMutableArray;
}

- (NSArray *)listCtrlArray
{
    if (!_listCtrlArray)
    {
        _listCtrlArray = [[NSArray alloc] initWithObjects:@"BPInviteCFPViewController", @"BPInviteCustomerViewController",nil];
    }
    return _listCtrlArray;
}

- (NSMutableArray *)listContentMutableArray
{
    if (!_listContentMutableArray)
    {
        _listContentMutableArray = [[NSMutableArray alloc] init];
    }
    return _listContentMutableArray;
}

- (NSDictionary *)sharedDictionary
{
    if (!_sharedDictionary)
    {
        _sharedDictionary = [[NSDictionary alloc] init];
    }
    return _sharedDictionary;
}


@end
