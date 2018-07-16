//
//  CustomPopView.h
//  FinancialManager
//
//  Created by xnkj on 27/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CouponPopType)
{
    RedPacketType = 0,
    LevelType,
    ComissionType,
    ComissionRecordType
};

typedef void(^DetailBlock)(CouponPopType type);
typedef void(^CancelBlock)(CouponPopType type);
typedef void(^FinishedBlock)();

@interface CustomCouponPopView : UIView

@property (nonatomic, assign) CouponPopType type;
@property (nonatomic, copy) DetailBlock detailBlock;
@property (nonatomic, copy) CancelBlock cancelBlock;
@property (nonatomic, copy) FinishedBlock finishedBlock;

//初始化操作
- (void)initImage:(NSString *)imageName titleName:(NSString *)title CouponType:(CouponPopType)type;

//设置弹出详情
- (void)setClickDetailBlock:(DetailBlock)block;

//设置取消操作
- (void)setClickCancelBlock:(CancelBlock)block;

//完成后的操作
- (void)setOperationFinishedBlock:(FinishedBlock)block;
@end

