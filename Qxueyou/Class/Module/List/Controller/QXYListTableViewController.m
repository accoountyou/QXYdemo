//
//  QXYListTableViewController.m
//  Qxueyou
//
//  Created by 熊德庆 on 15/12/4.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYListTableViewController.h"
#import "QXYNetworkTools.h"
#import "QXYListTableViewCell.h"
#import "QXYTestViewController.h"
#import "QXYListButton.h"

@interface QXYListTableViewController ()

@end

@implementation QXYListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self.tableView registerClass:[QXYListTableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 设置导航栏
- (void)setupNavigationBar {
    self.title = @"模拟考试";
    QXYListButton *leftButton = [QXYListButton listButtonWithTitleName:@"返回" andImageName:@"左"];
    [leftButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    // 加个弹簧
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    // 设置leftButton与左边界面的距离
    negativeSpacer.width = - 10;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, barItem, nil];
}


- (void)clickCancelButton {
    // 利用通知注销  显示登录界面
    [[NSNotificationCenter defaultCenter] postNotificationName:QXYLoginSuccessNotification object:@"Cancel"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[[QXYTestViewController alloc] init] animated:YES];
}


@end
