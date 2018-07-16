//
//  CustomPopAdvView.h
//  FinancialManager
//
//  Created by ancye.Xie on 2/22/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickAdViewBlock)();

@protocol CustomPopAdvViewDelegate <NSObject>

- (void)gotoDetailViewController:(NSString *)linkUrl;
@end

@interface CustomPopAdvView : UIView

@property (nonatomic, assign) id<CustomPopAdvViewDelegate> delegate;
@property (nonatomic, copy) clickAdViewBlock block;

- (id)initWithImageUrl:(NSString *)imageUrl linkUrl:(NSString *)linkUrl;

- (void)showInView:(UIViewController *)controller;

- (void)hiddenPopAdvView;

- (void)setClickPopAdViewBlock:(void(^)())block;
@end
