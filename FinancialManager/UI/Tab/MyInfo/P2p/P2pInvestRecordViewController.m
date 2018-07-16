//
//  P2pInvestRecordViewController.m
//  FinancialManager
//
//  Created by xnkj on 14/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "P2pInvestRecordViewController.h"

#import "MyInvestCell.h"
#import "XNInvestPlatformsEmptyCell.h"
#import "PieChartView.h"
#import "PieChartModel.h"

#import "XNInvestPlatformMode.h"
#import "XNInvestStatisticItem.h"
#import "XNInvestPlatformDetailMode.h"
#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"

#import "ShareGroupView.h"

#import "MJRefresh.h"

#import "WeChatManager.h"
#import "QQManager.h"

#import "XNInvitedModule.h"

#define PIECHART_SIZE 90.0
#define CELLHEIGHT 58.0f
#define DEFAULTEMPTYCELLHEIGHT 100.0f

@interface P2pInvestRecordViewController ()<XNMyInformationModuleObserver, ShareGroupViewDelegate>

@property (nonatomic, strong) NSArray        * platformColorArray;

@property (nonatomic, strong) ShareGroupView *shareGroupView;

@property (nonatomic, weak) IBOutlet UILabel * investMoneyLabel;
@property (nonatomic, weak) IBOutlet UILabel * investProfitLabel;
@property (nonatomic, weak) IBOutlet UILabel * totalProfitLabel;
@property (nonatomic, weak) IBOutlet UIView  * headerView;

@property (nonatomic, weak) IBOutlet UITableView * investTableView;
@property (nonatomic, weak) IBOutlet UIView  * investListView;

@property (nonatomic, weak) IBOutlet UILabel * investPlatformCountLabel;
@property (nonatomic, weak) IBOutlet UILabel * totalProfitRateLabel;
@property (nonatomic, weak) IBOutlet UIView  * chatView;
@property (nonatomic, weak) IBOutlet UIView  * platformListView;
@property (nonatomic, weak) IBOutlet UIView  * investContainerView;

@property (nonatomic, weak) IBOutlet UIScrollView * containerScrollView;

@property (weak, nonatomic) IBOutlet UIImageView *unknownImg;
@property (weak, nonatomic) IBOutlet UIButton *unknownBtn;

@end

@implementation P2pInvestRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[XNMyInformationModule defaultModule] removeObserver:self];
    [[XNInvitedModule defaultModule] removeObserver:self];
}

//////////////////
#pragma mark - 自定义方法
///////////////////////////////

//初始化
- (void)initView
{
    self.title = @"网贷";
    [[XNMyInformationModule defaultModule] addObserver:self];
    [[XNInvitedModule defaultModule] addObserver:self];
    
    [self createUI];
    
    [self.investTableView registerNib:[UINib nibWithNibName:@"MyInvestCell" bundle:nil] forCellReuseIdentifier:@"MyInvestCell"];
    [self.investTableView registerNib:[UINib nibWithNibName:@"XNInvestPlatformsEmptyCell" bundle:nil] forCellReuseIdentifier:@"XNInvestPlatformsEmptyCell"];
    [self.investTableView setSeparatorColor:[UIColor clearColor]];
    
    weakSelf(weakSelf)
    self.containerScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [[XNMyInformationModule defaultModule] getMyInvestPlatform];
        [weakSelf.view showGifLoading];
    }];
    
    [[XNMyInformationModule defaultModule] getMyInvestPlatform];
    
    [[XNInvitedModule defaultModule] xnInvitedHomeInfo];
    
    [weakSelf.view showGifLoading];
    
    if ([self.view respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

//更新视图
- (void)createUI
{
    [self.containerScrollView addSubview:self.headerView];
    [self.containerScrollView addSubview:self.investListView];
    [self.containerScrollView addSubview:self.investContainerView];
    
    weakSelf(weakSelf)
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.containerScrollView.mas_leading);
        make.top.mas_equalTo(weakSelf.containerScrollView.mas_top);
        make.trailing.mas_equalTo(weakSelf.containerScrollView.mas_trailing);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(@(163));
    }];
    
    __weak UIView * tmpView = self.headerView;
    [self.investListView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.mas_equalTo(weakSelf.containerScrollView.mas_leading);
        make.top.mas_equalTo(tmpView.mas_bottom).offset(15);
        make.trailing.mas_equalTo(weakSelf.containerScrollView.mas_trailing);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(@(33));
    }];
    
    tmpView = self.investListView;
    [self.investContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.containerScrollView.mas_leading);
        make.top.mas_equalTo(tmpView.mas_bottom).offset(15);
        make.trailing.mas_equalTo(weakSelf.containerScrollView.mas_trailing);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(@(242));
        make.bottom.mas_equalTo(weakSelf.containerScrollView.mas_bottom);
    }];
}

