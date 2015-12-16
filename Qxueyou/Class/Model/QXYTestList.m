//
//  QXYTestList.m
//  Qxueyou
//
//  Created by zhu on 15/12/7.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYTestList.h"
#import "QXYNetworkTools.h"
#import "SVProgressHUD.h"

@implementation QXYTestList

/// 类方法构造单利对象
+ (instancetype)sharedTestList {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - 字典转模型
- (void)loadTestList {
    [SVProgressHUD showWithStatus:@"正在努力加载" maskType:SVProgressHUDMaskTypeBlack];
    QXYNetworkTools *tools = [QXYNetworkTools sharedTools];
    NSMutableArray *Marray = [NSMutableArray array];
    [tools loadTestListFinished:^(id success) {
//        NSArray *successArray = (NSArray *)success;
        for (NSDictionary *dict in success) {
            QXYTestList *listModel = [[QXYTestList alloc] init];
            [listModel setValuesForKeysWithDictionary:dict];
            [Marray addObject:listModel];
        }
        [SVProgressHUD dismiss];
        self.relate(Marray);
    } fail:^(NSError *error) {
//        NSLog(@"error");
    }];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


@end
