//
//  ReturnMoneyCell.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/19.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReturnMoneyItemModel;

@interface ReturnMoneyCell : UITableViewCell

@property (nonatomic, strong) ReturnMoneyItemModel *itemModel;

@property (nonatomic, copy) NSString *endTimeStr;

@end
