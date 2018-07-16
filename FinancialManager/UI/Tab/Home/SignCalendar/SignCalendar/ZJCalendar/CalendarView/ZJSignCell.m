//
//  ZJSignCell.m
//  4_5_1日历
//
//  Created by 张吉晴 on 2017/11/30.
//  Copyright © 2017年 Power. All rights reserved.
//

#import "ZJSignCell.h"
#import "ZJSignCalendarCell.h"
#import "ZJCalendarManager.h"
#import "ZJCalendarModel.h"

@interface ZJSignCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *weekArr;
@property (nonatomic, strong) NSArray *dataArr;

/*** 当前显示的年月 （防止频繁回调） **/
@property (nonatomic, assign) NSInteger showYear;
@property (nonatomic, assign) NSInteger showMonth;

@property (weak, nonatomic) IBOutlet UIView *weekView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@end

@implementation ZJSignCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setUI];
    
    [self layoutIfNeeded];
    
    NSArray *calendarArrr = [[ZJCalendarManager shareInstance] getSignCalendarModelArr];
    __weak typeof(self) weakSelf = self;
    [calendarArrr enumerateObjectsUsingBlock:^(ZJCalendarModel *calendarModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (calendarModel.isShow) {
            [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    }];
    
    NSArray *calenderModelArr = [[ZJCalendarManager shareInstance] getSignCalendarModelArr];
    ZJCalendarModel *calenderModel = [calenderModelArr lastObject];
    self.showYear = calenderModel.year;
    self.showMonth = calenderModel.month;
}


- (void)setUI
{
    CGFloat width = SCREEN_WIDTH / self.weekArr.count;
    
    [self.weekArr enumerateObjectsUsingBlock:^(NSString *weekStr, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *weekLabel = [[UILabel alloc] init];
        weekLabel.frame = CGRectMake(idx * width, 0, width, self.weekView.frame.size.height);
        weekLabel.font = [UIFont systemFontOfSize:14.f];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.textColor = UIColorFromHex(0XB2B2B2);
        weekLabel.text = weekStr;
        [self.weekView addSubview:weekLabel];
    }];
    
    // 注册
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZJSignCalendarCell" bundle:nil] forCellWithReuseIdentifier:@"ZJSignCalendarCell"];
    
    // 设置水平方向滚动
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 设置水平方向滚动条隐藏、翻页
    self.collectionView.scrollEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
}

#pragma mark - UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count; 
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZJSignCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZJSignCalendarCell" forIndexPath:indexPath];
    cell.cellType = Sign_Calendar_Cell;
    // 日历几月几号（数据模型）
    cell.calendarModel = self.dataArr[indexPath.item];
    // 是否签到数据模型
    cell.signArr = self.signCalendarArr;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CalendarCell_Width, CalendarCell_Height + 1);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
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
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    NSArray *calendarArr = [[ZJCalendarManager shareInstance] getSignCalendarModelArr];
    ZJCalendarModel *calendarModel = calendarArr[currentPage];
    
    if (self.showYear != calendarModel.year || self.showMonth != calendarModel.month) {
        self.showYear = calendarModel.year;
        self.showMonth = calendarModel.month;
        
        if (self.passBlock) {
            self.passBlock(calendarModel.year, calendarModel.month);
        }
    }
}

///////////////////////////////////
#pragma mark - setter / getter
////////////////////////////////////

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
        _dataArr = [ZJCalendarManager shareInstance].getSignCalendarModelArr;
    }
    return _dataArr;
}

- (void)setSignCalendarArr:(NSMutableArray *)signCalendarArr
{
    _signCalendarArr = signCalendarArr;
    
    [self.collectionView reloadData];
}



@end
