//
//  QXYTestQuestion.m
//  Qxueyou
//
//  Created by zhu on 15/12/7.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYTestQuestion.h"



@interface QXYTestQuestion ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UILabel *question;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIImageView *iconImage;
@property(nonatomic, strong) NSArray *modelArray;

/// 是否提交
@property(nonatomic, assign) BOOL assignmentSuccess;


///答案选项
@property(nonatomic, copy) NSString *answerAll;

@end

@implementation QXYTestQuestion

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        [self prepareUI];
//    }
//    return self;
//}

- (void)prepareUI {
    [self addSubview:self.question];
    [self addSubview:self.tableView];

    self.question.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[LineView]-10-|" options:0 metrics:nil views:@{@"LineView": self.question}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-74-[LineView]" options:0 metrics:nil views:@{@"LineView": self.question}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[LineView]-0-|" options:0 metrics:nil views:@{@"LineView": self.tableView}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.question attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
//    self.analysisView = [[QXYAnalysisView alloc] init];
//    self.analysisView.hidden = YES;
}

- (void)setTest:(QXYTest *)test {
    _test = test;
    
    [self prepareUI];
    
    NSString *titleString = @"";
    NSString *headSting = @"";
    if (test.type == 1) {
        headSting = @"[单选]";
        titleString = [NSString stringWithFormat:@"%@ %@", headSting, test.title];
    } else if (test.type == 2) {
        headSting = @"[多选]";
        titleString = [NSString stringWithFormat:@"%@ %@", headSting, test.title];
    } else {
        headSting = @"[判断]";
        titleString = [NSString stringWithFormat:@"%@ %@", headSting, test.title];
    }
    NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:titleString];
    NSRange blueRange = NSMakeRange(0, [[noteString string] rangeOfString:headSting].length);
    [noteString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:blueRange];
    [self.question setAttributedText:noteString];

    self.modelArray = test.options;
    [self.tableView reloadData];
    // 取出提交状态，看是否提交
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *assignment = [defaults valueForKey:self.test.exerciseGroupId];
    if ([assignment isEqualToString:@"assignmentSuccess"]) {
        self.assignmentSuccess = YES;
        self.analysisView.hidden = NO;
    } else {
        self.assignmentSuccess = NO;
        self.analysisView.hidden = YES;
    }
    __weak typeof(self) weakSelf = self;
    self.viewHight = ^(CGFloat hight){
        weakSelf.analysisView.frame = CGRectMake(0, 0, 1, hight);
        weakSelf.tableView.tableFooterView = weakSelf.analysisView;
    };
    self.analysisView.viewHight = self.viewHight;
    self.analysisView.answerDict = self.answerDic;
    self.analysisView.test = self.test;
    /// 让tableview一直显示在顶部
    [self.tableView setContentOffset:CGPointZero animated:NO];
    [self setNeedsDisplay];
}

#pragma mark - 懒加载

- (UILabel *)question {
    if (_question == nil) {
        _question = [[UILabel alloc] init];
        _question.numberOfLines = 0;
    }
    return _question;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (QXYAnalysisView *)analysisView {
    if (_analysisView == nil) {
        _analysisView = [[QXYAnalysisView alloc] init];
    }
    return _analysisView;
}

#pragma mark - dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.imageView.userInteractionEnabled = NO;

    NSDictionary *dict = self.modelArray[indexPath.row];
    NSString *answerString = [NSString stringWithFormat:@"%@、%@", dict[@"optionOrder"], dict[@"content"]];
    if ([dict[@"optionOrder"] isEqualToString:@"True"]) {
        answerString = @"对";
    } else if ([dict[@"optionOrder"] isEqualToString:@"False"]) {
        answerString = @"错";
    }
    self.answerAll = answerString;
    cell.textLabel.text = answerString;
    cell.textLabel.numberOfLines = 0;
    cell.imageView.image = [UIImage imageNamed:@"单选_a4"];
    if (_answerDic) {
        NSArray *array = [_answerDic[@"answer"] componentsSeparatedByString:@","];
        for (NSString *str in array) {
            NSString *string = str;
            if ([str isEqualToString:@"0"]) {
                string = @"False";
            } else if ([str isEqualToString:@"1"]) {
                string = @"True";
            }
            if ([string isEqualToString:dict[@"optionOrder"]]) {
                cell.imageView.userInteractionEnabled = YES;
                cell.imageView.image = [UIImage imageNamed:@"单选效果图_12"];
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.imageView.userInteractionEnabled) {
        cell.imageView.userInteractionEnabled = NO;
        cell.imageView.image = [UIImage imageNamed:@"单选_a4"];
        // 移除答案
        if ([self.delegate respondsToSelector:@selector(removeMyAnswerWithTest:andRow:)]) {
            [self.delegate removeMyAnswerWithTest:self.test andRow:indexPath.row];
        }
    } else {
        if (self.test.type == 2) {
            cell.imageView.userInteractionEnabled = YES;
            cell.imageView.image = [UIImage imageNamed:@"单选效果图_12"];
            // 写入答案
            if ([self.delegate respondsToSelector:@selector(writeMyAnswerWithTest:andRow:)]) {
                [self.delegate writeMyAnswerWithTest:self.test andRow:indexPath.row];
            }
        } else {
            UITableViewCell *cell1 = nil;
            BOOL select = cell.imageView.userInteractionEnabled;
            for (int i = 0; i < self.modelArray.count; i++) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                cell1 = [tableView cellForRowAtIndexPath:path];
                cell1.imageView.image = [UIImage imageNamed:@"单选_a4"];
                cell1.imageView.userInteractionEnabled = NO;
            }
            cell.imageView.userInteractionEnabled = select;
            // 删除原本存在的答案
            if ([self.delegate respondsToSelector:@selector(removeMyAnswerWithTest:andRow:)]) {
                [self.delegate removeMyAnswerWithTest:self.test andRow:indexPath.row];
            }
            if (select) {
                cell.imageView.image = [UIImage imageNamed:@"单选_a4"];
            } else {
                // 写入答案
                if ([self.delegate respondsToSelector:@selector(writeMyAnswerWithTest:andRow:)]) {
                    [self.delegate writeMyAnswerWithTest:self.test andRow:indexPath.row];
                }
                cell.imageView.image = [UIImage imageNamed:@"单选效果图_12"];
            }
            cell.imageView.userInteractionEnabled = !cell.imageView.userInteractionEnabled;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getSizeWithContent:self.answerAll withFont:[UIFont systemFontOfSize:16.0]];
}

- (CGFloat)getSizeWithContent:(NSString *)content withFont:(UIFont *)font {
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize size = [content boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 70, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
        return size.height + 25;
}

@end
