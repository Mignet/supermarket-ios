//
//  DropDownListCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/7/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "DropDownListCell.h"

@interface DropDownListCell()

@property (nonatomic, weak) IBOutlet UILabel *txtLabel;
@property (nonatomic, weak) IBOutlet UIImageView *checkImageView;

@end

@implementation DropDownListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}


- (void)showDatas:(NSString *)string
{
    _txtLabel.textColor = UIColorFromHex(0x323232);
    _checkImageView.hidden = YES;
    _txtLabel.text = string;
}

- (void)selected:(BOOL)isSelect
{
    if (isSelect)
    {
        //选中
        _txtLabel.textColor = UIColorFromHex(0x12b7f5);
        _checkImageView.hidden = NO;
    }
    else
    {
        _txtLabel.textColor = UIColorFromHex(0x323232);
        _checkImageView.hidden = YES;
    }
    
}



@end
