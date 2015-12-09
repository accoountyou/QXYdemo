//
//  QXYSelectTest.m
//  Qxueyou
//
//  Created by zhu on 15/12/9.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYSelectTest.h"
#import "QXYListButton.h"

@interface QXYSelectTest ()

@property(nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation QXYSelectTest

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init {
    return [super initWithCollectionViewLayout:self.layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self prepareUI];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  准备界面
 */
- (void)prepareUI {
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.layout.minimumInteritemSpacing = 10;
    self.layout.minimumLineSpacing = 10;
    self.layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 4 * 10) / 8, ([UIScreen mainScreen].bounds.size.width - 4 * 10) / 8);
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.bounces = NO;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.layout.itemSize.width, self.layout.itemSize.height)];
    lable.text = [NSString stringWithFormat:@"%ld",indexPath.item + 1];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.layer.cornerRadius = self.layout.itemSize.width * 0.5;
    lable.layer.masksToBounds = YES;
    lable.backgroundColor = [UIColor orangeColor];
    [cell.contentView addSubview:lable];
    
    return cell;
}

#pragma mark - 懒加载
- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _layout;
}

@end
