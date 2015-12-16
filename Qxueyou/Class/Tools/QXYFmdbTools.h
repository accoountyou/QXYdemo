//
//  QXYFmdbTools.h
//  Qxueyou
//
//  Created by zhu on 15/12/9.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface QXYFmdbTools : NSObject

#pragma mark - FMDB
+ (FMDatabase *)createDB ;
+ (void)insertData:(NSString *)key json:(NSString *)json;
+ (void)insertData:(NSString *)key json:(NSString *)json withUpdateTime:(NSString *)updateTime;
+ (NSString *)queryData:(NSString *)key;
+ (NSDictionary *)queryUpdateTimeWithKey:(NSString *)key;
//+ (void)changeRecordIdWithKey:(NSString *)key andRecordId:(NSString *)recordId;
@end
