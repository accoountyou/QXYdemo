//
//  QXYTestList.h
//  Qxueyou
//
//  Created by zhu on 15/12/7.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QXYTestList : NSObject

/// 试题名称
@property(nonatomic, copy) NSString *name;
/// 试题数
@property(nonatomic, copy) NSString *allCount;
/// 试题groupId
@property(nonatomic, copy) NSString *groupId;
/// 题型
@property(nonatomic, assign) int type;
/// 回调block
@property(nonatomic, copy) void (^relate)(NSArray *listArray);
/// userld
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *classId;
/// 字典转模型
- (void)loadTestList;

/// 类方法构造单利对象
+ (instancetype)sharedTestList;

@end
