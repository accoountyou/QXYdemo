//
//  QXYNetworkTools.m
//  Qxueyou
//
//  Created by zhu on 15/12/3.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYNetworkTools.h"
#import "SSKeychain.h"
#import "SVProgressHUD.h"

@implementation QXYNetworkTools

/// 登陆
- (void)login {
    if (self.password.length == 0 || self.username.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"账号或密码不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"http://tt.iqtogether.com/qxueyou/sys/login/login/%@",self.username];
    NSDictionary *parameters = @{@"password": self.password, @"callback": @"callback"};
    NSLog(@"%@",urlString);
    NSLog(@"%@",parameters);
    self.afnManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.afnManager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        // 保存用户信息
        [self saveUserInfo];
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:QXYLoginSuccessNotification object:@"LoginSuccess"];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        [SVProgressHUD showErrorWithStatus:@"您输入的账户密码不正确,请重新输入" maskType:SVProgressHUDMaskTypeBlack];
    }];
}

/// 类方法构造单利对象
+ (instancetype)sharedTools {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self loadUserInfo];
        self.afnManager = [[AFHTTPRequestOperationManager alloc] init];
    }
    return self;
}

#pragma mark - 加载和保护用户信息
#define QXYUsernameKey @"QXYUsernameKey"

/**
 *  保存用户登陆信息
 */
- (void)saveUserInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.username forKey:QXYUsernameKey];
    NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
    [SSKeychain setPassword:self.password forService:bundleId account:self.username];
}

/**
 *  加载用户登陆信息
 */
- (void)loadUserInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.username = [defaults valueForKey:QXYUsernameKey];
    NSString *boundleId = [NSBundle mainBundle].bundleIdentifier;
    self.password = [SSKeychain passwordForService:boundleId account:self.username];
}

@end
