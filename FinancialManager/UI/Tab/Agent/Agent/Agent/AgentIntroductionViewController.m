//
//  AgentIntroductionViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 10/19/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "AgentIntroductionViewController.h"
#import "UIImageView+WebCache.h"
#import "UniversalInteractWebViewController.h"
#import "CustomTapGestureRecognizer.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "AgentTeamMsgViewController.h"
#import "ClickTextView.h"

#import "XNFMAgentDetailMode.h"
#import "XNFMAgentTeamDetailMode.h"
#import "XNCommonModule.h"
#import "XNConfigMode.h"

#define HEIGHT_DEFAULT 126
#define ARROW_VIEW_HEIGHT_DEFAULT 31
#define ARROW_VIEW_DEFAULT_TAG 1000
#define ARROW_IMAGEVIEW_DEFAULT_TAG 10000
#define PLATFORM_INTRODUCT_LABEL 100011
#define PLATFORM_INTRODUCT_VIEW  100012

@interface AgentIntroductionViewController ()

@property (nonatomic, strong) IBOutlet UIView *basicMsgView;

@property (nonatomic, strong) IBOutlet UILabel *registerMoneyLabel; //注册资金
@property (nonatomic, strong) IBOutlet UILabel *onlineTimeLabel; //上线时间
@property (nonatomic, strong) IBOutlet UILabel *cityLabel; //所在城市
@property (nonatomic, strong) IBOutlet UILabel *deadLineLabel; //项目期限
@property (nonatomic, strong) IBOutlet UILabel *securityLevelLabel; //安全评级
@property (nonatomic, strong) IBOutlet UILabel *ICPLabel; //ICP备案
@property (nonatomic, strong) IBOutlet UILabel *serverMobileLabel; //客服电话

@property (nonatomic, strong) IBOutlet UIView *teamView;

@property (nonatomic, strong) XNFMAgentDetailMode *mode;
@property (nonatomic, strong) NSMutableArray *teamsArray;
@property (nonatomic, strong) NSMutableArray *dynamicArray;

@property (nonatomic, assign) float fPlatIntroductHeight; //平台简介的总高度
@property (nonatomic, assign) float fPlatInvestHeight; //投资相关
@property (nonatomic, assign) float fPlatformArchivesHeight; //档案
@property (nonatomic, assign) float fPlatDynamicHeight; //平台动态的总高度
@property (nonatomic, assign) BOOL isDownMsg; //是否下拉显示所有信息
@property (nonatomic, assign) NSInteger nPicIndex; //图片tag
@property (nonatomic, strong) NSMutableArray *picsArray;
@property (nonatomic, strong) NSMutableArray *investTitleArray;
@property (nonatomic, strong) NSMutableArray *investDescArray;

@property (nonatomic, assign) float fPlatIntroductDefaultHeight; //平台简介的默认高度

@end

@implementation AgentIntroductionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil mode:(XNFMAgentDetailMode *)mode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _mode = mode;
        self.teamsArray = [mode.teamInfos mutableCopy];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    
}

//////////////////////////////
#pragma mark - 简介 Methods
//////////////////////////////////////////

- (void)showIntroduction
{
    NSString * str = [_mode.orgProfile stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    UIView *contentView = [self showTextLines:str isPlatIntroduct:YES];
    [self.view addSubview:contentView];
    
    float fPlatIntroductViewHeight = contentView.frame.size.height;
    
    weakSelf(weakSelf)
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(3);
        make.left.equalTo(weakSelf.view.mas_left);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.height.mas_equalTo(fPlatIntroductViewHeight);
    }];
    
    _fPlatIntroductHeight = fPlatIntroductViewHeight + 6;
    
    if (fPlatIntroductViewHeight > self.fPlatIntroductDefaultHeight)
    {
        [self arrowDownViewWithBtnTag:PlatIntroductTag totalHeight:_fPlatIntroductHeight];
        self.fPlatIntroductDefaultHeight += ARROW_VIEW_HEIGHT_DEFAULT;
    }
    
    //显示默认高度
    [self showActualHeight:_fPlatIntroductHeight tabType:PlatIntroductTag defaultHeight:self.fPlatIntroductDefaultHeight showDefaultHeight:YES];
}

