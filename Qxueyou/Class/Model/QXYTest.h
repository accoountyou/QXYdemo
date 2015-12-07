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
@property(nonatomic, copy) NSString *type;
/// 

#pragma mark - 字典转模型
- (void)loadTestWithGroupId:(NSString *)groupId;

/// 类方法构造单利对象
+ (instancetype)sharedTest;

@end
