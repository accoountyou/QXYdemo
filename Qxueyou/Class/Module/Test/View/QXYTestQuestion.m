//
//  QXYTestQuestion.m
//  Qxueyou
//
//  Created by zhu on 15/12/7.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYTestQuestion.h"

@interface QXYTestQuestion ()

@property(nonatomic, strong) UILabel *question;

@end

@implementation QXYTestQuestion

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI {
    [self addSubview:self.question];

    self.question.translatesAutoresizingMaskIntoConstraints = NO;
    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.option attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:20]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.option attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:20]];
    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[LineView]-10-|" options:0 metrics:nil views:@{@"LineView": self.question}]];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[LineView]-10-|" options:0 metrics:nil views:@{@"LineView": self.question}]];

}


#pragma mark - 懒加载

- (UILabel *)question {
    if (_question == nil) {
        _question = [[UILabel alloc] init];
        [_question sizeToFit];
        _question.text = @"fasdfasdf";
    }
    return _question;
}

@end
