//
//  UIViewController+PopView.h
//  FinancialManager
//
//  Created by xnkj on 15/9/30.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^completeBlock)();

@interface UIViewController(PopView)

- (void)showCustomWarnViewWithContent:(NSString *)content;
- (void)showCustomWarnViewWithContent:(NSString *)content Completed:(completeBlock)completed;
- (void)showCustomWarnViewWithContent:(NSString *)content Completed:(completeBlock)completed showTime:(NSTimeInterval )delyTime;
- (void)showCustomWarnViewWithContent:(NSString *)content SubContent:(NSString *)subContent;

- (void)showCustomSpecialWarnViewWithContent:(NSString *)content Completed:(completeBlock)completed showTime:(NSTimeInterval )delyTime;

//自定义弹出点击框（一个按钮,根据URL)
- (void)showCustomAlertViewWithUrl:(NSString *)url okTitle:(NSString *)okTitle okTitleColor:(UIColor *)okTitleColor okCompleteBlock:(completeBlock)okCompleted topPadding:(CGFloat )topPadding;
- (void)showCustomAlertViewWithTitle:(NSString *)title okTitle:(NSString *)okTitle okTitleColor:(UIColor *)okTitleColor okCompleteBlock:(completeBlock)okCompleted;
- (void)showCustomAlertViewWithTitle:(NSString *)title okTitle:(NSString *)okTitle okTitleColor:(UIColor *)okTitleColor okCompleteBlock:(completeBlock)okCompleted topPadding:(CGFloat )topPadding textAlignment:(NSTextAlignment)textAlignment;
- (void)showCustomAlertViewWithTitle:(NSString *)title titleFont:(CGFloat )font okTitle:(NSString *)okTitle okCompleteBlock:(completeBlock)okCompleted cancelTitle:(NSString *)cancelTitle cancelCompleteBlock:(completeBlock )cancelCompleted;
- (void)showCustomAlertViewWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(CGFloat )font okTitle:(NSString *)okTitle okTitleColor:(UIColor *)okTitleColor okCompleteBlock:(completeBlock)okCompleted cancelTitle:(NSString *)cancelTitle cancelCompleteBlock:(completeBlock )cancelCompleted  topPadding:(CGFloat )topPadding textAlignment:(NSTextAlignment)textAlignment;

- (void)showCUstomInformationAlertWithTitle:(NSString *)title announcementContent:(NSArray *)announcedPropertyArray myMessageContent:(NSArray *)msgPropertyArray okTitle:(NSString *)okTitle okCompleteBlock:(completeBlock)okCompleted;

- (void)showFMRecommandViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle subTitleLeftPadding:(CGFloat )leftPadding otherSubTitle:(NSString *)otherSubTitle okTitle:(NSString *)okTitle okCompleteBlock:(completeBlock)okCompleted cancelTitle:(NSString *)cancelTitle cancelCompleteBlock:(completeBlock )cancelCompleted;
- (void)showFMRecommandViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle otherSubTitle:(NSString *)otherSubTitle okTitle:(NSString *)okTitle okCompleteBlock:(completeBlock)okCompleted cancelTitle:(NSString *)cancelTitle cancelCompleteBlock:(completeBlock )cancelCompleted;

- (void)showCustomAlertViewWithTitle:(NSString *)title
                            subTitle:(NSString *)subTitle
                 subTitleLeftPadding:(CGFloat )leftPadding
                       otherSubTitle:(NSString *)otherSubTitle
                             okTitle:(NSString *)okTitle okCompleteBlock:(completeBlock)okCompleted
                         cancelTitle:(NSString *)cancelTitle cancelCompleteBlock:(completeBlock )cancelCompleted;

- (void)showGifViewWithContent:(NSString *)content;
- (void)hideGifView;

//隐藏弹出提示
- (void)hide;
@end