//根据数据更新数据
- (void)updateUI
{
    //根据平台数限制高度
    CGFloat height = [[[[XNMyInformationModule defaultModule] investPlatformMode] investPlatformList] count] * 58;
    if ([[[[XNMyInformationModule defaultModule] investPlatformMode] investPlatformList] count] <= 0) {
        
        height = height + 100;
    }
    
    weakSelf(weakSelf)
    __weak UIView * tmpView = self.headerView;
    [self.investListView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.containerScrollView.mas_leading);
        make.top.mas_equalTo(tmpView.mas_bottom).offset(15);
        make.trailing.mas_equalTo(weakSelf.containerScrollView.mas_trailing);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(@(33 + height));
    }];
    
    tmpView = self.investListView;
    
    height = [[[[XNMyInformationModule defaultModule] investPlatformMode] investStatisticList] count] / 2 * 33 +  [[[[XNMyInformationModule defaultModule] investPlatformMode] investStatisticList] count] % 2 * 33;
    
    [self.investContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.mas_equalTo(weakSelf.containerScrollView.mas_leading);
            make.top.mas_equalTo(tmpView.mas_bottom).offset(15);
        make.trailing.mas_equalTo(weakSelf.containerScrollView.mas_trailing);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.mas_equalTo(@(292 + height));
        make.bottom.mas_equalTo(weakSelf.containerScrollView.mas_bottom);
    }];
    
    [self.containerScrollView layoutIfNeeded];

    //更新数据
    self.investMoneyLabel.text = [[[XNMyInformationModule defaultModule] investPlatformMode] investingAmt];
    self.investProfitLabel.text = [[[XNMyInformationModule defaultModule] investPlatformMode] investingProfit];
    self.totalProfitLabel.text = [[[XNMyInformationModule defaultModule] investPlatformMode] totalProfit];
    
    NSArray *propertyArray = @[@{@"range": @"在投平台:",
                                 @"color": UIColorFromHex(0x999999),
                                 @"font": [UIFont systemFontOfSize:14]},
                               @{@"range": [NSString stringWithFormat:@"%@",[[[XNMyInformationModule defaultModule] investPlatformMode] investingPlatformNum]],
                                 @"color": UIColorFromHex(0xfd6d6d),
                                 @"font": [UIFont systemFontOfSize:14]},
                               @{@"range": @"个",
                                 @"color": UIColorFromHex(0x999999),
                                 @"font": [UIFont systemFontOfSize:14]}];
    
    NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
    self.investPlatformCountLabel.attributedText = string;
    
    propertyArray = @[@{@"range": @"综合年化收益率:",
                                 @"color": UIColorFromHex(0x999999),
                                 @"font": [UIFont systemFontOfSize:14]},
                               @{@"range": [NSString stringWithFormat:@"%@%@",[[[XNMyInformationModule defaultModule] investPlatformMode] yearProfitRate],@"%"],
                                 @"color": UIColorFromHex(0xfd6d6d),
                                 @"font": [UIFont systemFontOfSize:14]}];
    
    string = [NSString getAttributeStringWithAttributeArray:propertyArray];
    self.totalProfitRateLabel.attributedText = string;
    
    // 显示问号
    self.unknownImg.hidden = NO;
    
    [self drawChatView];
    [self drawPlatformListView];
    [self.investTableView reloadData];
}

