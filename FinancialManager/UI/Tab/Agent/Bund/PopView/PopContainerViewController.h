//
//  PopContainerViewController.h
//  FinancialManager
//
//  Created by ancye.Xie on 8/18/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopContainerViewControllerDelegate <NSObject>

- (void)popContainerViewControllerClick:(NSArray *)selectedArray;

- (void)popContainerViewControllerHidden;

@end

@interface PopContainerViewController : UIViewController

@property (nonatomic, assign) id<PopContainerViewControllerDelegate> delegate;

- (id)initWithDatas:(BOOL)isShowLastCell topPadding:(float)topPadding leftPadding:(float)leftPadding datas:(NSArray *)dataArray;

- (void)updateDatas:(NSArray *)dataArray selectedArray:(NSArray *)selectedArray;

@end
