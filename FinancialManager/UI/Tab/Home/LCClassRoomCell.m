//
//  LCClassRoomCell.m
//  FinancialManager
//
//  Created by xnkj on 13/09/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "LCClassRoomCell.h"
#import "CustomScrollLabel.h"

@interface LCClassRoomCell()<CustomScrollLabelDelegate>

@property (nonatomic, strong) NSArray                  * contentList;
@property (nonatomic, weak) IBOutlet CustomScrollLabel * scrollLabel;
@end

@implementation LCClassRoomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.scrollLabel.delegate = self;
    [self.scrollLabel setLabelFrame:CGRectMake(97, 0, SCREEN_FRAME.size.width - 97 - 15, 44)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//设置回调
- (void)setClickClassRoomItemBlock:(ClassRoomItemBlock)block
{
    if (block) {
        
        self.classRoomItemBlock = nil;
        self.classRoomItemBlock = block;
    }
}

//刷新数据
- (void)refreshLcClassRoomContentItemName:(NSArray *)contentList urlItemList:(NSArray *)urlList
{
    BOOL refresh = NO;
    if (self.contentList.count <= 0) {
        
        self.contentList = contentList;
        refresh = YES;
    }else
    {
        NSInteger index = 0;
        for (NSString * str in contentList) {
            
            [self.contentList containsObject:str];
            index ++;
        }
        
        if (self.contentList.count != contentList.count || index != contentList.count )
        {
            refresh = YES;
        }
    }

    if (refresh) {
        
        NSArray * property = nil;
        NSMutableArray * arr_property = [NSMutableArray array];
        for (NSString * str in contentList) {
            
            property = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:str,@"range", UIColorFromHex(0x4f5960),@"color", [UIFont fontWithName:@"PingFang-SC" size:12],@"font", nil],nil];
            [arr_property addObject:property];
        }
        
        [self.scrollLabel animationWithTitles:arr_property urls:urlList];
    }
}

//协议回调用
- (void)customScrollLabel:(CustomScrollLabel *)customScrollLabel didSelectedAtIndex:(NSInteger)index didSelectedAtUrl:(NSString *)url
{
    self.classRoomItemBlock(index,url);
}

/////////////////
#pragma mark - setter/getter
////////////////////////////////

//内容数组
- (NSArray *)contentList
{
    if (!_contentList) {
        
        _contentList = [[NSArray alloc]init];
    }
    return _contentList;
}
@end
