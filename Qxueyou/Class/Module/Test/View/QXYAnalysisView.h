//
//  QXYAnalysisView.h
//  Qxueyou
//
//  Created by zhu on 15/12/8.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QXYTest.h"

@interface QXYAnalysisView : UIView

/// 答案模型
@property(nonatomic, strong) QXYTest *test;
/// 自己做单的字典
@property(nonatomic, strong) NSDictionary *answerDict;

/// 回调block
@property(nonatomic, copy) void (^viewHight)(CGFloat hight);

@end
