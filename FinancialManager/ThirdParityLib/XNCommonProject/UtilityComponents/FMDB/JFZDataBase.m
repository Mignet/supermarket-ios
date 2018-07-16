//
//  JFZDataBase.m
//  JinFuZiApp
//
//  Created by 嘉维 陈 on 15/7/14.
//  Copyright (c) 2015年 com.jinfuzi. All rights reserved.
//

#import "JFZDataBase.h"

@implementation JFZDataBase

#pragma mark - 初始化

+ (JFZDataBase *)shareDataBaseWithDBName:(NSString *)dbName {
    static NSMutableDictionary *shareDictionary;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if(!shareDictionary){
            shareDictionary = [[NSMutableDictionary alloc]init];
        }
    });
    if(!shareDictionary[dbName]){
        JFZDataBase *dataBase = [[JFZDataBase alloc]initWithDBName:dbName];
        shareDictionary[dbName] = dataBase;
    }
    return shareDictionary[dbName];
    
}

- (id)initWithDBName:(NSString *)dbName {
    if(self = [super init]){
        _dbName = dbName;
        NSString *dbDir =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0] stringByAppendingPathComponent: @"userDB"];
        if(![[NSFileManager defaultManager] fileExistsAtPath:dbDir]){
            //sql目录不存在
            JCLogInfo(@"FMDB SQL path Doesn't exist,create Dir");
            [[NSFileManager defaultManager] createDirectoryAtPath: dbDir withIntermediateDirectories: YES attributes: @{NSFilePosixPermissions:@0777} error: nil];
        }else{
            //sql目录存在
            NSError *error = nil;
            [[NSFileManager defaultManager] setAttributes: @{NSFilePosixPermissions:@0777} ofItemAtPath: dbDir error: &error];
        }
        _dbQueue = [[FMDatabaseQueue alloc]initWithPath:[self dbPath]];
        _dataBase = [[FMDatabase alloc]initWithPath:[self dbPath]];
    }
    return self;
}

- (NSString *)dbPath {
    //数据库的路径
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0] stringByAppendingPathComponent:[NSString stringWithFormat:@"userDB/%@.db",self.dbName]];
}

- (void)createDataBaseIfNotExistWithParams:(NSDictionary *)param
                                primaryKey:(NSString *)primaryKey
                                 tableName:(NSString *)tableName
                        shouldAutoIncrease:(BOOL)shouldAI{
    //构造sql语句
    //如果表明存在，则return
    if(![_dataBase open]){
        JCLogInfo(@"dataBase :%@ couldNot Open",self.dbName);
        return;
    }
    if([_dataBase tableExists:tableName]){
        [_dataBase close];
        return;
    }
    NSString *query;
    __block NSString *keyString = @"(";
    [param enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *type, BOOL *stop) {
        NSString *tempStr = @"";
        if([key isEqualToString:primaryKey]){
            tempStr = @"PRIMARY KEY";
            if(shouldAI){
                tempStr = [tempStr stringByAppendingString:@" AUTOINCREMENT"];
            }
        }
        keyString = [keyString stringByAppendingString:[NSString stringWithFormat:@"%@ %@ %@,",key,type,tempStr]];
    }];
    keyString = [keyString substringWithRange:NSMakeRange(0, keyString.length - 1)];
    keyString = [keyString stringByAppendingString:[NSString stringWithFormat:@")"]];
    query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@%@",tableName,keyString];
    [self runSQLInDataBase:query success:nil failed:nil];
}


- (void)resetTableAutoIncreaseNumWithTableName:(NSString *)tableName Number:(NSString *)number {
    if([_dataBase tableExists:tableName]){
        return;
    }
    NSString *query = [NSString stringWithFormat:@"UPDATE sqlite_sequence set seq=%@ where name='%@'",number,tableName];
    [self runSQLInDataBase:query success:nil failed:nil];
}


- (void)updateColumnIfNeedWithColumnName:(NSString *)column tableName:(NSString *)tableName {
    //如果该字段已经存在，return
    if([_dataBase columnExists:column inTableWithName:tableName]){
        return;
    }
    NSString *query = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ text",tableName,column];
    [self runSQLInDataBase:query success:nil failed:nil];
}

#pragma mark - 删除数据库表
- (void)deleteDataBaseTable:(NSString *)talbeName
{
    NSString *query = [NSString stringWithFormat:@"DROP TABLE %@",talbeName];

    [self runSQLInDataBase:query success:nil failed:nil];
}

