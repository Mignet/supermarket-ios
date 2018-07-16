//
//  XNUploadPicModule.h
//  FinancialManager
//
//  Created by xnkj on 5/18/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "AppModuleBase.h"

#define XN_UPLOAD_IMAGE_INFO @"info"
#define XN_UPLOAD_IMAGE_INFO_SIZE @"size"
#define XN_UPLOAD_IMAGE_INFO_MD5 @"md5"

@interface XNUploadPicModule : AppModuleBase

@property (nonatomic, strong) NSString * imageMd5;

+ (instancetype)defaultModule;

/**
 * 上传用户头像
 * params file 
 **/
- (void)uploadUserPicWithFile:(UIImage *)imageData;

/**
 * 上传图片链接
 * params imageUrl 图片信息
 **/
- (void)uploadUserPicUrlWithImageUrl:(NSString *)imageUrl;
@end
