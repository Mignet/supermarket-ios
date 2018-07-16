//
//  PopCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/19/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "PopCell.h"

@interface PopCell ()

@property (nonatomic, weak) IBOutlet UIView *contentsView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;

@property (nonatomic, weak) IBOutlet UIView *defaultView;

@end

@implementation PopCell

- (void)showDatas:(NSString *)titleString selected:(BOOL)isSelected showLastDefaultCell:(BOOL)isShowLastDefaultCell
{
    self.contentsView.hidden = NO;
    self.defaultView.hidden = YES;
    
    if (isShowLastDefaultCell)
    {
        self.contentsView.hidden = YES;
        self.defaultView.hidden = NO;
    }
    
    
    self.titleLabel.text = titleString;
    if (isSelected)
    {
        self.iconImageView.hidden = NO;
        self.titleLabel.textColor = UIColorFromHex(0x4e8cef);
    }
    else
    {
        self.iconImageView.hidden = YES;
        self.titleLabel.textColor = UIColorFromHex(0x4f5960);
    }

}

@end
