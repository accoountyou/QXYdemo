//
//  QXYNetworkTools.m
//  Qxueyou
//
//  Created by zhu on 15/12/3.
//  Copyright © 2015年 zhu. All rights reserved.
//

//NSString *urlString = @"http://tt.iqtogether.com/qxueyou/exercise/Exercise/examsList";

#import "QXYNetworkTools.h"
#import "SSKeychain.h"
#import "SVProgressHUD.h"
#import "CDLJSONPResponseSerializer.h"
#import "QXYFmdbTools.h"
#import <JSONKit/JSONKit.h>

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
//        NSLog(@"error:%@",error);
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
        [SVProgressHUD showErrorWithStatus:@"网络加载出错" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }];
}

/**
 *  加载试题的方法
 */
- (void)loadTestWithGroupId:(NSString *)groupId finished:(void (^)(id success))finished fail:(void (^)(NSError *error))fail {
    NSString *urlString = [NSString stringWithFormat:@"http://tt.iqtogether.com/qxueyou/exercise/Exercise/examsExerList/%@",groupId];
    NSDictionary *parameters = @{@"exerciseRecordId": @"", @"exerciseGroupId": groupId, @"updateTime": @"", @"callback": @"callback"};
    //数据库查询updateTime
    NSString *key = [NSString stringWithFormat:@"%@%@", urlString,[parameters JSONString]];
    NSDictionary *jsonDic = [QXYFmdbTools queryUpdateTimeWithKey:key];
    NSString *timeStr = jsonDic[@"updateTime"];
    if (!timeStr) {
        timeStr = @"";
    }
    NSDictionary *parametersUrl = @{@"exerciseRecordId": @"", @"exerciseGroupId": groupId, @"updateTime": timeStr, @"callback": @"callback"};
    [self requestWithGetUrl:urlString parameters:parametersUrl finished:^(id success) {
        //返回的数据中取出updateTime
        NSString *updateTimeS = @"";
        if (((NSArray *)success).count) {
            long time = [[success firstObject][@"updateTime"] longValue];
            updateTimeS = [self getDateFormatterWithTime:time];
            //存储数据
            if ([NSJSONSerialization isValidJSONObject:success])
            {
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:success options:NSJSONWritingPrettyPrinted error:&error];
                NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [QXYFmdbTools insertData:key json:json withUpdateTime:updateTimeS];
            }
            finished(success);
        }else{
            NSString *jsonStr = jsonDic[@"json"];
            NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            id response = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            finished(response);
            
        }
    } fail:^(NSError *error) {
        // 离线缓存
        NSString *oldData = [QXYFmdbTools queryData:key];
        if (!oldData) {
            [SVProgressHUD showErrorWithStatus:@"网络加载出错" maskType:SVProgressHUDMaskTypeBlack];
            return;
        }
        NSData *jsonData = [oldData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        id response = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        finished(response);
    }];
}

/**
 *  提交试题答案
 */
- (void)assignmentWithAnswerArray:(NSArray *)answerArray finished:(void (^)(id success))finished fail:(void (^)(NSError *error))fail {
    NSString *urlString = @"http://tt.iqtogether.com/qxueyou/exercise/Exercise/submitExerAnswers";
    NSDictionary *keyParameters = @{@"answerResults": answerArray};
    NSData *keyData = [NSJSONSerialization dataWithJSONObject:keyParameters options:0 error:nil];
    NSString *keyParametersString = [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{@"answers": keyParametersString, @"callback": @"callback"};
//    NSLog(@"%@",parameters);
    [self requestWithGetUrl:urlString parameters:parameters finished:^(id success) {
        //向数据库中插入exerciseRecordId
//        NSLog(@"success:%@",success);
        // 再次请求加载试题
        finished(success);
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络加载出错" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }];
}

/**
 *  请求评论列表
 */
- (void)assessWithUid:(NSString *)uid finished:(void (^)(id success))finished fail:(void (^)(NSError *error))fail {
    NSString *urlString = @"http://tt.iqtogether.com/qxueyou/comment/Comment/commentList";
    NSDictionary *parameters = @{@"commentObjectUid": uid, @"commentObjectType": @"2", @"page": @"1", @"limit": @"10000", @"start": @"0", @"callback": @"callback"};
    [self requestWithGetUrl:urlString parameters:parameters finished:^(id success) {
//        NSLog(@"success:%@",success);
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络加载出错" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }];
}

/**
 *  提交评论
 */
- (void)commitWithUid:(NSString *)uid andContent:(NSString *)content finished:(void (^)(id success))finished fail:(void (^)(NSError *error))fail {
    NSString *urlString = @"http://tt.iqtogether.com/qxueyou/comment/Comment/submitData";
    NSDictionary *parameters = @{@"objectId": uid, @"type": @"2", @"content":content, @"callback": @"callback"};
    [self requestWithGetUrl:urlString parameters:parameters finished:^(id success) {
//        NSLog(@"success:%@",success);
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark - 封装网络请求的方法
- (void)requestWithGetUrl:(NSString *)urlString parameters:(NSDictionary *)parameters finished:(void (^)(id success))finished fail:(void (^)(NSError *error))fail {
    NSString *callback = @"callback";
    NSString *key = [NSString stringWithFormat:@"%@%@", urlString,[parameters JSONString]];
    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlString parameters:parameters];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [CDLJSONPResponseSerializer serializerWithCallback:callback];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([(NSDictionary *)responseObject objectForKey:@"msg"] || [(NSDictionary *)responseObject objectForKey:@"commentPraiseCount"]) {
                finished(responseObject);
                return ;
            }
        }
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (!((NSArray *)responseObject).count) {
                finished(responseObject);
                return;
            }
        }
        if ([NSJSONSerialization isValidJSONObject:responseObject])
        {
            
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
            NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [QXYFmdbTools insertData:key json:json];
        }
        finished(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 离线缓存
        NSString *jsonStr = [QXYFmdbTools queryData:key];
        
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        if (!jsonData) {
            fail(error);
            return;
        }
        NSError *err;
        id response = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        finished(response);
    }];
    [[NSOperationQueue mainQueue] addOperation:operation];
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
