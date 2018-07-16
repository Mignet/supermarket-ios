//
//  BackStatisticalCell.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/27.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "BackStatisticalCell.h"
#import "InvestStatisticsModel.h"
#import "NSDate+Extension.h"

@interface BackStatisticalCell ()

@property (weak, nonatomic) IBOutlet UILabel *investAmtTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeAmountSumTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *investAmtTotalMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeAmountSumTotalMsgLabel;

@property (weak, nonatomic) IBOutlet UIImageView *askImg;
@property (weak, nonatomic) IBOutlet UIButton *askBtn;


@end

@implementation BackStatisticalCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setInvestStatisticsModel:(InvestStatisticsModel *)investStatisticsModel
{
    _investStatisticsModel = investStatisticsModel;

    if (investStatisticsModel.investAmtTotal.length > 0 && investStatisticsModel.feeAmountSumTotal.length > 0) {
        self.investAmtTotalLabel.text = investStatisticsModel.investAmtTotal;
        self.feeAmountSumTotalLabel.text = investStatisticsModel.feeAmountSumTotal;
        
        NSInteger month = [NSDate month:[NSDate new]];
        self.investAmtTotalMsgLabel.text = [NSString stringWithFormat:@"%ld月团队累计业绩(元)", month];
        self.feeAmountSumTotalMsgLabel.text = [NSString stringWithFormat:@"%ld月累计佣金(元)", month];
        self.askImg.hidden = NO;
    }
    
    
    if (investStatisticsModel.havaRepaymentAmtTotal.length > 0 && investStatisticsModel.waitRepaymentAmtTotal.length > 0) {
        self.investAmtTotalLabel.text = investStatisticsModel.havaRepaymentAmtTotal;
        self.feeAmountSumTotalLabel.text = investStatisticsModel.waitRepaymentAmtTotal;
        
        NSInteger month = [NSDate month:[NSDate new]];
        self.investAmtTotalMsgLabel.text = [NSString stringWithFormat:@"%ld月已回款金额(元)", month];
        self.feeAmountSumTotalMsgLabel.text = [NSString stringWithFormat:@"%ld月待回款金额(元)", month];
        self.askImg.hidden = YES;
    }
}

#pragma mark - 问号点击方法
- (IBAction)askBtnClick
{
    if ([self.delegate respondsToSelector:@selector(backStatisticalCellDid:)]) {
        [self.delegate backStatisticalCellDid:self];
    }
}




@end
