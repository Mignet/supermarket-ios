//
//  JFZDataBase.h
//  JinFuZiApp
//
//  Created by 嘉维 陈 on 15/7/14.
//  Copyright (c) 2015年 com.jinfuzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

typedef NS_ENUM(NSInteger, JFZDataBaseCondition) {
    JFZDataBaseConditionNone = 0,
    JFZDataBaseConditionEqual,
    JFZDataBaseConditionNotEqual,
    JFZDataBaseConditionGreater,
    JFZDataBaseConditionEqualOrGreater,
    JFZDataBaseConditionLessThan,
    JFZDataBaseConditionEqualOrLessThan,
};

typedef void(^JFZDataBaseSuccessBlock) (id result, FMDatabase *db);
typedef void (^JFZDataBaseFailedBlock)  (NSError *error);
@interface JFZDataBase : NSObject
@property (nonatomic ,strong) NSString *dbName;
@property (nonatomic ,strong) FMDatabaseQueue *dbQueue;
@property (nonatomic ,strong) FMDatabase *dataBase;

/*
 database单例
 @dbName dataBase的名字,当本地没有该数据库的时候，会创建
 */
+ (JFZDataBase *)shareDataBaseWithDBName:(NSString *)dbName;


/*
 创建数据库表
 @param 表中需要的数据以及类型 key-value 形式 key 为字段名 value 为字段的数据类型
 @primaryKey 主健
 @tableName 表名
 @shouldAutoIncrease 主健是否支持自动增加
 */
- (void)createDataBaseIfNotExistWithParams:(NSDictionary *)param
                                primaryKey:(NSString *)primaryKey
                                 tableName:(NSString *)tableName
                        shouldAutoIncrease:(BOOL)shouldAI;

/*
 删除数据库表
 */
- (void)deleteDataBaseTable:(NSString *)talbeName;


/*
 清除数据表中自动增加的数据，将自增置为指定数字
 @tableName 表名
 @number 自增起始数字
*/
- (void)resetTableAutoIncreaseNumWithTableName:(NSString *)tableName
                                        Number:(NSString *)number;

/*
 添加数据库表中字段，用于版本更新，更新数据库
 @colum 字段名
 @tableName 表名
*/
- (void)updateColumnIfNeedWithColumnName:(NSString *)column
                               tableName:(NSString *)tableName;

#pragma mark - 插入数据
///////////////////////插入数据中的param注意规范形式可以是NSNumber , NSString等

/*
 向数据库添加数据
 @param 数据 key-value格式，key为字段名 value为数据
 @tableName 数据表名
 @success 中，如果该表中的主健为自动增加，block中result为新增的id
 
 SQL : INSERT INTO tableName (key1,key2,key3...) VALUES (value1,value2,value3...)
 */
- (void)inserDataWithParams:(NSDictionary *)param
              WithTableName:(NSString *)tableName
                    success:(JFZDataBaseSuccessBlock)success
                     failed:(JFZDataBaseFailedBlock)failed;


#pragma mark -删除数据
/*
 删除符合条件的数据
 @table 数据表名
 @key 条件对应的键值
 @value 条件的数据
 @condition 根据枚举值对应相应的匹配规则
 
 SQL: DELETE FROM tableName WHERE key =(or <,<=,>,>=,<>)value
 */
- (void)deleteDataInTable:(NSString *)tableName
                  WithKey:(NSString *)key
                    value:(NSString *)value
                condition:(JFZDataBaseCondition)condition
                  success:(JFZDataBaseSuccessBlock)success
                   failed:(JFZDataBaseFailedBlock)failed;


/*
 删除符合条件的数据
 @table 数据表名
 @conditionStr 条件语句
 
 SQL: DELETE FROM tableName WHERE condtionStr
 */
- (void)deleteDataInTable:(NSString *)tableName
             conditionStr:(NSString *)condtionStr
                  success:(JFZDataBaseSuccessBlock)success
                   failed:(JFZDataBaseFailedBlock)failed;


/*
 清除表中的所有数据
 */
- (void)clearAllDataInTable:(NSString *)tableName;

#pragma mark - 更新数据
/*
 更新数据
 @table 数据表名
 @findKey 条件对应的键值
 @findValue 条件的数据
 @condition 根据枚举值对应相应的匹配规则
 @updateParam key-value形式 key为字段 value为数据
 
 SQL:UPDATE table SET 'findKey' = 'findValue' WHERE key =(or <,<=,>,>=,<>)value
*/
- (void)updateDataInTable:(NSString *)table
              WithFindKey:(NSString *)findKey
                findValue:(NSString *)findValue
                condition:(JFZDataBaseCondition)condtion
              updateParam:(NSDictionary *)updateParam
                  success:(JFZDataBaseSuccessBlock)success
                   failed:(JFZDataBaseFailedBlock)failed;