//////////////////////////////
#pragma mark - 投资相关 Methods
//////////////////////////////////////////

- (void)showInvestMessage
{
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    
    __weak UIView *weakView = view;
    float fLastHeight = 15;
    float fcellHeight = 0;
    UIView *cellView = nil;
    BOOL isShowLimitTable = NO;
    for (int i = 0; i < self.investTitleArray.count; i++)
    {
        if (i == 1 && self.mode.rechargeLimitTitle.length > 0)
        {
            isShowLimitTable = YES;
        }
        else
        {
            isShowLimitTable = NO;
        }
        
        NSString *descString = [self.investDescArray objectAtIndex:i];
        
        if (descString.length <= 0)
        {
            continue;
        }
        
        cellView = [self investCell:[self.investTitleArray objectAtIndex:i] desc:descString showLimitTable:isShowLimitTable lastHeight:fLastHeight];
        
        if (cellView)
        {
            fcellHeight = cellView.size.height;
            
            [view addSubview:cellView];
            [cellView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakView.mas_left);
                make.right.mas_equalTo(weakView.mas_right);
                make.top.mas_equalTo(weakView.mas_top).offset(fLastHeight);
                make.height.mas_equalTo(fcellHeight);
            }];
        }
        fLastHeight += fcellHeight;
    }

    weakSelf(weakSelf)
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.right.mas_equalTo(weakSelf.view.mas_right);
        make.top.mas_equalTo(weakSelf.view.mas_top);
        make.height.mas_equalTo(fLastHeight);
    }];
    
    _fPlatInvestHeight = fLastHeight + 10;
//    [self arrowDownViewWithBtnTag:InvestMsgTag totalHeight:_fPlatInvestHeight];
    [self showActualHeight:_fPlatInvestHeight tabType:InvestMsgTag defaultHeight:0 showDefaultHeight:NO];
}

- (UIView *)investCell:(NSString *)title desc:(NSString *)desc showLimitTable:(BOOL)isShowLimitTable lastHeight:(float)lastHeight
{
    UIView *view = [[UIView alloc] init];
    
    NSString *descString = [desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = UIColorFromHex(0x666666);
    titleLabel.font = [UIFont systemFontOfSize:12.f];
    titleLabel.text = title;
    
    ClickTextView *descTextView = [[ClickTextView alloc] init];
    descTextView.textColor = UIColorFromHex(0x999999);
    descTextView.font = [UIFont systemFontOfSize:12.f];
    
    weakSelf(weakSelf)
    if (isShowLimitTable)
    {
        NSString *content = [NSString stringWithFormat:@"%@%@", descString, self.mode.rechargeLimitTitle];
        
        descTextView.text = content;
        NSString *orgNameString = [self.mode.orgName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *limitUrl = [NSString stringWithFormat:@"%@?orgNo=%@&orgName=%@",self.mode.rechargeLimitLinkUrl, self.mode.orgNo, orgNameString];
        NSRange range = [content rangeOfString:self.mode.rechargeLimitTitle];
        
        [descTextView setUnderlineTextWithRange:range withUnderlineColor:UIColorFromHex(0x4e8cef) withClickCoverColor:nil withBlock:^(NSString *clickText) {
            if (weakSelf.mode.rechargeLimitLinkUrl.length > 0)
            {
                //跳转到web页面
                UniversalInteractWebViewController *webViewController = [[UniversalInteractWebViewController alloc] initRequestUrl:limitUrl requestMethod:@"GET"];
                [_UI pushViewControllerFromRoot:webViewController animated:YES];
            }
            
        }];
    }
    else
    {
        
        descTextView.text = desc;
    }
    
    //计算字的高度
    CGFloat fTextHeight = [descTextView sizeThatFits:CGSizeMake(SCREEN_FRAME.size.width - 95, 1000)].height;
    
    [view addSubview:titleLabel];
    [view addSubview:descTextView];

    __weak UIView *weakView = view;
    __weak UILabel *weakTitleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakView.mas_top);
        make.left.mas_equalTo(weakView.mas_left).offset(15);
        make.width.mas_equalTo(70);
    }];
    
    [descTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakTitleLabel.mas_top).offset(-8);
        make.left.mas_equalTo(weakTitleLabel.mas_right);
        make.right.mas_equalTo(weakView.mas_right).offset(-10);
        make.height.mas_equalTo(fTextHeight);
    }];
    
    CGFloat fHeight = fTextHeight;
    view.size = CGSizeMake(SCREEN_FRAME.size.width, fHeight);
    
    return view;
}

