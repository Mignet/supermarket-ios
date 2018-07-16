//
//  BPHeaderViewCell.h
//  FinancialManager
//
//  Created by ancye.Xie on 7/5/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BPHeaderViewCellDelegate <NSObject>

- (void)BPHeaderViewCellDidChangeHeight:(BOOL)isShowCloseIcon;

- (void)BPHeaderViewCellDidInputContent:(NSString *)content;

@end

@interface BPHeaderViewCell : UITableViewCell

@property (nonatomic, assign) id<BPHeaderViewCellDelegate> delegate;

- (void)showDatas:(NSString *)content;

@end
