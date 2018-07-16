//
//  MyCfgCell.m
//  FinancialManager
//
//  Created by xnkj on 18/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyCfgCell.h"
#import "XNCSNewCustomerItemModel.h"

@interface MyCfgCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel * gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@end

@implementation MyCfgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//更新信息
- (void)showCfgInfo:(XNCSNewCustomerItemModel *)model type:(NSString *)busType
{
    //头像
    NSString *urlString = [NSString stringWithFormat:@"%@?f=png", [_LOGIC getImagePathUrlWithBaseUrl:model.headImage]];
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    [self.iconImgView.layer setCornerRadius:20];
    [self.iconImgView.layer setMasksToBounds:YES];
    
    //名称
    self.nameLabel.text = model.userName;
    
    self.gradeLabel.text = model.grade;
    
    //描述
    if ([busType isEqualToString:@"3"]) {
        
        self.describeLabel.text = [NSString stringWithFormat:@"注册时间: %@",model.registerTime];
    }else if([busType isEqualToString:@"4"])
    {
        self.describeLabel.text = ![NSObject isValidateInitString:model.recentTranDate]?@"还未出单":[NSString stringWithFormat:@"最近出单: %@",model.recentTranDate];
    }else
    {
        self.describeLabel.text = ![NSObject isValidateInitString:model.recentTranDate]?@"还未出单":[NSString stringWithFormat:@"最近出单:%@",model.recentTranDate];
    }
}

@end
