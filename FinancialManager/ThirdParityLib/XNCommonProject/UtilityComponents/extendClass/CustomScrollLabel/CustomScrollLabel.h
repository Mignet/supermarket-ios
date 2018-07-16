//
//  CustomScrollLabel.h
//  FinancialManager
//
//  Created by ancyeXie on 16/11/14.
//  Copyright © 2016年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CustomTitlePosition){
    
    CustomTitlePositionTop = 1,
    CustomTitlePositionMiddle,
    CustomTitlePositionBottom
};

typedef NS_ENUM(NSInteger, ScrollDirectionType){
    ScrollDirectionTopType = 1,
    ScrollDirectionDownType
    
};

@class CustomScrollLabel;
@protocol CustomScrollLabelDelegate <NSObject>

- (void)customScrollLabel:(CustomScrollLabel *)customScrollLabel didSelectedAtIndex:(NSInteger)index didSelectedAtUrl:(NSString *)url;
@end

@interface CustomScrollLabel : UIView

@property (nonatomic, assign) id<CustomScrollLabelDelegate> delegate;

- (id)initWithFrame:(CGRect)frame isShowUnderline:(BOOL)isShowUnderline textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor textFont:(UIFont *)textFont scrollDirection:(NSInteger)nScrollDirection;
- (void)setLabelFrame:(CGRect)frame;
- (void)animationWithTitles:(NSArray *)titleArray urls:(NSArray *)urlArray;
- (void)stopAnimation;

@end
