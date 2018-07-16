//
//  XNInvestPlatformsEmptyCellTableViewCell.m
//  FinancialManager
//
//  Created by xnkj on 29/06/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNInvestPlatformsEmptyCell.h"

@interface XNInvestPlatformsEmptyCell()

@property (nonatomic, weak) IBOutlet UILabel *explainLabel;
@property (nonatomic, weak) IBOutlet UIButton * recommendButton;

@property (nonatomic, copy) recommendBlock recommendBlock;
@end

@implementation XNInvestPlatformsEmptyCell

- (void)showExplain:(NSString *)string btnTitle:(NSString *)title
{
    self.explainLabel.text = string;
    
    if (![NSObject isValidateInitString:title]) {
        [self.recommendButton setHidden:YES];
    }else
    {
        [self.recommendButton setTitle:title forState:UIControlStateNormal];
    }
}

- (void)setCliekRecommend:(recommendBlock)recommendBlock
{
    self.recommendBlock = nil;
    self.recommendBlock = [recommendBlock copy];
}

- (IBAction)clickRecommend:(id)sender
{
    if (self.recommendBlock) {
        
        self.recommendBlock();
    }
}

@end

