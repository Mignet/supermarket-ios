//
//  CustomPopView.h
//  FinancialManager
//
//  Created by xnkj on 27/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CancelCouponRecordBlock)();
typedef void(^FinishedCouponRecordBlock)();

@interface CustomCouponRecordPopView : UIView

@property (nonatomic, copy) CancelCouponRecordBlock   cancelBlock;
@property (nonatomic, copy) FinishedCouponRecordBlock finishedBlock;

//初始化操作
- (void)initImageName:(NSString *)imageName titleName:(NSString *)title subTitleName:(NSString *)subTitle;

//设置取消操作
- (void)setClickCancelBlock:(CancelCouponRecordBlock)block;

//完成后的操作
- (void)setOperationFinishedBlock:(FinishedCouponRecordBlock)block;
@end

