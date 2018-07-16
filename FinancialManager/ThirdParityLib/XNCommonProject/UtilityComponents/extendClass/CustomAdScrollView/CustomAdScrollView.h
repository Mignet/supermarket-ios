//
//  CustomAdScrollView.h
//  CFGApp
//
//  Created by 王希朋 on 14-7-22.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CustomAdScrollDirection){
    
    CustomAdScrollLeftDirection,
    CustomAdScrollRightDirection
};

typedef void(^ImgClickedBlock)(id object);

@interface CustomAdScrollView : UIView

@property (assign, nonatomic) BOOL      autoPlay;                      //是否自动播放
@property (assign, nonatomic) float     interminal;                    //自动播放的时间间隔
@property (nonatomic, strong) UIColor  * pageIndicatorTintColor;
@property (nonatomic, strong) UIColor  * currentPageIndicatorTintColor;
@property (nonatomic, assign) NSInteger  alignment;//pagecontrol的排序方式0表示左对齐，1标志剧中，2表示右对齐
@property (assign, nonatomic) CustomAdScrollDirection scrollDirection; //自动播放的方向
@property (nonatomic, copy) ImgClickedBlock imgClickedBlock;

- (id)initWithFrame:(CGRect)frame pageAlignBottom:(float)fBottom pageAlignment:(NSInteger)alignment;

- (void)refreshAdScrollViewWithAdUrlObjectArray:(NSArray*)adUrlObjectArr;
- (void)refreshAdScrollViewWithAdObjectArray:(NSArray *)adObjectArr urlArray:(NSArray *)adUrlArr;
- (void)setClickedImgBlock:(ImgClickedBlock)imgClickedBlock;
@end
