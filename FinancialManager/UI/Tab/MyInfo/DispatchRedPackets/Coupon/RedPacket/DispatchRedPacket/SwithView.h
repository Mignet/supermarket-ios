//
//  ReturnSwithView.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/20.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SwithViewType) {
    
    CFGTYPE = 0,
    CUSTOMERTYPE
};

@class SwithView;

@protocol SwithViewDelegate <NSObject>

- (void)swithViewDid:(SwithView *)swithView clickType:(SwithViewType)clickType;

@end

@interface SwithView : UIView

/***  代理对象 **/
@property (nonatomic, weak) id <SwithViewDelegate> delegate;
@property(nonatomic, assign) CGSize intrinsicContentSize;

@property (weak, nonatomic) IBOutlet UIButton *customerBtn;
@property (weak, nonatomic) IBOutlet UIButton *cfgBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;

+ (instancetype)returnSwithView;

- (IBAction)btnClick:(UIButton *)sender;



@end