//////////////////////////////
#pragma mark - 平台动态 Methods
//////////////////////////////////////////

- (void)showPlatDynamic
{
    if (_mode.orgDynamicList == nil || _mode.orgDynamicList.count < 1)
    {
        return;
    }
    [self.dynamicArray addObjectsFromArray:_mode.orgDynamicList];
    CGFloat fHeight = 0.0f;
    weakSelf(weakSelf)
    for (int i = 0; i < self.dynamicArray.count; i ++)
    {
        UIView *view = [self dynamicCell:[self.dynamicArray objectAtIndex:i]];
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        [button addTarget:self action:@selector(platDynamicClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:view];
        [view addSubview:button];
        CGFloat fViewHeight = view.size.height;
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view.mas_top).offset(fHeight);
            make.left.equalTo(weakSelf.view.mas_left);
            make.right.equalTo(weakSelf.view.mas_right);
            make.height.mas_equalTo(fViewHeight);
        }];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        
        fHeight = fHeight + view.size.height;
    }
        
//    [self arrowDownViewWithBtnTag:PlatDynamicTag totalHeight:fHeight];
    _fPlatDynamicHeight = fHeight;
    
    [self showActualHeight:_fPlatDynamicHeight tabType:PlatDynamicTag defaultHeight:0 showDefaultHeight:NO];
    
}

#pragma mark - 平台动态cell
- (UIView *)dynamicCell:(NSDictionary *)dic
{
    UIView *dynamicView = [[UIView alloc] init];
    dynamicView.backgroundColor = [UIColor whiteColor];
    
    //计算字的高度
    CGFloat fHeight = [[dic objectForKey:XN_PLATFORM_DYNAMIC_TITLE] getSpaceLabelHeightWithFont:12 withWidth:SCREEN_FRAME.size.width - 53 lineSpacing:5];
    
    //title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = JFZ_COLOR_GRAY;
    titleLabel.numberOfLines = 0;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[dic objectForKey:XN_PLATFORM_DYNAMIC_TITLE]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[dic objectForKey:XN_PLATFORM_DYNAMIC_TITLE] length])];
    titleLabel.attributedText = attributedString;
    [titleLabel sizeToFit];
    
    //time
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = JFZ_COLOR_LIGHT_GRAY;
    timeLabel.text = [dic objectForKey:XN_PLATFORM_DYNAMIC_TIME];
    
    //arrowImage
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"XN_Home_activity_bg_arrow_readed.png"]];
    
    UIImageView *sepImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"XN_FinancialManager_Institutions_sepline.png"]];
    
    [dynamicView addSubview:titleLabel];
    [dynamicView addSubview:timeLabel];
    [dynamicView addSubview:arrowImageView];
    [dynamicView addSubview:sepImageView];
    
    __weak UIView *weakDynamicView = dynamicView;
    __weak UIImageView *weakArrowImageView = arrowImageView;
    __weak UILabel *weakTitleLabel = titleLabel;
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakDynamicView.mas_centerY);
        make.right.equalTo(weakDynamicView.mas_right).offset(-15);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(14);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakDynamicView.mas_top).offset(5);
        make.left.equalTo(weakDynamicView.mas_left).offset(15);
        make.right.equalTo(weakArrowImageView.mas_left).offset(-15);
        make.height.mas_equalTo(fHeight);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakTitleLabel.mas_bottom);
        make.left.mas_equalTo(weakTitleLabel.mas_left);
        make.right.equalTo(weakArrowImageView.mas_left).offset(-15);
        make.height.mas_equalTo(20);
    }];

    [sepImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakDynamicView.mas_left).offset(12);
        make.right.equalTo(weakDynamicView.mas_right).offset(-12);
        make.bottom.equalTo(weakDynamicView.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    
    dynamicView.size = CGSizeMake(SCREEN_FRAME.size.width, fHeight + 30);
    
    return dynamicView;
}

