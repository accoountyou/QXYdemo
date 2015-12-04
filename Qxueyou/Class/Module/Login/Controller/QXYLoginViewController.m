//
//  QXYLoginViewController.m
//  Qxueyou
//
//  Created by zhu on 15/12/3.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYLoginViewController.h"
#import "QXYNetworkTools.h"

@interface QXYLoginViewController ()<UITextFieldDelegate>

/// 账号
@property (nonatomic, strong) UITextField *nameField;
/// 密码
@property (nonatomic, strong) UITextField *passField;
/// 登陆
@property (nonatomic, strong) UIButton *loginButton;
/// 忘记密码
@property (nonatomic, strong) UIButton *forgetPassword;
/// 注册
@property (nonatomic, strong) UIButton *registered;
/// 游客
@property (nonatomic, strong) UIButton *visitor;

@end

@implementation QXYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareUI];
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.title = @"登陆";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(clickBackButton)];
    
    self.nameField.delegate = self;
    self.passField.delegate = self;
    [self loadUserInfo];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.nameField == textField) {
        [self.passField becomeFirstResponder];
    } else {
        [self clickLoginButton];
    }
    return YES;
}


- (void)clickBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 准备界面
- (void)prepareUI {
    [self.view addSubview:self.nameField];
    [self.view addSubview:self.passField];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.forgetPassword];
    [self.view addSubview:self.registered];
    [self.view addSubview:self.visitor];
    
    self.nameField.translatesAutoresizingMaskIntoConstraints = NO;
    self.passField.translatesAutoresizingMaskIntoConstraints = NO;
    self.loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.forgetPassword.translatesAutoresizingMaskIntoConstraints = NO;
    self.registered.translatesAutoresizingMaskIntoConstraints = NO;
    self.visitor.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nameField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nameField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:64]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nameField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nameField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.passField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.passField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.nameField attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.passField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.passField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.passField attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.forgetPassword attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.forgetPassword attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.loginButton attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.registered attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:15]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.registered attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.visitor attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-15]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.visitor attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-10]];
    
}

#pragma mark - 保存和加载用户信息
- (void)loadUserInfo{
    // 从单列中获取用户信息
    QXYNetworkTools *tools = [QXYNetworkTools sharedTools];
    self.nameField.text = tools.username;
    self.passField.text = tools.password;
}


#pragma mark - 按钮点击事件
/**
 *  登陆
 */
- (void)clickLoginButton {
    QXYNetworkTools *tool = [QXYNetworkTools sharedTools];
    tool.username = self.nameField.text;
    tool.password = self.passField.text;
    [tool login];
}

/**
 *  忘记密码
 */
- (void)clickForgetPasswordButton {
    
}
/**
 *  立即注册
 */
- (void)clickRegisteredButton {
    
}
/**
 *  游客
 */
- (void)clickVisitorButton {
    
}

#pragma mark - 懒加载
- (UITextField *)nameField {
    if (_nameField == nil) {
        _nameField = [[UITextField alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        label.text = @"手机号:";
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        _nameField.clearButtonMode = UITextFieldViewModeAlways;
        _nameField.leftView = label;
        _nameField.leftViewMode = UITextFieldViewModeAlways;
        _nameField.backgroundColor = [UIColor cyanColor];
    }
    return _nameField;
}

- (UITextField *)passField {
    if (_passField == nil) {
        _passField = [[UITextField alloc] init];
        [_passField setSecureTextEntry:YES];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        label.text = @"密    码:";
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        _passField.clearButtonMode = UITextFieldViewModeAlways;
        _passField.leftView = label;
        _passField.leftViewMode = UITextFieldViewModeAlways;
        _passField.backgroundColor = [UIColor cyanColor];
    }
    return _passField;
}

- (UIButton *)loginButton {
    if (_loginButton == nil) {
        _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
        [_loginButton setBackgroundColor:[UIColor blueColor]];
        [_loginButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_loginButton addTarget:self action:@selector(clickLoginButton) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.layer.cornerRadius = 8;
        _loginButton.layer.masksToBounds = YES;
    }
    return _loginButton;
}

- (UIButton *)forgetPassword {
    if (_forgetPassword == nil) {
        _forgetPassword = [[UIButton alloc] init];
        [_forgetPassword sizeToFit];
        [_forgetPassword setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetPassword setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_forgetPassword.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_forgetPassword addTarget:self action:@selector(clickForgetPasswordButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPassword;
}

- (UIButton *)registered {
    if (_registered == nil) {
        _registered = [[UIButton alloc] init];
        [_registered sizeToFit];
        [_registered setTitle:@"立即注册" forState:UIControlStateNormal];
        [_registered setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_registered.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_registered addTarget:self action:@selector(clickRegisteredButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registered;
}

- (UIButton *)visitor {
    if (_visitor == nil) {
        _visitor = [[UIButton alloc] init];
        [_visitor sizeToFit];
        [_visitor setTitle:@"游客浏览" forState:UIControlStateNormal];
        [_visitor setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_visitor.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_visitor addTarget:self action:@selector(clickVisitorButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _visitor;
}

@end
