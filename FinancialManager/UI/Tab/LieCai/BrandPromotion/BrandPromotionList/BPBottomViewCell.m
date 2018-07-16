//
//  BPBottomViewCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/5/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "BPBottomViewCell.h"
#import "XNLCBrandPromotionMode.h"
#import "CustomTapGestureRecognizer.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#define OFFSET_TOP 28.0f
#define fPadding 10.0f
#define imageTag 10000
#define checkboxImageTag 20000
#define hotPicTag 1111111111
#define remmendPicTag 2222222222

@interface BPBottomViewCell ()

@property (nonatomic, weak) IBOutlet UIView *hotPostersView;
@property (nonatomic, weak) IBOutlet UIView *hotPostersPicView;
@property (nonatomic, weak) IBOutlet UIView *postersView;
@property (nonatomic, weak) IBOutlet UIView *postersPicView;

@property (nonatomic, strong) XNLCBrandPromotionMode *mode;

@property (nonatomic, strong) NSMutableArray *picsUrlArray;
@property (nonatomic, assign) NSInteger nPicIndex; //图片tag
@property (nonatomic, strong) NSMutableArray *allPicArray;//当前页面所有的图片
@property (nonatomic, strong) NSMutableArray *selectedPicArray; //记录选中的图片
@property (nonatomic, strong) NSMutableArray *selectedPicUrlArray; //记录选中的图片的大图url
@property (nonatomic, assign) BOOL isShouldUpdatePics;

@end

@implementation BPBottomViewCell

- (void)showDatas:(XNLCBrandPromotionMode *)mode type:(NSString *)type selectedPics:(NSArray *)selectedPicArray selectedPicUrls:(NSArray *)selectedPicUrlsArray shouldUpdatePics:(BOOL)isShouldUpdatePics
{
    self.nPicIndex = 0;
    self.isShouldUpdatePics = isShouldUpdatePics;
    [self.hotPostersPicView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.postersPicView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [self.allPicArray removeAllObjects];
    [self.picsUrlArray removeAllObjects];
    [self.selectedPicArray removeAllObjects];
    [self.selectedPicUrlArray removeAllObjects];
    [self.selectedPicArray addObjectsFromArray:selectedPicArray];
    [self.selectedPicUrlArray addObjectsFromArray:selectedPicUrlsArray];
    
    self.mode = mode;
    weakSelf(weakSelf)
    __weak UIView *weakPostersView = self.postersView;
    if (mode.hotPosterList && mode.hotPosterList.count > 0)
    {
        self.hotPostersView.hidden = NO;
        [self.postersView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-10);
            make.left.mas_equalTo(weakPostersView.mas_left);
            make.right.mas_equalTo(weakPostersView.mas_right);
            make.height.mas_equalTo(100);
        }];
        UIView *view = [self showPosters:mode.hotPosterList picType:HotPicType];
        [self.hotPostersPicView addSubview:view];
        __weak UIView *weakHotPostersPicView = self.hotPostersPicView;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakHotPostersPicView);
        }];
    }
    else
    {
        self.hotPostersView.hidden = YES;
        [self.postersView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.mas_top).offset(OFFSET_TOP);
            make.left.mas_equalTo(weakPostersView.mas_left);
            make.right.mas_equalTo(weakPostersView.mas_right);
            make.height.mas_equalTo(100);
        }];
    }
    
    if (mode.recommenList && mode.recommenList.count > 0)
    {
        UIView *view = [self showPosters:mode.recommenList picType:RecommendPicType];
        [self.postersPicView addSubview:view];
        __weak UIView *weakPostersPicView = self.postersPicView;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakPostersPicView);
        }];
    }
    
}

