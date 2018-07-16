//
//  CustomActionSheet.h
//  FinancialManager
//
//  Created by ancye.Xie on 11/25/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomActionSheetDelegate <NSObject>

- (void)didSelectIndex:(NSInteger)index;

@end

@interface CustomActionSheet : UIView

@property (nonatomic, assign) id<CustomActionSheetDelegate> delegate;

- (id)initWithTitle:(NSString *)title list:(NSArray *)array;

- (void)showInView:(UIViewController *)controller;

@end
