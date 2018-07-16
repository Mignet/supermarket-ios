//
//  HomeCfgSaleCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 6/23/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "HomeCfgSaleCell.h"
#import "CustomScrollLabel.h"

@interface HomeCfgSaleCell()

@property (nonatomic, strong) IBOutlet UIView *labelView;
@property (nonatomic, strong) NSArray           *cfgOrderList;
@property (nonatomic, strong) CustomScrollLabel *customScrollLabel;

@end

@implementation HomeCfgSaleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showDatas:(NSArray *)cfgOrderList
{
    if (cfgOrderList && cfgOrderList.count > 0)
    {
        NSInteger index = 0;
        if (self.cfgOrderList.count > 0) {
            
            for (NSString * str in cfgOrderList) {
                
                if ([self.cfgOrderList containsObject:str]) {
                    
                    index ++;
                }
            }
        }
        
        if (self.cfgOrderList.count <= 0 || !(cfgOrderList.count == self.cfgOrderList.count && self.cfgOrderList.count == index)) {
            
            self.cfgOrderList = cfgOrderList;
            
            if ([_labelView.subviews containsObject:self.customScrollLabel])
            {
                [self.customScrollLabel removeFromSuperview];
            }
            
            CustomScrollLabel *customScrollLabel = [[CustomScrollLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width , 31) isShowUnderline:NO textAlignment:NSTextAlignmentCenter textColor:UIColorFromHex(0x4d585f) textFont:[UIFont systemFontOfSize:12] scrollDirection:ScrollDirectionTopType];
            
            [_labelView addSubview:customScrollLabel];
            __weak UIView *weakLabelView = _labelView;
            [customScrollLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(weakLabelView);
            }];
            self.customScrollLabel = customScrollLabel;
            
            NSMutableArray *listArray = [NSMutableArray array];
            NSString *mobile = @"";
            NSString *amount = @"";
            NSArray * property = nil;
            for (NSDictionary *dic in cfgOrderList)
            {
                mobile = [dic objectForKey:@"mobile"];
                amount = [dic objectForKey:@"orderMoney"];
                
                if (!IOS_IPHONE5OR4_SCREEN)
                {
                    property = [NSArray arrayWithObjects:
                                [NSDictionary dictionaryWithObjectsAndKeys:@"刚刚理财师 ",@"range", UIColorFromHex(0x4d585f),@"color", [UIFont fontWithName:@"PingFang-SC" size:12],@"font", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:[NSObject isValidateInitString:mobile]?mobile:@"",@"range",UIColorFromHex(0x4d585f),@"color",[UIFont fontWithName:@"PingFang-SC" size:12],@"font", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@" 出单 ",@"range",UIColorFromHex(0x4d585f),@"color",[UIFont fontWithName:@"PingFang-SC" size:12],@"font", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:[NSObject isValidateInitString:amount]?amount:@"",@"range",UIColorFromHex(0x4d585f),@"color",[UIFont fontWithName:@"DINOT" size:16],@"font", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@" 元 ",@"range",UIColorFromHex(0x4d585f),@"color",[UIFont fontWithName:@"PingFang-SC" size:12],@"font", nil],
                                nil];
                }
                else
                {
                    property = [NSArray arrayWithObjects:
                                [NSDictionary dictionaryWithObjectsAndKeys:@"刚刚理财师 ",@"range", UIColorFromHex(0x4d585f),@"color", [UIFont fontWithName:@"PingFang-SC" size:12],@"font", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:[NSObject isValidateInitString:mobile]?mobile:@"",@"range",UIColorFromHex(0x4d585f),@"color",[UIFont fontWithName:@"PingFang-SC" size:12],@"font", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@" 出单 ",@"range",UIColorFromHex(0x4d585f),@"color",[UIFont fontWithName:@"PingFang-SC" size:12],@"font", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:[NSObject isValidateInitString:amount]?amount:@"",@"range",UIColorFromHex(0x4d585f),@"color",[UIFont fontWithName:@"DINOT" size:16],@"font", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@" 元 ",@"range",UIColorFromHex(0x4d585f),@"color",[UIFont fontWithName:@"PingFang-SC" size:12],@"font", nil],
                                nil];
                }
                
                [listArray addObject:property];
            }
            
            [self.customScrollLabel animationWithTitles:listArray urls:nil];
        }
    }
}


#pragma mark - customScrollLabel
- (CustomScrollLabel *)customScrollLabel
{
    if (!_customScrollLabel)
    {
        _customScrollLabel = [[CustomScrollLabel alloc] init];
    }
    return _customScrollLabel;
}

//cfgOrderList
- (NSArray *)cfgOrderList
{
    if (!_cfgOrderList) {
        
        _cfgOrderList = [[NSArray alloc]init];
    }
    return _cfgOrderList;
}

@end
