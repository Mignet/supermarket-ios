//
//  MyCustomerCell.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/17.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XNCSNewCustomerItemModel;

@interface MyCustomerCategoryCell : UITableViewCell

@property (nonatomic, strong) NSString * type;//1 表示未投资客户、2表示我关注的客户
@property (nonatomic, strong) XNCSNewCustomerItemModel *itemModel;

@end
