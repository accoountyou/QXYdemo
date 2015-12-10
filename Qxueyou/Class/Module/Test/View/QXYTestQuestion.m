//
//  QXYTestQuestion.m
//  Qxueyou
//
//  Created by zhu on 15/12/7.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYTestQuestion.h"
#import "QXYAnalysisView.h"


@interface QXYTestQuestion ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UILabel *question;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *modelArray;
@property(nonatomic, strong) QXYAnalysisView *analysisView;

///答案选项
@property(nonatomic, copy) NSString *answerAll;

@end

@implementation QXYTestQuestion

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

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

}

- (void)setTest:(QXYTest *)test {
    _test = test;
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
    
    self.analysisView = [[QXYAnalysisView alloc] init];
    __weak typeof(self) weakSelf = self;
    self.viewHight = ^(CGFloat hight){
        weakSelf.analysisView.frame = CGRectMake(0, 0, 1, hight);
        weakSelf.analysisView.backgroundColor = [UIColor redColor];
        weakSelf.tableView.tableFooterView = weakSelf.analysisView;
    };
    self.analysisView.viewHight = self.viewHight;
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
    NSDictionary *dict = self.modelArray[indexPath.row];
    NSLog(@"%d",indexPath.row);
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
    /// 判断是否为多选
    if (self.test.type == 2) {
        cell.imageView.image = [UIImage imageNamed:@"多选_a4"];
    }
    cell.backgroundColor = [UIColor cyanColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"单选效果图_12"];
    /// 判断是否为多选
    if (self.test.type == 2) {
        cell.imageView.image = [UIImage imageNamed:@"单选效果图_10"];
    }
    NSLog(@"%@",NSStringFromCGRect(cell.textLabel.frame));
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