#pragma mark - 平台动态点击事件
- (void)platDynamicClick:(UIButton *)sender
{
    NSString *dynamicUrlString = [[self.dynamicArray objectAtIndex:sender.tag] objectForKey:XN_PLATFORM_DYNAMIC_URL];
    
    if (![NSObject isValidateInitString:dynamicUrlString])
    {
        NSString *orgId = [[self.dynamicArray objectAtIndex:sender.tag] objectForKey:XN_PLATFORM_DYNAMIC_ID];
        
        dynamicUrlString = [_LOGIC getComposeUrlWithBaseUrl:[[[XNCommonModule defaultModule] configMode] informationDetailUrl] compose:[NSString stringWithFormat:@"type=1&id=%@&t=%@",orgId,[NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]]]];
    }
    
    if (dynamicUrlString.length > 0)
    {
        //跳转到web页面
        UniversalInteractWebViewController *webViewController = [[UniversalInteractWebViewController alloc] initRequestUrl:dynamicUrlString requestMethod:@"GET"];
        [_UI pushViewControllerFromRoot:webViewController animated:YES];
    }

}

//////////////////////////////
#pragma mark - 档案 Methods
//////////////////////////////////////////

- (void)showPlatformMessage
{
    UIView *platHonourView = [self showPlatHonour];
    UIView *basicMsgView = [self showBasicMsg];
    
    [self.view addSubview:platHonourView];
    [self.view addSubview:basicMsgView];
    [self.view addSubview:_teamView];
    
    
    float fBasicMsgViewHeight = basicMsgView.frame.size.height;
    float fPlatHonourViewHeight = platHonourView.frame.size.height;
    float fTeamViewHeight = _teamView.frame.size.height;
    
    weakSelf(weakSelf)
    __weak UIView *weakPlatHonourView = platHonourView;
    __weak UIView *weakBasicMsgView = basicMsgView;
    
    [platHonourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(4);
        make.left.equalTo(weakSelf.view.mas_left);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(fPlatHonourViewHeight);
    }];
    
    [basicMsgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakPlatHonourView.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(fBasicMsgViewHeight);
    }];
    
    [_teamView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakBasicMsgView.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(fTeamViewHeight);
    }];
    
    _fPlatformArchivesHeight = fBasicMsgViewHeight + fPlatHonourViewHeight + fTeamViewHeight;
//    [self arrowDownViewWithBtnTag:ArchivesTag totalHeight:_fPlatformArchivesHeight];
    [self showActualHeight:_fPlatformArchivesHeight tabType:ArchivesTag defaultHeight:0 showDefaultHeight:NO];
}

- (IBAction)teamAction:(id)sender
{
    AgentTeamMsgViewController *viewController = [[AgentTeamMsgViewController alloc] initWithNibName:@"AgentTeamMsgViewController" bundle:nil mode:_mode];
    [_UI pushViewControllerFromRoot:viewController animated:YES];
}

#pragma mark - 头部标题
- (UIView *)headerViewWithTitle:(NSString *)title
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = JFZ_COLOR_GRAY;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = title;
    
    [headerView addSubview:titleLabel];
    
    __weak UIView *weakHeaderView = headerView;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakHeaderView.mas_centerY);
        make.left.equalTo(weakHeaderView.mas_left).offset(12);
        make.height.mas_equalTo(20);
    }];
    headerView.size = CGSizeMake(SCREEN_FRAME.size.width, 30);
    return headerView;
}


