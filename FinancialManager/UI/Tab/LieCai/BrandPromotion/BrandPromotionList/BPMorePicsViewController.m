//
//  BPMorePicsViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/7/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "BPMorePicsViewController.h"
#import "CustomTapGestureRecognizer.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#define fLeftPadding 15.0f
#define fTopPadding 15.0f
#define imageTag 10000
#define checkboxImageTag 20000
#define hotPicTag 1111111111
#define remmendPicTag 2222222222

@interface BPMorePicsViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger nPicType;
@property (nonatomic, strong) NSMutableArray *selectedPicsArray; //记录选中的图片
@property (nonatomic, strong) NSMutableArray *selectedPicsUrlArray;
@property (nonatomic, strong) NSMutableArray *allPicsUrlArray;
@property (nonatomic, strong) NSMutableArray *allPicsArray;

@property (nonatomic, assign) NSInteger nPicIndex; //图片tag

@end

@implementation BPMorePicsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
                picType:(NSInteger)picType
        selectedPics:(NSArray *)selectedArray
       selectedPicUrl:(NSArray *)selectedPicUrlArray
         allPicsUrlArray:(NSArray *)allPicsUrlArray

{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self)
    {
        [self.selectedPicsArray removeAllObjects];
        [self.selectedPicsUrlArray removeAllObjects];
        [self.allPicsUrlArray removeAllObjects];
        self.nPicType = picType;
        [self.selectedPicsArray addObjectsFromArray:selectedArray];
        [self.selectedPicsUrlArray addObjectsFromArray:selectedPicUrlArray];
        [self.allPicsUrlArray addObjectsFromArray:allPicsUrlArray];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)willDealloc
{
    return NO;
}

- (void)clickBack:(UIButton *)sender
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(BPMorePicsViewControllerDidSelectedPics:selectedPicUrls:)])
    {
        [self.delegate BPMorePicsViewControllerDidSelectedPics:self.selectedPicsArray selectedPicUrls:self.selectedPicsUrlArray];
    }
    [super clickBack:sender];
    
}

////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    if (self.nPicType == HotPicType)
    {
        self.title = @"热点海报";
    }
    else
    {
        self.title = @"精品推荐";
    }

}

- (void)initCell:(UITableViewCell *)cell
{
    UIView *picsView = [self showPosters:self.allPicsUrlArray picType:self.nPicType];
    picsView.backgroundColor = UIColorFromHex(0xf6f6f6);

    [cell addSubview:picsView];
    __weak UITableViewCell *weakCell = cell;
    [picsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakCell);
    }];
}

