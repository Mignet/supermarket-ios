//
//  SaleGoodNewsCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/26/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "SaleGoodNewsCell.h"
#import "UIGridViewButton.h"

#define fLeftPadding 15.0f
#define fTopPadding 15.0f
#define imageTag 10000
#define checkboxImageTag 20000

@interface SaleGoodNewsCell ()

@property (nonatomic, strong) NSMutableArray *datasArray;
@property (nonatomic, strong) XNLCSaleGoodNewsItemMode *selectedMode;
@property (nonatomic, assign) NSInteger nPicIndex; //图片tag
@property (nonatomic, assign) NSInteger lastSelectedTag; //上一次选中的项

@end

@implementation SaleGoodNewsCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showDatas:(NSArray *)datasArray selectedMode:(XNLCSaleGoodNewsItemMode *)mode
{
    [self.datasArray removeAllObjects];
    [self.datasArray addObjectsFromArray:datasArray];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.selectedMode = mode;
//    self.nPicIndex = 0;
    
    UIView *picsView = [self showCells];
    picsView.backgroundColor = UIColorFromHex(0xf6f6f6);
    
    [self addSubview:picsView];
    weakSelf(weakSelf)
    [picsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf);
    }];
    
}

- (UIView *)showCells
{
    UIView *picView = [[UIView alloc] init];
    
    float fLeftRightPadding = fLeftPadding; //左右间距
    float fTopBottomPadding = fTopPadding; //上下间距
    float fPicWidth = (SCREEN_FRAME.size.width - fLeftPadding * 3) / 2;
    float fPicHeight = 97;//fPicWidth * 130 / 207;
    //总行数
    NSInteger nRow = self.datasArray.count % 2 == 0 ? self.datasArray.count / 2 : self.datasArray.count / 2 + 1;
    //总高度
    float fTotalHeight = fPicHeight * nRow + fTopBottomPadding * (nRow - 1);
    
    float fHeaderPadding = 30.0f;
    __weak UIView *weakPicView = picView;
    for (int i = 0; i < self.datasArray.count; i ++)
    {
        self.nPicIndex ++;
        
        XNLCSaleGoodNewsItemMode *mode = [self.datasArray objectAtIndex:i];
        
        UIView *view = [[UIView alloc] init];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 3;
        
        UIImageView *headBgImageView = [[UIImageView alloc] init];
        headBgImageView.image = [UIImage imageNamed:@"XN_LieCai_Sale_Good_News_cell_bg.png"];
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.text = @"出单";
        textLabel.textColor = [UIColor whiteColor];
        textLabel.font = [UIFont systemFontOfSize:9];
        
        UILabel *amountLabel = [[UILabel alloc] init];
        NSArray *propertyArray = @[@{@"range": mode.amount,
                                     @"color": [UIColor whiteColor],
                                     @"font": [UIFont fontWithName:@"DINOT" size:24]},
                                   @{@"range": @"元",
                                     @"color": [UIColor whiteColor],
                                     @"font": [UIFont systemFontOfSize:10]}];
        NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
        textLabel.attributedText = string;
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor whiteColor];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = UIColorFromHex(0x4f5960);
        nameLabel.font = [UIFont systemFontOfSize:12];
        nameLabel.text = mode.userName;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = UIColorFromHex(0x666666);
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.text = mode.investTime;
        timeLabel.textAlignment = NSTextAlignmentRight;
        
        UIView *shadowView = [[UIView alloc] init];
        shadowView.backgroundColor = [UIColor clearColor];
        shadowView.tag = imageTag + i + 1;//self.nPicIndex;
        
        UIImageView *checkboxImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"XN_LieCai_Brand_Promotion_Checkbox_unselected_icon@2x.png"]];
        checkboxImageView.tag = checkboxImageTag + i + 1;//self.nPicIndex;
        
        UIButton *checkboxButton = [[UIButton alloc] init];
        checkboxButton.selected = NO;
        checkboxButton.tag = i + 1;//self.nPicIndex;
        [checkboxButton addTarget:self action:@selector(checkboxButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:headBgImageView];
        [view addSubview:textLabel];
        [view addSubview:amountLabel];
        
        [view addSubview:bottomView];
        [view addSubview:nameLabel];
        [view addSubview:timeLabel];
        
        [view addSubview:shadowView];
        [view addSubview:checkboxImageView];
        [view addSubview:checkboxButton];
        [picView addSubview:view];
        
        __weak UIView *weakView = view;
        __weak UILabel *weakTextLabel = textLabel;
        __weak UIView *weakBottomView = bottomView;
        __weak UILabel *weakNameLabel = nameLabel;
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakPicView.mas_top).offset(fHeaderPadding);
            make.left.equalTo(weakPicView.mas_left).offset(fLeftRightPadding);
            make.width.mas_equalTo(fPicWidth);
            make.height.mas_equalTo(fPicHeight);
        }];
        
        [headBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakView.mas_left);
            make.right.mas_equalTo(weakView.mas_right);
            make.top.mas_equalTo(weakView.mas_top);
            make.height.mas_equalTo(67);
        }];
        
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakView.mas_top).offset(13);
            make.left.mas_equalTo(weakView.mas_left).offset(10);
        }];
        
        [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakTextLabel.mas_left);
            make.top.mas_equalTo(weakTextLabel.mas_bottom).offset(3);
        }];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakView.mas_left);
            make.right.mas_equalTo(weakView.mas_right);
            make.bottom.mas_equalTo(weakView.mas_bottom);
            make.height.mas_equalTo(30);
        }];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakBottomView.mas_left).offset(10);
            make.centerY.mas_equalTo(weakBottomView.mas_centerY);
        }];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakNameLabel.mas_right);
            make.centerY.mas_equalTo(weakBottomView.mas_centerY);
            make.right.mas_equalTo(weakBottomView.mas_right).offset(-10);
        }];
        
        [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakView);
        }];
        
        [checkboxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakView.mas_top).offset(6);
            make.right.mas_equalTo(weakView.mas_right).offset(-6);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(15);
        }];
        
        [checkboxButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakView);
        }];
        
        if ([mode.billId isEqualToString:self.selectedMode.billId])
        {
            self.lastSelectedTag = checkboxButton.tag;
            self.selectedMode = mode;
            checkboxButton.selected = YES;
            checkboxImageView.image = [UIImage imageNamed:@"XN_LieCai_Brand_Promotion_Checkbox_selected_icon@2x.png"];
            shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        }
        
        fLeftRightPadding += fPicWidth + fLeftPadding;
        if ((i + 1) % 2 == 0)
        {
            fLeftRightPadding = fLeftPadding;
            fHeaderPadding += fPicHeight + fTopBottomPadding;
        }
    }
    
    picView.size = CGSizeMake(SCREEN_FRAME.size.width, fTotalHeight);
    return picView;
}

