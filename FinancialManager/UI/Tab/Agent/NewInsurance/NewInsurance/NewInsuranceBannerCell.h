//
//  NewInsuranceBannerCell.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/25.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewInsuranceBannerCell;

typedef NS_ENUM(NSInteger, NewInsuranceBannerCellClickType){

    Severe_Illness_Click = 0,
    Accident_Click,
    Children_Click,
    More_Insurance,
    Banner_Click
};

@protocol NewInsuranceBannerCellDelegate <NSObject>

- (void)newInsuranceBannerCellDid:(NewInsuranceBannerCell *)insuranceBannerCell ClickType:(NewInsuranceBannerCellClickType)clickType withUrl:(NSString *)linkUrl;

@end

@interface NewInsuranceBannerCell : UITableViewCell

@property (nonatomic, weak) id <NewInsuranceBannerCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *adSupView;

@property (nonatomic, strong) NSMutableArray *urlArr;

@end
