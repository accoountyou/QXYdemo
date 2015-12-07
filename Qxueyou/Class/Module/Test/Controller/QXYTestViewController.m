//
//  QXYTestViewController.m
//  Qxueyou
//
//  Created by zhu on 15/12/3.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYTestViewController.h"
#import "QXYTestToolBar.h"
#import "QXYListButton.h"
#import "QXYTest.h"
#import "QXYTextTableView.h"

@interface QXYTestViewController ()<QXYTestToolBarDelegate>

/// 工具栏
@property(nonatomic, strong) QXYTestToolBar *toolBar;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) QXYTextTableView *textTabelView;

@end

@implementation QXYTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBar];
    [self prepareUI];
    // 加载数据
    [self loadTest];
}



#pragma mark - 加载数据
- (void)loadTest {
    QXYTest *test = [QXYTest sharedTest];
    [test loadTestWithGroupId:self.list.groupId];
}


#pragma mark - 设置导航栏
- (void)setupNavigationBar {
    self.title = self.list.name;
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

- (void)dealloc {
    NSLog(@"delloc");
}

/**
 *  准备UI
 */
- (void)prepareUI {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:self.textTabelView];
    
    
    self.toolBar = [[QXYTestToolBar alloc] init];
    [self.view addSubview:self.toolBar];
    // 设置代理
    self.toolBar.delegate = self;
    
    self.toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];
}

#pragma mark - 工具栏的代理方法
- (void)qxyTestToolBarClickAssignmentButton:(QXYTestButton *)button {
    
}

- (void)qxyTestToolBarClickCommentButton:(QXYTestButton *)button {
    
}

- (void)qxyTestToolBarClickMoreButton:(QXYTestButton *)button {
    
}

- (QXYTextTableView *)textTabelView {
    if (_textTabelView == nil) {
        _textTabelView = [[QXYTextTableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    return _textTabelView;
}

@end
