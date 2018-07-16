//
//  CustomTimer.h
//  FinancialManager
//
//  Created by xnkj on 08/03/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HandleBlock)();

@interface CustomTimer : NSObject

- (void)scheduleDispatchTimerWithTimerInterval:(double)intervalTime
                                        repeat:(BOOL)repeat
                                        handle:(HandleBlock)handleBlock;
- (void)cancelTimer;
@end
