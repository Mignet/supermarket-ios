//
//  InvestRecordCell.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/19.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "InvestRecordCell.h"
#import "MIInvestRecordItemMode.h"

@interface InvestRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelHeight;

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameDescribeLabel;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UILabel *InvestTerraceLabel;
@property (weak, nonatomic) IBOutlet UILabel *issueSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;

@property (weak, nonatomic) IBOutlet UILabel *platformNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *platformMoneyLabel;



@end

@implementation InvestRecordCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setItemModel:(MIInvestRecordItemMode *)itemModel
{
    _itemModel = itemModel;
    
    if ([self.startTimeStr isEqualToString:itemModel.startTimeStr]) {
        self.timeLabel.text = nil;
        self.timeLabelHeight.constant = 0.f;
    } else {
        self.timeLabel.text = itemModel.startTimeStr;
        self.timeLabelHeight.constant = 30.f;
    }
    

    //头像
    NSString *urlString = [NSString stringWithFormat:@"%@?f=png", [_LOGIC getImagePathUrlWithBaseUrl:itemModel.headImage]];
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    
    //理财师名称
    self.nameLabel.text = itemModel.userName;
    
    //机构名称
    self.InvestTerraceLabel.text = itemModel.platformName;
    
    //投资金额
    self.issueSumLabel.text = itemModel.investAmt;
    
    //佣金
    self.commissionLabel.text = itemModel.feeAmountSum;
    
    //用户类型 0- 客户 1-直推 2-二级 3-三级
    [self.typeBtn setTitle:nil forState:UIControlStateNormal];
    self.nameDescribeLabel.hidden = YES;
    
    self.platformNameLabel.text = @"出单平台";
    self.platformMoneyLabel.text = @"出单金额(元)";
    
    switch ([itemModel.userType integerValue]) {
        case 0:
        {
            self.platformNameLabel.text = @"投资平台";
            self.platformMoneyLabel.text = @"投资金额(元)";
            [self.typeBtn setBackgroundImage:[UIImage imageNamed:@"invest_clientele"] forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [self.typeBtn setBackgroundImage:[UIImage imageNamed:@"invest_vertical"] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [self.typeBtn setBackgroundImage:[UIImage imageNamed:@"invest_two_rank"] forState:UIControlStateNormal];
            self.nameDescribeLabel.hidden = NO;
            self.nameDescribeLabel.text = @"的直推理财师";
        }
            break;
        case 3:
        {
            self.nameDescribeLabel.hidden = NO;
            self.nameDescribeLabel.text = @"的二级理财师";
            [self.typeBtn setBackgroundImage:[UIImage imageNamed:@"invest_three_rank"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    
    //settle_accounts_fail.png
    //if (itemModel.clearingStatus.length > 0) {
        // 0-待计算 1-计算成功 2-计算失败
    
    if (itemModel.clearingStatus.length == 0) {
        return;
    }
    
    switch ([itemModel.clearingStatus integerValue]) {
        
        case 0:
        {
            [self.settle_accounts_ImgView setImage:[UIImage imageNamed:@"settle_accounts_wait.png"]];
                self.settle_accounts_ImgView.hidden = NO;
        }
            break;
        case 2:
        {
            [self.settle_accounts_ImgView setImage:[UIImage imageNamed:@"settle_accounts_fail.png"]];
            self.settle_accounts_ImgView.hidden = NO;
        }
            break;
        default:
        {
            self.settle_accounts_ImgView.hidden = YES;
        }
            break;
        }
}


@end
