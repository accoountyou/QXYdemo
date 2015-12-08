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
#import "CDLJSONPResponseSerializer.h"

@implementation QXYNetworkTools

/// 登陆
- (void)login {
    if (self.password.length == 0 || self.username.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"账号或密码不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"http://tt.iqtogether.com/qxueyou/sys/login/login/%@",self.username];
    NSDictionary *parameters = @{@"password": self.password, @"callback": @"callback"};
    [self requestWithGetUrl:urlString parameters:parameters finished:^(id success) {
        if ([success[@"userType"] integerValue] > 0) {
            // 保存用户信息
            [self saveUserInfo];
            // 发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:QXYLoginSuccessNotification object:@"LoginSuccess"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"您输入的账户密码不正确,请重新输入" maskType:SVProgressHUDMaskTypeBlack];
            [[NSNotificationCenter defaultCenter] postNotificationName:QXYLoginSuccessNotification object:@"LoginFail"];
        }
    } fail:^(NSError *error) {
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"您输入的账户密码不正确,请重新输入" maskType:SVProgressHUDMaskTypeBlack];
        [[NSNotificationCenter defaultCenter] postNotificationName:QXYLoginSuccessNotification object:@"LoginFail"];
        
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
    }
    return self;
}

#pragma mark - 网络请求的各种方法
/**
 *  加载试题列表的方法
 */
- (void)loadTestListFinished:(void (^)(id success))finished fail:(void (^)(NSError *error))fail {
    NSString *urlString = @"http://tt.iqtogether.com/qxueyou/exercise/Exercise/examsList";
    NSDictionary *parameters = @{@"records": @"", @"callback": @"callback"};
    [self requestWithGetUrl:urlString parameters:parameters finished:^(id success) {
        finished(success);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

/**
 *  加载试题的方法
 */
- (void)loadTestWithGroupId:(NSString *)groupId finished:(void (^)(id success))finished fail:(void (^)(NSError *error))fail {
    NSString *urlString = [NSString stringWithFormat:@"http://tt.iqtogether.com/qxueyou/exercise/Exercise/examsExerList/%@",groupId];
    NSDictionary *parameters = @{@"exerciseRecordId": @"", @"exerciseGroupId": groupId, @"updateTime": @"", @"callback": @"callback"};
    [self requestWithGetUrl:urlString parameters:parameters finished:^(id success) {
        finished(success);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

#pragma mark - 封装网络请求的方法
- (void)requestWithGetUrl:(NSString *)urlString parameters:(NSDictionary *)parameters finished:(void (^)(id success))finished fail:(void (^)(NSError *error))fail {
    NSString *callback = @"callback";
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlString parameters:parameters];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [CDLJSONPResponseSerializer serializerWithCallback:callback];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        finished(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
    [[NSOperationQueue mainQueue] addOperation:operation];
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