#pragma mark - 基本信息
- (UIView *)showBasicMsg
{
    UIView *basicMsgView = [[UIView alloc] init];
    UIView *headerView = [self headerViewWithTitle:@"基本信息"];
    
    [basicMsgView addSubview:headerView];
    [basicMsgView addSubview:_basicMsgView];
    
    float fHeaderViewHeight = headerView.frame.size.height;
    float fContentViewHeight = _basicMsgView.frame.size.height;
    
    __weak UIView *weakBasicMsgView = basicMsgView;
    __weak UIView *weakHeaderView = headerView;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakBasicMsgView.mas_top);
        make.left.equalTo(weakBasicMsgView.mas_left);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(fHeaderViewHeight);
    }];
    
    [_basicMsgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakHeaderView.mas_bottom);
        make.left.equalTo(weakHeaderView.mas_left);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(fContentViewHeight);
    }];

    
    _registerMoneyLabel.text = _mode.capital;
    _onlineTimeLabel.text = _mode.upTime;
    _cityLabel.text = _mode.city;
    //产品期限
    NSArray *deadLineArray = [_mode.deadLineValueText componentsSeparatedByString:@","];
    NSString *minDeadLineString = @""; //最小期限的单位
    NSString *maxDeadLineString = [[deadLineArray lastObject] stringByReplacingOccurrencesOfString:@" " withString:@""]; //最大期限的单位
    NSString *productDeadlineString = @"";
    
    if (deadLineArray.count > 2)
    {
        minDeadLineString = [[deadLineArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""];
        productDeadlineString = [NSString stringWithFormat:@"%@~%@", [[deadLineArray firstObject] stringByReplacingOccurrencesOfString:@" " withString:@""], [[deadLineArray objectAtIndex:2] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    }
    else
    {
        minDeadLineString = maxDeadLineString;
        productDeadlineString = [[deadLineArray firstObject] stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    _deadLineLabel.text = [NSString stringWithFormat:@"%@%@", productDeadlineString, minDeadLineString];
    
    if (![minDeadLineString isEqual:maxDeadLineString])
    {
        _deadLineLabel.text = [NSString stringWithFormat:@"%@%@-%@%@", [[deadLineArray firstObject] stringByReplacingOccurrencesOfString:@" " withString:@""], minDeadLineString, [[deadLineArray objectAtIndex:2] stringByReplacingOccurrencesOfString:@" " withString:@""], maxDeadLineString];
    }
    
    _securityLevelLabel.text = _mode.orgLevel;
    _ICPLabel.text = _mode.icp;
    
    _serverMobileLabel.text = _mode.contact;
    
    basicMsgView.size = CGSizeMake(SCREEN_FRAME.size.width, fHeaderViewHeight + fContentViewHeight);
    return basicMsgView;
}

//拨打电话
- (IBAction)mobileAction:(id)sender
{
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt:%@", _mode.contact];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark - 荣誉
- (UIView *)showPlatHonour
{
    UIView *platHonourView = [[UIView alloc] init];
    UIView *headerView = [[UIView alloc] init];
    UIView *contentView = [[UIView alloc] init];
    
    if (_mode.orgHonor.length > 0)
    {
        headerView = [self headerViewWithTitle:@"公司荣誉"];
        contentView = [self showTextLines:_mode.orgHonor isPlatIntroduct:NO];
    }

    [platHonourView addSubview:headerView];
    [platHonourView addSubview:contentView];
    
    float fHeaderViewHeight = headerView.frame.size.height;
    float fContentViewHeight = contentView.frame.size.height;
    
    __weak UIView *weakPlatHonourView = platHonourView;
    __weak UIView *weakHeaderView = headerView;
    __weak UIView *weakContentView = contentView;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakPlatHonourView.mas_top);
        make.left.equalTo(weakPlatHonourView.mas_left);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(fHeaderViewHeight);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakHeaderView.mas_bottom);
        make.left.equalTo(weakHeaderView.mas_left);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(fContentViewHeight);
    }];
    
    float fPicHeaderViewHeight = 0.0f;
    float fPicViewHeight = 0.0f;
    if (_mode.orgCertificatesList != nil && _mode.orgCertificatesList.count > 0)
    {
        UIView *picHeaderView = [self headerViewWithTitle:@"公司证件及证书"];
        UIView *picView = [self showPictureWithHeight:_mode.orgCertificatesList];
        
        [platHonourView addSubview:picHeaderView];
        [platHonourView addSubview:picView];
        
        fPicHeaderViewHeight = picHeaderView.frame.size.height;
        fPicViewHeight = picView.frame.size.height;
        
        [picHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakContentView.mas_bottom);
            make.left.mas_equalTo(weakContentView.mas_left);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.mas_equalTo(fPicHeaderViewHeight);
        }];
        
        __weak UIView *weakPicHeaderView = picHeaderView;
        [picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakPicHeaderView.mas_bottom);
            make.left.equalTo(weakPicHeaderView.mas_left);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.mas_equalTo(fPicViewHeight);
        }];
    }
    
    platHonourView.size = CGSizeMake(SCREEN_FRAME.size.width, fHeaderViewHeight + fContentViewHeight + fPicHeaderViewHeight + fPicViewHeight + 10);
    return platHonourView;
}

