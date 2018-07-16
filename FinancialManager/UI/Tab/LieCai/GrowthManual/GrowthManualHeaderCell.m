//
//  GrowthManualHeaderCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/31/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "GrowthManualHeaderCell.h"

#define HEADER_HEIGHT 218.0f
#define fLeftPadding 15.0f
#define fTopPadding 15.0f
#define imageTag 10000

@interface GrowthManualHeaderCell ()

@property (nonatomic, strong) NSMutableArray *datasArray;

@end

@implementation GrowthManualHeaderCell

- (void)showDatas:(NSArray *)datasArray
{
    [self.datasArray removeAllObjects];
    [self.datasArray addObjectsFromArray:datasArray];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *view = [self showCells];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    weakSelf(weakSelf)
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top);
        make.left.mas_equalTo(weakSelf.mas_left);
        make.right.mas_equalTo(weakSelf.mas_right);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-15);
    }];
    
}

- (UIView *)showCells
{
    UIView *view = [[UIView alloc] init];
    float fLeftRightPadding = fLeftPadding; //左右间距
    float fTop = fTopPadding;
    float fPicWidth = (SCREEN_FRAME.size.width - fLeftPadding * 3) / 2;
    float fPicHeight = 70;
    
    __weak UIView *weakView = view;
    for (int i = 0; i < self.datasArray.count; i++)
    {
        
        XNGrowthManualCategoryMode *mode = [self.datasArray objectAtIndex:i];
        UIView *picView = [[UIView alloc] init];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 3;
        NSString *urlString = [_LOGIC getImagePathUrlWithBaseUrl:mode.icon];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@""]];
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.textColor = UIColorFromHex(0x666666);
        textLabel.font = [UIFont systemFontOfSize:13];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.numberOfLines = 1;
        textLabel.text = mode.desc;
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:picView];
        [picView addSubview:imageView];
        [picView addSubview:textLabel];
        [picView addSubview:button];
        
        __weak UIView *weakPicView = picView;
        __weak UIImageView *weakImageView = imageView;
        [picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakView.mas_top).offset(fTop);
            make.left.mas_equalTo(weakView.mas_left).offset(fLeftRightPadding);
            make.width.mas_equalTo(fPicWidth);
            make.height.mas_equalTo(fPicHeight + 20);
        }];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakPicView.mas_top);
            make.left.mas_equalTo(weakPicView.mas_left);
            make.right.mas_equalTo(weakPicView.mas_right);
            make.width.mas_equalTo(fPicWidth);
            make.height.mas_equalTo(fPicHeight);
        }];
        
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakImageView.mas_bottom);
            make.left.mas_equalTo(weakImageView.mas_left);
            make.right.mas_equalTo(weakImageView.mas_right);
            make.height.mas_equalTo(20);
        }];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakPicView);
        }];
        
        fLeftRightPadding += fPicWidth + fLeftPadding;
        
        if (fLeftRightPadding >= SCREEN_FRAME.size.width)
        {
            fTop = fPicHeight + 40;
            fLeftRightPadding = fLeftPadding;
        }
    }

    view.size = CGSizeMake(SCREEN_FRAME.size.width, HEADER_HEIGHT);
    return view;
}

#pragma mark - 选中
- (void)buttonAction:(UIButton *)btn
{
    XNGrowthManualCategoryMode *mode = [self.datasArray objectAtIndex:btn.tag];
    if ([self.delegate respondsToSelector:@selector(growthManualHeaderCellDidClick:)])
    {
        [self.delegate growthManualHeaderCellDidClick:mode];
    }
}


///////////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

#pragma mark - datasArray
- (NSMutableArray *)datasArray
{
    if (_datasArray == nil)
    {
        _datasArray = [[NSMutableArray alloc] init];
    }
    return _datasArray;
}

@end