#pragma mark - 展示图片
- (UIView *)showPosters:(NSArray *)listArray picType:(NSInteger)picType
{
    UIView *picView = [[UIView alloc] init];
    
    float fLeftRightPadding = fLeftPadding; //左右间距
    float fTopBottomPadding = fTopPadding; //上下间距
    float fPicWidth = (SCREEN_FRAME.size.width - fLeftPadding * 4) / 3;
    float fPicHeight = fPicWidth * 130 / 207;
    //总行数
    NSInteger nRow = listArray.count % 3 == 0 ? listArray.count / 3 : listArray.count / 3 + 1;
    //总高度
    float fTotalHeight = fPicHeight * nRow + fTopBottomPadding * (nRow - 1);
    
    float fHeaderPadding = 30.0f;
    __weak UIView *weakPicView = picView;
    for (int i = 0; i < listArray.count; i ++)
    {
        self.nPicIndex ++;
        
        UIView *view = [[UIView alloc] init];
        view.userInteractionEnabled = YES;
        CustomTapGestureRecognizer *tapRecognizer = [[CustomTapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLargeImage:)];
        tapRecognizer.nIndex = self.nPicIndex - 1;
        [view addGestureRecognizer:tapRecognizer];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = picType == HotPicType ? (hotPicTag + i) : (remmendPicTag + i);
        NSString *imageString = [[listArray objectAtIndex:i] valueForKey:@"smallImage"];
        NSString *urlString = [_LOGIC getImagePathUrlWithBaseUrl:imageString];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@""]];
        
        UIView *shadowView = [[UIView alloc] init];
        shadowView.backgroundColor = [UIColor clearColor];
        shadowView.tag = imageTag + self.nPicIndex;
        
        UIImageView *checkboxImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"XN_LieCai_Brand_Promotion_Checkbox_unselected_icon@2x.png"]];
        checkboxImageView.tag = checkboxImageTag + self.nPicIndex;
        
        UIButton *checkboxButton = [[UIButton alloc] init];
        checkboxButton.selected = NO;
        checkboxButton.tag = self.nPicIndex;
        [checkboxButton addTarget:self action:@selector(checkboxButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:imageView];
        [view addSubview:shadowView];
        [view addSubview:checkboxImageView];
        [view addSubview:checkboxButton];
        [picView addSubview:view];
        
        __weak UIView *weakView = view;
        __weak UIImageView *weakCheckboxImageView = checkboxImageView;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakPicView.mas_top).offset(fHeaderPadding);
            make.left.equalTo(weakPicView.mas_left).offset(fLeftRightPadding);
            make.width.mas_equalTo(fPicWidth);
            make.height.mas_equalTo(fPicHeight);
        }];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakView);
        }];
        
        [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakView);
        }];
        
        [checkboxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakView.mas_top).offset(4.5);
            make.right.mas_equalTo(weakView.mas_right).offset(-4.5);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(15);
        }];
        
        [checkboxButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakView.mas_top);
            make.right.mas_equalTo(weakView.mas_right);
            make.left.mas_equalTo(weakCheckboxImageView.mas_left).offset(-10);
            make.bottom.mas_equalTo(weakCheckboxImageView.mas_bottom).offset(10);
        }];

        for (UIImageView *selectedImageView in self.selectedPicsArray)
        {
            if (selectedImageView.tag == imageView.tag)
            {
                checkboxButton.selected = YES;
                checkboxImageView.image = [UIImage imageNamed:@"XN_LieCai_Brand_Promotion_Checkbox_selected_icon@2x.png"];
                shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
                break;
            }
        }
        
        fLeftRightPadding += fPicWidth + fLeftPadding;
        if ((i + 1) % 3 == 0)
        {
            fLeftRightPadding = fLeftPadding;
            fHeaderPadding += fPicHeight + fTopBottomPadding;
        }
        
        [self.allPicsArray addObject:imageView];
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
    for (int i = 0; i < self.allPicsUrlArray.count; i++)
    {
        NSString *imageString = [[self.allPicsUrlArray objectAtIndex:i] valueForKey:@"image"];
        NSURL *url = [NSURL URLWithString:[_LOGIC getImagePathUrlWithBaseUrl:imageString]];
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

#pragma mark - 选中图片
- (void)checkboxButtonAction:(UIButton *)btn
{
    UIView *shadowView = [self.view viewWithTag:(imageTag + btn.tag)];
    UIImageView *checkboxIcon = [self.view viewWithTag:(checkboxImageTag + btn.tag)];
    UIImageView *imageView = [self.allPicsArray objectAtIndex:(btn.tag - 1)];
    
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        if (self.selectedPicsArray.count >= 3)
        {
            [self.view showCustomWarnViewWithContent:@"您最多选择3张图片"];
        }
        else
        {
            checkboxIcon.image = [UIImage imageNamed:@"XN_LieCai_Brand_Promotion_Checkbox_selected_icon@2x.png"];
            shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            [self.selectedPicsArray addObject:imageView];
            [self.selectedPicsUrlArray addObject:[[self.allPicsUrlArray objectAtIndex:(btn.tag - 1)] valueForKey:@"image"]];
        }
    }
    else
    {
        checkboxIcon.image = [UIImage imageNamed:@"XN_LieCai_Brand_Promotion_Checkbox_unselected_icon@2x.png"];
        shadowView.backgroundColor = [UIColor clearColor];
        
        if ([self.selectedPicsArray containsObject:imageView])
        {
            [self.selectedPicsArray removeObject:imageView];
            [self.selectedPicsUrlArray removeObject:[[self.allPicsUrlArray objectAtIndex:(btn.tag - 1)] valueForKey:@"image"]];
        }
        else
        {
            NSArray *array = [NSArray arrayWithArray:self.selectedPicsArray];
            for (UIImageView *selectedImageView in array)
            {
                if (selectedImageView.tag == imageView.tag)
                {
                    [self.selectedPicsArray removeObject:selectedImageView];
                    [self.selectedPicsUrlArray removeObject:[[self.allPicsUrlArray objectAtIndex:(btn.tag - 1)] valueForKey:@"image"]];
                    break;
                }
            }
        }
        
    }
    
}

////////////////////
#pragma mark - UITableView Delegate
////////////////////////////////////////////

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self initCell:cell];
    }
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float fTopBottomPadding = fTopPadding; //上下间距
    float fPicWidth = (SCREEN_FRAME.size.width - fLeftPadding * 4) / 3;
    float fPicHeight = fPicWidth * 130 / 207;
    //总行数
    NSInteger nRow = self.allPicsUrlArray.count % 3 == 0 ? self.allPicsUrlArray.count / 3 : self.allPicsUrlArray.count / 3 + 1;
    //总高度
    float fTotalHeight = fPicHeight * nRow + fTopBottomPadding * (nRow - 1);
    
    return fTotalHeight;
}

////////////////////
#pragma mark - setter/getter
////////////////////////////////////////////

- (NSMutableArray *)selectedPicsArray
{
    if (!_selectedPicsArray)
    {
        _selectedPicsArray = [[NSMutableArray alloc] init];
    }
    return _selectedPicsArray;
}

- (NSMutableArray *)selectedPicsUrlArray
{
    if (!_selectedPicsUrlArray)
    {
        _selectedPicsUrlArray = [[NSMutableArray alloc] init];
    }
    return _selectedPicsUrlArray;
}

- (NSMutableArray *)allPicsUrlArray
{
    if (!_allPicsUrlArray)
    {
        _allPicsUrlArray = [[NSMutableArray alloc] init];
    }
    return _allPicsUrlArray;
}

- (NSMutableArray *)allPicsArray
{
    if (!_allPicsArray)
    {
        _allPicsArray = [[NSMutableArray alloc] init];
    }
    return _allPicsArray;
}

@end
