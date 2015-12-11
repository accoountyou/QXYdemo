//
//  QXYFmdbTools.m
//  Qxueyou
//
//  Created by zhu on 15/12/9.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYFmdbTools.h"

@implementation QXYFmdbTools

/// 创建数据库并返回数据库
+ (FMDatabase *)createDB {
    NSString *FMDBPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/QXYTest.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:FMDBPath];
    
    if (![self isExistFile:FMDBPath]) {
        if ([db open]) {
            NSString *sqlCreateTable = @"CREATE TABLE CACHES (URL TEXT PRIMARY KEY, JSON TEXT)";
            BOOL res = [db executeUpdate:sqlCreateTable];
            
            NSString *sqlCreateTableTest = @"CREATE TABLE TEST (URL TEXT PRIMARY KEY, JSON TEXT, UPDATETIME TEXT)";
            BOOL resTest = [db executeUpdate:sqlCreateTableTest];
            
            if (!res || !resTest) {
                NSLog(@"error when creating db table");
            } else {
                NSLog(@"success to creating db table");
            }
            [db close];
        }
    }
    return db;
}


+ (void)insertData:(NSString *)key json:(NSString *)json{
    FMDatabase *db = [self createDB];
    if ([db open]) {
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT OR REPLACE INTO CACHES (URL, JSON) VALUES ('%@', '%@')",
                               key, json];
        BOOL res = [db executeUpdate:insertSql1];
        
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        [db close];
    }
}

+ (void)insertData:(NSString *)key json:(NSString *)json withUpdateTime:(NSString *)updateTime {
    FMDatabase *db = [self createDB];
    if ([db open]) {
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT OR REPLACE INTO TEST (URL, JSON ,UPDATETIME) VALUES ('%@', '%@','%@')",
                               key, json,updateTime];
        BOOL res = [db executeUpdate:insertSql1];
        
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        [db close];
    }
}

+ (NSDictionary *)queryUpdateTimeWithKey:(NSString *)key{
    FMDatabase *db = [self createDB];
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
    if ([db open]) {
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM TEST WHERE URL = '%@'", key];
        FMResultSet * rs = [db executeQuery:querySql];
        while ([rs next]) {
            //NSString * key = [rs stringForColumn:@"URL"];
            
            [jsonDic setObject:[rs stringForColumn:@"UPDATETIME"] forKey:@"updateTime"];
            [jsonDic setObject:[rs stringForColumn:@"JSON"] forKey:@"json"];
            
            //NSLog(@"id = %@, address = %@", key, json);
        }
        [db close];
    }
    
    return jsonDic;
}
+ (NSString *)queryData:(NSString *)key{
    FMDatabase *db = [self createDB];
    NSString * json = nil;
    if ([db open]) {
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM CACHES WHERE URL = '%@'", key];
        FMResultSet * rs = [db executeQuery:querySql];
        while ([rs next]) {
            //NSString * key = [rs stringForColumn:@"URL"];
            json = [rs stringForColumn:@"JSON"];
            //NSLog(@"id = %@, address = %@", key, json);
        }
        [db close];
    }
    
    return json;
}
/**
 *  判断文件路径是否有效
 *
 *  @param fileName 路径
 *
 *  @return bool
 */
+ (BOOL)isExistFile:(NSString *)fileName{
    return [[NSFileManager defaultManager] fileExistsAtPath:fileName];
}

@end
