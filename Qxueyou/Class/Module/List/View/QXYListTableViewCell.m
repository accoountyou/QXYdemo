//
//  QXYListTableViewCell.m
//  Qxueyou
//
//  Created by zhu on 15/12/4.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYListTableViewCell.h"

@interface QXYListTableViewCell ()

/// 文本
@property(nonatomic, strong) UILabel *messageLabel;

/// 分割线
@property(nonatomic, strong) UIView *LineView;

@end

@implementation QXYListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self prepareUI];
    }
    return self;
}

/**
 *  准备UI
 */
- (void)prepareUI {
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.LineView];
    
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.LineView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[LineView]-0-|" options:0 metrics:nil views:@{@"LineView": self.LineView}]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.LineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.LineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1]];
}

#pragma mark - 懒加载
- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = @"点我点我";
    }
    return _messageLabel;
}

- (UIView *)LineView {
    if (_LineView == nil) {
        _LineView = [[UIView alloc] init];
        _LineView.backgroundColor = [UIColor grayColor];
    }
    return _LineView;
}


@end
