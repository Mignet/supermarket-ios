//
//  SystemSharedManager.m
//  FinancialManager
//
//  Created by xnkj on 20/06/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "SystemSharedManager.h"
#import "SharedItem.h"
#import "CustomTabBarController.h"

@implementation SystemSharedManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static SystemSharedManager * instance = nil;
    dispatch_once(&onceToken, ^{
        
        instance = [[SystemSharedManager alloc]init];
    });
    
    return instance;
}

//调用系统的分享操作
- (void)systemSharedWithImageNameArray:(NSArray *)imgArray
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSString *path_sandox = NSHomeDirectory();
    NSString *imagePath = @"";
    UIImage * image = nil;
    for (int i = 0; i < imgArray.count; i++) {

        imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/lcdsTool/Activity/%@.jpg",[imgArray objectAtIndex:i]]];
        
        image = [[UIImage alloc]initWithContentsOfFile:imagePath];
        NSURL *shareobj = [NSURL fileURLWithPath:imagePath];
        
        SharedItem *item = [[SharedItem alloc] initWithData:image andFile:shareobj];
        
        [array addObject:item];
    }
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:array applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    
     [_UI.rootTabBarCtrl presentViewController:activityVC animated:YES completion:nil];
}

@end
