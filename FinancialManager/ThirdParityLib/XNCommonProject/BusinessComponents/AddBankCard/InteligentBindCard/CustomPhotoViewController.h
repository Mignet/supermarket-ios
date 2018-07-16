//
//  CustomPhotoViewController.h
//  FinancialManager
//
//  Created by xnkj on 22/12/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^UseCaptureImage)(NSDictionary * params);

@interface CustomPhotoViewController : BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil maskBezierPath:(UIBezierPath *)bezierPath title:(NSString*)title describeContent:(NSString *)describeContent captureType:(NSString *)type;

@property (nonatomic,copy) UseCaptureImage useCaptureImageBlock;

- (void)setCaptrueImageBlock:(UseCaptureImage)block;
@end
