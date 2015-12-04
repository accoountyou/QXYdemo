//
//  QXYBaseTableViewController.m
//  Qxueyou
//
//  Created by zhu on 15/12/3.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYBaseTableViewController.h"
#import "QXYVisitorView.h"
#import "QXYLoginViewController.h"

@interface QXYBaseTableViewController () <QXYVisitorViewDelegate>

/// 视图
@property(nonatomic, strong) QXYVisitorView *visitorView;

@end

@implementation QXYBaseTableViewController

- (void)loadView {
//    [super loadView];
    [self prepareUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *  跳转到登录界面
 */
- (void)prepareUI {
    self.view = self.visitorView;
    self.visitorView.delegate = self;
    [self.visitorView startRotationAnimation];
    // 注册通知监听程序在前台还是后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - 实现代理方法
- (void)clickVistorViewLoginButton {
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[QXYLoginViewController alloc] init]] animated:YES completion:nil];
}

- (void)clickVistorViewRegisterButton {
    
}

#pragma mark - 通知的方法
- (void)didEnterBackground {
    // 也可以强转view的类型
    [self.visitorView pauseAnimation];
}

- (void)didBecomeActive {
    [self.visitorView startAnimation];
}

/// 移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

#pragma mark - 懒加载
- (QXYVisitorView *)visitorView {
    if (_visitorView == nil) {
        _visitorView = [[QXYVisitorView alloc] init];
    }
    return _visitorView;
}

@end
