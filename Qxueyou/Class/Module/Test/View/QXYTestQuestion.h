//
//  QXYTestQuestion.h
//  Qxueyou
//
//  Created by zhu on 15/12/7.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QXYTest.h"

@interface QXYTestQuestion : UIView


@property(nonatomic, strong) QXYTest *test;

/// 回调block
@property(nonatomic, copy) void (^viewHight)(CGFloat hight);

@end
