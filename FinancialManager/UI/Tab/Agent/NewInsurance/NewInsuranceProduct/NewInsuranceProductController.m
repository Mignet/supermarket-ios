//
//  NewInsuranceProductController.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/26.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "NewInsuranceProductController.h"
#import "InsuranceTypeListViewController.h"
#import "XNInsuranceCategoryModel.h"
#import "InsuranceOptionCellItem.h"

@interface NewInsuranceProductController () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/*** 选项视图 **/
//@property (weak, nonatomic) IBOutlet UIScrollView *optionScrollView;

@property (nonatomic, copy) NSString *insuranceType;

@property (weak, nonatomic) IBOutlet UICollectionView *optionCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

/*** 产品描述视图 **/
@property (weak, nonatomic) IBOutlet UIView *productDescribeView;

/*** 产品描述视图高 **/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productDescribeViewheight;

/*** 缓存按钮数组 **/
@property (nonatomic, strong) NSMutableArray *optionBtnArr;

/*** 保险列表数组 **/
@property (nonatomic, strong) NSMutableArray *listInsuranceArr;

/*** 下滑线 **/
@property (nonatomic, strong) UIView *lineView;

/*** 产品视图 **/
@property (weak, nonatomic) IBOutlet UIScrollView *productScrollView;

/*** 数据源 **/
@property (nonatomic, strong) NSMutableArray *optionArr;

@property (nonatomic, assign) BOOL isScroll;

@property (nonatomic, strong) XNInsuranceCategoryModel *defaultCategoryModel;


@end

@implementation NewInsuranceProductController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withInsuranceType:(NSString *)insuranceType
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        // 1-意外险  2-旅游险 3-家财险  4-医疗险 5-重疾险 6-年金险 7-寿险 8-少儿险 9-老年险
        self.insuranceType = insuranceType;
        self.isScroll = YES;
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.isScroll) {
        
        NSInteger num = 0;
        for (NSInteger i = 0; i < self.optionArr.count; i ++) {
            XNInsuranceCategoryModel *categoryModel = self.optionArr[i];
            if ([self.insuranceType integerValue] == [categoryModel.category integerValue]) {
                num = i;
            }
        }
        
        CGFloat scro_width = 0.f;
        CGFloat width = SCREEN_FRAME.size.width / 5.f;
        
        if (num > 5) {
            
            if(self.optionArr.count - num > 1){
               scro_width = width * (num - 5 + 2);
            }else{
                scro_width = width * (num - 5 + 1);
            }
        }
        [self.optionCollectionView setContentOffset:CGPointMake(scro_width, 0.f)];
        
        self.isScroll = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化默认
    self.productScrollView.showsHorizontalScrollIndicator = NO;
    self.productScrollView.contentSize = CGSizeMake(SCREEN_FRAME.size.width * self.optionArr.count , 0.f);
    
    [self initView];
    
    // 注册单元格
    [self.optionCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([InsuranceOptionCellItem class]) bundle:nil] forCellWithReuseIdentifier:@"InsuranceOptionCellItem"];
    // 设置滚动方向
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.optionCollectionView.showsHorizontalScrollIndicator = false;
    
    [self initListInsuranceView];

}


//////////////////////////////////
#pragma mark - custom method
//////////////////////////////////

- (void)initView
{
    self.navigationItem.title = @"保险产品";
}

- (void)initListInsuranceView
{
    for (NSInteger i = 0; i < self.optionArr.count; i ++) {
        
        XNInsuranceCategoryModel *categoryModel = self.optionArr[i];
        
        InsuranceTypeListViewController *insuranceTypeListVC = [[InsuranceTypeListViewController alloc] initWithNibName:@"InsuranceTypeListViewController" bundle:nil Index:i InsuranceType:categoryModel.category];
        
        if (categoryModel.isChoose == YES) {
    
            [self.productScrollView addSubview:insuranceTypeListVC.view];
            self.productScrollView.contentOffset = CGPointMake(i * SCREEN_FRAME.size.width, 0);
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.optionCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
        
        [self.listInsuranceArr addObject:insuranceTypeListVC];
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
    
    XNInsuranceCategoryModel *categoryModel = self.optionArr[pageIndex];
    
    if (![categoryModel.category isEqualToString:self.defaultCategoryModel.category]) {
        
        categoryModel.isChoose = YES;
        self.defaultCategoryModel.isChoose = NO;
        self.defaultCategoryModel = categoryModel;
        
        [self.optionCollectionView reloadData];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:pageIndex inSection:0];
        [self.optionCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        InsuranceTypeListViewController *listVC = self.listInsuranceArr[pageIndex];
        [self.productScrollView addSubview:listVC.view];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.optionArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InsuranceOptionCellItem *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InsuranceOptionCellItem" forIndexPath:indexPath];
    itemCell.categoryModel = self.optionArr[indexPath.item];
    return itemCell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XNInsuranceCategoryModel *categoryModel = self.optionArr[indexPath.item];
    
    if (![categoryModel.category isEqualToString:self.defaultCategoryModel.category]) {
        
        // 设置默认选中
        self.defaultCategoryModel.isChoose = NO;
        categoryModel.isChoose = YES;
        self.defaultCategoryModel = categoryModel;
        
        // 添加视图
        InsuranceTypeListViewController *listVC = self.listInsuranceArr[indexPath.row];
        [self.productScrollView addSubview:listVC.view];
        
        // 滚动视图
        [UIView animateWithDuration:0.3 animations:^{
            self.productScrollView.contentOffset = CGPointMake(SCREEN_FRAME.size.width * indexPath.item, 0);
        }];
    }
    
    // 点击滚动到指定的位置
    [self.optionCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.optionCollectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake (SCREEN_FRAME.size.width / 5.f, 45.f);
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
        
        // 初始化数组
        _optionArr = [NSMutableArray arrayWithCapacity:0];
        NSArray *categoryArr = [_LOGIC readDataFromFileName:@"insurance_category.plist"];
        
        for (NSDictionary *params in categoryArr) {
          XNInsuranceCategoryModel * categoryModel = [XNInsuranceCategoryModel createInsuranceCategoryModel:params];
            
            if ([categoryModel.category isEqualToString:self.insuranceType]) {
                categoryModel.isChoose = YES;
                self.defaultCategoryModel = categoryModel;
            } else {
                categoryModel.isChoose = NO;
            }
            [_optionArr addObject:categoryModel];
        }
    }
    return _optionArr;
}

- (NSMutableArray *)listInsuranceArr
{
    if (!_listInsuranceArr) {
        _listInsuranceArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _listInsuranceArr;
}



@end
