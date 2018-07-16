//
//  SaleProgressView.h
//  FinancialManager
//
//  Created by xnkj on 10/02/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^operationBlock)();

@interface SaleProgressView : UIView

/**
 * 显示产品购买进度
 *
 * params value 进度值
 * params imageName 图片名
 *
 **/
- (void)showSaleProgressWithProgressValue:(CGFloat )value
                     backgroundImageName:(NSString *)imageName;

/**
 * 操作按钮回调设置
 *
 * params block 回调处理
 *
 **/
- (void)clickOperationCompletation:(operationBlock )block;
@end