#pragma mark - 图片总高度
- (UIView *)showPictureWithHeight:(NSArray *)pictureArray
{
    UIView *picView = [[UIView alloc] init];
    if (pictureArray == nil || pictureArray.count < 1)
    {
        return picView;
    }
    
    float fLeftPadding = 12.0f; //左右间距
    float fPadding = 7.0f; //图片之间间距
    float fPicWidth = (SCREEN_FRAME.size.width - fLeftPadding * 2 - fPadding * 2) / 3;
    //如果只有一张图，则宽度显示屏幕的宽度大小
    if (pictureArray.count == 1)
    {
        fPicWidth = SCREEN_FRAME.size.width - fLeftPadding * 2;
    }
    float fPicHeight = fPicWidth * 9 / 16;
    
    //总行数
    NSInteger nRow = pictureArray.count % 3 == 0 ? pictureArray.count / 3 : pictureArray.count / 3 + 1;
    //总高度
    float fTotalHeight = fPicHeight * nRow + fPadding * (nRow - 1);
    
    float fTopPadding = 0.0f;
    __weak UIView *weakPicView = picView;
    for (int i = 0; i < pictureArray.count; i ++)
    {
        self.nPicIndex ++;
        NSString *urlString = [_LOGIC getImagePathUrlWithBaseUrl:[[pictureArray objectAtIndex:i] objectForKey:XN_PLATFORM_PICTURE]];
        [self.picsArray addObject:urlString];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderColor = JFZ_LINE_COLOR_GRAY.CGColor;
        imageView.layer.borderWidth = 0.5f;
        imageView.userInteractionEnabled = YES;
        CustomTapGestureRecognizer *tapRecognizer = [[CustomTapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLargeImage:)];
        tapRecognizer.nIndex = self.nPicIndex - 1;
        [imageView addGestureRecognizer:tapRecognizer];

        [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@""]];
        [picView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakPicView.mas_top).offset(fTopPadding);
            make.left.equalTo(weakPicView.mas_left).offset(fLeftPadding);
            make.width.mas_equalTo(fPicWidth);
            make.height.mas_equalTo(fPicHeight);
        }];
        fLeftPadding += fPicWidth + fPadding;
        if ((i + 1) % 3 == 0)
        {
            fLeftPadding = 12.0f;
            fTopPadding += fPicHeight + fPadding;
        }
    }
    
    picView.size = CGSizeMake(SCREEN_FRAME.size.width, fTotalHeight);
    return picView;
}

#pragma mark - 文字高度
- (UIView *)showTextLines:(NSString *)textString isPlatIntroduct:(BOOL)isPlatIntroduct
{
    //计算字的高度
    UIView *view = [[UIView alloc] init];
    [view setTag:PLATFORM_INTRODUCT_VIEW];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setTag:PLATFORM_INTRODUCT_LABEL];
    descLabel.textColor = UIColorFromHex(0x999999);
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.numberOfLines = 0;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0];//调整行间距
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textString length])];
    descLabel.attributedText = attributedString;
    [view addSubview:descLabel];
    
    CGFloat height = [descLabel sizeThatFits:CGSizeMake(SCREEN_FRAME.size.width - 24, 1000)].height;
    [view setFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width, height)];
    
    if (isPlatIntroduct)
    {
//       CGFloat labelHeight = [descLabel sizeThatFits:CGSizeMake(descLabel.frame.size.width, MAXFLOAT)].height;
        CGFloat labelHeight = [@"测试" getSpaceLabelHeightWithFont:12 withWidth:SCREEN_FRAME.size.width - 24 lineSpacing:5];
//        NSInteger count = (fHeight - 12) / labelHeight + 1;
        //默认显示4行高度
        self.fPlatIntroductDefaultHeight = labelHeight * 4 + 3;
        
        __weak UIView *weakView = view;
        weakSelf(weakSelf)
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakView.mas_top);
            make.left.equalTo(weakView.mas_left).offset(12);
            make.right.equalTo(weakView.mas_right).offset(-12);
            make.height.mas_equalTo(weakSelf.fPlatIntroductDefaultHeight);
        }];
    }else
    {
        __weak UIView *weakView = view;
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakView.mas_top);
            make.left.equalTo(weakView.mas_left).offset(12);
            make.right.equalTo(weakView.mas_right).offset(-12);
            make.height.mas_equalTo(height);
        }];
    }

    return view;
}


