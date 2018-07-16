//
//  SeekTreasureHeaderView.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/20.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SeekTreasureHeaderView.h"

@interface SeekTreasureHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moreImgView;


@end

@implementation SeekTreasureHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

+ (instancetype)seekTreasureHeaderViewType:(SeekTreasureHeaderViewType)seekType
{
    SeekTreasureHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SeekTreasureHeaderView class]) owner:nil options:nil] firstObject];
    headerView.seekType = seekType;
    
    if (seekType == SeekTreasureActivity) {
        
        headerView.nameLabel.text = @"热门活动";
        headerView.moreLabel.hidden = NO;
        headerView.moreImgView.hidden = NO;
        
    } else if (seekType == SeekTreasureOption) {
        
        headerView.nameLabel.text = @"精选推荐";
        headerView.moreLabel.hidden = YES;
        headerView.moreImgView.hidden = YES;
        
    } else if (seekType == SeekTreasureRead) {
        
        headerView.nameLabel.text = @"最近热读";
        headerView.moreLabel.hidden = NO;
        headerView.moreImgView.hidden = NO;
    
    } else if (seekType == NewInsuranceProduct) {
        
        headerView.nameLabel.text = @"甄选保险";
        headerView.moreLabel.hidden = YES;
        headerView.moreImgView.hidden = YES;
    }

    return headerView;
}

- (IBAction)btnClick
{
    if (![self.delegate respondsToSelector:@selector(seekTreasureHeaderViewDid:HeaderViewType:)]) {
        return;
    }
    
    if (self.seekType == SeekTreasureActivity) {
        [self.delegate seekTreasureHeaderViewDid:self HeaderViewType:SeekTreasureActivity];
    }
    
    else if (self.seekType == SeekTreasureOption) {
        [self.delegate seekTreasureHeaderViewDid:self HeaderViewType:SeekTreasureOption];
    }
    
    else if (self.seekType == SeekTreasureRead) {
        [self.delegate seekTreasureHeaderViewDid:self HeaderViewType:SeekTreasureRead];
    }
}


@end
