//
//  BaseModule.h
//  FinancialManager
//
//  Created by xnkj on 28/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModule : NSObject

@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSArray * dataArr;
@property (nonatomic, strong) ReqCallBackCode *retCode;

//抽象接口
-(void) addObserver:(id)observer;

-(void) removeObserver:(id)observer;

-(void) notifyObservers:(SEL)selector;   //the selector must hava only one param which is module self

-(void) notifyObservers:(SEL)selector withObject:(id)param;

-(void) notifyObservers:(SEL)selector withObject:(id)param1 withObject:(id)param2;

//数据转换
- (void)convertRetWithError:(NSError *)error;
- (id)convertRetJsonData:(id)jsonData;

-(void)clearErrorCode;
@end

@interface BaseReqCallBackCode: NSObject

@property(nonatomic, strong)NSString* ret;

@property(nonatomic, strong)NSString* errorCode;

@property(nonatomic, strong)NSString* errorMsg;

@property(nonatomic, strong)NSDictionary * detailErrorDic;

+(BaseReqCallBackCode *)initWithDictionary:(NSDictionary*)dict;
@end

@interface BaseModuleObserver : NSObject

@property (weak, nonatomic) id obj;   //防止循环引用问题
@end

