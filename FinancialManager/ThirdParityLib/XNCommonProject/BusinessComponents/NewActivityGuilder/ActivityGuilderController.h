//
//  ActivityGuilderController.h
//  FinancialManager
//
//  Created by xnkj on 08/12/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ActivityGuilderController;
@protocol ActivityGuilderControllerDelegate <NSObject>
@optional

- (void)activityGuilderController:(ActivityGuilderController *)ctrl didFinishedActivitywithTag:(NSInteger )tagIndex;
- (void)activityGuilderControllerDidExistActivity;
@end

@class NewUserGuildController;
@interface ActivityGuilderController : UIViewController

@property (nonatomic, weak) id<ActivityGuilderControllerDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil titleName:(NSString *)titleName bgImageName:(NSString *)imageName activityId:(NSInteger )activityId activityCount:(NSInteger)activityCount;

- (void)showGuilderMarkPathArray:(NSArray *)maskPathArray fingerImageName:(NSArray *)imageName fingerPoint:(NSArray *)fingerPointArray guildDescriptionImage:(NSArray *)guildDescriptionImageArray guildDescriptionLocationImage:(NSArray *)guildDescriptionLocationImageArray tapAreaArray:(NSArray *)tapAreaArray existButtonLocation:(CGRect)existBtnLocation;
@end
