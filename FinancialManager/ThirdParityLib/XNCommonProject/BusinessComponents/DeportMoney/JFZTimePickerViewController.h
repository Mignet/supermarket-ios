//
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cancelTimePickBlock)();
typedef void(^confirmTimePickBlock)();

@class JFZTimePickerViewController;
@protocol TimePickerViewDelegate <NSObject>
@optional

- (NSInteger )numberOfColumn;
- (NSInteger )TimePickerView:(UIPickerView *)pickerView rowsForColumn:(NSInteger )column;
- (NSString *)TimePickerView:(UIPickerView *)pickerView titleForRow:(NSInteger )row AtColumn:(NSInteger )column;
- (void)TimePickerView:(UIPickerView *)pickerView DidSelectedAtRow:(NSInteger )row Column:(NSInteger )column;
@end

@interface JFZTimePickerViewController : UIViewController

@property (nonatomic, assign) BOOL                       autoRefreshNextColumn; //自动刷新下个列内容
@property (nonatomic, assign) id<TimePickerViewDelegate> delegate;

@property (nonatomic, copy) cancelTimePickBlock cancelBlock;
@property (nonatomic, copy) confirmTimePickBlock confirmBlock;

- (void)clickCancelPickerBlock:(cancelTimePickBlock)pickerBlock;
- (void)clickConfirmPickerBlock:(confirmTimePickBlock)confirmBlock;
- (void)show;
- (void)showInHomePage;
- (void)selectRow:(NSInteger )row AtColumn:(NSInteger)column;
- (void)setRowAlignment:(NSTextAlignment )alignment;
@end
