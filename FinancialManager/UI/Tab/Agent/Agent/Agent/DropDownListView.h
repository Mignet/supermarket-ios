//
//  DropDownListViewController.h
//  FinancialManager
//
//  Created by ancye.Xie on 7/7/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DropDownListViewDelegate <NSObject>
@optional

/*!
 @param selectString 选中的项
 @param nType 哪种类型
 */
- (void)selectedString:(NSString *)selectString type:(NSInteger)nType;

@end

@interface DropDownListView : UIView

@property (nonatomic, assign) id<DropDownListViewDelegate> delegate;

/*!
 @param dataArray 数组
 @param nType 哪种类型
 @param selectString 选中的项
 */
- (void)show:(NSMutableArray *)dataArray type:(NSInteger)nType selectedString:(NSString *)selectString;
- (void)hide;

@end
