//
//  QXYTestQuestion.h
//  Qxueyou
//
//  Created by zhu on 15/12/7.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QXYTest.h"
#import "QXYAnalysisView.h"

@protocol QXYTestQuestionDelegate <NSObject>

//写入或删除自己的答案
- (void)writeMyAnswerWithTest:(QXYTest *)test andRow:(NSInteger)row;
- (void)removeMyAnswerWithTest:(QXYTest *)test andRow:(NSInteger)row;

@end

@interface QXYTestQuestion : UIView

@property(nonatomic, strong) QXYAnalysisView *analysisView;

@property (nonatomic ,strong) NSDictionary *answerDic;

@property(nonatomic, strong) QXYTest *test;

/// 回调block
@property(nonatomic, copy) void (^viewHight)(CGFloat hight);

@property(nonatomic, strong) id<QXYTestQuestionDelegate> delegate;

@end
