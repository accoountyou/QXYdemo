//
//  QXYVisitorView.h
//  Qxueyou
//
//  Created by zhu on 15/12/3.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QXYVisitorViewDelegate <NSObject>

- (void)clickVistorViewRegisterButton;

- (void)clickVistorViewLoginButton;

@end

@interface QXYVisitorView : UIView

@property (nonatomic, weak) id<QXYVisitorViewDelegate> delegate;

/// 给外界提供方法修改界面的视图
- (void)changeVistorViewWithImageName:(NSString *)imageName title:(NSString *)title;

/// 旋转图片的动画
- (void)startRotationAnimation;

/// 暂停动画
- (void)pauseAnimation;

/// 开始动画
- (void)startAnimation;

@end
