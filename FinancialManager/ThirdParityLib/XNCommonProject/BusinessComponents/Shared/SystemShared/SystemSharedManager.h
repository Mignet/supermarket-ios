//
//  SystemSharedManager.h
//  FinancialManager
//
//  Created by xnkj on 20/06/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemSharedManager : NSObject

+ (instancetype)sharedInstance;

- (void)systemSharedWithImageNameArray:(NSArray *)imgArray;
@end
