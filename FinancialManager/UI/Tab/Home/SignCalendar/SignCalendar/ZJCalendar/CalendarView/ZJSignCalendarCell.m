//
//  ZJSignCalendarCell.m
//  4_5_1日历
//
//  Created by 张吉晴 on 2017/11/30.
//  Copyright © 2017年 Power. All rights reserved.
//

#import "ZJSignCalendarCell.h"
#import "ZJSignItemCell.h"
#import "ZJRebackItemCell.h"
#import "ZJRebackItemCell.h"
#import "ZJCalendarManager.h"
#import "ZJCalendarModel.h"
#import "ZJCalendarItemModel.h"
#import "SignCalendarModel.h"
#import "InvestStatisticsItemModel.h"

@interface ZJSignCalendarCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@end

@implementation ZJSignCalendarCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setUI];
}

- (void)setUI
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZJSignItemCell" bundle:nil] forCellWithReuseIdentifier:@"ZJSignItemCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZJRebackItemCell" bundle:nil] forCellWithReuseIdentifier:@"ZJRebackItemCell"];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.calendarModel.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellType == Sign_Calendar_Cell) {
        
        ZJSignItemCell *signItemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZJSignItemCell" forIndexPath:indexPath];
        signItemCell.signImg.hidden = YES;
        ZJCalendarItemModel *itemModel = self.calendarModel.dataArray[indexPath.item];
        signItemCell.itemModel = itemModel;
        
        if (itemModel.type == ZJCalendarTypeCurrent) {
            
            [self.signArr enumerateObjectsUsingBlock:^(SignCalendarModel  *signCalendarModel, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([signCalendarModel.year integerValue] == [itemModel.date year] && [signCalendarModel.month integerValue] == [itemModel.date month]) {
            
                    for (NSInteger i = 0; i < signCalendarModel.data.count; i ++) {
                        NSString *signDayStr = signCalendarModel.data[i];
                        if ([signDayStr integerValue] == [itemModel.date day]) {
                            signItemCell.signImg.hidden = NO;
                        }
                    };
                    
                } else {
                    signItemCell.signImg.hidden = YES;
                }
            }];
            
        } else {
            
            //signItemCell.signImg.hidden = YES;
        }

        
        return signItemCell;
    
    } else {
        
        ZJRebackItemCell *rebackItemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZJRebackItemCell" forIndexPath:indexPath];
        rebackItemCell.rebackNumLabel.hidden = YES;
        rebackItemCell.signImgView.hidden = YES;
        ZJCalendarItemModel *itemModel = self.calendarModel.dataArray[indexPath.item];
        rebackItemCell.itemModel = itemModel;
        
        if (itemModel.type == ZJCalendarTypeCurrent) {
            
            [self.investStatisticsArr enumerateObjectsUsingBlock:^(InvestStatisticsItemModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj.year integerValue] == [itemModel.date year] && [obj.month integerValue] == [itemModel.date month] && [itemModel.date day] == [obj.day integerValue]) {
                    if ([NSObject isValidateObj:obj.calendarNumber]) {
                        rebackItemCell.rebackNumLabel.text = obj.calendarNumber;
                    }
                }
            }];
        }
        
        return rebackItemCell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CalendarItem_Width, CalendarItem_Height);
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
    return 0;
}

///////////////////////
#pragma mark - setter / getter
///////////////////////////

- (void)setCalendarModel:(ZJCalendarModel *)calendarModel
{
    _calendarModel = calendarModel;
    
    [self.collectionView reloadData];
}

- (void)setSignArr:(NSMutableArray *)signArr
{
    _signArr = signArr;
    
    [self.collectionView reloadData];
}

- (void)setInvestStatisticsArr:(NSMutableArray *)investStatisticsArr
{
    _investStatisticsArr = investStatisticsArr;
    
    [self.collectionView reloadData];
}


@end