#pragma mark - 插入数据
- (void)inserDataWithParams:(NSDictionary *)param
              WithTableName:(NSString *)tableName
                    success:(JFZDataBaseSuccessBlock)success
                     failed:(JFZDataBaseFailedBlock)failed {

    NSString *query = [self createInsertSqlStrWithParam:param tableName:tableName];
#if 0
    __block BOOL suc;
    __block FMDatabase *dataBase;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        dataBase = db;
        suc = NO;
        suc = [db executeUpdate:query withParameterDictionary:param];
    }];
    if(suc){
        NSString *lastID = [NSString stringWithFormat:@"%lld",[dataBase lastInsertRowId]];
        if(success){
            success(lastID,dataBase);
        }
    }else{
        if(failed){
            NSError *error = [NSError errorWithDomain:[dataBase lastErrorMessage] code:[dataBase lastErrorCode] userInfo:nil];
            failed(error);
        }
    }
#else
    NSLog(@"liaochangpingliaochangping");
    [self runSQLInDataBase:query success:^(id result, FMDatabase *db) {
        NSString *lastID = [NSString stringWithFormat:@"%lld",[db lastInsertRowId]];
        if(success){
            success(lastID,db);
        }
    } failed:failed];
#endif
    
}


#pragma mark -删除数据
- (void)deleteDataInTable:(NSString *)tableName
             conditionStr:(NSString *)condtionStr
                  success:(JFZDataBaseSuccessBlock)success
                   failed:(JFZDataBaseFailedBlock)failed {
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",tableName,condtionStr ? condtionStr : @"1"];
#if 0
    __block BOOL suc;
    __block FMDatabase *dataBase;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        dataBase = db;
        suc = NO;
        suc = [db executeUpdate:query];
    }];
    if(suc){
        if(success){
            success(nil,dataBase);
        }
    }else{
        if(failed){
            NSError *error = [NSError errorWithDomain:[dataBase lastErrorMessage] code:[dataBase lastErrorCode] userInfo:nil];
            failed(error);
        }
    }
#else
    [self runSQLInDataBase:query success:success failed:failed];
#endif
}

- (void)deleteDataInTable:(NSString *)tableName
                  WithKey:(NSString *)key
                    value:(NSString *)value
                condition:(JFZDataBaseCondition)condition
                  success:(JFZDataBaseSuccessBlock)success
                   failed:(JFZDataBaseFailedBlock)failed {
    __block BOOL suc;
    __block FMDatabase *dataBase;
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ %@ ?",tableName,key,[self getContidtionString:condition]];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        dataBase = db;
        suc= NO;
        suc = [db executeUpdate:sql,value];
    }];
    if(suc){
        if(success){
            success(nil,dataBase);
        }
    }else{
        if(failed){
            NSError *error = [NSError errorWithDomain:[dataBase lastErrorMessage] code:[dataBase lastErrorCode] userInfo:nil];
            failed(error);
        }
    }
}

- (void)clearAllDataInTable:(NSString *)tableName {
    [self deleteDataInTable:tableName conditionStr:nil success:nil failed:nil];
}

#pragma mark - 更新数据
- (void)updateDataInTable:(NSString *)table
             conditionStr:(NSString *)condtionStr
              updateParam:(NSDictionary *)updateParam
                  success:(JFZDataBaseSuccessBlock)success
                   failed:(JFZDataBaseFailedBlock)failed {
    NSString *query = [self createUpdateSqlStrWithParam:updateParam tableName:table condition:condtionStr];

#if 0
    __block BOOL suc;
    __block FMDatabase *dataBase;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        dataBase = db;
        suc = NO;
        suc = [db executeUpdate:query];
    }];
    if(suc){
        if(success){
            success(nil,dataBase);
        }
    }else{
        if(failed){
            NSError *error = [NSError errorWithDomain:[dataBase lastErrorMessage] code:[dataBase lastErrorCode] userInfo:nil];
            failed(error);
        }
    }
#else
    [self runSQLInDataBase:query success:success failed:failed];
#endif
    
}

- (void)updateDataInTable:(NSString *)table
              WithFindKey:(NSString *)findKey
                findValue:(NSString *)findValue
                condition:(JFZDataBaseCondition)condtion
              updateParam:(NSDictionary *)updateParam
                  success:(JFZDataBaseSuccessBlock)success
                   failed:(JFZDataBaseFailedBlock)failed {
    NSString *conditionStr = (condtion == JFZDataBaseConditionNone) ? nil : [NSString stringWithFormat:@"%@ %@ %@",findKey,[self getContidtionString:condtion],findValue];
    [self updateDataInTable:table conditionStr:conditionStr updateParam:updateParam success:success failed:failed];
}

