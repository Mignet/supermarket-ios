//
//  HotCfgMsgCell.m
//  FinancialManager
//
//  Created by xnkj on 13/09/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "HotCfgMsgCell.h"
#import "UIImageView+WebCache.h"

@interface HotCfgMsgCell()

@property (nonatomic, strong) NSString * linkUrl;
@property (nonatomic, weak) IBOutlet UIImageView * bgImageView;
@end

@implementation HotCfgMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//刷新图片
- (void)refreshImageWithUrl:(NSString *)url linkUrl:(NSString *)linkUrl
{
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"hot_commend_bannner_default"]];
}

@end