//////////////////////////////
#pragma mark - 上下箭头 Methods
//////////////////////////////////////////

#pragma mark - 向下展示更多内容
- (void)arrowDownViewWithBtnTag:(NSInteger)buttonTag totalHeight:(float)fTotalHeight
{
    //如果小于默认高度，则不显示下拉图标
//    if (fTotalHeight <= HEIGHT_DEFAULT)
//    {
//        return;
//    }
    
    UIView *arrowView = [[UIView alloc] init];
    arrowView.tag = ARROW_VIEW_DEFAULT_TAG + buttonTag;
    arrowView.backgroundColor = [UIColor whiteColor];
    arrowView.layer.borderColor = [JFZ_LINE_COLOR_GRAY CGColor];
    arrowView.layer.borderWidth = 0.5f;
    
    UIButton *arrowButton = [[UIButton alloc] init];
    arrowButton.tag = buttonTag;
    [arrowButton addTarget:self action:@selector(showMoreMsgAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = [UIImage imageNamed:@"XN_Agent_Arrow_down_icon.png"];
    arrowImageView.tag = ARROW_IMAGEVIEW_DEFAULT_TAG + buttonTag;
    
    [self.view addSubview:arrowView];
    [arrowView addSubview:arrowButton];
    [arrowView addSubview:arrowImageView];
    
    weakSelf(weakSelf)
    __weak UIView *weakArrowView = arrowView;
    
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(ARROW_VIEW_HEIGHT_DEFAULT);
    }];
    
    [arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakArrowView);
    }];
    
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakArrowView.mas_centerY);
        make.centerX.equalTo(weakArrowView.mas_centerX);
        make.width.mas_equalTo(21);
        make.height.mas_equalTo(21);
    }];
    
}

#pragma mar - 显示更多内容
- (void)showMoreMsgAction:(UIButton *)btn
{
    _isDownMsg = !_isDownMsg;
    
    UIView *view = [self.view viewWithTag:(btn.tag + ARROW_VIEW_DEFAULT_TAG)];
    UIImageView *arrowImageView = (UIImageView *)[view viewWithTag:(ARROW_IMAGEVIEW_DEFAULT_TAG + btn.tag)];

    float fTotalHeight = ARROW_VIEW_HEIGHT_DEFAULT;
    switch (btn.tag) {
        case PlatIntroductTag: //平台实力
        {
            fTotalHeight += _fPlatIntroductHeight;
        
            UIView * view = [self.view viewWithTag:PLATFORM_INTRODUCT_VIEW];
            UILabel * descLabel = [view viewWithTag:PLATFORM_INTRODUCT_LABEL];
            
            //向上缩放信息
            __weak UIView *weakView = view;
            if (!_isDownMsg)
            {
                CGFloat labelHeight = [@"测试" getSpaceLabelHeightWithFont:12 withWidth:SCREEN_FRAME.size.width - 24 lineSpacing:5] * 4;
                
                [descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakView.mas_top);
                    make.left.equalTo(weakView.mas_left).offset(12);
                    make.right.equalTo(weakView.mas_right).offset(-12);
                    make.height.mas_equalTo(labelHeight);
                }];
            }
            else
            {
                [descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakView.mas_top);
                    make.left.equalTo(weakView.mas_left).offset(12);
                    make.right.equalTo(weakView.mas_right).offset(-12);
                    make.height.mas_equalTo(weakView.mas_height);
                }];
            }
        }
            break;
        case InvestMsgTag: //投资相关
            fTotalHeight += _fPlatInvestHeight;
            
            break;
        case ArchivesTag: //档案
            fTotalHeight += _fPlatformArchivesHeight;
            break;
        case PlatDynamicTag: //平台动态
            fTotalHeight += _fPlatDynamicHeight;
            
            break;
        default:
            break;
    }
    
    //向上缩放信息
    if (!_isDownMsg)
    {
        arrowImageView.image = [UIImage imageNamed:@"XN_Agent_Arrow_down_icon.png"];
        //显示默认高度
        fTotalHeight = self.fPlatIntroductDefaultHeight;//HEIGHT_DEFAULT;
    }
    else
    {
        //向下展示所有信息
        arrowImageView.image = [UIImage imageNamed:@"XN_Agent_Arrow_up_icon.png"];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showPlatformMoreMsgWithHeight:nTabTag:defaultHeight:showDefaultHeight:)]) {
        
        [self.delegate showPlatformMoreMsgWithHeight:fTotalHeight nTabTag:btn.tag defaultHeight:self.fPlatIntroductDefaultHeight showDefaultHeight:NO];
    }
    
}

