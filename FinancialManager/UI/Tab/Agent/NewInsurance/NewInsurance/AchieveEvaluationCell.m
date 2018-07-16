//
//  AchieveEvaluationCell.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/27.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "AchieveEvaluationCell.h"
#import "InsuranceRecommendItemCell.h"
#import "XNInsuranceQquestionResultModel.h"
#import "QquestionResultRecomListItem.h" 

#define ITEM_CELL_WIDTH ((SCREEN_FRAME.size.width - 10.f - 10.f - 20.f) / 2.f)
#define ITEM_CELL_HEIGHT ((ITEM_CELL_WIDTH * 375 / SCREEN_FRAME.size.height) + 3.f)

@interface AchieveEvaluationCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@end

@implementation AchieveEvaluationCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.describeLabel.font = [UIFont fontWithName:@"DINOT" size:16.f];
    
    [self initUI];
}

/////////////////////////////
#pragma mark - custom method
/////////////////////////////

- (void)initUI
{
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([InsuranceRecommendItemCell class]) bundle:nil] forCellWithReuseIdentifier:@"InsuranceRecommendItemCell"];
    
    // 设置水平方向滚动
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 设置水平方向滚动条隐藏、翻页
    self.collectionView.scrollEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    // self.collectionView.pagingEnabled = YES; //分页
}

// 查看报告
- (IBAction)checkReport
{
    if ([self.delegate respondsToSelector:@selector(achieveEvaluationCellDid:withInsuranceCategroy:)]) {
        [self.delegate achieveEvaluationCellDid:self withInsuranceCategroy:nil];
    }
}

/////////////////////////////
#pragma mark - system method
/////////////////////////////

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.questionResultModel.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InsuranceRecommendItemCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InsuranceRecommendItemCell" forIndexPath:indexPath];
    itemCell.recomListItem = self.questionResultModel.data[indexPath.item];
    return itemCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(achieveEvaluationCellDid:withInsuranceCategroy:)]) {
        
        QquestionResultRecomListItem *listItem = self.questionResultModel.data[indexPath.item];
        [self.delegate achieveEvaluationCellDid:self withInsuranceCategroy:listItem.recomCategory];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ITEM_CELL_WIDTH, ITEM_CELL_HEIGHT);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.f, 5.f, 0.f, 0.f); // {top, left, bottom, right};
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

////////////////////////////////
#pragma mark - setter / getter
///////////////////////////////

- (void)setQuestionResultModel:(XNInsuranceQquestionResultModel *)questionResultModel
{
    _questionResultModel = questionResultModel;
    
    // 1.家庭保障分
    NSArray *propertyArray = @[@{@"range": @"家庭保障指数",
                                 @"color": UIColorFromHex(0X434B51),
                                 @"font": [UIFont fontWithName:@"DINOT" size:16.f]},
                               @{@"range": [NSString stringWithFormat:@"%@", questionResultModel.totalScore],
                                 @"color": UIColorFromHex(0X4E8CEF),
                                 @"font": [UIFont fontWithName:@"DINOT" size:16.f]},
                               @{@"range": @"分",
                                 @"color": UIColorFromHex(0X434B51),
                                 @"font": [UIFont fontWithName:@"DINOT" size:16.f]},
                               ];
    
    // 赋值页面上的数据
    NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
    self.scoreLabel.attributedText = string;
    
    // 2.风险等级
    self.describeLabel.text = questionResultModel.riskGrade;
    
    // 3.推荐
    [self.collectionView reloadData];
}



@end
