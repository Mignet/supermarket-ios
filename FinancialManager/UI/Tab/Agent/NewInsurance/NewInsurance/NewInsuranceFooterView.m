//
//  NewInsuranceFooterView.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/26.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "NewInsuranceFooterView.h"

@implementation NewInsuranceFooterView

+ (instancetype)newInsuranceFooterView
{
    NewInsuranceFooterView *footerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NewInsuranceFooterView class]) owner:nil options:nil] firstObject];
    
    return footerView;
}

@end
