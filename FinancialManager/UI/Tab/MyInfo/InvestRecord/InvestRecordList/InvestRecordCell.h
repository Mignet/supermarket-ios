//
//  InvestRecordCell.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/19.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MIInvestRecordItemMode;

@interface InvestRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *settle_accounts_ImgView;

@property (nonatomic, strong) MIInvestRecordItemMode *itemModel;

@property (nonatomic, copy) NSString *startTimeStr;

@end
