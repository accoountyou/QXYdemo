//
//  QXYAnalysisView.m
//  Qxueyou
//
//  Created by zhu on 15/12/8.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYAnalysisView.h"

@interface QXYAnalysisView ()

@property(nonatomic, strong) UILabel *answerLabel;
@property(nonatomic, strong) UILabel *answerMore;
@property(nonatomic, strong) UILabel *countLabel;
@property(nonatomic, strong) UILabel *countMore;
@property(nonatomic, strong) UILabel *analysisLabel;
@property(nonatomic, strong) UILabel *analysisMore;

@end

@implementation QXYAnalysisView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

/**
 *  准备界面
 */
- (void)prepareUI {
    [self addSubview:self.answerMore];
    [self addSubview:self.answerLabel];
    [self addSubview:self.countMore];
    [self addSubview:self.countLabel];
    [self addSubview:self.analysisMore];
    [self addSubview:self.analysisLabel];
    
    self.answerMore.translatesAutoresizingMaskIntoConstraints = NO;
    self.answerLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.countMore.translatesAutoresizingMaskIntoConstraints = NO;
//    self.countLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.analysisMore.translatesAutoresizingMaskIntoConstraints = NO;
//    self.analysisLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[LineView]-10-|" options:0 metrics:nil views:@{@"LineView": self.answerLabel}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[LineView]" options:0 metrics:nil views:@{@"LineView": self.answerLabel}]];
    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[LineView]" options:0 metrics:nil views:@{@"LineView": self.answerMore}]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.answerMore attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.answerLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
//
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[LineView]" options:0 metrics:nil views:@{@"LineView": self.countLabel}]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.countLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.answerMore attribute:NSLayoutAttributeBottom multiplier:1 constant:30]];
//    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[LineView]" options:0 metrics:nil views:@{@"LineView": self.countMore}]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.countMore attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.countLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
//    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[LineView]" options:0 metrics:nil views:@{@"LineView": self.analysisLabel}]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.analysisLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.countMore attribute:NSLayoutAttributeBottom multiplier:1 constant:30]];
    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[LineView]" options:0 metrics:nil views:@{@"LineView": self.analysisMore}]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.countMore attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.analysisLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.countMore attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
//    
}




#pragma mark - 懒加载
- (UILabel *)answerMore {
    if (_answerMore == nil) {
        _answerMore = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.width)];
        _answerMore.numberOfLines = 0;
        _answerMore.text = @"2015年11月12日 - 需求:表头上显示文字两种方案:系统给我们提供了tableViewController的代理方法返回组头/组尾文字字符串NSString-(NSString*)tableView:(UITableView*)...";
        _answerMore.font = [UIFont systemFontOfSize:16];
    }
    return _answerMore;
}

- (UILabel *)countMore {
    if (_countMore == nil) {
        _countMore = [[UILabel alloc] init];
        _countMore.numberOfLines = 0;
        _countMore.text = @"2015年asdffffffffffffffffff11月12日 - 需求:表头上显示文字两种方案:系统给我们提供了tableViewController的代理方法返回组头/组尾文字字符串NSString-(NSString*)tableView:(UITableView*)...";
    }
    return _countMore;
}

- (UILabel *)analysisMore {
    if (_analysisMore == nil) {
        _analysisMore = [[UILabel alloc] init];
        _analysisMore.numberOfLines = 0;
        _analysisMore.text = @"fljhasdkjhsfk";
    }
    return _analysisMore;
}

- (UILabel *)answerLabel {
    if (_answerLabel == nil) {
        _answerLabel = [[UILabel alloc] init];
        _answerLabel.text = @"答案";
        _answerLabel.textColor = [UIColor grayColor];
        _answerLabel.font = [UIFont systemFontOfSize:18];
    }
    return _answerLabel;
}

- (UILabel *)countLabel {
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.text = @"统计";
        _countLabel.textColor = [UIColor grayColor];
        _countLabel.font = [UIFont systemFontOfSize:18];
    }
    return _countLabel;
}

- (UILabel *)analysisLabel {
    if (_analysisLabel == nil) {
        _analysisLabel = [[UILabel alloc] init];
        _analysisLabel.text = @"解析";
        _analysisLabel.textColor = [UIColor grayColor];
        _analysisLabel.font = [UIFont systemFontOfSize:18];
    }
    return _analysisLabel;
}



@end
