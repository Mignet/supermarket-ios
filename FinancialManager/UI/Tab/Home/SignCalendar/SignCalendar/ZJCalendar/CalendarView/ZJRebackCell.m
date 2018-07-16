//
//  ZJRebackCell.m
//  4_5_1日历
//
//  Created by 张吉晴 on 2017/12/3.
//  Copyright © 2017年 Power. All rights reserved.
//

#import "ZJRebackCell.h"

#import "ZJCalendarMacros.h"
#import "ZJCalendarManager.h"

#import "ZJSignCalendarCell.h"
#import "ZJRebackMonthItemCell.h"

#import "ZJCalendarModel.h"
#import "ZJCalendarItemModel.h"


@interface ZJRebackCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *weekArr;
@property (nonatomic, strong) NSArray *dataArr;

@property (weak, nonatomic) IBOutlet UIView *weekView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *monthCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *monthLayout;


/*** 当前显示的年月 （防止频繁回调） **/
@property (nonatomic, assign) NSInteger showYear;
@property (nonatomic, assign) NSInteger showMonth;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@end

@implementation ZJRebackCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initWeekView];
    
    self.yearLabel.text = [NSString stringWithFormat:@"%ld年", (unsigned long)[[NSDate new] year]];
    
    [self initCollectionView];
    
    // 注册
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZJSignCalendarCell" bundle:nil] forCellWithReuseIdentifier:@"ZJSignCalendarCell"];
    
    [self.monthCollectionView registerNib:[UINib nibWithNibName:@"ZJRebackMonthItemCell" bundle:nil] forCellWithReuseIdentifier:@"ZJRebackMonthItemCell"];
    
    __weak typeof(self) weakSelf = self;
    [ZJCalendarManager shareInstance].block = ^(ZJCalendarType type, NSInteger index, NSInteger year) {
    
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [weakSelf.monthCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [weakSelf.monthCollectionView reloadData];
        
        [weakSelf.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        weakSelf.yearLabel.text = [NSString stringWithFormat:@"%ld年", (long)year];
        
        
        /*** 控制器请求数据 **/
        if (weakSelf.block) {
            weakSelf.block(index);
        }
        
        [weakSelf.collectionView reloadData];
    };
    
    
    [ZJCalendarManager shareInstance].itemBlock = ^(ZJCalendarItemModel *itemModel) {
    
        if (itemModel != [ZJCalendarManager shareInstance].selectedItemModel) {
            
            if (weakSelf.dayBlock) {
                weakSelf.dayBlock(itemModel);
            }
        }
        
        [ZJCalendarManager shareInstance].selectedItemModel.isSelected = NO;
        [ZJCalendarManager shareInstance].selectedItemModel = itemModel;
        [ZJCalendarManager shareInstance].selectedItemModel.isSelected = YES;
        
        [weakSelf.collectionView reloadData];
    };
    
    //默认滚动到指定单元格
    [self layoutIfNeeded];
    ZJCalendarModel *calendarModel = [[ZJCalendarManager shareInstance] getSelectedMonthModel];
    
    // 防止重复请求数据
    self.showYear = calendarModel.year;
    self.showMonth = calendarModel.month;
    
    if (calendarModel) { // 默认滚动到指定位置
        if ([ZJCalendarManager shareInstance].investOrReback == Manager_Reback_Type) {
            [weakSelf.monthCollectionView setContentOffset:CGPointMake((SCREEN_WIDTH - 70.f) / 5 * calendarModel.index - 15.f, 0.f)];
        } else if ([ZJCalendarManager shareInstance].investOrReback == Manager_Invest_Type) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:calendarModel.index inSection:0];
            [weakSelf.monthCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
        
        [weakSelf.collectionView setContentOffset:CGPointMake(SCREEN_WIDTH * calendarModel.index, 0.f)];
    }
}

////////////////////////
#pragma mark - custom method
////////////////////////

- (void)initWeekView
{
    CGFloat width = SCREEN_WIDTH / self.weekArr.count;
    
    [self.weekArr enumerateObjectsUsingBlock:^(NSString *weekStr, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *weekLabel = [[UILabel alloc] init];
        weekLabel.frame = CGRectMake(idx * width, 0, width, self.weekView.frame.size.height);
        weekLabel.font = [UIFont systemFontOfSize:15.f];
        weekLabel.textColor = UIColorFromHex(0XB2B2B2);
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.text = weekStr;
        [self.weekView addSubview:weekLabel];
    }];
    
}

- (void)initCollectionView
{
    // 设置水平方向滚动
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.monthLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 设置水平方向滚动条隐藏、翻页
    //self.collectionView.scrollEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    
    self.monthCollectionView.scrollEnabled = YES;
    self.monthCollectionView.showsHorizontalScrollIndicator = NO;
}

#pragma mark - UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count; // 3
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView) {
        
        ZJSignCalendarCell *signCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZJSignCalendarCell" forIndexPath:indexPath];
        signCell.cellType = Reback_Calendar_Cell;
        signCell.calendarModel = self.dataArr[indexPath.item];
        signCell.investStatisticsArr = self.statisticsArr;
        return signCell;
    
    } else {
    
        ZJRebackMonthItemCell *rebackItemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZJRebackMonthItemCell" forIndexPath:indexPath];
        rebackItemCell.calendarModel = self.dataArr[indexPath.item];
        return rebackItemCell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.monthCollectionView) {
        
        [[ZJCalendarManager shareInstance] updateSelectedMonthModel:self.dataArr[indexPath.item] withIndex:indexPath.item];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView) {
        return CGSizeMake(CalendarCell_Width, CalendarCell_Height + 1);
    }
    
    return CGSizeMake((SCREEN_WIDTH - 76.f) / 5.f, 45.f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView) {
        
            CGFloat pageWidth = scrollView.frame.size.width;
            NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
            NSArray *calendarArr = [[ZJCalendarManager shareInstance] getRebackCalendarModelArr];
        
            ZJCalendarModel *calendarModel = calendarArr[currentPage];
        
        
        if (self.showYear != calendarModel.year || self.showMonth != calendarModel.month) {
            self.showYear = calendarModel.year;
            self.showMonth = calendarModel.month;
            
            [[ZJCalendarManager shareInstance] updateSelectedMonthModel:calendarModel withIndex:currentPage];
        }
    }
}

////////////////////////
#pragma mark - setter / getter
////////////////////////

- (NSArray *)weekArr
{
    if (!_weekArr) {
        _weekArr = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    }
    return _weekArr;
}

- (NSArray *)dataArr
{
    if (!_dataArr) {
        
        _dataArr = [ZJCalendarManager shareInstance].getRebackCalendarModelArr;
    }
    return _dataArr;
}

- (void)setStatisticsArr:(NSMutableArray *)statisticsArr
{
    _statisticsArr = statisticsArr;
    
    [self.collectionView reloadData];
}


@end
