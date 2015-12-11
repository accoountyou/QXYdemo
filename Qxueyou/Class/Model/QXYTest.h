//
//  QXYTest.h
//  Qxueyou
//
//  Created by zhu on 15/12/7.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QXYTest : NSObject

/// 题目
@property(nonatomic, copy) NSString *title;
/// 选项
@property(nonatomic, strong) NSArray *options;
/// 题型
@property(nonatomic, assign) int type;
/// 题目Id
@property(nonatomic, copy) NSString *exerciseId;
/// exerciseGroupId
@property(nonatomic, copy) NSString  *exerciseGroupId;

/// 正确答案
@property(nonatomic, copy) NSDictionary *analisisResult;

@property(nonatomic,copy)NSString * correctAnswers;
@property(nonatomic,copy)NSString * answerU;
@property(nonatomic,copy)NSString * analysis;
@property(nonatomic,copy)NSString * submitNumber;
@property(nonatomic,copy)NSString * submitErrorNumber;
@property(nonatomic,copy)NSString * accuracy;
@property(nonatomic,copy)NSString * submitAllNumber;
@property(nonatomic,copy)NSString * allAccuracy;

/// 回调block
@property(nonatomic, copy) void (^relate)(NSArray *listArray);

#pragma mark - 字典转模型
- (void)loadTestWithGroupId:(NSString *)groupId;

/// 类方法构造单利对象
+ (instancetype)sharedTest;

@end