/*
 更新符合自己规定条件的数据
 @table 数据表名
 @conditionStr 为SQL语句中where的语句，根据自己的条件填写,当置为nil时，则更新所有数据
 @updateParam key-value形式 key为字段 value为数据
 
SQL: UPDATE table SET 'key1' = 'value1','key2' = 'value2'....(取自updateParam) WHERE conditionStr
 */
- (void)updateDataInTable:(NSString *)table
             conditionStr:(NSString *)condtionStr
              updateParam:(NSDictionary *)updateParam
                  success:(JFZDataBaseSuccessBlock)success
                   failed:(JFZDataBaseFailedBlock)failed;



/////////////////////////////////////// 查询 ///////////////////////////////////////////////
#pragma mark - 查询数据

/*
 查找符合条件的第一个数据
 @key 匹配的字段
 @value 匹配的相关数据
 @condition 根据枚举值对应相应的匹配规则 当condtion为None或者0的时候，会执行conditionStr内的条件语句
 @conditionStr 为SQL语句中where的语句，根据自己的条件填写包括排序规则
 @orderBy 排序规则，没有则不填
 @success 返回的是一个NSdictionary数据
 
 生成的SQL : SELECT * FROM table WHERE key =(or <,<=,>,>=,<>)value  ORDER BY orderBy LIMIT 0,1
 */
- (void)findSingleDataInTable:(NSString *)table
                      WithKey:(NSString *)key
                        value:(NSString *)value
                    condition:(JFZDataBaseCondition)condition
                 conditionStr:(NSString *)conditionStr
                      orderBy:(NSString *)orderBy
                      success:(JFZDataBaseSuccessBlock)success
                       failed:(JFZDataBaseFailedBlock)failed;



/*
 查找符合条件的数据列表
 
 @conditionStr 为SQL语句中where的语句，根据自己的条件填写 ,为Nil默认为显示所有数据
 @orderBy 排序规则，没有则置为nil
 @page分页查询中的页数
 @pageSize 每页数据的数量，当pageSize ＝ 0时，则不分页
 @success 返回的是一个Nsarray数据，每个元素为NSdictionary
 
 生成的SQL 为 SELECT * FROM table WHERE WithConditionStr ORDER BY orderBy LIMIT page*pageSize,pageSize
 */
- (void)findDataInTable:(NSString *)table
       WithConditionStr:(NSString *)conditionStr
                orderBy:(NSString *)orderBy
                   page:(NSInteger)page
               pageSize:(NSInteger)pageSize
                success:(JFZDataBaseSuccessBlock)success
                 failed:(JFZDataBaseFailedBlock)failed;


/*
 查找包含特定字段的符合条件的数据列表
 
 @columnStr 需要特定的查询的字段名     不填则默认为 '*'
 @conditionStr 为SQL语句中where的语句，根据自己的条件填写 ,为Nil默认为显示所有数据
 @orderBy 排序规则，没有则置为nil
 @page分页查询中的页数
 @pageSize 每页数据的数量，当pageSize ＝ 0时，则不分页
 @success 返回的是一个Nsarray数据，每个元素为NSdictionary
 
 生成的SQL 为 SELECT columnStr FROM table WHERE WithConditionStr ORDER BY orderBy LIMIT page*pageSize,pageSize
 */
- (void)findDataInTable:(NSString *)table
              columnStr:(NSString *)columnStr
       WithConditionStr:(NSString *)conditionStr
                orderBy:(NSString *)orderBy
                   page:(NSInteger)page
               pageSize:(NSInteger)pageSize
                success:(JFZDataBaseSuccessBlock)success
                 failed:(JFZDataBaseFailedBlock)failed;


/*
 计算并返回符合条件的数据数量
 @tableName 表名
 @conditionStr 条件 条件为空则计算该表所有数据的数量
 */
- (NSInteger)countDataInTable:(NSString *)tableName
                 conditionStr:(NSString *)conditionStr;


/*
 当以上查询方法都不符合自己的查询规则时可以自己写SQLite语句完成需求
 @sql sql语句
 @success 返回的是一个Nsarray数据，每个元素为NSdictionary
 */
- (void)getDataFromDataBaseWithSQL:(NSString *)sql
                           success:(JFZDataBaseSuccessBlock)success
                            failed:(JFZDataBaseFailedBlock)failed;


#pragma mark - 修改表数据SQL方法
/*
 当增删改的方法无法满足需求，可以自己填写SQL语句来完成
 */
- (void)runSQLInDataBase:(NSString *)sql
                 success:(JFZDataBaseSuccessBlock)success
                  failed:(JFZDataBaseFailedBlock)failed;

@end
