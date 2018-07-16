//
//  SignRecordCell.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/17.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SignRecordCell.h"
#import "SignRecordListItemModel.h"
#import "SignRecordListItemModel.h"

@interface SignRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *rowLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation SignRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setItemModel:(SignRecordListItemModel *)itemModel
{
    _itemModel = itemModel;

    self.rowLabel.text = [NSString stringWithFormat:@"第%@签", itemModel.rownum];
    self.timeLabel.text = [NSString stringWithFormat:@"%@", itemModel.signTime];
    
    if ([itemModel.signAmount floatValue] > 0.0 && [itemModel.timesAmount floatValue] > 0.0) {
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2lf元 + %.2lf元", [itemModel.signAmount floatValue], [itemModel.timesAmount floatValue]];
    } else {
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2lf元", [itemModel.signAmount floatValue]];
    }
}

@end
