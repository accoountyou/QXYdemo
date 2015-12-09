//
//  QXYFmdbTools.m
//  Qxueyou
//
//  Created by zhu on 15/12/9.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYFmdbTools.h"
#import "FMDB.h"

@implementation QXYFmdbTools

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

/// 创建数据库并返回数据库
+ (FMDatabase *)createDB {
    NSString *FMDBPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/FMDB.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:FMDBPath];
    
    if (![self isExistFile:FMDBPath]) {
        if ([db open]) {
            NSString *sqlCreateTable = @"CREATE TABLE CACHES (URL TEXT PRIMARY KEY, JSON TEXT)";
            BOOL res = [db executeUpdate:sqlCreateTable];
            NSString *sqlCreateTable2 = @"CREATE TABLE  MSG (ID INTEGER PRIMARY KEY AUTOINCREMENT, DATE TEXT, MSG TEXT, MARK BOOLEAN)";
            BOOL res2 = [db executeUpdate:sqlCreateTable2];
            if (!res || !res2) {
                NSLog(@"error when creating db table");
            } else {
                NSLog(@"success to creating db table");
            }
            [db close];
        }
    }
    return db;
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
