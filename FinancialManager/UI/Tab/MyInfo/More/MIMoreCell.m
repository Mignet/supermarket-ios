//
//  MIMoreCell.m
//  FinancialManager
//
//  Created by xnkj on 15/9/24.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "MIMoreCell.h"

@interface MIMoreCell()

@property (nonatomic, weak) IBOutlet UILabel * titleLabel;
@property (nonatomic, weak) IBOutlet UILabel * contentLabel;
@property (nonatomic, weak) IBOutlet UIImageView * iconImageView;
@property (nonatomic, weak) IBOutlet UILabel   * topSeperatorLine;
@property (nonatomic, weak) IBOutlet UILabel     * seperatorLine;
@property (nonatomic, weak) IBOutlet UILabel   * fullSeperatorLine;
@end

@implementation MIMoreCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark - 更新内容
- (void)updateContent:(NSDictionary *)params topSeperatorHidden:(BOOL)hideValue hideSeperator:(BOOL)hide
{
    [self.titleLabel setText:[params objectForKey:@"title"]];
    
    [self.contentLabel setText:[params objectForKey:@"content"]];
    
    [self.topSeperatorLine setHidden:hideValue];
    [self.seperatorLine setHidden:!hide];
    [self.fullSeperatorLine setHidden:hide];
}

@end