//绘制图表
- (void)drawChatView
{
    for (UIView * subView in self.chatView.subviews) {
        
        [subView removeFromSuperview];
    }
    
    NSInteger index = 0;
    NSMutableArray *pecentArray = [NSMutableArray array];
    PieChartModel *model = nil;
    for (XNInvestStatisticItem * item in [[[XNMyInformationModule defaultModule] investPlatformMode] investStatisticList])
    {
        model = [[PieChartModel alloc] init];
        model.color = [self.platformColorArray objectAtIndex:index];
        model.fpercent = [item.totalPercent floatValue] / 100.0;
        
        [pecentArray addObject:model];
        index = index + 1;
    }
    
    PieChartView *pieChartView = [[PieChartView alloc] initWithFrame:CGRectMake(0, 0, PIECHART_SIZE, PIECHART_SIZE) withStrokeWidth:PIECHART_SIZE / 4 bgColor:UIColorFromHex(0xd9e8ff) percentArray:pecentArray isAnimation:YES];
    
    [self.chatView addSubview:pieChartView];
    
    __weak UIView *weakPieChartView = self.chatView;
    [pieChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(weakPieChartView);
        make.width.height.mas_equalTo(PIECHART_SIZE);
    }];
}

//创建投资列表
- (void)drawPlatformListView
{
    for (UIView * subView in self.platformListView.subviews) {
        
        [subView removeFromSuperview];
    }
    
    NSInteger index = 0;
    UIView * itemView = nil;
    __weak UIView * lastItemView = itemView;
    weakSelf(weakSelf)
    for (XNInvestStatisticItem * item in [[[XNMyInformationModule defaultModule] investPlatformMode] investStatisticList]) {
        
        itemView = [self createInvestItemWithPlatformColor:[self.platformColorArray objectAtIndex:index] orgName:item.orgName percent:item.totalPercent];
        [self.platformListView addSubview:itemView];
        
        if ([[[[XNMyInformationModule defaultModule] investPlatformMode] investingPlatformNum] integerValue] > 1)
        {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
               
                if (index % 2 == 0) {
                    make.leading.mas_equalTo(weakSelf.platformListView.mas_leading).offset(SCREEN_FRAME.size.width / 2 - 150);
                }else
                {
                    make.leading.mas_equalTo(weakSelf.platformListView.mas_centerX).offset(28);
                }
                
            make.top.mas_equalTo(weakSelf.platformListView.mas_top).offset(33 * (index / 2));
                make.height.mas_equalTo(@(41));
                make.width.mas_equalTo(@(150));
                
            }];
            lastItemView = itemView;
        }else
        {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.equalTo(weakSelf.platformListView);
                make.top.mas_equalTo(weakSelf.platformListView.mas_top).offset(33 * (index / 2));
                make.height.mas_equalTo(@(41));
                make.width.mas_equalTo(@(150));
                
            }];
        }
        
        index = index + 1;
    }
}

//创建投资项
- (UIView *)createInvestItemWithPlatformColor:(UIColor *)color orgName:(NSString *)orgName percent:(NSString *)pencent
{
    UIView * investContainer = [[UIView alloc]init];
    
    UILabel * colorBlock = [[UILabel alloc]init];
    [colorBlock setBackgroundColor:color];
    
    UILabel * orgNameLabel = [[UILabel alloc]init];
    [orgNameLabel setFont:[UIFont systemFontOfSize:13]];
    [orgNameLabel setTextColor:UIColorFromHex(0x999999)];
    orgNameLabel.text = [NSString stringWithFormat:@"%@ %@%@",orgName,pencent,@"%"];
    
    [investContainer addSubview:colorBlock];
    [investContainer addSubview:orgNameLabel];
    
    __weak UIView * tmpView = investContainer;
    [colorBlock mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(24);
        make.leading.mas_equalTo(tmpView.mas_leading);
        make.width.mas_equalTo(@(7));
        make.height.mas_equalTo(@(7));
    }];
    
    __weak UILabel * tmpLabel = colorBlock;
    [orgNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.mas_equalTo(tmpLabel.mas_trailing).offset(11);
        make.top.mas_equalTo(tmpView.mas_top).offset(18);
        make.height.mas_equalTo(@(21));
    }];

    return investContainer;
}

