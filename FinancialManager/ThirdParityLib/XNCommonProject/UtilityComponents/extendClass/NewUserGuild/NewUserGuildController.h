//
//  NewUserGuildController.h
//  XNCommonProject
//
//  Created by xnkj on 5/20/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completeBlock)();
typedef void(^nextStepBlock)(NSInteger step);

@interface NewUserGuildController : UIViewController

@property (nonatomic, copy) completeBlock block;
@property (nonatomic, copy) nextStepBlock stepBlock;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil masksPathArray:(NSArray *)masksPathArray guildImagesArray:(NSArray *)guildImageArray guildImageLocationArray:(NSArray *)guildImageLocationArray;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil masksPathArray:(NSArray *)masksPathArray guildDescriptionImageArray:(NSArray *)guildDescriptionArray guildDescriptionImageLocationArray:(NSArray *)guildDescriptionImageLocationArray clickAreaArray:(NSArray *)clickAreaArray tapMaskArea:(BOOL)tapMaskArea;

- (void)setClickCompleteBlock:(completeBlock )block;
- (void)setCliekStepBlock:(nextStepBlock)block;
@end
