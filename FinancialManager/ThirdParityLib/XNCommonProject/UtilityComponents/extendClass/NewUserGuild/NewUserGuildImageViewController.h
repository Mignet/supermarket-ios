//
//  NewUserGuildImageViewController.h
//  FinancialManager
//
//  Created by xnkj on 27/12/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completeBlock)();

@interface NewUserGuildImageViewController : UIViewController

@property (nonatomic, copy) completeBlock block;

/**
 * 初始化
 *
 * params nibNameOrNil nib名
 * params nibBundleOrNil 
 * params imageName 背景图片
 * params masksPathArray 抠图路径数组
 * params guildImageArray 描述图数组
 * params guildImageLocationArray 描述图位置
 **/
- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                    bgImageName:(NSString *)imagName
                 masksPathArray:(NSArray *)masksPathArray
               guildImagesArray:(NSArray *)guildImageArray
        guildImageLocationArray:(NSArray *)guildImageLocationArray;

/**
 * 初始化
 *
 * params nibNameOrNil nib名
 * params nibBundleOrNil
 * params imageName 背景图片
 * params masksPathArray 抠图路径数组
 * params guildImageArray 描述图数组
 * params guildImageLocationArray 描述图位置
 * params clickAreaArray 点击区域
 * params tapMsakArea 是否需要点击
 **/
- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                    bgImageName:(NSString *)imageName
                 masksPathArray:(NSArray *)masksPathArray
     guildDescriptionImageArray:(NSArray *)guildDescriptionArray
guildDescriptionImageLocationArray:(NSArray *)guildDescriptionImageLocationArray
                 clickAreaArray:(NSArray *)clickAreaArray
                    tapMaskArea:(BOOL)tapMaskArea;

- (void)setClickCompleteBlock:(completeBlock )block;
@end