// 分享我的投资组合
- (IBAction)shareInvestBtn:(UIButton *)sender
{
    self.shareGroupView.investPlatformMode = [[XNMyInformationModule defaultModule] investPlatformMode];
    [self.shareGroupView show];
}

// 问号弹窗
- (IBAction)unknownClick
{
    [self showFMRecommandViewWithTitle:@"综合年化收益率" subTitle:@"综合年化收益率 = 所有在投产品累计收益（包括：投资收益+猎财佣金+猎财返现红包+平台奖励） ／ 所有在投产品累计年化金额。" otherSubTitle:nil okTitle:@"我知道了" okCompleteBlock:^{
    } cancelTitle:nil cancelCompleteBlock:^{
    }];
}

//////////////////
#pragma mark - 协议回掉
///////////////////////////////

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[[XNMyInformationModule defaultModule] investPlatformMode] investPlatformList].count <= 0) {
        
        return 1;
    }
    
    return [[[XNMyInformationModule defaultModule] investPlatformMode] investPlatformList].count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[XNMyInformationModule defaultModule] investPlatformMode] investPlatformList].count <= 0) {
        
        return DEFAULTEMPTYCELLHEIGHT;
    }
    
    return CELLHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[XNMyInformationModule defaultModule] investPlatformMode] investPlatformList].count <= 0) {
        
        XNInvestPlatformsEmptyCell * cell =(XNInvestPlatformsEmptyCell *)[tableView dequeueReusableCellWithIdentifier:@"XNInvestPlatformsEmptyCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell setCliekRecommend:^{
            
            ProductViewController * ctrl = [[ProductViewController alloc]initWithNibName:@"ProductViewController" bundle:nil];
            
            [_UI pushViewControllerFromRoot:ctrl animated:YES];
        }];
        
        return cell;
    }
    
    MyInvestCell * cell = (MyInvestCell *)[tableView dequeueReusableCellWithIdentifier:@"MyInvestCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    XNInvestPlatformDetailMode * mode = [[[[XNMyInformationModule defaultModule] investPlatformMode] investPlatformList] objectAtIndex:indexPath.row];
    
    [cell updateContentWithAgentLogo:mode.platformLogo investMoney:mode.investingAmt investProfit:mode.investingProfit];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[XNMyInformationModule defaultModule] investPlatformMode] investPlatformList] .count > 0) {
        
        XNInvestPlatformDetailMode * mode = [[[[XNMyInformationModule defaultModule] investPlatformMode] investPlatformList]  objectAtIndex:indexPath.row];
        
        NSString *urlString = [NSString stringWithFormat:@"orgAccount=%@&orgKey=%@&orgNumber=%@&requestFrom=%@&sign=%@&timestamp=%@", mode.orgAccount, mode.orgKey, mode.orgNumber, mode.requestFrom, mode.sign, mode.timestamp];
        
        //进入平台用户中心
        UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:mode.orgUsercenterUrl httpBody:urlString requestMethod:@"POST"];
        [webCtrl setIsEnterThirdPlatform:YES platformName:mode.platformName];
        [webCtrl.view setBackgroundColor:[UIColor whiteColor]];
        [_UI pushViewControllerFromRoot:webCtrl animated:YES];
    }
}

