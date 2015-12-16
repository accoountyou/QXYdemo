//
//  QXYTestToolBar.m
//  Qxueyou
//
//  Created by zhu on 15/12/3.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYTestToolBar.h"
#import "QXYTestButton.h"

@interface QXYTestToolBar ()

/// 收藏
@property (nonatomic, strong) QXYTestButton *saveButton;
/// 交卷
@property (nonatomic, strong) QXYTestButton *assignmentButton;
/// 时间
@property (nonatomic, strong) QXYTestButton *timeButton;
/// 评论
@property (nonatomic, strong) QXYTestButton *commentButton;
/// 更多
@property (nonatomic, strong) QXYTestButton *moreButton;
/// 分割线
@property (nonatomic, strong) UIView *lineView;

/// 测试时间
@property(nonatomic, assign) int testTime;
/// 计时器
@property(nonatomic, strong) NSTimer *timer;

/// 是否提交
@property(nonatomic, assign) BOOL assignmentSuccess;

@end

@implementation QXYTestToolBar

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        
//    }
//    return self;
//}

- (void)setGroupId:(NSString *)groupId {
    _groupId = groupId;
    // 取出提交状态，看是否提交
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *assignment = [defaults valueForKey:self.groupId];
    if ([assignment isEqualToString:@"assignmentSuccess"]) {
        self.assignmentSuccess = YES;
    } else {
        self.assignmentSuccess = NO;
    }
    [self prepareUI];
}

- (void)updateTime {
    self.testTime--;
    static NSString *minString = nil;
    static NSString *secondString = nil;
    minString = self.testTime/60 < 10 ? [NSString stringWithFormat:@"0%d",self.testTime/60] : [NSString stringWithFormat:@"%d",self.testTime/60];
    secondString = self.testTime%60 < 10 ? [NSString stringWithFormat:@"0%d",self.testTime%60] : [NSString stringWithFormat:@"%d",self.testTime%60];
    NSString *newTime = [NSString stringWithFormat:@"%@:%@",minString,secondString];
    [self.timeButton setTitle:newTime forState:UIControlStateNormal];
}

- (void)dealloc {
    [self.timer invalidate];
}

/**
 *  准备界面
 */
- (void)prepareUI {
    self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    
    [self addSubview:self.saveButton];
    [self addSubview:self.assignmentButton];
    [self addSubview:self.timeButton];
    [self addSubview:self.commentButton];
    [self addSubview:self.moreButton];
    [self addSubview:self.lineView];
    
    self.saveButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.assignmentButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.timeButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.commentButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.moreButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.lineView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.saveButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.saveButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.saveButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.saveButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.2 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.assignmentButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.saveButton attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.assignmentButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.assignmentButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.assignmentButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.2 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.assignmentButton attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.2 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.commentButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.timeButton attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.commentButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.commentButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.commentButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.2 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.moreButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.commentButton attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.moreButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.moreButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.moreButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.2 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0.5]];
}

#pragma mark - 按钮点击事件
- (void)clickSaveButton:(QXYTestButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [button setTitle:@"已收藏" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"收藏2-128-72"] forState:UIControlStateNormal];
    } else {
        [button setTitle:@"收藏" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"收藏111"] forState:UIControlStateNormal];
    }
    if ([self.delegate respondsToSelector:@selector(qxyTestToolBarClickSaveButton:)]) {
        [self.delegate qxyTestToolBarClickSaveButton:button];
    }
}

- (void)clickAssignmentButton:(QXYTestButton *)button {
    if (!self.assignmentSuccess) {
        if ([self.delegate respondsToSelector:@selector(qxyTestToolBarClickAssignmentButton:)]) {
            [self.delegate qxyTestToolBarClickAssignmentButton:button];
        }
    }
}

- (void)clickCommentButton:(QXYTestButton *)button {
    if ([self.delegate respondsToSelector:@selector(qxyTestToolBarClickCommentButton:)]) {
        [self.delegate qxyTestToolBarClickCommentButton:button];
    }
}

- (void)clickMoreButton:(QXYTestButton *)button {
    if ([self.delegate respondsToSelector:@selector(qxyTestToolBarClickMoreButton:)]) {
        [self.delegate qxyTestToolBarClickMoreButton:button];
    }
}


#pragma mark - 懒加载
- (QXYTestButton *)saveButton {
    if (_saveButton == nil) {
        _saveButton = [QXYTestButton testButtonWithTitleName:@"收藏" andImageName:@"收藏111"];
        [_saveButton addTarget:self action:@selector(clickSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (QXYTestButton *)assignmentButton {
    if (_assignmentButton == nil) {
        if (self.assignmentSuccess) {
            _assignmentButton = [QXYTestButton testButtonWithTitleName:@"已交卷" andImageName:@"交卷2"];
        } else {
            _assignmentButton = [QXYTestButton testButtonWithTitleName:@"交卷" andImageName:@"交卷1"];
        }
        [_assignmentButton addTarget:self action:@selector(clickAssignmentButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _assignmentButton;
}

- (QXYTestButton *)timeButton {
    if (_timeButton == nil) {
        _timeButton = [QXYTestButton testButtonWithTitleName:@"45:00" andImageName:@"计时"];
        [_timeButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        if (!self.assignmentSuccess) {
            self.testTime = 45 * 60;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        } else {
            [_timeButton setTitle:@"已交卷" forState:UIControlStateNormal];
        }
    }
    return _timeButton;
}

- (QXYTestButton *)commentButton {
    if (_commentButton == nil) {
        _commentButton = [QXYTestButton testButtonWithTitleName:@"答题卡" andImageName:@"进度"];
        [_commentButton addTarget:self action:@selector(clickCommentButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}

- (QXYTestButton *)moreButton {
    if (_moreButton == nil) {
        _moreButton = [QXYTestButton testButtonWithTitleName:@"评论" andImageName:@"移除题目"];
        [_moreButton addTarget:self action:@selector(clickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor grayColor];
        _lineView.alpha = 0.8;
    }
    return _lineView;
}


@end
