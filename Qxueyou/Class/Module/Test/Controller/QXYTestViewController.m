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
#import "QXYTestQuestion.h"

@interface QXYTestViewController ()<QXYTestToolBarDelegate, UIScrollViewDelegate>

/// 工具栏
@property(nonatomic, strong) QXYTestToolBar *toolBar;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) QXYTestQuestion *testQuestionLeft;
@property(nonatomic, strong) QXYTestQuestion *testQuestionMiddle;
@property(nonatomic, strong) QXYTestQuestion *testQuestionRight;
/// 左边界面的数组下标
@property(nonatomic, assign) NSInteger leftIndex;
/// 中间界面的数组下标
@property(nonatomic, assign) NSInteger middleIndex;
/// 右界面的数组下标
@property(nonatomic, assign) NSInteger rightIndex;

/// 试题模型数组
@property(nonatomic, strong) NSArray *modelArray;

@end

@implementation QXYTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBar];
    // 加载数据
    [self loadTest];
}



#pragma mark - 加载数据
- (void)loadTest {
    __weak typeof(self) weakSelf = self;
    self.relate = ^(NSArray *listArray){
        weakSelf.modelArray = listArray;
        [weakSelf prepareUI];
    };
    
    QXYTest *test = [QXYTest sharedTest];
    test.relate = self.relate;
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
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, 0);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.testQuestionLeft];
    [self.scrollView addSubview:self.testQuestionMiddle];
    [self.scrollView addSubview:self.testQuestionRight];
    
    self.testQuestionMiddle.test = self.modelArray.firstObject;
    self.testQuestionLeft.test = self.modelArray.lastObject;
    self.middleIndex = 0;
    self.rightIndex = 1;
    if (self.modelArray.count == 1) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 0);
    } else if (self.modelArray.count == 2) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, 0);
        self.testQuestionRight.test = [self.modelArray objectAtIndex:1];
        self.leftIndex = 1;
    } else {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, 0);
        self.testQuestionRight.test = [self.modelArray objectAtIndex:1];
        self.leftIndex = self.modelArray.count - 1;
    }
    
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

#pragma mark - 监听scrollview发生滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollView.contentOffset.x == 0) {
        /// 小心数组越界即可
        self.leftIndex = --self.leftIndex >= 0 ? self.leftIndex : self.modelArray.count - 1;
        self.middleIndex = --self.middleIndex >= 0 ? self.middleIndex : self.modelArray.count - 1;
        self.rightIndex = --self.rightIndex >= 0 ? self.rightIndex : self.modelArray.count - 1;
        self.testQuestionLeft.test = self.modelArray[self.leftIndex];
        self.testQuestionMiddle.test = self.modelArray[self.middleIndex];
        self.testQuestionRight.test = self.modelArray[self.rightIndex];
        /// 将偏移设置回来
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    } else if (self.scrollView.contentOffset.x == self.scrollView.frame.size.width * 2) {
        /// 小心数组越界即可
        self.leftIndex = ++self.leftIndex <= self.modelArray.count - 1 ? self.leftIndex : 0;
        self.middleIndex = ++self.middleIndex <= self.modelArray.count - 1 ? self.middleIndex : 0;
        self.rightIndex = ++self.rightIndex <= self.modelArray.count - 1 ? self.rightIndex : 0;
        self.testQuestionLeft.test = self.modelArray[self.leftIndex];
        self.testQuestionMiddle.test = self.modelArray[self.middleIndex];
        self.testQuestionRight.test = self.modelArray[self.rightIndex];
        /// 将偏移设置回来
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }
    
}

#pragma mark - 懒加载
- (QXYTestQuestion *)testQuestionLeft {
    if (_testQuestionLeft == nil) {
        _testQuestionLeft = [[QXYTestQuestion alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 44)];
    }
    return _testQuestionLeft;
}

- (QXYTestQuestion *)testQuestionMiddle {
    if (_testQuestionMiddle == nil) {
        _testQuestionMiddle = [[QXYTestQuestion alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 44)];
    }
    return _testQuestionMiddle;
}

- (QXYTestQuestion *)testQuestionRight {
    if (_testQuestionRight == nil) {
        _testQuestionRight = [[QXYTestQuestion alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 2, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 44)];
    }
    return _testQuestionRight;
}

@end

