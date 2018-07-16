//
//  BundSearchViewController.h
//  FinancialManager
//
//  Created by xnkj on 22/08/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ExitSearch)();

@interface BundSearchViewController : BaseViewController

@property (nonatomic, copy) ExitSearch exitSearchBlock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil selectedPeriodType:(NSString *)selectedPeriodType selectedPeriodString:(NSString *)selectedPeriodString selectedFundTypeString:(NSString *)selectedFundTypeString selectedFundTypeValueString:(NSString *)selectedFundTypeValueString;

- (void)setInitClickExitSearchBlock:(ExitSearch)block;

- (void)addObserver;
@end
