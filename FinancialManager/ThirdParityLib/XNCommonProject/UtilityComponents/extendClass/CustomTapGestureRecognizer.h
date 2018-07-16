//
//  CustomTapGestureRecognizer.h
//  FinancialManager
//
//  Created by ancye.Xie on 11/17/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTapGestureRecognizer : UITapGestureRecognizer

@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger nIndex;

@end
