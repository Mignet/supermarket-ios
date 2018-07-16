//
//  XNInvitedPopCell.m
//  XNCommonProject
//
//  Created by xnkj on 5/4/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

#import "XNInvitedPopCell.h"

@interface XNInvitedPopCell()

@property (nonatomic, weak) IBOutlet UIImageView * iconImageView;
@property (nonatomic, weak) IBOutlet UILabel     * titleLabel;
@property (nonatomic, weak) IBOutlet UILabel     * bottomLine;
@property (nonatomic, weak) IBOutlet UIImageView *pointImageView;
@end

@implementation XNInvitedPopCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (self.highlighted) {
        self.backgroundColor = UIColorFromHex(0x323232);
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)updateIcon:(NSString *)imageName title:(NSString *)title isLastCell:(BOOL)lastCell isHiddenRedPoint:(BOOL)isHiddenRedPoint
{
    self.pointImageView.hidden = isHiddenRedPoint;
    [self.iconImageView setImage:[UIImage imageNamed:imageName]];
    [self.titleLabel setText:title];
    
    [self.bottomLine setHidden:NO];
    if (lastCell) {
        
        [self.bottomLine setHidden:YES];
    }
}

@end