#pragma mark - 查询数据
- (void)findDataInTable:(NSString *)table
       WithConditionStr:(NSString *)conditionStr
                orderBy:(NSString *)orderBy
                   page:(NSInteger)page
               pageSize:(NSInteger)pageSize
                success:(JFZDataBaseSuccessBlock)success
                 failed:(JFZDataBaseFailedBlock)failed {
    NSString *query = [self createFindSqlStrWithConditionStr:conditionStr findColumn:nil orderBy:orderBy page:page pageSize:pageSize tableName:table];
    [self getDataFromDataBaseWithSQL:query success:success failed:failed];
}

- (void)findDataInTable:(NSString *)table
              columnStr:(NSString *)columnStr
       WithConditionStr:(NSString *)conditionStr
                orderBy:(NSString *)orderBy
                   page:(NSInteger)page
               pageSize:(NSInteger)pageSize
                success:(JFZDataBaseSuccessBlock)success
                 failed:(JFZDataBaseFailedBlock)failed {
    
    NSString *query = [self createFindSqlStrWithConditionStr:conditionStr
                                                  findColumn:columnStr
                                                     orderBy:orderBy
                                                        page:page
                                                    pageSize:pageSize
                                                   tableName:table];
    
     [self getDataFromDataBaseWithSQL:query success:success failed:failed];
}

- (void)findSingleDataInTable:(NSString *)table
                      WithKey:(NSString *)key
                        value:(NSString *)value
                    condition:(JFZDataBaseCondition)condition
                 conditionStr:(NSString *)conditionStr
                      orderBy:(NSString *)orderBy
                      success:(JFZDataBaseSuccessBlock)success
                       failed:(JFZDataBaseFailedBlock)failed {
    
    __block NSDictionary *data;
    __block BOOL suc;
    __block FMDatabase *dataBase;
    JCLogInfo(@"start Finding Single Data In table%@",table);
    NSString *realConditionStr = conditionStr ? conditionStr : (condition == JFZDataBaseConditionNone) ? nil : [NSString stringWithFormat:@"%@ %@ '%@'", key,[self getContidtionString:condition],value];
    NSString *query = [self createFindSqlStrWithConditionStr:realConditionStr findColumn:nil orderBy:orderBy page:0 pageSize:1 tableName:table];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        dataBase = db;
        suc = NO;
        FMResultSet *resultSet = [db executeQuery:query];
        if(!resultSet){
            return;
        }
        if([resultSet next]) {
            data = [NSDictionary dictionaryWithDictionary:[resultSet resultDictionary]];
        }
        suc = YES;
        [resultSet close];
    }];
    if(suc){
        JCLogInfo(@"Find Single Data In Table:%@ Success!",table);
        if(success){
            success(data,dataBase);
        }
    }else{
        NSError *error = [NSError errorWithDomain:[dataBase lastErrorMessage] code:[dataBase lastErrorCode] userInfo:nil];
        JCLogInfo(@"Find Single Data In Table :%@ Failed With Code:%ld,Msg:%@",table,error.code,error.domain);
        if(failed){
            failed(error);
        }
    }
}

- (NSInteger)countDataInTable:(NSString *)tableName conditionStr:(NSString *)conditionStr
{
    NSString *query = [NSString stringWithFormat:@"SELECT COUNT(*) AS number FROM %@ WHERE %@",tableName,conditionStr];
    if(![_dataBase open]){
        JCLogInfo(@"dataBase :%@ couldNot Open",self.dbName);
        return 0;
    }
    NSInteger number = 0;
    FMResultSet *result = [_dataBase executeQuery:query];
    if([result next]){
        number = [result intForColumn:@"number"];
    }
    if(!result){
        JCLogInfo(@"get number In table:%@ Failed With Code:%d,Msg:%@ ",tableName,[_dataBase lastErrorCode],[_dataBase lastErrorMessage]);
    }else{
        JCLogInfo(@"get number In table:%@ Success!",tableName);
    }
    [result close];
    [_dataBase close];
    
    return number;
    
}

