//
//  RecommendHeaderView.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/14.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "RecommendHeaderView.h"

@interface RecommendHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation RecommendHeaderView

+ (instancetype)recommendHeaderView
{
    RecommendHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([RecommendHeaderView class]) owner:nil options:nil] firstObject];
    
    return headerView;
}

- (void)setTitle:(NSString *)title
{
    self.nameLabel.text = title;
}

@end
