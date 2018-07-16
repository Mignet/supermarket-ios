//
//  XNGestureView.m
//  FinancialManager
//
//  Created by xnkj on 14/02/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNGestureView.h"
#import "XNDeviceUtil.h"


#define XN_GESTURE_DOT_WIDTH        56


@interface XNGestureView()

@property (nonatomic, assign) CGPoint currentTouchPoint;

@property (nonatomic, strong) NSMutableArray * gestureDotsArray;
@property (nonatomic, strong) NSMutableArray * gestureDotsContentView;
@property (nonatomic, strong) NSMutableArray * selectedIndexes;
@end

@implementation XNGestureView

////////////////////////////
#pragma mark - life cycle
//////////////////////////////////

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self createGestureDotView];
        [self layoutGestureDots];
    }
    return self;
}

- (BOOL)willDealloc
{
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    UIButton *gestureDot = [self gestureDotContainsPoint:location];
    if (gestureDot) {
        
        [self.selectedIndexes addObject:[NSNumber numberWithInteger:gestureDot.tag]];
        [gestureDot setSelected:YES];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    UIButton *gestureDot = [self gestureDotContainsPoint:location];
    
    if ([self.selectedIndexes count] > 0) {
        
        // 第一个点已经选中之后的移动
        if (gestureDot) {
            
            [self.selectedIndexes addObject:[NSNumber numberWithInteger:gestureDot.tag]];
            [gestureDot setSelected:YES];
            self.currentTouchPoint = [self convertPoint:gestureDot.center fromView:self];
        } else {
            
            self.currentTouchPoint = location;
        }
        
        [self setNeedsDisplay];
    } else if (gestureDot) {
        
        // 第一个点
        [self.selectedIndexes addObject:[NSNumber numberWithInteger:gestureDot.tag]];
        [gestureDot setSelected:YES];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([self.selectedIndexes count] > 0) {
        
        [self gestureDidEnd];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([_selectedIndexes count] > 0) {
        
        [self gestureDidEnd];
    }
}

- (void)gestureDidEnd {
    
    UIButton *lastGestureDot = [self.gestureDotsContentView objectAtIndex:[[self.selectedIndexes lastObject] integerValue]];
    if (lastGestureDot) {
        
        self.currentTouchPoint = [self convertPoint:lastGestureDot.center fromView:self];
    }
    [self setNeedsDisplay];
    
    NSMutableString *password = [NSMutableString stringWithCapacity:[self.selectedIndexes count]];
    [self.selectedIndexes enumerateObjectsUsingBlock:^(NSNumber *dotIndex, NSUInteger idx, BOOL *stop) {
        
        [password appendString:[dotIndex stringValue]];
    }];
    
    if (self.delegate) {
        
        [self.delegate gesturePasswordDidCreatePassword:password];
    }
}

#pragma mark - draw rect
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if ([self.selectedIndexes count] > 0) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIColorFromHex(0x4e8cef) set];
        
        CGContextSetLineWidth(context, 3.f);
        weakSelf(weakSelf)
        [self.selectedIndexes enumerateObjectsUsingBlock:^(NSNumber *selectedIndex, NSUInteger idx, BOOL *stop) {
            
            UIButton *gestureDots = [weakSelf.gestureDotsContentView objectAtIndex:[selectedIndex integerValue]];
            
            CGPoint gestureDotPointInSelf = [weakSelf convertPoint:gestureDots.center fromView:weakSelf];
            
            if (idx == 0) {
                
                CGContextMoveToPoint(context, gestureDotPointInSelf.x, gestureDotPointInSelf.y);
            } else {
                
                CGContextAddLineToPoint(context, gestureDotPointInSelf.x, gestureDotPointInSelf.y);
            }
            
        }];
        
        CGContextAddLineToPoint(context, _currentTouchPoint.x, _currentTouchPoint.y);
        CGContextStrokePath(context);
    }
}

////////////////////////////
#pragma mark -  自定义方法
//////////////////////////////////