#pragma mark - 自定SQL
- (void)getDataFromDataBaseWithSQL:(NSString *)sql success:(JFZDataBaseSuccessBlock)success failed:(JFZDataBaseFailedBlock)failed
{
    __block NSMutableArray *dataList = [[NSMutableArray alloc]init];
    __block BOOL suc;
    __block FMDatabase *dataBase;
    JCLogInfo(@"start Geting Data With SQL : %@",sql);
    [_dbQueue inDatabase:^(FMDatabase *db) {
        dataBase = db;
        suc = NO;
        FMResultSet *resultSet = [db executeQuery:sql];
        if(!resultSet){
            return;
        }
        
        while ([resultSet next]) {
            NSMutableDictionary *dataItem = [NSMutableDictionary dictionaryWithDictionary:[resultSet resultDictionary]];
            [dataList addObject:dataItem];
        }
        suc = YES;
        [resultSet close];
    }];
    if(suc){
        JCLogInfo(@"Succeed by Getting Data With SQL : %@ ",sql);
        if(success){
            success(dataList,dataBase);
        }
    }else{
        NSError *error = [NSError errorWithDomain:[dataBase lastErrorMessage] code:[dataBase lastErrorCode] userInfo:nil];
        JCLogInfo(@"Failed With Getting Data With SQL : %@ errorCode:%ld,msg:%@",sql,(long)error.code,error.domain);
        if(failed){
        failed(error);
        }
    }
}

- (void)runSQLInDataBase:(NSString *)sql success:(JFZDataBaseSuccessBlock)success failed:(JFZDataBaseFailedBlock)failed
{
    __block BOOL suc;
    __block FMDatabase *dataBase;

    [_dbQueue inDatabase:^(FMDatabase *db) {
        dataBase = db;
        suc = NO;
        suc = [db executeUpdate:sql];
    }];
    if(suc){

        if(success){
            success(nil,dataBase);
        }
    }else{
        NSError *error = [NSError errorWithDomain:[dataBase lastErrorMessage] code:[dataBase lastErrorCode] userInfo:nil];

        if(failed){
            failed(error);
        }
    }
}

#pragma mark - private Method
- (NSString *)createInsertSqlStrWithParam:(NSDictionary *)param tableName:(NSString *)tableName
{
//    JCLogInfo(@"creating Insert Sql In tableName :%@",tableName);
    __block NSString *keyStr = @"(";
    __block NSString *valueStr = @"(";
    [param enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        keyStr = [keyStr stringByAppendingString:[NSString stringWithFormat:@"%@ ,",key]];
        valueStr = [valueStr stringByAppendingString:[NSString stringWithFormat:@"'%@',",value]];
    }];
    keyStr = [[keyStr substringWithRange:NSMakeRange(0, keyStr.length - 1)] stringByAppendingString:@")"];
    valueStr = [[valueStr substringWithRange:NSMakeRange(0, valueStr.length - 1)] stringByAppendingString:@")"];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ %@ VALUES %@",tableName,keyStr,valueStr];
    return sql;
}

- (NSString *)createUpdateSqlStrWithParam:(NSDictionary *)param tableName:(NSString *)tableName condition:(NSString *)conditionStr
{
    __block NSString *setValueStr = @"";
    JCLogInfo(@"creating Update Sql In tableName :%@",tableName);
    [param enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        setValueStr = [setValueStr stringByAppendingString:[NSString stringWithFormat:@"'%@' = '%@' ,",key,obj]];
    }];
    setValueStr = [setValueStr substringWithRange:NSMakeRange(0, setValueStr.length - 1)];
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",tableName,setValueStr,conditionStr ? conditionStr : @"1"];
    return query;
}

- (NSString *)createFindSqlStrWithConditionStr:(NSString *)conditionStr findColumn:(NSString *)columns orderBy:(NSString *)orderBy page:(NSInteger)page pageSize:(NSInteger)pageSize tableName:(NSString *)tableName {
    JCLogInfo(@"creating Select Sql In tableName :%@",tableName);
    NSString *query = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ ",columns ? columns : @"*",tableName,conditionStr ? conditionStr : @"1"];
    if(orderBy){
        query = [query stringByAppendingFormat:@"ORDER BY %@ ",orderBy];
    }
    if (pageSize != 0) {
        NSInteger realPage = page * pageSize;
        query = [query stringByAppendingFormat:@"LIMIT %ld,%ld",realPage,pageSize];
    }
    return query;
}

- (NSString *)getContidtionString:(JFZDataBaseCondition)condition
{
    switch (condition) {
        case JFZDataBaseConditionNone:
            return nil;
        case JFZDataBaseConditionEqual:
            return @"=";
        case JFZDataBaseConditionEqualOrGreater:
            return @">=";
        case JFZDataBaseConditionEqualOrLessThan:
            return @"<=";
        case JFZDataBaseConditionGreater:
            return @">";
        case JFZDataBaseConditionLessThan:
            return @"<";
        case JFZDataBaseConditionNotEqual:
            return @"<>";
        default:
            break;
    }
}


@end
