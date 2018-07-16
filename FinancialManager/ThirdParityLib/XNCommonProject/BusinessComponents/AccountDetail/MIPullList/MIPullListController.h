//
//  MIPullListController.h
//  FinancialManager
//
//  Created by xnkj on 15/9/22.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^exitTypeSelectBlock)(NSString * type, NSInteger index);
typedef void(^selectedTypeBlock)(NSString * type, NSInteger index);

@interface MIPullListController : UIViewController

@property (nonatomic, copy) exitTypeSelectBlock exitBlock;
@property (nonatomic, copy) selectedTypeBlock selectedBlock;

- (void)setSelectedIndex:(NSInteger )Index;

- (void)setShowContent:(NSArray *)contentArray;

- (void)setClickExitTypeSelectBlock:(exitTypeSelectBlock )block;
- (void)setClickSelectedTypeBlock:(selectedTypeBlock )block;

- (void)show;
@end
