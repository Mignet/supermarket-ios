//
//  ModuleBase.m
//  GXQApp
//
//  Created by jinfuzi on 14-2-26.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ReqCallBackCode;
@interface ModuleBase : NSObject
{
    NSMutableArray* _obervers;
}

@property (readonly,nonatomic) NSArray* observers;

// 返回错误码
@property (nonatomic, strong) ReqCallBackCode *retCode;
@property (nonatomic, strong) NSDictionary *resDic;

-(void) addObserver:(id)observer;

-(void) removeObserver:(id)observer;

-(void) notifyObservers:(SEL)selector;   //the selector must hava only one param which is module self

-(void) notifyObservers:(SEL)selector withObject:(id)param;

-(void) notifyObservers:(SEL)selector withObject:(id)param1 withObject:(id)param2;

-(void)clearErrorCode;

- (void)convertRetWithError:(NSError *)error;
- (id)convertRetJsonData:(id)jsonData;

@end

@interface ModuleObserver : NSObject

@property (weak, nonatomic) id obj;   //防止循环引用问题

@end

@interface ReqCallBackCode: NSObject

@property(nonatomic, strong)NSString* ret;

@property(nonatomic, strong)NSString* errorCode;

@property(nonatomic, strong)NSString* errorMsg;

@property(nonatomic, strong)NSDictionary * detailErrorDic;

+(ReqCallBackCode *)initWithDictionary:(NSDictionary*)dict;

@end
