//
//  BPInviteCFPViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/5/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "BPInviteCFPViewController.h"
#import "BPMorePicsViewController.h"
#import "BPHeaderViewCell.h"
#import "BPBottomViewCell.h"
#import "XNLCBrandPromotionMode.h"
#import "XNLeiCaiModule.h"
#import "XNLeiCaiModuleObserver.h"

#define HEADERCELL_DEFAULT_HEIGHT 222.0f
#define HEADERCELL_SHORT_HEIGHT 92.0f
#define BOTTOMCELL_DEFAULT_HEIGHT 252.0f
#define BOTTOMCELL_SHORT_HEIGHT 133.0f
#define hotPicTag 11111
#define remmendPicTag 22222

@interface BPInviteCFPViewController ()<XNLeiCaiModuleObserver, BPHeaderViewCellDelegate, BPBottomViewCellDelegate, BPMorePicsViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) XNLCBrandPromotionMode *mode;
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;

@property (nonatomic, assign) BOOL isShowCloseIcon;
@property (nonatomic, assign) BOOL isUpdatePics;
@property (nonatomic, strong) NSString *defaultContent;
@property (nonatomic, assign) BOOL isOwnerInputContent; //是否自己编辑了内容
@property (nonatomic, strong) NSMutableArray *selectedPicsArray;
@property (nonatomic, strong) NSMutableArray *selectedPicUrlArray;
@property (nonatomic, assign) BOOL isFirstIn;

@end

@implementation BPInviteCFPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
   [[XNMyInformationModule defaultModule] removeObserver:self];
}

////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////

//初始化操作
- (void)initView
{
    self.isShowCloseIcon = YES;
    self.isUpdatePics = YES;
    self.isOwnerInputContent = NO;
    self.defaultContent = @"";
    self.isFirstIn = YES;
    [[XNLeiCaiModule defaultModule] addObserver:self];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BPHeaderViewCell" bundle:nil] forCellReuseIdentifier:@"BPHeaderViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BPBottomViewCell" bundle:nil] forCellReuseIdentifier:@"BPBottomViewCell"];
    
    [self loadDatas];
    [self.view showGifLoading];
}

//加载数据
- (void)loadDatas
{
    [[XNLeiCaiModule defaultModule] requestBrandPromotion:@"1"];
}

//一键分享
- (IBAction)sharedAction:(id)sender
{
    //传递文字、图片    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.defaultContent, @"content", self.mode.qrcode, @"qrcode", self.selectedPicsArray, @"selectedPicsArray", self.selectedPicUrlArray, @"selectedPicUrlsArray", nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(BPInviteCFPViewControllerDidSharedWithParams:)])
    {
        [self.delegate BPInviteCFPViewControllerDidSharedWithParams:dic];
    }
    
}

//退出键盘
- (void)exitKeyboard:(UIGestureRecognizer *)gesture
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

//键盘将要显示
- (void)keyboardShow:(NSNotification *)notifx
{
    [self.view addGestureRecognizer:self.tapGesture];
}

//键盘将要消失
- (void)keyboardHide:(NSNotification *)notif
{
    [self.view removeGestureRecognizer:self.tapGesture];
}

////////////////////
#pragma mark - 组件回调
////////////////////////////////////////////

//UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = indexPath.row;
    if (nRow == 0)
    {
        if (self.isShowCloseIcon)
        {
            return HEADERCELL_DEFAULT_HEIGHT;
        }
        return HEADERCELL_SHORT_HEIGHT;
    }
    
    if (self.mode.hotPosterList.count <= 0)
    {
        return BOTTOMCELL_SHORT_HEIGHT;
    }
    return BOTTOMCELL_DEFAULT_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = [indexPath row];
    if (nRow == 0)
    {
        static NSString *cellIdentifierString = @"BPHeaderViewCell";
        BPHeaderViewCell *cell = (BPHeaderViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
        cell.delegate = self;
        [cell showDatas:self.defaultContent];
        
        return cell;
    }
    
    static NSString *cellIdentifierString = @"BPBottomViewCell";
    BPBottomViewCell *cell = (BPBottomViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
    cell.delegate = self;
    if (!self.isUpdatePics || !self.mode)
    {
        return cell;
    }
    [cell showDatas:self.mode type:@"1" selectedPics:self.selectedPicsArray selectedPicUrls:self.selectedPicUrlArray shouldUpdatePics:!self.isFirstIn];
    
    return cell;
    
}

//BPHeaderViewCellDelegate
- (void)BPHeaderViewCellDidChangeHeight:(BOOL)isShowCloseIcon
{
    self.isShowCloseIcon = !isShowCloseIcon;
    self.isUpdatePics = NO;
    
    UIImageView *lastImageView = self.selectedPicsArray.lastObject;
    NSString *tagString = [NSString stringWithFormat:@"%ld", lastImageView.tag];
    
    if ([tagString hasPrefix:[NSString stringWithFormat:@"%d", hotPicTag]])
    {
        //热点海报
        self.defaultContent = self.mode.hotContent;
    }
    else if ([tagString hasPrefix:[NSString stringWithFormat:@"%d", remmendPicTag]])
    {
        //精品推荐
        self.defaultContent = self.mode.recomContent;
    }
    
    [self.tableView reloadData];
}

- (void)BPHeaderViewCellDidInputContent:(NSString *)content
{
    self.defaultContent = content;
    self.isOwnerInputContent = YES;
}

//BPBottomViewCellDelegate
- (void)BPBottomViewCellDelegateDidSelectedPics:(NSArray *)selectedPicsArray selectedPicUrls:(NSArray *)selectedPicUrlsArray isMoreThreePic:(BOOL)isMoreThreePic
{
    [self.selectedPicsArray removeAllObjects];
    [self.selectedPicUrlArray removeAllObjects];
    [self.selectedPicsArray addObjectsFromArray:selectedPicsArray];
    [self.selectedPicUrlArray addObjectsFromArray:selectedPicUrlsArray];
    
    //超过3张了
    if (isMoreThreePic)
    {
        [self.view showCustomWarnViewWithContent:@"您最多选择3张图片"];
    }
    
    //不显示文字
    if (!self.isShowCloseIcon || self.isOwnerInputContent)
    {
        return;
    }
    
    UIImageView *lastImageView = selectedPicsArray.lastObject;
    NSString *tagString = [NSString stringWithFormat:@"%ld", lastImageView.tag];
    
    if ([tagString hasPrefix:[NSString stringWithFormat:@"%d", hotPicTag]])
    {
        //热点海报
        self.defaultContent = self.mode.hotContent;
    }
    else if ([tagString hasPrefix:[NSString stringWithFormat:@"%d", remmendPicTag]])
    {
        //精品推荐
        self.defaultContent = self.mode.recomContent;
    }
    
    self.isUpdatePics = NO;
    [self.tableView reloadData];
}

- (void)BPBottomViewCellDelegateDidShowMoreDatas:(NSInteger)index
{
    NSInteger picType = 0;
    NSArray *array = [NSArray array];
    switch (index) {
        case 0: //热点海报
        {
            picType = HotPicType;
            array = self.mode.hotPosterList;
        }
            break;
        case 1: //精品推荐
        {
            picType = RecommendPicType;
            array = self.mode.recommenList;
        }
            break;
        default:
            break;
    }
    
    if (array.count <= 0)
    {
        return;
    }
    BPMorePicsViewController *viewController = [[BPMorePicsViewController alloc] initWithNibName:@"BPMorePicsViewController" bundle:nil picType:picType selectedPics:self.selectedPicsArray selectedPicUrl:self.selectedPicUrlArray allPicsUrlArray:array];
    viewController.delegate = self;
    [_UI pushViewControllerFromRoot:viewController animated:YES];
}

//BPMorePicsViewControllerDelegate
- (void)BPMorePicsViewControllerDidSelectedPics:(NSArray *)selectedPicArray selectedPicUrls:(NSArray *)selectedPicUrlsArray
{
    self.isFirstIn = NO;
    self.isUpdatePics = YES;
    [self.selectedPicsArray removeAllObjects];
    [self.selectedPicUrlArray removeAllObjects];
    [self.selectedPicsArray addObjectsFromArray:selectedPicArray];
    [self.selectedPicUrlArray addObjectsFromArray:selectedPicUrlsArray];
    
    //不显示文字
    if (!self.isShowCloseIcon || self.isOwnerInputContent)
    {
        
    }
    else
    {
        UIImageView *lastImageView = selectedPicArray.lastObject;
        NSString *tagString = [NSString stringWithFormat:@"%ld", lastImageView.tag];
        
        if ([tagString hasPrefix:[NSString stringWithFormat:@"%d", hotPicTag]])
        {
            //热点海报
            self.defaultContent = self.mode.hotContent;
        }
        else if ([tagString hasPrefix:[NSString stringWithFormat:@"%d", remmendPicTag]])
        {
            //精品推荐
            self.defaultContent = self.mode.recomContent;
        }
    }
    
    [self.tableView reloadData];
}

///////////////////
#pragma mark - 网络回调
/////////////////////////////////////

//个人品牌推广
- (void)XNLeiCaiModuleBrandPromotionDidSuccess:(XNLeiCaiModule *)module
{
    [self.view hideLoading];
    if (module.cfpBrandPromotionMode == nil)
    {
        return;
    }
    
    [self.selectedPicsArray removeAllObjects];
    [self.selectedPicUrlArray removeAllObjects];
    
    //不显示文字
    if (!self.isOwnerInputContent)
    {
        self.mode = module.cfpBrandPromotionMode;
        if (self.mode.hotContent && self.mode.hotContent.length > 0)
        {
            self.defaultContent = self.mode.hotContent;
        }
        else
        {
            self.defaultContent = self.mode.recomContent;
        }
    }

    [self.tableView reloadData];
}

- (void)XNLeiCaiModuleBrandPromotionDidFailed:(XNLeiCaiModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic)
    {
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

////////////////////
#pragma mark - setter/getter
////////////////////////////////////////////

#pragma mark - tapGesture
- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture)
    {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitKeyboard:)];
    }
    return _tapGesture;
}

- (NSMutableArray *)selectedPicsArray
{
    if (!_selectedPicsArray)
    {
        _selectedPicsArray = [[NSMutableArray alloc] init];
    }
    return _selectedPicsArray;
}

- (NSMutableArray *)selectedPicUrlArray
{
    if (!_selectedPicUrlArray)
    {
        _selectedPicUrlArray = [[NSMutableArray alloc] init];
    }
    return _selectedPicUrlArray;
}

@end