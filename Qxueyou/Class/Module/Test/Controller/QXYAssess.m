//
//  QXYAssess.m
//  Qxueyou
//
//  Created by zhu on 15/12/9.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYAssess.h"
#import "QXYListButton.h"

@interface QXYAssess ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, weak) UICollectionViewFlowLayout *layout;
/// collection 答题卡
@property (weak, nonatomic) IBOutlet UICollectionView *testCollectView;
/// 报告生成时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/// 答案情况
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
/// 正确率
@property (weak, nonatomic) IBOutlet UILabel *trueLabel;
/// 排名
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
/// 班级排名
@property (weak, nonatomic) IBOutlet UILabel *garldNumberLabel;
/// 做正确的答案数组
@property (nonatomic, strong) NSMutableArray *trueArray;
/// 做错误的答案数组
@property (nonatomic, strong) NSMutableArray *falseArray;

@end

@implementation QXYAssess

static NSString * const reuseIdentifier = @"Cell";

- (void)setArray:(NSArray *)array {
    _array = array;
    for (NSDictionary *dict in self.array) {
        if ([dict[@"correct"] isEqualToString:@"true"]) {
            [self.trueArray addObject:dict[@"dictIndex"]];
        } else if ([dict[@"correct"] isEqualToString:@"false"]) {
            [self.falseArray addObject:dict[@"dictIndex"]];
        }
    }
    [self prepareUI];
    NSDictionary *dict = array.firstObject;
    self.trueLabel.text = [NSString stringWithFormat:@"%.2lf%%",[dict[@"accuracy"] doubleValue]];
    self.answerLabel.text = [NSString stringWithFormat:@"答对:%lu题,答错:%lu题,未答:%lu题,总共:%lu题",
                             self.trueArray.count,self.falseArray.count,
                             [dict[@"doCount"] integerValue]-self.trueArray.count-self.falseArray.count,
                             [dict[@"doCount"] integerValue]];
    // 时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    self.timeLabel.text = [NSString stringWithFormat:@"报告生成时间:%@",[formatter stringFromDate:date]];
    [self.testCollectView reloadData];
}

/**
 *  准备界面
 */
- (void)prepareUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBar];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 4 * 10) / 8, ([UIScreen mainScreen].bounds.size.width - 4 * 10) / 8);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout = layout;
    self.testCollectView.bounces = NO;
    self.testCollectView.collectionViewLayout = layout;
    [self.testCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self setupNavigationBar];
}

#pragma mark - 设置导航栏
- (void)setupNavigationBar {
    self.title = @"答题卡";
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemNum;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.layout.itemSize.width, self.layout.itemSize.height)];
    lable.text = [NSString stringWithFormat:@"%ld",indexPath.item + 1];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.layer.cornerRadius = self.layout.itemSize.width * 0.5;
    lable.layer.masksToBounds = YES;
    lable.backgroundColor = [UIColor lightGrayColor];
    for (NSNumber *index in self.trueArray) {
        if ([index integerValue]-1 == indexPath.item) {
            lable.backgroundColor = [UIColor greenColor];
        }
    }
    for (NSNumber *index in self.falseArray) {
        if ([index integerValue]-1 == indexPath.item) {
            lable.backgroundColor = [UIColor redColor];
        }
    }
    [cell.contentView addSubview:lable];
    return cell;
}

#pragma mark - 懒加载
- (NSMutableArray *)trueArray {
    if (_trueArray == nil) {
        _trueArray = [NSMutableArray array];
    }
    return _trueArray;
}

- (NSMutableArray *)falseArray {
    if (_falseArray == nil) {
        _falseArray = [NSMutableArray array];
    }
    return _falseArray;
}



@end
