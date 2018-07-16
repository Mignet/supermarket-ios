//
//  InsuranceOptionCellItem.h
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/2.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XNInsuranceCategoryModel, XNLCBrandTypeItem;

@interface InsuranceOptionCellItem : UICollectionViewCell

@property (nonatomic, strong) XNInsuranceCategoryModel *categoryModel;

@property (nonatomic, strong) XNLCBrandTypeItem *brandTypeItem;


@end
