//
//  SeekTreasureOptionCell.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/20.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SeekTreasureOptionCell.h"

@interface SeekTreasureOptionCell ()

@property (weak, nonatomic) IBOutlet UIButton *activityBtn;
@property (weak, nonatomic) IBOutlet UIButton *dayPaperBtn;
@property (weak, nonatomic) IBOutlet UIButton *manualBtn;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UIButton *newsPaperBtn;
@property (weak, nonatomic) IBOutlet UIButton *listPaperBtn;
@property (weak, nonatomic) IBOutlet UIButton *cardBtn;
@property (weak, nonatomic) IBOutlet UIButton *compBtn;


@end

@implementation SeekTreasureOptionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (IBAction)btnClick:(UIButton *)sender
{
    if (![self.delegate respondsToSelector:@selector(seekTreasureOptionCellDid:OptionCellBtn:)]) {
        return;
    }
    
    if (sender == self.activityBtn) {
        [self.delegate seekTreasureOptionCellDid:self OptionCellBtn:ActivityBtn];
    }
    
    else if (sender == self.dayPaperBtn) {
        [self.delegate seekTreasureOptionCellDid:self OptionCellBtn:DayPaperBtn];
    }
    
    else if (sender == self.manualBtn) {
        [self.delegate seekTreasureOptionCellDid:self OptionCellBtn:ManualBtn];
    }
    
    else if (sender == self.inviteBtn) {
        [self.delegate seekTreasureOptionCellDid:self OptionCellBtn:InviteBtn];
    }
    
    else if (sender == self.newsPaperBtn) {
        [self.delegate seekTreasureOptionCellDid:self OptionCellBtn:NewsPaperBtn];
    }
    
    else if (sender == self.listPaperBtn) {
        [self.delegate seekTreasureOptionCellDid:self OptionCellBtn:ListPaperBtn];
    }
    
    else if (sender == self.cardBtn) {
        [self.delegate seekTreasureOptionCellDid:self OptionCellBtn:CardBtn];
    }
    
    else if (sender == self.compBtn) {
        [self.delegate seekTreasureOptionCellDid:self OptionCellBtn:CompBtn];
    }
}


@end