#pragma mark - 展示图片
- (UIView *)showPosters:(NSArray *)listArray picType:(NSInteger)picType
{
//    UIView *picView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 30, 65)];
    UIView *picView = [[UIView alloc] init];
    float fPicWidth = (SCREEN_FRAME.size.width - 30 - fPadding * 4) / 3;
    float fPicHeight = fPicWidth * 130 / 207;
    float fLeftPadding = fPadding; //左右间距
    NSInteger nCount = listArray.count >= 3 ? 3 : listArray.count;
    __weak UIView *weakPicView = picView;
    for (int i = 0; i < nCount; i ++)
    {
        self.nPicIndex ++;
        NSString *imageString = [[listArray objectAtIndex:i] valueForKey:@"smallImage"];
        NSString *urlString = [_LOGIC getImagePathUrlWithBaseUrl:imageString];
        //大图
        [self.picsUrlArray addObject:[[listArray objectAtIndex:i] valueForKey:@"image"]];
        
        UIView *view = [[UIView alloc] init];
        view.userInteractionEnabled = YES;
        CustomTapGestureRecognizer *tapRecognizer = [[CustomTapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLargeImage:)];
        tapRecognizer.nIndex = self.nPicIndex - 1;
        [view addGestureRecognizer:tapRecognizer];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = picType == HotPicType ? (hotPicTag + i) : (remmendPicTag + i);
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
            make.top.mas_equalTo(weakPicView.mas_top);
            make.left.equalTo(weakPicView.mas_left).offset(fLeftPadding);
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
        
        fLeftPadding += fPicWidth + fPadding;
        
        NSString *selectedStatue = @"0";
        
        if (self.isShouldUpdatePics && self.selectedPicArray.count > 0)
        {
//            if (self.selectedPicArray.count <= 0)
//            {
//                break;
//            }
            for (UIImageView *selectedImageView in self.selectedPicArray)
            {
                if (selectedImageView.tag == imageView.tag)
                {
                    checkboxButton.selected = YES;
                    checkboxImageView.image = [UIImage imageNamed:@"XN_LieCai_Brand_Promotion_Checkbox_selected_icon@2x.png"];
                    shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
                    break;
                }
            }
        }
        else
        {
            if (i == 0 && self.selectedPicArray.count <= 0)
            {
                if (picType == HotPicType || (picType == RecommendPicType && self.mode.hotPosterList.count <= 0))
                {
                    selectedStatue = @"1";
                    checkboxButton.selected = YES;
                    checkboxImageView.image = [UIImage imageNamed:@"XN_LieCai_Brand_Promotion_Checkbox_selected_icon@2x.png"];
                    shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
                    [self.selectedPicArray addObject:imageView];
                    [self.selectedPicUrlArray addObject:[[listArray objectAtIndex:i] valueForKey:@"image"]];
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(BPBottomViewCellDelegateDidSelectedPics:selectedPicUrls:isMoreThreePic:)])
                    {
                        [self.delegate BPBottomViewCellDelegateDidSelectedPics:self.selectedPicArray selectedPicUrls:self.selectedPicUrlArray isMoreThreePic:NO];
                    }
                }
            }
            
        }

        [self.allPicArray addObject:imageView];
    }
    
    return picView;
}

#pragma mark - 点击放大图片
- (void)clickLargeImage:(UITapGestureRecognizer *)gesture
{
    CustomTapGestureRecognizer *gestureRecogizer = (CustomTapGestureRecognizer *)gesture;
    //查看头像大图
    NSMutableArray *photos = [NSMutableArray array];
    for (NSString *urlString in self.picsUrlArray)
    {
        NSURL *url = [NSURL URLWithString:[_LOGIC getImagePathUrlWithBaseUrl:urlString]];
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
    UIView *shadowView = [self viewWithTag:(imageTag + btn.tag)];
    UIImageView *checkboxIcon = [self viewWithTag:(checkboxImageTag + btn.tag)];
    UIImageView *imageView = [self.allPicArray objectAtIndex:(btn.tag - 1)];
    
    BOOL isMoreThreePic = NO;
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        if (self.selectedPicArray.count >= 3)
        {
            isMoreThreePic = YES;
        }
        else
        {
            checkboxIcon.image = [UIImage imageNamed:@"XN_LieCai_Brand_Promotion_Checkbox_selected_icon@2x.png"];
            shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            
            [self.selectedPicArray addObject:imageView];
            [self.selectedPicUrlArray addObject:[self.picsUrlArray objectAtIndex:(btn.tag - 1)]];
        }
    }
    else
    {
        checkboxIcon.image = [UIImage imageNamed:@"XN_LieCai_Brand_Promotion_Checkbox_unselected_icon@2x.png"];
        shadowView.backgroundColor = [UIColor clearColor];
        
        if ([self.selectedPicArray containsObject:imageView])
        {
            [self.selectedPicArray removeObject:imageView];
            [self.selectedPicUrlArray removeObject:[self.picsUrlArray objectAtIndex:(btn.tag - 1)]];
        }
        else
        {
            NSArray *array = [NSArray arrayWithArray:self.selectedPicArray];
            for (UIImageView *selectedImageView in array)
            {
                if (selectedImageView.tag == imageView.tag)
                {
                    [self.selectedPicArray removeObject:selectedImageView];
                    [self.selectedPicUrlArray removeObject:[self.picsUrlArray objectAtIndex:(btn.tag - 1)]];
 
                }
            }
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(BPBottomViewCellDelegateDidSelectedPics:selectedPicUrls:isMoreThreePic:)])
    {
        [self.delegate BPBottomViewCellDelegateDidSelectedPics:self.selectedPicArray selectedPicUrls:self.selectedPicUrlArray isMoreThreePic:isMoreThreePic];
    }
    
}

- (IBAction)showMoreAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(BPBottomViewCellDelegateDidShowMoreDatas:)])
    {
        [self.delegate BPBottomViewCellDelegateDidShowMoreDatas:btn.tag];
    }
}


////////////////////
#pragma mark - setter/getter
////////////////////////////////////////////

- (NSMutableArray *)picsUrlArray
{
    if (!_picsUrlArray)
    {
        _picsUrlArray = [[NSMutableArray alloc] init];
    }
    return _picsUrlArray;
}

- (NSMutableArray *)allPicArray
{
    if (!_allPicArray)
    {
        _allPicArray = [[NSMutableArray alloc] init];
    }
    return _allPicArray;
}

- (NSMutableArray *)selectedPicArray
{
    if (!_selectedPicArray)
    {
        _selectedPicArray = [[NSMutableArray alloc] init];
    }
    return _selectedPicArray;
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
