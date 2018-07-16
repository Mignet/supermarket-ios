//
//  ReturnMoneyCell.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/19.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "ReturnMoneyCell.h"
#import "ReturnMoneyItemModel.h"

@interface ReturnMoneyCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UILabel *InvestTerraceLabel;
@property (weak, nonatomic) IBOutlet UILabel *issueSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelHeight;

@end

@implementation ReturnMoneyCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}


- (void)setItemModel:(ReturnMoneyItemModel *)itemModel
{
    _itemModel = itemModel;
    
    if ([self.endTimeStr isEqualToString:itemModel.endTimeStr]) {
        self.timeLabel.text = nil;
        self.timeLabelHeight.constant = 0.f;
    } else {
        self.timeLabel.text = itemModel.endTimeStr;
        self.timeLabelHeight.constant = 30.f;
    }

    //头像
    NSString *urlString = [NSString stringWithFormat:@"%@?f=png", [_LOGIC getImagePathUrlWithBaseUrl:itemModel.headImage]];
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    
    //理财师名称
    self.nameLabel.text = itemModel.userName;
    
    //机构名称
    self.InvestTerraceLabel.text = itemModel.platformName;
    
    //预期收益
    self.issueSumLabel.text = itemModel.profit;
    
    //回款本金
    self.commissionLabel.text = itemModel.investAmt;
    
    //repaymentUserType
    [self.typeBtn setTitle:nil forState:UIControlStateNormal];
    
    switch ([itemModel.repaymentUserType integerValue]) { //0- 客户 1-直推
        case 0:
        {
            [self.typeBtn setBackgroundImage:[UIImage imageNamed:@"invest_clientele"] forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [self.typeBtn setBackgroundImage:[UIImage imageNamed:@"invest_vertical"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }

}

@end
