//
//  QXYVisitorView.m
//  Qxueyou
//
//  Created by zhu on 15/12/3.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYVisitorView.h"

@interface QXYVisitorView ()

/// 转盘
@property(nonatomic, strong) UIImageView *iconView;
/// 房子
@property(nonatomic, strong) UIImageView *houseView;
/// 文字label
@property(nonatomic, strong) UILabel *textLabel;
/// 注册按钮
@property(nonatomic, strong) UIButton *registerButton;
/// 登录按钮
@property(nonatomic, strong) UIButton *loginButton;
/// 遮盖
@property(nonatomic, strong) UIImageView *coverView;

@end

@implementation QXYVisitorView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupVistorView];
    };
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupVistorView];
    }
    return self;
}

#pragma mark - 提供给外界的方法

/// 给外界提供方法修改界面的视图
- (void)changeVistorViewWithImageName:(NSString *)imageName title:(NSString *)title {
    self.iconView.hidden = YES;
    self.houseView.image = [UIImage imageNamed:imageName];
    self.textLabel.text = title;
    [self sendSubviewToBack:self.coverView];
}

/// 旋转图片的动画
- (void)startRotationAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration = 20;
    animation.repeatCount = MAXFLOAT;
    animation.toValue = @(2 * M_PI);
    // 动画执行完毕后不移除,系统默认会移除
    animation.removedOnCompletion = NO;
    // key表示这个动画的名字
    [self.iconView.layer addAnimation:animation forKey:@"iconViewAnimation"];
}

/// 暂停动画
- (void)pauseAnimation {
    // 记录暂停时间
    CFTimeInterval pauseTime = [self.iconView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 设置动画速度为0
    self.iconView.layer.speed = 0;
    // 设置动画偏移时间
    self.iconView.layer.timeOffset = pauseTime;
}

/// 开始动画
- (void)startAnimation {
    // 获取暂停时间
    CFTimeInterval pauseTime = self.iconView.layer.timeOffset;
    // 设置动画速度为1
    self.iconView.layer.speed = 1;
    self.iconView.layer.timeOffset = 0;
    self.iconView.layer.beginTime = 0;
    CFTimeInterval timeSincePause = [self.iconView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
    self.iconView.layer.beginTime = timeSincePause;
}

#pragma mark - 设置控件

/// 设置欢迎视图
- (void)setupVistorView {
    // 设置灰灰的背景色
    self.backgroundColor = [UIColor colorWithWhite:237.0 / 255 alpha:1];
    // 添加子控件
    [self addSubview:self.iconView];
    [self addSubview:self.coverView];
    [self addSubview:self.houseView];
    [self addSubview:self.textLabel];
    [self addSubview:self.registerButton];
    [self addSubview:self.loginButton];
    // 取消Autoresizing对约束造成影响
    self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    self.coverView.translatesAutoresizingMaskIntoConstraints = NO;
    self.houseView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.registerButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    // 设置约束
    // 转盘
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    // 房子
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.houseView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.iconView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.houseView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.iconView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    // 文字
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.iconView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.iconView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:240]];
    // 注册按钮
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.registerButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.registerButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:16]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.registerButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.registerButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:35]];
    // 登录按钮
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:16]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:35]];
    // 覆盖
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.coverView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.coverView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.registerButton attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[ios]-0-|" options:NSLayoutFormatAlignmentMask metrics:nil views:@{@"ios" : self.coverView}]];
    
}

#pragma mark - 按钮的点击事件

- (void)clickRegisterButton {
    if ([self.delegate respondsToSelector:@selector(clickVistorViewRegisterButton)]) {
        [self.delegate clickVistorViewRegisterButton];
    }
}

- (void)clickLoginButton {
    if ([self.delegate respondsToSelector:@selector(clickVistorViewLoginButton)]) {
        [self.delegate clickVistorViewLoginButton];
    }
}

#pragma mark - 懒加载各个控件

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visitordiscover_feed_image_smallicon"]];
        [_iconView sizeToFit];
    }
    return _iconView;
}

- (UIImageView *)houseView {
    if (!_houseView) {
        _houseView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visitordiscover_feed_image_house"]];
        [_houseView sizeToFit];
    }
    return _houseView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"登录后,您可以随心所欲的做题";
        _textLabel.numberOfLines = 0;
        [_textLabel sizeToFit];
    }
    return _textLabel;
}

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [[UIButton alloc] init];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_registerButton setBackgroundImage:[UIImage imageNamed:@"common_button_white_disable"] forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(clickRegisterButton) forControlEvents:UIControlEventTouchUpInside];
        [_registerButton sizeToFit];
    }
    return _registerButton;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] init];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"common_button_white_disable"] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(clickLoginButton) forControlEvents:UIControlEventTouchUpInside];
        [_loginButton sizeToFit];
    }
    return _loginButton;
}

- (UIImageView *)coverView {
    if (!_coverView) {
        _coverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visitordiscover_feed_mask_smallicon"]];
    }
    return _coverView;
}

@end
