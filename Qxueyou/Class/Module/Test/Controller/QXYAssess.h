//
//  QXYAssess.h
//  Qxueyou
//
//  Created by zhu on 15/12/9.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QXYAssess : UIViewController

/// 总共多少题
@property(nonatomic, assign) NSInteger itemNum;
/// 答案数组
@property(nonatomic, strong) NSArray *array;

@end
