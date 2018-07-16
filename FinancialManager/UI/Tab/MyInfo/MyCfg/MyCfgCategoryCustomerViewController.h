//
//  MyCategoryCustomerViewController.h
//  FinancialManager
//
//  Created by xnkj on 17/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"

@interface MyCfgCategoryCustomerViewController : BaseViewController

/**
 * 创建视图
 * params title 视图标题
 * params attenInvestType 1未投资客户 2我关注的客户 3未出单的直推理财师 4我关注的直推理财
 **/
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)title attenInvestType:(NSString *)attenInvestType;
@end