#pragma mark - 显示实际高度
- (void)showActualHeight:(float)fHeight tabType:(NSInteger)type defaultHeight:(float)fDefaultHeight showDefaultHeight:(BOOL)isShowDefaultHeight
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showPlatformMoreMsgWithHeight:nTabTag:defaultHeight:showDefaultHeight:)]) {
        
        [self.delegate showPlatformMoreMsgWithHeight:fHeight nTabTag:type defaultHeight:fDefaultHeight showDefaultHeight:isShowDefaultHeight];
    }
}

#pragma mark -更新箭头图标
- (void)updateArrowImage:(BOOL)isShowMsgDefaultHeight nTabTag:(NSInteger)nTag
{
    _isDownMsg = !isShowMsgDefaultHeight;
    
    UIView *view = [self.view viewWithTag:(nTag - ARROW_IMAGEVIEW_DEFAULT_TAG + ARROW_VIEW_DEFAULT_TAG)];
    UIImageView *arrowImageView = (UIImageView *)[view viewWithTag:nTag];
    //向上缩放信息
    if (!_isDownMsg)
    {
        arrowImageView.image = [UIImage imageNamed:@"XN_Agent_Arrow_down_icon.png"];
    }
    else
    {
        //向下展示所有信息
        arrowImageView.image = [UIImage imageNamed:@"XN_Agent_Arrow_up_icon.png"];
    }
}

#pragma mark - 点击放大图片
- (void)clickLargeImage:(UITapGestureRecognizer *)gesture
{
    CustomTapGestureRecognizer *gestureRecogizer = (CustomTapGestureRecognizer *)gesture;
    //查看头像大图
    NSMutableArray *photos = [NSMutableArray array];
    for (NSString *urlString in self.picsArray)
    {
        NSURL *url = [NSURL URLWithString:urlString];
        // 替换为中等尺寸图片
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = url;
        [photos addObject:photo];
    }
    
    // 2.图片预览（放大）
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.isShowSaveButton = NO;  //显示保存按钮
    browser.currentPhotoIndex = gestureRecogizer.nIndex;
    browser.photos = photos; // 设置所有的图片
    [browser show];

}

////////////////////
#pragma mark - setter/getter
////////////////////////////////////////////

#pragma mark - productsArray
- (NSMutableArray *)teamsArray
{
    if (!_teamsArray)
    {
        _teamsArray = [[NSMutableArray alloc] init];
    }
    return _teamsArray;
}

#pragma mark - dynamicArray
- (NSMutableArray *)dynamicArray
{
    if (!_dynamicArray)
    {
        _dynamicArray = [[NSMutableArray alloc] init];
    }
    return _dynamicArray;
}

- (NSMutableArray *)picsArray
{
    if (!_picsArray)
    {
        _picsArray = [[NSMutableArray alloc] init];
    }
    return _picsArray;
}

- (NSMutableArray *)investTitleArray
{
    if (!_investTitleArray)
    {
        _investTitleArray = [[NSMutableArray alloc] initWithObjects:@"发标时间：", @"充值限制：", @"起息时间：", @"提现费用：", @"提现到账：", @"其他：", nil];
    }
    return _investTitleArray;
}

- (NSArray *)investDescArray
{
    if (!_investDescArray)
    {
        _investDescArray = [[NSMutableArray alloc] initWithObjects:self.mode.productReleaseTime, self.mode.rechargeLimitDescription, self.mode.interestTime, self.mode.withdrawalCharges, self.mode.cashInTime, self.mode.investOthers, nil];
    }
    return _investDescArray;
}

@end
