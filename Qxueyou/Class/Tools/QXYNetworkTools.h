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

/// baseUrl
@property(nonatomic, strong)AFHTTPRequestOperationManager *afnManager;

/// 用户名
@property(nonatomic, copy) NSString *username;

/// 密码
@property(nonatomic, copy) NSString *password;

/// 登陆
- (void)login;

/// 类方法构造单利对象
+ (instancetype)sharedTools;

@end