#pragma mark - 选中图片
- (void)checkboxButtonAction:(UIButton *)btn
{
    self.selectedMode = [self.datasArray objectAtIndex:(btn.tag - 1)];
    UIView *currentShadowView = [self viewWithTag:(imageTag + btn.tag)];
    UIImageView *currentCheckboxIcon = [self viewWithTag:(checkboxImageTag + btn.tag)];
    
    btn.selected = !btn.selected;
    
    UIButton *lastCheckboxButton = [self viewWithTag:self.lastSelectedTag];

    if (btn.selected)
    {
        lastCheckboxButton.selected = btn.selected;
        currentCheckboxIcon.image = [UIImage imageNamed:@"XN_LieCai_Brand_Promotion_Checkbox_selected_icon@2x.png"];
        currentShadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        if (self.lastSelectedTag != btn.tag)
        {
            UIView *lastShadowView = [self viewWithTag:(imageTag + self.lastSelectedTag)];
            UIImageView *lastCheckboxIcon = [self viewWithTag:(checkboxImageTag + self.lastSelectedTag)];
            lastCheckboxIcon.image = [UIImage imageNamed:@"XN_LieCai_Brand_Promotion_Checkbox_unselected_icon@2x.png"];
            lastShadowView.backgroundColor = [UIColor clearColor];
            lastCheckboxButton.selected = NO;
        }
        
        
    }
    else
    {
        if (self.lastSelectedTag == btn.tag)
        {
            self.selectedMode = nil;
        }
        lastCheckboxButton.selected = NO;
        currentCheckboxIcon.image = [UIImage imageNamed:@"XN_LieCai_Brand_Promotion_Checkbox_unselected_icon@2x.png"];
        currentShadowView.backgroundColor = [UIColor clearColor];
    }
    
    self.lastSelectedTag = btn.tag;
    
    if ([self.delegate respondsToSelector:@selector(saleGoodNewsCellDidClick:)])
    {
        [self.delegate saleGoodNewsCellDidClick:self.selectedMode];
    }
}

/*
- (void)showDatas:(NSArray *)datasArray
{
    self.datasArray = [datasArray copy];
    //列数
    int nColumns = 2;
    CGFloat Y = 0;
    CGFloat W = SCREEN_FRAME.size.width / 2;
    CGFloat H = 80;
    CGFloat X = (SCREEN_FRAME.size.width - nColumns * W) / (nColumns + 1);
    
    for (int i = 0; i < datasArray.count; i++)
    {
        int row = i / nColumns;
        int column = i % nColumns;
        CGFloat viewX = X + column * (W + X);
        CGFloat viewY = row * (H + Y);
        UIGridViewButton *button = [[UIGridViewButton alloc] initWithFrame:CGRectMake(viewX, viewY, W, H)];
        button.tag = i;
        [button addTarget:self action:@selector(gridItemClick:) forControlEvents:UIControlEventTouchUpInside];
        NSString *contentString = @"";
        if (datasArray.count > 1)
        {
            contentString = [datasArray objectAtIndex:i];
        }
        [button showDatas:[datasArray objectAtIndex:i] title:[datasArray objectAtIndex:i] text:contentString];
        
        [self addSubview:button];
    }
}

- (void)gridItemClick:(UIGridViewButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(saleGoodNewsCellDidClick:)])
    {
        [self.delegate saleGoodNewsCellDidClick:[self.datasArray objectAtIndex:btn.tag]];
    }
}
 */

///////////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

#pragma mark - NSArray
- (NSMutableArray *)datasArray
{
    if (_datasArray == nil)
    {
        _datasArray = [[NSMutableArray alloc] init];
    }
    return _datasArray;
}

@end
