//
//  GXQBankPickerViewController.m
//  GXQApp
//
//  Created by 王希朋 on 14-9-9.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import "JFZTimePickerViewController.h"

@interface JFZTimePickerViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, assign) NSTextAlignment rowTitleAlignment;
@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, strong) NSMutableDictionary * rowCountInColumnDictionary;

@property (nonatomic, weak) IBOutlet UIView       * popView;
@property (nonatomic, weak) IBOutlet UILabel      * lb_Title;
@property (nonatomic, weak) IBOutlet UIPickerView * pickerView;
@end

@implementation JFZTimePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

/////////////////////////////
#pragma mark - 自定义方法汇总
/////////////////////////////////////////////////////////////////////

#pragma mark - 初始化
- (void)initView
{
    self.columnCount = 0;
    [self.view setFrame:SCREEN_FRAME];
    [self.view setHidden:YES];
    [self.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    
    [self.view addSubview:self.popView];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    [self.view addGestureRecognizer:tapGesture];
    
    weakSelf(weakSelf)
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.trailing.equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(SCREEN_FRAME.size.height * 0.34);
    }];
    
    [self.view layoutIfNeeded];
}

- (IBAction)test:(id)sender
{
    [self hide];
}
#pragma mark - 执行确认
- (IBAction)confirmBtnClicked:(id)sender {
    
    if (self.confirmBlock) {
        self.confirmBlock();
    }
    
    [self hide];
}

//#pragma mark - 放弃操作
//- (IBAction)quitBtnClicked:(id)sender {
//    
//    if (self.cancelBlock) {
//        
//        self.cancelBlock();
//    }
//    
//    [self hide];
//}

#pragma mark - 设置block
- (void)clickCancelPickerBlock:(cancelTimePickBlock)pickerBlock
{
    if (pickerBlock) {
        
        self.cancelBlock = pickerBlock;
    }
}

- (void)clickConfirmPickerBlock:(confirmTimePickBlock)confirmBlock
{
    if (confirmBlock) {
        
        self.confirmBlock = confirmBlock;
    }
}

#pragma mark - 显示
-(void)show {

    [self.pickerView reloadAllComponents];
    [self.view setHidden:NO];
    
    //默认选中第一项
    if ([[self.rowCountInColumnDictionary objectForKey:@"0"] integerValue] > 0)
    {
        [self.pickerView  selectRow:0 inComponent:0 animated:YES];
        
        for (int i = 1; i < self.columnCount; i ++) {
            
            if ([[self.rowCountInColumnDictionary objectForKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]] integerValue] > 0) {
                
                [self.pickerView  selectRow:0 inComponent:i animated:YES];
            }
        }
        
        [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
    }
    
    [self.view layoutIfNeeded];
    weakSelf(weakSelf)
    [self.popView mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.trailing.equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(SCREEN_FRAME.size.height * 0.34);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 主页中显示
- (void)showInHomePage
{
    [self.pickerView reloadAllComponents];
    [self.view setHidden:NO];
    
    if ([[self.rowCountInColumnDictionary objectForKey:@"0"] integerValue] > 0)
    {
        [self.pickerView  selectRow:0 inComponent:0 animated:YES];
        
        for (int i = 1; i < self.columnCount; i ++) {
            
            if ([[self.rowCountInColumnDictionary objectForKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]] integerValue] > 0) {
                
                [self.pickerView  selectRow:0 inComponent:i animated:YES];
            }
        }
        
        [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
    }
    
    [self.view layoutIfNeeded];
    weakSelf(weakSelf)
    [self.popView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-20);
        make.height.mas_equalTo(SCREEN_FRAME.size.height * 0.34);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 隐藏
-(void)hide{
    
    [self.view layoutIfNeeded];
    
    weakSelf(weakSelf)
    [self.popView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(SCREEN_FRAME.size.height * 0.34);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    
        [self.view setHidden:YES];
    }];
}

#pragma mark - 选中某列中的某一项
- (void)selectRow:(NSInteger )row AtColumn:(NSInteger)column
{
    [self.pickerView selectRow:row inComponent:column animated:NO];
}

#pragma mark - 设置行对齐方式
- (void)setRowAlignment:(NSTextAlignment )alignment
{
    self.rowTitleAlignment = alignment;
}

/////////////////////////////
#pragma mark - 协议方法汇总
/////////////////////////////////////////////////////////////////////

//列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    self.columnCount = [self.delegate numberOfColumn];
    
    return  self.columnCount;
}

//行数
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if ([self.delegate respondsToSelector:@selector(TimePickerView:rowsForColumn:)]) {
        
        NSInteger rowCountInColumn = [self.delegate TimePickerView:pickerView rowsForColumn:component];
        [self.rowCountInColumnDictionary setValue:[NSNumber numberWithInteger:rowCountInColumn] forKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:component]]];
        
        return rowCountInColumn;
    }
    
    return 0;
}

//返回指定列，行的高度，就是自定义行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 33;
}
//返回指定列的宽度
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return SCREEN_FRAME.size.width / self.columnCount;
}
//定制视图
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    //取得指定列的宽度
    CGFloat width=[self pickerView:pickerView widthForComponent:component];
    //取得指定列，行的高度
    CGFloat height=[self pickerView:pickerView rowHeightForComponent:component];
    
    //view
    UIView *rowView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    rowView.backgroundColor = [UIColor clearColor];
    //label
    UILabel *label=[[UILabel alloc] initWithFrame:rowView.frame];
    label.tag = 1000;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = self.rowTitleAlignment;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:18];
    
    [rowView addSubview:label];

    NSString * str_ = @"";
    if ([self.delegate respondsToSelector:@selector(TimePickerView:titleForRow:AtColumn:)]) {
        
        str_ = [self.delegate TimePickerView:pickerView titleForRow:row AtColumn:component];
    }
    
    label.text =  [NSString stringWithFormat:@"%@",str_];
    
    return rowView;
}

//监听轮子的移动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if ([self.delegate respondsToSelector:@selector(TimePickerView:DidSelectedAtRow:Column:)])
    [self.delegate TimePickerView:pickerView DidSelectedAtRow:row Column:component];
    
    if (self.autoRefreshNextColumn) {
        
        for (NSInteger i = component + 1; i < self.columnCount; i ++ ) {
            
            [self.pickerView reloadComponent:i];
            [self.pickerView selectRow:0 inComponent:i animated:YES];
        }
    }
}

//////////////////
#pragma mark - setter/getter
/////////////////////////////////////////

- (NSMutableDictionary *)rowCountInColumnDictionary
{
    if (!_rowCountInColumnDictionary) {
        
        _rowCountInColumnDictionary = [[NSMutableDictionary alloc]init];
    }
    return _rowCountInColumnDictionary;
}

@end
