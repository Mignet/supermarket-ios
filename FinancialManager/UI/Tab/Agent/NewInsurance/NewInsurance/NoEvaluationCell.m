//
//  NoEvaluationCell.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/25.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "NoEvaluationCell.h"

@interface NoEvaluationCell ()

@property (weak, nonatomic) IBOutlet UIButton *hintOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *hintTwoBtn;


@end

@implementation NoEvaluationCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 按钮文字居左显示
    self.hintOneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.hintTwoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.hintOneBtn.titleEdgeInsets = UIEdgeInsetsMake(0.f, 12.f, 0.f, 0.f);
    self.hintTwoBtn.titleEdgeInsets = UIEdgeInsetsMake(0.f, 12.f, 0.f, 0.f);
}

- (IBAction)immediatelyClick
{
    if ([self.delegate respondsToSelector:@selector(noEvaluationCellDid:)]) {
        [self.delegate noEvaluationCellDid:self];
    }
}

@end
