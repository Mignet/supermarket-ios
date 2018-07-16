//
//  MyCustomerInvestRecordCell.m
//  FinancialManager
//
//  Created by xnkj on 18/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyCustomerInvestRecordCell.h"
#import "XNCSMyCustomerInvestRecordItemMode.h"

@interface MyCustomerInvestRecordCell()

@property (nonatomic, weak) IBOutlet UILabel     * timeLabel;
@property (nonatomic, weak) IBOutlet UIImageView * headImageView;
@property (nonatomic, weak) IBOutlet UILabel     * nameLabel;
@property (nonatomic, weak) IBOutlet UILabel     * platformLabel;
@property (nonatomic, weak) IBOutlet UILabel     * investMoneyLabel;
@property (nonatomic, weak) IBOutlet UILabel     * myComissionLabel;
@property (nonatomic, weak) IBOutlet UIImageView * levelImageView;
@property (nonatomic, weak) IBOutlet UILabel     * nameDescribeLabel;
@end

@implementation MyCustomerInvestRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//更新数据
- (void)refreshInvestRecordCellWithParams:(XNCSMyCustomerInvestRecordItemMode *)params
{
    //头像
    NSString *urlString = [NSString stringWithFormat:@"%@?f=png", [_LOGIC getImagePathUrlWithBaseUrl:params.headImage]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    [self.headImageView.layer setCornerRadius:18];
    [self.headImageView.layer setMasksToBounds:YES];
    
    //理财师名称
    self.nameLabel.text = params.userName;
    
    //机构名称
    self.platformLabel.text = params.platformName;
    
    //投资金额
    self.investMoneyLabel.text = params.investAmt;
    
    //佣金
    self.myComissionLabel.text = params.feeAmountSum;
    
    self.timeLabel.text = params.startTime;
    
    //用户类型 0- 客户 1-直推 2-二级 3-三级
    self.nameDescribeLabel.hidden = YES;
}

@end
