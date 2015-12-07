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


//- (void)loadTestList {
//    [SVProgressHUD showWithStatus:@"正在努力加载" maskType:SVProgressHUDMaskTypeBlack];
//    QXYNetworkTools *tools = [QXYNetworkTools sharedTools];
//    NSMutableArray *Marray = [NSMutableArray array];
//    [tools loadTestListFinished:^(id success) {
//        for (NSDictionary *dict in success) {
//            QXYTest *listModel = [[QXYTest alloc] init];
//            [listModel setValuesForKeysWithDictionary:dict];
//            [Marray addObject:listModel];
//        }
//        [SVProgressHUD dismiss];
//    } fail:^(NSError *error) {
//        NSLog(@"error");
//    }];
//}

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
    QXYNetworkTools *tools = [QXYNetworkTools sharedTools];
    [tools loadTestWithGroupId:groupId finished:^(id success) {
//        NSLog(@"%@",success);
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