- (void)shareGroupViewDid:(ShareGroupView *)shareGroupView clickType:(ShareGroupViewClickType)clickType cutImg:(UIImage *)cutImg
{
    /**
     Share_Group_Photo = 0,
     Share_Group_QQ,
     Share_Group_WeCat,
     Share_Group_Circle
     */
    
    if (cutImg == nil) {
        
    }
    
    
    if (clickType == Share_Group_Photo) { // 保存到相册
       
        UIImageWriteToSavedPhotosAlbum(cutImg, self, @selector(cutImg:didFinishSavingWithError:contextInfo:), NULL);
    }
    
    else if (clickType == Share_Group_QQ) { // QQ 分享
        
        if ([QQManager isInstalledQQ])
        {
            [[QQManager sharedInstance] sendImage:cutImg withFlag:YES];
        }
        else {
            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:@"您还没有安装QQ,是否去App Store下载" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"马上去下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *strUrl = QQDOWNLOADLINK;
                NSURL *url = [NSURL URLWithString:strUrl];
                [[UIApplication sharedApplication] openURL:url];
                
                [_UI dismissNaviModalViewCtrlAnimated:YES];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [_UI dismissNaviModalViewCtrlAnimated:YES];
            }]];
            
            [_UI presentNaviModalViewCtrl:alertController animated:YES];
        }
    }
    
    else if (clickType == Share_Group_WeCat) { // 微信好友分享
    
        if ([WeChatManager isWeChatInstall])
        {
            [[WeChatManager sharedManager] sendImage:cutImg atScene:0];
        }
        else {
            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:@"您还没有安装微信,是否去App Store下载" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"马上去下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *strUrl = [WeChatManager weChatUrl];
                NSURL *url = [NSURL URLWithString:strUrl];
                [[UIApplication sharedApplication] openURL:url];
                
                [_UI dismissNaviModalViewCtrlAnimated:YES];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [_UI dismissNaviModalViewCtrlAnimated:YES];
            }]];
            
            [_UI presentNaviModalViewCtrl:alertController animated:YES];
        }
    }
    
    else if (clickType == Share_Group_Circle) { // 微信朋友圈分享
        

        if ([WeChatManager isWeChatInstall])
        {
            [[WeChatManager sharedManager] sendImage:cutImg atScene:1];
        }
        else {
            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:@"您还没有安装微信,是否去App Store下载" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"马上去下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *strUrl = [WeChatManager weChatUrl];
                NSURL *url = [NSURL URLWithString:strUrl];
                [[UIApplication sharedApplication] openURL:url];
                
                [_UI dismissNaviModalViewCtrlAnimated:YES];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [_UI dismissNaviModalViewCtrlAnimated:YES];
            }]];
            
            [_UI presentNaviModalViewCtrl:alertController animated:YES];
        }
    }
}

// 指定回调方法
- (void)cutImg:(UIImage *)cutImg didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if (error != NULL) {
        [self showCustomWarnViewWithContent:@"保存图片失败"];
    } else {
        [self showCustomWarnViewWithContent:@"保存图片成功"];
    }
}

//////////////////
#pragma mark - 网络请求回调用
///////////////////////////////

- (void)XNMyInfoModuleGetInvestPlatformDidReceive:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    [self.containerScrollView.mj_header endRefreshing];
    
    [self updateUI];
}

- (void)XNMyInfoModuleGetInvestPlatformDidFailed:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    [self.containerScrollView.mj_header endRefreshing];
    
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//推荐理财师首页
- (void)xnInvitedModuleInvitedHomePageDidReceiver:(XNInvitedModule *)module
{
    NSDictionary *dic = module.invitedHomeInfoMode;
    
    if ([NSObject isValidateObj:dic[@"url"]]) {
        
        // 二维码
        NSString *urlString = [NSString stringWithFormat:@"%@?f=png", [_LOGIC getImagePathUrlWithBaseUrl:dic[@"url"]]];
        [self.shareGroupView.erweimaImgView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    }
}

- (void)xnInvitedModuleInvitedHomePageDidFailed:(XNInvitedModule *)module
{
    [self.view hideLoading];
    [self.containerScrollView.mj_header endRefreshing];
    
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

///////////////////////////////
#pragma mark - setter/getter
///////////////////////////////

- (NSArray *)platformColorArray
{
    if (!_platformColorArray) {
        
        _platformColorArray = [[NSArray alloc]initWithObjects:UIColorFromHex(0xec7962),UIColorFromHex(0xefaa4a),UIColorFromHex(0xf7e65e),UIColorFromHex(0x68d5e2),UIColorFromHex(0x6493f7),UIColorFromHex(0x4375c1),UIColorFromHex(0x655cd9),UIColorFromHex(0xcf7cd9),UIColorFromHex(0x4375c1),UIColorFromHex(0x655cd9),UIColorFromHex(0xcf7cd9), nil];
    }
    return _platformColorArray;
}

- (ShareGroupView *)shareGroupView
{
    if (!_shareGroupView) {
        _shareGroupView = [ShareGroupView shareGroupView];
        _shareGroupView.delegate = self;
    }
    return _shareGroupView;
}



@end
