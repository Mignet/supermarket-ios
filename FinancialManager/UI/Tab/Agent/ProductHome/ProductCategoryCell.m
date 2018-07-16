//
//  ProductCategoryCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 2/24/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "ProductCategoryCell.h"
#import "XNFMProductCategoryStatisticMode.h"

@interface ProductCategoryCell()

@property (nonatomic, weak) IBOutlet UIView *mainView;

@end

@implementation ProductCategoryCell

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

- (void)showProductCategory:(NSArray *)params
{
    CGFloat fCategoryItemWidth = SCREEN_FRAME.size.width / [[XNFinancialManagerModule defaultModule] productCategoryStatisticArray].count;
    
    UIView *categoryView = nil;
    UIView *lastView = nil;
    
    weakSelf(weakSelf)
    __weak UIView *weakMainView = self.mainView;
    __weak UIView *weakLastView = lastView;
    for (NSInteger i = 0; i < params.count; i ++)
    {
        XNFMProductCategoryStatisticMode *mode = [params objectAtIndex:i];
        NSString *iconString = @"";
        switch ([mode.cateId integerValue]) {
            case NewerbieProductType: //新手标
                iconString = @"XN_Product_Category_newerbie_icon";
                break;
            case ShortProductType: //短期产品
                iconString = @"XN_Product_Category_short_icon";
                break;
            case HighProfitProductType: //高收益产品
                iconString = @"XN_Product_Category_high_profit_icon";
                break;
            case LongProductType: //中长期产品
                iconString = @"XN_Product_Category_long_icon";
                break;
            default:
                break;
        }
        
        categoryView = [self createCategoryView:iconString title:mode.cateName tag:[mode.cateId integerValue]];
        [self addSubview:categoryView];
        
        if (i == 0)
        {
            [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.mas_equalTo(weakSelf.mas_leading);
                make.top.mas_equalTo(weakSelf.mas_top);
                make.bottom.mas_equalTo(weakMainView.mas_bottom);
                make.width.mas_equalTo(fCategoryItemWidth);
                make.height.mas_equalTo(weakMainView.mas_height);
            }];
        }
        else if (i < (params.count - 1))
        {
            weakLastView = lastView;
            [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.mas_equalTo(weakLastView.mas_trailing);
                make.top.mas_equalTo(weakSelf.mas_top);
                make.bottom.mas_equalTo(weakMainView.mas_bottom);
                make.width.mas_equalTo(fCategoryItemWidth);
                make.height.mas_equalTo(weakMainView.mas_height);
            }];
        }
        else
        {
            weakLastView = lastView;
            [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.mas_equalTo(weakLastView.mas_trailing);
                make.top.mas_equalTo(weakSelf.mas_top);
                make.bottom.mas_equalTo(weakMainView.mas_bottom);
                make.width.mas_equalTo(fCategoryItemWidth);
                make.height.mas_equalTo(weakMainView.mas_height);
            }];
            
        }
        lastView = categoryView;
    }
}

#pragma mark - 创建单个view
- (UIView *)createCategoryView:(NSString *)imageString title:(NSString *)titleString tag:(NSInteger)tag
{
    UIView *categoryView = [[UIView alloc] init];
    
    //图片
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageString]];
    [categoryView addSubview:imageView];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = titleString;
    titleLabel.textColor = JFZ_COLOR_GRAY;
    titleLabel.font = [UIFont systemFontOfSize:12];
    [categoryView addSubview:titleLabel];
    
    UIButton *pressButton = [[UIButton alloc] init];
    pressButton.tag = tag;
    [pressButton addTarget:self action:@selector(categoryClick:) forControlEvents:UIControlEventTouchUpInside];
    [categoryView addSubview:pressButton];
    
    __weak UIView *weakCategoryView = categoryView;
    __weak UIImageView *weakImageView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakCategoryView.mas_centerX);
        make.top.mas_equalTo(weakCategoryView.mas_top).offset(12);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakCategoryView.mas_left);
        make.top.mas_equalTo(weakImageView.mas_bottom).offset(4);
        make.right.mas_equalTo(weakCategoryView.mas_right);
        make.bottom.mas_equalTo(weakCategoryView.mas_bottom).offset(-12);
    }];
    
    [pressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakCategoryView);
    }];
    
    return categoryView;
}

- (void)categoryClick:(UIButton *)sender
{
    switch (sender.tag) {
        case NewerbieProductType: //新手标
            [XNUMengHelper umengEvent:@"C_new_product"];
            
            break;
        case ShortProductType: //短期产品
            [XNUMengHelper umengEvent:@"C_short_product"];
            
            break;
        case HighProfitProductType: //高收益产品
            [XNUMengHelper umengEvent:@"C_high_product"];
            
            break;
        case LongProductType: //中长期产品
            [XNUMengHelper umengEvent:@"C_long_product"];
            
            break;
            
        default:
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(XNProductCategoryCellDidClick:)])
    {
        [self.delegate XNProductCategoryCellDidClick:sender.tag];
    }
}

@end
