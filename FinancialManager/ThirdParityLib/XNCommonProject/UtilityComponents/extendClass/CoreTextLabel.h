//
//  CoreContextLabel.h
//  JinFuZiApp
//
//  Created by LiaoChangping on 3/10/15.
//  Copyright (c) 2015 com.jinfuzi. All rights reserved.
//
/*Demo:
 firstDic = @{@"range":[NSString stringWithFormat:@"%@.",[tmpArray objectAtIndex:0]],
 @"color": UIColorFromHex(0xdc4437),
 @"font": [UIFont systemFontOfSize:40]};
 secondDic = @{@"range":[NSString stringWithFormat:@"%@%@",[tmpArray objectAtIndex:1],@"%"],
 @"color": UIColorFromHex(0xdc4437),
 @"font": [UIFont systemFontOfSize:30]};
 self.yearRateCoreTextLabel.arr_Property = [NSArray arrayWithObjects:firstDic,secondDic, nil];
 */


#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

typedef void(^clickBlock)();

@interface CoreTextLabel : UIView

@property (nonatomic, strong) NSArray * arr_Property;
@property (nonatomic, assign) CGFloat  clickAbleFontSize;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, copy)   clickBlock clickFunction;

- (void)setClickBlock:(clickBlock )block;

- (CGFloat )setCenterAlignment;
- (CGFloat )setLeftAlignment;
- (CGFloat )setRightAlignment;
@end
