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
#import "QXYSelectTest.h"
#import "QXYAssess.h"
#import "SVProgressHUD.h"

@interface QXYTestViewController ()<QXYTestToolBarDelegate, UIScrollViewDelegate, QXYTestQuestionDelegate>

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

/// 答案数组
@property(nonatomic, strong) NSMutableArray *answerArray;
/// 自己做题的数组
@property(nonatomic, strong) NSArray *write;

/// 试题字典
@property(nonatomic, strong) NSMutableDictionary *answerDict;

/// 试题模型数组
@property(nonatomic, strong) NSArray *modelArray;

@end

@implementation QXYTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 加载数据
    [self loadTest];
}



#pragma mark - 加载数据
- (void)loadTest {
    __weak typeof(self) weakSelf = self;
    self.relate = ^(NSArray *listArray){
        weakSelf.modelArray = listArray;
        [weakSelf prepareUI];
        [weakSelf initData];
    };
    QXYTest *test = [QXYTest sharedTest];
    test.relate = self.relate;
    [test loadTestWithGroupId:self.list.groupId];
}

/**
 *  创建数组字典
 */
- (void)initData {
//    self.answerArray = [NSMutableArray array];
   
    for (QXYTest *test in self.modelArray) {
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        [dictM setValue:self.list.userId forKey:@"userId"]; // 登陆后返回的数据里面有
        [dictM setValue:self.list.classId forKey:@"classId"];   // 登陆后返回的数据里面有
        [dictM setValue:test.exerciseId forKey:@"exerciseId"];  // 题目id
        [dictM setValue:test.exerciseGroupId forKey:@"exerciseGroupId"];    // 第二个网络请求返回的数据 test
        [dictM setValue:[NSNumber numberWithInt:self.list.type] forKey:@"type"];    // 题目类型
        [dictM setValue:[NSNumber numberWithInt:1] forKey:@"doTitleOrder"]; // 写死
        [dictM setValue:[NSNumber numberWithInt:0] forKey:@"accuracy"]; // 正确率 无% 保留两位小数
        [dictM setValue:@"id" forKey:@"id"];    // 写死
        [dictM setValue:@"exams" forKey:@"exerciseType"];   // 写死
        [dictM setValue:@"exerciseExtendId" forKey:@"exerciseExtendId"];    // 写死
        [dictM setValue:@"" forKey:@"sumbitAnswer"];    // 提交的答案  判断错误0  正确1  多选中间逗号
        [dictM setValue:@"" forKey:@"correct"]; // 题目正确还是错误 自己判断
        [dictM setValue:@"" forKey:@"exerciseRecordId"];    // 提交过后才有的数据
        [dictM setValue:test.analisisResult[@"correctAnswers"] forKey:@"answer"];  // 题目的正确答案
        [dictM setValue:@"" forKey:@"titleMaxNum"]; // 做的最大题目号
        [dictM setValue:@"" forKey:@"currTitleNum"];    // 做的最大题目号
        [dictM setValue:@"" forKey:@"correctCount"];    // 正确了几题
        [dictM setValue:@"" forKey:@"doCount"]; //总共做了几题
        [self.answerArray addObject:dictM];
    }
}

