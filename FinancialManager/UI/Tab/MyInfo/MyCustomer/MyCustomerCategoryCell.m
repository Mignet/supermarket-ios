//
//  MyCustomerCell.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/17.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "MyCustomerCategoryCell.h"
#import "XNCSNewCustomerItemModel.h"

@interface MyCustomerCategoryCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@end

@implementation MyCustomerCategoryCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setItemModel:(XNCSNewCustomerItemModel *)itemModel
{
    _itemModel = itemModel;
    
    //头像
    NSString *urlString = [NSString stringWithFormat:@"%@?f=png", [_LOGIC getImagePathUrlWithBaseUrl:itemModel.headImage]];
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    [self.iconImgView.layer setCornerRadius:20];
    [self.iconImgView.layer setMasksToBounds:YES];

    //名称
    self.nameLabel.text = itemModel.userName;
    
    //描述
    if ([self.type isEqualToString:@"1"]) {
        
        self.describeLabel.text = [NSString stringWithFormat:@"注册时间:%@",itemModel.registerTime];
    }else
    {
        self.describeLabel.text = ![NSObject isValidateInitString:itemModel.recentTranDate]?@"还未投资":[NSString stringWithFormat:@"最近投资:%@",itemModel.recentTranDate];
    }
}


@end
