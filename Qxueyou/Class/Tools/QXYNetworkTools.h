//
//  QXYNetworkTools.h
//  Qxueyou
//
//  Created by zhu on 15/12/3.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

// 登录成功通知
#define QXYLoginSuccessNotification @"QXYLoginSuccessNotification"

@interface QXYNetworkTools : NSObject

/// 用户名
@property(nonatomic, copy) NSString *username;

/// 密码
@property(nonatomic, copy) NSString *password;

/// 登陆
- (void)login;

/**
 *  加载试题列表的方法
 */
- (void)loadTestListFinished:(void (^)(id success))finished fail:(void (^)(NSError *error))fail;

/**
 *  加载试题的方法
 */
- (void)loadTestWithGroupId:(NSString *)groupId finished:(void (^)(id success))finished fail:(void (^)(NSError *error))fail;

/**
 *  提交试题答案
 */
- (void)assignmentWithAnswerArray:(NSArray *)answerArray finished:(void (^)(id success))finished fail:(void (^)(NSError *error))fail;

/**
 *  请求评论列表
 */
- (void)assessWithUid:(NSString *)uid finished:(void (^)(id success))finished fail:(void (^)(NSError *error))fail;

/**
 *  提交评论
 */
- (void)commitWithUid:(NSString *)uid andContent:(NSString *)content finished:(void (^)(id success))finished fail:(void (^)(NSError *error))fail;

/// 类方法构造单利对象
+ (instancetype)sharedTools;

@end