- (void)createGestureDotView
{
    //创建九宫格
    for (int i = 0; i < 9; i++) {
        
        UIButton *gestureDot = [UIButton buttonWithType:UIButtonTypeCustom];
        gestureDot.tag = i;
        gestureDot.frame = CGRectMake(0, 0, XN_GESTURE_DOT_WIDTH, XN_GESTURE_DOT_WIDTH);
        gestureDot.userInteractionEnabled = NO;
        [gestureDot setImage:[UIImage imageNamed:@"XN_User_Gesture_Normal_btn.png"]  forState:UIControlStateNormal];
        [gestureDot setImage:[UIImage imageNamed:@"XN_User_Gesture_Press_btn.png"]  forState:UIControlStateSelected];
        [self addSubview:gestureDot];
        [self.gestureDotsContentView addObject:gestureDot];
    }
}

#pragma mark - 布局
- (void)layoutGestureDots {
    
    // 点与屏幕边框的距离是两点之间距离的1.5倍
    CGFloat dotLeftGap = ([XNDeviceUtil screenWidth] - XN_GESTURE_DOT_WIDTH * 3) * 1.5 / 5.f;
    
    weakSelf(weakSelf)
    [self.gestureDotsContentView enumerateObjectsUsingBlock:^(UIButton *gestureDot, NSUInteger index, BOOL *stop) {
        
        [gestureDot mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@(XN_GESTURE_DOT_WIDTH));
            make.height.equalTo(@(XN_GESTURE_DOT_WIDTH));
            if (index % 3 == 0) {
                
                make.left.equalTo(weakSelf).offset(dotLeftGap);
            } else if (index % 3 == 1) {
                
                make.centerX.equalTo(weakSelf);
            } else if (index % 3 == 2) {
                
                make.right.equalTo(weakSelf).offset(-dotLeftGap);
            }
            if (index / 3 == 0) {
                
                make.top.equalTo(weakSelf);
            } else if (index / 3 == 1) {
                
                make.centerY.equalTo(weakSelf);
            } else if (index / 3 == 2) {
                
                make.bottom.equalTo(weakSelf);
            }
            
        }];
    }];
    
    [self layoutIfNeeded];
}

#pragma mark - 获取手势点
- (UIButton *)gestureDotContainsPoint:(CGPoint)point {
    
    __block UIButton *selectedGestureDot = nil;
    
    weakSelf(weakSelf)
    [self.gestureDotsContentView enumerateObjectsUsingBlock:^(UIButton *gestureDot, NSUInteger idx, BOOL *stop) {
        
        CGRect gestureDotFrameInSelf = [weakSelf convertRect:gestureDot.frame fromView:weakSelf];
        if (CGRectContainsPoint(gestureDotFrameInSelf, point)) {
            
            if (![weakSelf.selectedIndexes containsObject:[NSNumber numberWithInteger:gestureDot.tag]]) {
                
                selectedGestureDot = gestureDot;
            }
            *stop = YES;
        }
    }];
    
    return selectedGestureDot;
}

#pragma mark - 重置密码状态
- (void)resetPasswordStatus {
    
    weakSelf(weakSelf)
    [self.selectedIndexes enumerateObjectsUsingBlock:^(NSNumber *dotIndex, NSUInteger idx, BOOL *stop) {
        
        UIButton *gestureDot = [weakSelf.gestureDotsContentView objectAtIndex:[dotIndex integerValue]];
        [gestureDot setSelected:NO];
    }];
    [self.selectedIndexes removeAllObjects];
    self.currentTouchPoint = CGPointZero;
    
    [self setNeedsDisplay];
}


////////////////////////////
#pragma mark - setter/getter
//////////////////////////////////

#pragma mark - gestureDotsArray
- (NSMutableArray *)gestureDotsArray
{
    if (!_gestureDotsArray) {
        
        _gestureDotsArray = [[NSMutableArray alloc]initWithCapacity:9];
    }
    return _gestureDotsArray;
}

#pragma makr - gestureDotsContentView
- (NSMutableArray *)gestureDotsContentView
{
    if (!_gestureDotsContentView) {
        
        _gestureDotsContentView = [[NSMutableArray alloc]initWithCapacity:9];
    }
    return _gestureDotsContentView;
}

#pragma mark - selectedIndexes
- (NSMutableArray *)selectedIndexes
{
    if (!_selectedIndexes) {
        
        _selectedIndexes = [[NSMutableArray alloc]init];
    }
    return _selectedIndexes;
}

@end
