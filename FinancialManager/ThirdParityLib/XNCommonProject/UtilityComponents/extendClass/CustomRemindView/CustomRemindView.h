//
//  CustomRemindView.h
//  FinancialManager
//
//  Created by xnkj on 05/05/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickRemindViewBlock)();
typedef void(^clickRemindCheckDetail)();

@interface CustomRemindView : UIView

@property (nonatomic, copy) clickRemindViewBlock block;
@property (nonatomic, copy) clickRemindCheckDetail checkDetailBlock;


/*********************************
 * 初始化保职提示视图
 * 
 * params title 显示的标题
 * params descContent 显示需要满足的条件1
 * params detailContent 显示需要满足的条件2（可选，nil）
 *
 *********************************************/
- (id)initKeepLevelRemindViewWithTitle:(NSString *)title
                            desContent:(NSString *)descContent
                         detailContent:(NSString *)detailContent;

/*********************************
 * 弹出显示
 *
 * params  ctrl 显示内容在此容器中，此参数可以为nil，如果为nil，则显示到window上
 *
 *********************************************/
- (void)showInView:(UIViewController *)ctrl;

/**
 * 设置block回掉
 *
 * params block
 *
 **/
- (void)setClickCustomRemindViewBlock:(clickRemindViewBlock)block;

/**
 * 设置点击查看详情
 *
 * params block
 *
 **/
- (void)setClickCheckDetailBlock:(clickRemindCheckDetail)block;
@end
