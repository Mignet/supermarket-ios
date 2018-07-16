//
//  XNUploadPicModule.m
//  FinancialManager
//
//  Created by xnkj on 5/18/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNUploadPicModule.h"
#import "NSObject+Common.h"

#import "XNUploadPicModuleObserver.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

#define XNIMAGEUPLOADURLMETHOD @"/personcenter/icon"

@implementation XNUploadPicModule

#pragma mark - 初始化
+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

#pragma mark - 上传用户头像
- (void)uploadUserPicWithFile:(UIImage *)imageData
{
    
    //    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
    //        if (jsonData) {
    //
    //            if ([[jsonData objectForKey:@"ret"] integerValue] == 1) {
    //
    //                self.uploadImageDictionary = self.dataDic;
    //
    //                [self notifyObservers:@selector(XNUploadPicModuleDidUploadPicSuccess:) withObject:self];
    //            }
    //            else {
    //                [self notifyObservers:@selector(XNUploadPicModuleDidUploadPicFailed:) withObject:self];
    //            }
    //        } else {
    //            [self notifyObservers:@selector(XNUploadPicModuleDidUploadPicFailed:) withObject:self];
    //        }
    //    };
    //
    //    //请求失败block
    //    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
    //
    //        [self convertRetWithError:error];
    //        [self notifyObservers:@selector(XNUploadPicModuleDidUploadPicFailed:) withObject:self];
    //    };
    //
    //    //将UIImage 转化为字节数组
    //    NSData * imageDatas = UIImageJPEGRepresentation(imageData, 0.1);
    //    Byte * imageBytes = (Byte *)[imageDatas bytes];
    //
    //    NSDictionary * params = @{[NSValue valueWithBytes:imageBytes objCType:@encode(Byte)]};
    //
    //    [[EnvSwitchManager sharedClient] POSTPic:XN_IMAGE_UPLOAD_URL parameters:imageDatas success:^(id operation, id responseObject){
    //
    //        requestSuccessBlock(responseObject);
    //
    //    } failure:^(id operation, NSError *error) {
    //
    //        requestFailureBlock(error);
    //    }];
    
    //    [[EnvSwitchManager sharedClient] POST:XN_IMAGE_UPLOAD_URL parameters:@{} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    //
    //        [formData appendPartWithFormData:imageDatas name:@"file"];
    //
    //    } success:^(id operation, id responseObject) {
    //
    //        requestSuccessBlock(responseObject);
    //
    //    } failure:^(id operation, NSError *error) {
    //
    //        requestFailureBlock(error);
    //    }];
    
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    
    NSURL *url = [NSURL URLWithString:[_LOGIC getImagePathUrlWithBaseUrl:@"upload"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    //循环加入上传图片
    NSData* data =  UIImageJPEGRepresentation(imageData, 0.1);
    NSMutableString *imgbody = [[NSMutableString alloc] init];
    
    ////添加分界线，换行
    [imgbody appendFormat:@"%@\r\n",MPboundary];
    [imgbody appendFormat:@"Content-Disposition: form-data; name=\"File%d\"; filename=\"%@.jpg\"\r\n", 0, @"file"];
    //声明上传文件的格式
    [imgbody appendFormat:@"Content-Type: application/octet-stream; charset=utf-8\r\n\r\n"];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[imgbody dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    [myRequestData appendData:[ @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"%@\r\n",endMPboundary];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //设置接受response的data
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
       
        NSString * res = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if ([NSObject isValidateInitString:res]) {
            
            NSArray * seperatorArray = [res componentsSeparatedByString:@"MD5:"];
            
            if (seperatorArray.count >= 2) {
                
                self.imageMd5 = [[[[[[[[res componentsSeparatedByString:@"<body>"] lastObject] componentsSeparatedByString:@"</body>"] firstObject] componentsSeparatedByString:@"MD5:"] lastObject] componentsSeparatedByString:@","] firstObject];
                
                [self notifyObservers:@selector(XNUploadPicModuleDidUploadPicSuccess:) withObject:self];
            }else
            {
                [self notifyObservers:@selector(XNUploadPicModuleDidUploadPicFailed:) withObject:self];
            }
            
        }else
        {
            [self notifyObservers:@selector(XNUploadPicModuleDidUploadPicFailed:) withObject:self];
        }
     }];
}

#pragma mark - 图片相关参数上传
- (void)uploadUserPicUrlWithImageUrl:(NSString *)imageUrl
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNUploadPicModuleDidUploadPicUrlSuccess:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNUploadPicModuleDidUploadPicUrlFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNUploadPicModuleDidUploadPicUrlFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNUploadPicModuleDidUploadPicUrlFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateObj:token]) {
        
        token = @"";
    }
    
    NSDictionary * params = @{@"token":token,@"image":imageUrl,@"method":XNIMAGEUPLOADURLMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNIMAGEUPLOADURLMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

@end
