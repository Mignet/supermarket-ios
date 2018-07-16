//
//  NewBrandPromotionController.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/28.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "NewBrandPromotionController.h"
#import "NewBrandPromotionImageController.h"
#import "BrandPromotionImageShareView.h"
#import "InsuranceOptionCellItem.h"

#import "XNLCBrandTypeItem.h" // 推广海报类型

@interface NewBrandPromotionController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    
    CGFloat _itemWidth;
    CGFloat _itemHeight;
}

/*** 选项视图 **/
@property (weak, nonatomic) IBOutlet UIScrollView *optionScrollView;

@property (weak, nonatomic) IBOutlet UICollectionView *optionCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *optionLayout;

/*** 选项内容视图 **/
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

/*** 控制器数组 **/
@property (nonatomic, strong) NSMutableArray *controllerArr;

/*** 选项下划线 **/
@property (nonatomic, strong) UIView *lineView;

/*** 选项数组 **/
@property (nonatomic, strong) NSMutableArray *optionArr;

/*** 按钮存储数组 **/
@property (nonatomic, strong) NSMutableArray *optionBtnArr;

/*** 默认选中的选项 ***/
@property (nonatomic, strong) XNLCBrandTypeItem *defaultBrandTypeItem;

@end

@implementation NewBrandPromotionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    
    [self initCollectionView];
    
    // 创建控制器页面
    [self initChilderControllerView];
}

//////////////////////////////////
#pragma mark - custom method
//////////////////////////////////

- (void)initView
{
    self.navigationItem.title = @"推广海报";
    
    self.optionScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
}

- (void)initCollectionView
{
    _itemHeight = 45.f;
    if (self.optionArr.count < 4) {
        _itemWidth = SCREEN_FRAME.size.width / self.optionArr.count;
    } else {
        _itemWidth = SCREEN_FRAME.size.width / 4.f;
    }
    
    // 注册单元格
    [self.optionCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([InsuranceOptionCellItem class]) bundle:nil] forCellWithReuseIdentifier:@"InsuranceOptionCellItem"];
    // 设置滚动方向
    self.optionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.optionCollectionView.showsHorizontalScrollIndicator = false;
}


- (void)initChilderControllerView
{
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.contentSize = CGSizeMake(SCREEN_FRAME.size.width * self.optionArr.count, 0);
    
    for (NSInteger i = 0; i < self.optionArr.count; i ++) {
        
        XNLCBrandTypeItem *brandTypeItem = self.optionArr[i];
        
        NewBrandPromotionImageController *imageVC = [[NewBrandPromotionImageController alloc] initWithNibName:NSStringFromClass([NewBrandPromotionImageController class]) bundle:nil withIndex:i withThemeType:[NSString stringWithFormat:@"%@", brandTypeItem.typeValue]];
        
        if (brandTypeItem.isChoose == YES) {
            
            [self.contentScrollView addSubview:imageVC.view];
            self.contentScrollView.contentOffset = CGPointMake(i * SCREEN_FRAME.size.width, 0);
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.optionCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
        [self.controllerArr addObject:imageVC];
    }
}

//////////////////////////////////
#pragma mark - system protocol
//////////////////////////////////

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
    if (scrollView == self.optionCollectionView) { // 手动滚动选项CollectionView不做处理
        return;
    }
    
    NSInteger pageIndex = scrollView.contentOffset.x / SCREEN_FRAME.size.width;
    
    XNLCBrandTypeItem *brandTypeItem = self.optionArr[pageIndex];
    
    if (!([brandTypeItem.typeValue integerValue] == [self.defaultBrandTypeItem.typeValue integerValue])) {
        
        brandTypeItem.isChoose = YES;
        self.defaultBrandTypeItem.isChoose = NO;
        self.defaultBrandTypeItem = brandTypeItem;
        
        [self.optionCollectionView reloadData];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:pageIndex inSection:0];
        [self.optionCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        // 添加视图
        NewBrandPromotionImageController *imageVC = self.controllerArr[indexPath.row];
        [self.contentScrollView addSubview:imageVC.view];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.optionArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
    InsuranceOptionCellItem *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InsuranceOptionCellItem" forIndexPath:indexPath];
    itemCell.brandTypeItem = self.optionArr[indexPath.item];
    return itemCell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    XNLCBrandTypeItem *brandTypeItem = self.optionArr[indexPath.item];
    
    if (!([brandTypeItem.typeValue integerValue] == [self.defaultBrandTypeItem.typeValue integerValue])) {
        
        // 设置默认选中
        self.defaultBrandTypeItem.isChoose = NO;
        brandTypeItem.isChoose = YES;
        self.defaultBrandTypeItem = brandTypeItem;
        
        // 添加视图
        NewBrandPromotionImageController *imageVC = self.controllerArr[indexPath.row];
        [self.contentScrollView addSubview:imageVC.view];
        
        // 滚动视图
        [UIView animateWithDuration:0.35 animations:^{
            self.contentScrollView.contentOffset = CGPointMake(SCREEN_FRAME.size.width * indexPath.item, 0);
        }];
    }
    
    // 点击滚动到指定的位置
    [self.optionCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.optionCollectionView reloadData];

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake (_itemWidth, _itemHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f); // {top, left, bottom, right};
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}


//////////////////////////////////
#pragma mark - setter / getter
//////////////////////////////////

- (NSMutableArray *)optionArr
{
    if (!_optionArr) {
        
        _optionArr = [NSMutableArray arrayWithCapacity:0];
        
        NSArray *typeListArr = [_LOGIC readDataFromFileName:@"Liecai_User_PostersType.plist"];
        
        for (NSInteger i = 0; i < typeListArr.count; i ++) {
            
            XNLCBrandTypeItem *item = [XNLCBrandTypeItem brandTypeItem:typeListArr[i]];
            
            if (i == 0) {
                item.isChoose = YES;
                self.defaultBrandTypeItem = item;
            }
            [_optionArr addObject:item];
        }
    }
    
    return _optionArr;
}

- (NSMutableArray *)optionBtnArr
{
    if (!_optionBtnArr) {
        _optionBtnArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _optionBtnArr;
}

- (NSMutableArray *)controllerArr
{
    if (!_controllerArr) {
        _controllerArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _controllerArr;
}


@end
