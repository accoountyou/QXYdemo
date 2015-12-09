//
//  QXYAssess.m
//  Qxueyou
//
//  Created by zhu on 15/12/9.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYAssess.h"
#import "QXYListButton.h"

@interface QXYAssess ()

@end

@implementation QXYAssess

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBar];
}

#pragma mark - 设置导航栏
- (void)setupNavigationBar {
    self.title = @"学友分析";
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
    [self.navigationController popViewControllerAnimated:YES];
}


@end
