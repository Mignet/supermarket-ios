//
//  BPMorePicsViewController.h
//  FinancialManager
//
//  Created by ancye.Xie on 7/7/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"

@protocol BPMorePicsViewControllerDelegate <NSObject>

- (void)BPMorePicsViewControllerDidSelectedPics:(NSArray *)selectedPicArray selectedPicUrls:(NSArray *)selectedPicUrlsArray;

@end

@interface BPMorePicsViewController : BaseViewController

@property (nonatomic, assign) id<BPMorePicsViewControllerDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
              picType:(NSInteger)picType
         selectedPics:(NSArray *)selectedArray
       selectedPicUrl:(NSArray *)selectedPicUrlArray
      allPicsUrlArray:(NSArray *)allPicsUrlArray;

@end
