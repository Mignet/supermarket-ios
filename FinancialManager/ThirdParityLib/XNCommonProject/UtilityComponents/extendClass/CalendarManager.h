//
//  CalendarManager.h
//  FinancialManager
//
//  Created by xnkj on 19/09/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarManager : NSObject

+ (instancetype)defaultManager;

- (NSDateComponents *)dateComponentsWithDate:(NSDate *)date;
@end
