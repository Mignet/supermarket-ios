//
//  AgentTeamMsgViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/2/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "AgentTeamMsgViewController.h"

#import "CustomTapGestureRecognizer.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#import "XNFMAgentDetailMode.h"
#import "XNFMAgentTeamDetailMode.h"
#import "XNCommonModule.h"
#import "XNConfigMode.h"

@interface AgentTeamMsgViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic, strong) XNFMAgentDetailMode *mode;
@property (nonatomic, strong) NSMutableArray *teamsArray;
@property (nonatomic, strong) NSMutableArray *picsArray;
@property (nonatomic, assign) NSInteger nPicIndex; //图片tag
@property (nonatomic, assign) float fTotalHeight;

@end

@implementation AgentTeamMsgViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_FRAME.size.width, self.fTotalHeight);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.view hideLoading];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////

#pragma mark - 初始化
- (void)initView
{
    self.title = @"高管团队及现场实拍";
    
    UIView *mainView = [[UIView alloc] init];
    UIView *teamMsgView = [self showTeamMsg];
    [self.mainScrollView addSubview:mainView];
    [mainView addSubview:teamMsgView];
    
    float fTeamMsgViewHeight = teamMsgView.frame.size.height;
    
    __weak UIView *weakMainView = mainView;
    __weak UIView *weakTeamMsgView = teamMsgView;
    [teamMsgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakMainView.mas_top);
        make.left.equalTo(weakMainView.mas_left);
        make.right.equalTo(weakMainView.mas_right);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(fTeamMsgViewHeight);
    }];
    
    float fPicHeaderViewHeight = 0.0f;
    float fPicViewHeight = 0.0f;
    if (_mode.orgEnvironmentList != nil && _mode.orgEnvironmentList.count > 0)
    {
        UIView *picHeaderView = [self headerViewWithTitle:@"现场实拍"];
        UIView *picView = [self showPictureWithHeight:_mode.orgEnvironmentList];
        
        [mainView addSubview:picHeaderView];
        [mainView addSubview:picView];
        
        fPicHeaderViewHeight = picHeaderView.frame.size.height;
        fPicViewHeight = picView.frame.size.height;
        
        [picHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakTeamMsgView.mas_bottom);
            make.left.mas_equalTo(weakMainView.mas_left);
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
    
    self.fTotalHeight = fTeamMsgViewHeight + fPicHeaderViewHeight + fPicViewHeight + 12;
    
    __weak UIScrollView *weakMainScrollView = self.mainScrollView;
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakMainScrollView.mas_top);
        make.left.mas_equalTo(weakMainScrollView.mas_left);
        make.right.mas_equalTo(weakMainScrollView.mas_right);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(self.fTotalHeight);
    }];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
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

#pragma mark - 团队管理
- (UIView *)showTeamMsg
{
    UIView *teamMsgView = [[UIView alloc] init];
    
    if (self.teamsArray.count < 1)
    {
        return teamMsgView;
    }
    UIView *headerView = [self headerViewWithTitle:@"高管团队"];
    [teamMsgView addSubview:headerView];
    
    float fHeaderViewHeight = headerView.frame.size.height;
    
    CGFloat fHeight = fHeaderViewHeight;
    __weak UIView *weakTeamMsgView = teamMsgView;
    for (int i = 0; i < self.teamsArray.count; i ++)
    {
        UIView *view = [self teamCell:[self.teamsArray objectAtIndex:i]];
        [teamMsgView addSubview:view];
        CGFloat fViewHeight = view.size.height;
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakTeamMsgView.mas_top).offset(fHeight);
            make.left.equalTo(weakTeamMsgView.mas_left).offset(10);
            make.right.equalTo(weakTeamMsgView.mas_right);
            make.height.mas_equalTo(fViewHeight);
        }];
        
        fHeight = fHeight + view.size.height;
    }
    
    teamMsgView.size = CGSizeMake(SCREEN_FRAME.size.width, fHeaderViewHeight + fHeight);
    return teamMsgView;
    
}

#pragma mark - 团队cell
- (UIView *)teamCell:(XNFMAgentTeamDetailMode *)mode
{
    UIView *teamView = [[UIView alloc] init];
    teamView.backgroundColor = [UIColor whiteColor];
    
    //头像
    UIImageView *avatarImageView = [[UIImageView alloc] init];
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = 25.5f;
    NSString *urlString = [NSString stringWithFormat:@"%@%@", [XNCommonModule defaultModule].configMode.imgServerUrl, mode.orgIcon];
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"XN_Agent_Team_default.png"]];
    
    //姓名
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = JFZ_COLOR_BLACK;
    nameLabel.font = [UIFont systemFontOfSize:18.f];
    nameLabel.text = mode.orgMemberName;
    
    //职位
    UILabel *positionLabel = [[UILabel alloc] init];
    positionLabel.textColor = [UIColor lightGrayColor];
    positionLabel.font = [UIFont systemFontOfSize:15.f];
    positionLabel.text = mode.orgMemberGrade;
    
    //信息
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.textColor = [UIColor lightGrayColor];
    descLabel.font = [UIFont systemFontOfSize:12.f];
    descLabel.numberOfLines = 0;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:mode.orgDescribe];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [mode.orgDescribe length])];
    descLabel.attributedText = attributedString;
    [descLabel sizeToFit];
    
    [teamView addSubview:avatarImageView];
    [teamView addSubview:nameLabel];
    [teamView addSubview:positionLabel];
    [teamView addSubview:descLabel];
    
    __weak UIView *weakTeamView = teamView;
    __weak UIImageView *weakAvatarImageView = avatarImageView;
    __weak UILabel *weakNameLabel = nameLabel;
    
    [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakTeamView.mas_top).offset(15);
        make.left.equalTo(weakTeamView.mas_left).offset(12);
        make.width.mas_equalTo(51);
        make.height.mas_equalTo(51);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakAvatarImageView.mas_top);
        make.left.equalTo(weakAvatarImageView.mas_right).offset(12);
        make.height.mas_equalTo(21);
    }];
    
    [positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakNameLabel.mas_right).offset(4);
        make.bottom.equalTo(weakNameLabel.mas_bottom);
        make.height.mas_equalTo(weakNameLabel.mas_height);
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakNameLabel.mas_bottom).offset(10);
        make.left.equalTo(weakNameLabel.mas_left);
        make.right.equalTo(weakTeamView.mas_right).offset(-12);
    }];
    
    CGFloat fHeight = [mode.orgDescribe getSpaceLabelHeightWithFont:12 withWidth:SCREEN_FRAME.size.width - 32 - 51 lineSpacing:5] + 15 + 21 + 10;
    teamView.size = CGSizeMake(SCREEN_FRAME.size.width, fHeight);
    
    return teamView;
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

#pragma mark - teamsArray
- (NSMutableArray *)teamsArray
{
    if (!_teamsArray)
    {
        _teamsArray = [[NSMutableArray alloc] init];
    }
    return _teamsArray;
}

- (NSMutableArray *)picsArray
{
    if (!_picsArray)
    {
        _picsArray = [[NSMutableArray alloc] init];
    }
    return _picsArray;
}

@end
