//
//  QXYCommit.m
//  Qxueyou
//
//  Created by zhu on 15/12/15.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYCommit.h"
#import "QXYListButton.h"

@interface QXYCommit ()
/// 工具栏
@property(nonatomic, strong) UIView *toolBarView;

@end

@implementation QXYCommit

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self prepareUI];
}

/**
 *  准备界面
 */
- (void)prepareUI {
    [self.view addSubview:self.toolBarView];
    self.tableView.bounces = NO;
    // 创建工具栏
#warning sdsadfasdfasdf-----------------
    UITextField *contentField = [[UITextField alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 149 -64, [UIScreen mainScreen].bounds.size.width - 70, 49)];
    [self.toolBarView addSubview:contentField];
}

#pragma mark - 设置导航栏
- (void)setupNavigationBar {
    self.title = @"评论";
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text =@"ABC";
    return cell;
}

#pragma mark - 懒加载
- (UIView *)toolBarView {
    if (_toolBarView == nil) {
        _toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 49 - 64, [UIScreen mainScreen].bounds.size.width, 49)];
        _toolBarView.backgroundColor = [UIColor orangeColor];
    }
    return _toolBarView;
}


@end
