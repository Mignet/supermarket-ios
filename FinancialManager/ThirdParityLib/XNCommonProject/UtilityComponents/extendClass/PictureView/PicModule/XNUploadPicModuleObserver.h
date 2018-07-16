//
//  XNUploadPicModuleObserver.h
//  FinancialManager
//
//  Created by xnkj on 5/18/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

@class XNUploadPicModule;
@protocol XNUploadPicModuleObserver <NSObject>
@optional

//图片上传
- (void)XNUploadPicModuleDidUploadPicSuccess:(XNUploadPicModule *)module;
- (void)XNUploadPicModuleDidUploadPicFailed:(XNUploadPicModule *)module;

//图片链接上传
- (void)XNUploadPicModuleDidUploadPicUrlSuccess:(XNUploadPicModule *)module;
- (void)XNUploadPicModuleDidUploadPicUrlFailed:(XNUploadPicModule *)module;

@end