#pragma mark - QXYTestQuestionDelegate
- (void)writeMyAnswerWithTest:(QXYTest *)test andRow:(NSInteger)row {
    // 取出被点击的按钮
    for (NSMutableDictionary *dict in self.answerArray) {
        if ([test.exerciseId isEqualToString:dict[@"exerciseId"]]) {
            if (test.type == 3) { // 判断
                if (row == 0) {
                    [dict setValue:@"0" forKey:@"sumbitAnswer"];
                } else {
                    [dict setValue:@"1" forKey:@"sumbitAnswer"];
                }
            } else if (test.type == 1) { //单选
                if (row == 0) [dict setValue:@"A" forKey:@"sumbitAnswer"];
                else if (row == 1) [dict setValue:@"B" forKey:@"sumbitAnswer"];
                else if (row == 2) [dict setValue:@"C" forKey:@"sumbitAnswer"];
                else if (row == 3) [dict setValue:@"D" forKey:@"sumbitAnswer"];
                else if (row == 4) [dict setValue:@"E" forKey:@"sumbitAnswer"];
                else if (row == 5) [dict setValue:@"F" forKey:@"sumbitAnswer"];
            } else { // 多选
                NSString *answerString = nil;
                if ([dict[@"sumbitAnswer"] isEqualToString:@""]) {
                    if (row == 0) answerString = @"A";
                    else if (row == 1) answerString = @"B";
                    else if (row == 2) answerString = @"C";
                    else if (row == 3) answerString = @"D";
                    else if (row == 4) answerString = @"E";
                    else if (row == 5) answerString = @"F";
                } else {
                    if (row == 0) answerString = [NSString stringWithFormat:@"%@,%@",dict[@"sumbitAnswer"],@"A"];
                    else if (row == 1) answerString = [NSString stringWithFormat:@"%@,%@",dict[@"sumbitAnswer"],@"B"];
                    else if (row == 2) answerString = [NSString stringWithFormat:@"%@,%@",dict[@"sumbitAnswer"],@"C"];
                    else if (row == 3) answerString = [NSString stringWithFormat:@"%@,%@",dict[@"sumbitAnswer"],@"D"];
                    else if (row == 4) answerString = [NSString stringWithFormat:@"%@,%@",dict[@"sumbitAnswer"],@"E"];
                    else if (row == 5) answerString = [NSString stringWithFormat:@"%@,%@",dict[@"sumbitAnswer"],@"F"];
                }
                [dict setValue:[self sortStringByAbcd:answerString] forKey:@"sumbitAnswer"];
            }
        }
        NSLog(@"---------%@",dict[@"sumbitAnswer"]);
    }
}



- (void)removeMyAnswerWithTest:(QXYTest *)test andRow:(NSInteger)row {
    // 取出被点击的按钮
    for (NSMutableDictionary *dict in self.answerArray) {
        if ([test.exerciseId isEqualToString:dict[@"exerciseId"]]) {
            if (test.type == 2) {
                if ([dict[@"sumbitAnswer"] length] == 1) {
                    [dict setValue:@"" forKey:@"sumbitAnswer"];
                } else {
                    static NSString *answerString = nil;
                    if (row == 0) answerString = @"A";
                    else if (row == 1) answerString = @"B";
                    else if (row == 2) answerString = @"C";
                    else if (row == 3) answerString = @"D";
                    else if (row == 4) answerString = @"E";
                    else if (row == 5) answerString = @"F";
                    NSArray *array = [dict[@"sumbitAnswer"] componentsSeparatedByString:@","];
                    NSMutableArray *arrayM = [NSMutableArray array];
                    for (NSString *string in array) {
                        if (![string isEqualToString:answerString]) {
                            [arrayM addObject:string];
                        }
                    }
                    NSString *string = [arrayM componentsJoinedByString:@","];
                    [dict setValue:[self sortStringByAbcd:string] forKey:@"sumbitAnswer"];
                }
            } else {
                [dict setValue:@"" forKey:@"sumbitAnswer"];
            }
        }
        NSLog(@"--------%@",dict[@"sumbitAnswer"]);
    }
}

// 排列字符串 如“A,C,D,B” 为 “A,B,C,D”
- (NSMutableString *)sortStringByAbcd:(NSString *)kStr{
    NSArray *kArrSort = [kStr componentsSeparatedByString:@","]; //这里是字母数组:,g,a,b.y,m……
    NSArray *resultkArrSort = [kArrSort sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableString *newStr = [[NSMutableString alloc]init];
    for (int i = 0; i < resultkArrSort.count; i++) {
        if (i == 0) {
            [newStr appendString:resultkArrSort[0]];
        }else {
            [newStr appendFormat:@",%@",resultkArrSort[i]];
        }
    }
    return newStr;
}

#pragma mark - 设置导航栏
- (void)setupNavigationBar {
    NSString *numberTop = [NSString stringWithFormat:@"(%lu/%lu)",self.middleIndex + 1,self.modelArray.count];
    self.title = [NSString stringWithFormat:@"%@%@",self.list.name,numberTop];
    
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
    
    // 设置右边的跳题功能
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳题" style:UIBarButtonItemStylePlain target:self action:@selector(clickJumpButton)];
}

- (void)clickCancelButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    NSLog(@"delloc");
}

