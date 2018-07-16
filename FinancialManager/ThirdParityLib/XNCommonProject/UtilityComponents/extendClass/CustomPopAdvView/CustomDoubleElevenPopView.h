//
//  CustomPopView.h
//  FinancialManager
//
//  Created by xnkj on 27/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ActivityDetailBlock)();
typedef void(^ActivityCancelBlock)();
typedef void(^FinishedBlock)();

@interface CustomDoubleElevenPopView : UIView

@property (nonatomic, copy) ActivityDetailBlock detailBlock;
@property (nonatomic, copy) ActivityCancelBlock cancelBlock;
@property (nonatomic, copy) FinishedBlock finishedBlock;

//设置弹出详情
- (void)setClickActivityDetailBlock:(ActivityDetailBlock)block;

//设置取消操作
- (void)setClickActivityCancelBlock:(ActivityCancelBlock)block;

//完成后的操作
- (void)setOperationFinishedBlock:(FinishedBlock)block;
@end

