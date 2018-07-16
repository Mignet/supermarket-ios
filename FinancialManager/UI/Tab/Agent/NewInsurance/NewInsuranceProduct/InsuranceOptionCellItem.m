//
//  InsuranceOptionCellItem.m
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/2.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import "InsuranceOptionCellItem.h"
#import "XNInsuranceCategoryModel.h"
#import "XNLCBrandTypeItem.h"

@interface InsuranceOptionCellItem ()

@property (weak, nonatomic) IBOutlet UILabel *optionLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation InsuranceOptionCellItem

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setCategoryModel:(XNInsuranceCategoryModel *)categoryModel
{
    _categoryModel = categoryModel;
    
    self.optionLabel.text = categoryModel.message;
    
    
    self.optionLabel.textColor = categoryModel.isChoose ? UIColorFromHex(0x4E8CEF): UIColorFromHex(0x4F5960);
    self.lineView.backgroundColor = categoryModel.isChoose ? UIColorFromHex(0x4E8CEF): UIColorFromHex(0xFFFFFF);
    
}

- (void)setBrandTypeItem:(XNLCBrandTypeItem *)brandTypeItem
{
    _brandTypeItem = brandTypeItem;
    
    self.optionLabel.text = brandTypeItem.name;
    
    
    self.optionLabel.textColor = brandTypeItem.isChoose ? UIColorFromHex(0x4E8CEF): UIColorFromHex(0x4F5960);
    self.lineView.backgroundColor = brandTypeItem.isChoose ? UIColorFromHex(0x4E8CEF): UIColorFromHex(0xFFFFFF);
    
}

@end
