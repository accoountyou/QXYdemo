//
//  QXYTest.m
//  Qxueyou
//
//  Created by zhu on 15/12/7.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYTest.h"
#import "QXYNetworkTools.h"
#import "SVProgressHUD.h"

@implementation QXYTest

/// 类方法构造单利对象
+ (instancetype)sharedTest {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - 字典转模型
- (void)loadTestWithGroupId:(NSString *)groupId {
    [SVProgressHUD showWithStatus:@"正在努力加载" maskType:SVProgressHUDMaskTypeBlack];
    QXYNetworkTools *tools = [QXYNetworkTools sharedTools];
    NSMutableArray *Marray = [NSMutableArray array];
    [tools loadTestWithGroupId:groupId finished:^(id success) {
        for (NSDictionary *dict in success) {
            QXYTest *listModel = [[QXYTest alloc] init];
            [listModel setValuesForKeysWithDictionary:dict];
            [Marray addObject:listModel];
        }
        [SVProgressHUD dismiss];
        self.relate(Marray);
    } fail:^(NSError *error) {
//        NSLog(@"%@",error);
    }];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

/**
 *  整型的时间转化成时间字符串
 */
- (NSString *)getDateFormatterWithTime:(long)time {
    NSDate *newTime = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:newTime];
}

@end
