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
    // 沙盒目录
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    // 文件路径
    NSString *filename = [path stringByAppendingPathComponent:[groupId stringByAppendingString:@".plist"]];
    // 读取文件
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:filename];
    // 模型数组
    NSMutableArray *Marray = [NSMutableArray array];
    
    if (array) {
        for (NSDictionary *dict in array) {
            QXYTest *listModel = [[QXYTest alloc] init];
            [listModel setValuesForKeysWithDictionary:dict];
            [Marray addObject:listModel];
        }
        self.relate(Marray);
        return;
    }
    [SVProgressHUD showWithStatus:@"正在努力加载" maskType:SVProgressHUDMaskTypeBlack];
    QXYNetworkTools *tools = [QXYNetworkTools sharedTools];
    [tools loadTestWithGroupId:groupId finished:^(id success) {
        for (NSDictionary *dict in success) {
            QXYTest *listModel = [[QXYTest alloc] init];
            [listModel setValuesForKeysWithDictionary:dict];
            [Marray addObject:listModel];
        }
        [SVProgressHUD dismiss];
        self.relate(Marray);
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


@end