/**
 *  跳转题目
 */
- (void)clickJumpButton {
    NSString *jumpString = [NSString stringWithFormat:@"请输入需要跳转的题号:1~%ld",self.modelArray.count];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:jumpString preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:nil];
    UITextField *jumpField = alert.textFields.firstObject;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        int index = [jumpField.text intValue];
        if (self.modelArray.count == 1) {
            return;
        }
        if (index < 1 || index > self.modelArray.count) {
            [SVProgressHUD showErrorWithStatus:@"您输入的题号有误" maskType:SVProgressHUDMaskTypeBlack];
            return;
        }
        if (index == 1) {
            self.leftIndex = self.modelArray.count - 1;
            self.middleIndex = index - 1;
            self.rightIndex = index;
            self.testQuestionLeft.test = self.modelArray[self.leftIndex];
            self.testQuestionMiddle.test = self.modelArray[self.middleIndex];
            self.testQuestionRight.test = self.modelArray[self.rightIndex];
        }
        else if (index == self.modelArray.count) {
            self.leftIndex = index - 2;
            self.middleIndex = self.modelArray.count - 1;
            self.rightIndex = 0;
            self.testQuestionLeft.test = self.modelArray[self.leftIndex];
            self.testQuestionMiddle.test = self.modelArray[self.middleIndex];
            self.testQuestionRight.test = self.modelArray[self.rightIndex];
        } else {
            self.leftIndex = index - 2;
            self.middleIndex = index - 1;
            self.rightIndex = index;
            self.testQuestionLeft.test = self.modelArray[self.leftIndex];
            self.testQuestionMiddle.test = self.modelArray[self.middleIndex];
            self.testQuestionRight.test = self.modelArray[self.rightIndex];
        }
        [self setupNavigationBar];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 *  准备UI
 */
- (void)prepareUI {
    
    [self setupNavigationBar];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, 0);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:[[UIScrollView alloc] initWithFrame:CGRectZero]];
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
    [self.navigationController pushViewController:[[QXYAssess alloc] init] animated:YES];
}

- (void)qxyTestToolBarClickMoreButton:(QXYTestButton *)button {
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[QXYSelectTest alloc] init]] animated:YES completion:nil];
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
    [self setupNavigationBar];
}

#pragma mark - 懒加载
- (QXYTestQuestion *)testQuestionLeft {
    if (_testQuestionLeft == nil) {
        _testQuestionLeft = [[QXYTestQuestion alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44)];
    }
    return _testQuestionLeft;
}

- (QXYTestQuestion *)testQuestionMiddle {
    if (_testQuestionMiddle == nil) {
        _testQuestionMiddle = [[QXYTestQuestion alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44)];
        _testQuestionMiddle.delegate = self;
    }
    return _testQuestionMiddle;
}

- (QXYTestQuestion *)testQuestionRight {
    if (_testQuestionRight == nil) {
        _testQuestionRight = [[QXYTestQuestion alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 2, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44)];
    }
    return _testQuestionRight;
}

- (NSMutableArray *)answerArray {
    if (_answerArray == nil) {
        _answerArray = [[NSMutableArray alloc] init];
    }
    return _answerArray;
}

- (NSMutableDictionary *)answerDict {
    if (_answerDict == nil) {
        _answerDict = [NSMutableDictionary dictionary];
    }
    return _answerDict;
}

@end

