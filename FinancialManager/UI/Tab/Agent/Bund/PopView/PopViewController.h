//
//  PopViewController.h
//  FinancialManager
//
//  Created by ancye.Xie on 8/18/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopViewControllerDelegate <NSObject>

- (void)popViewControllerClick:(NSArray *)selectedArray;

@end

@interface PopViewController : UITableViewController

@property (nonatomic, assign) id<PopViewControllerDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil showLastCell:(BOOL)isShowLastCell;

- (void)updateDatas:(NSArray *)dataArray selectedArray:(NSArray *)selectedArray;

@end
