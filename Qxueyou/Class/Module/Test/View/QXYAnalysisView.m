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
}

- (void)setTest:(QXYTest *)test {
    _test = test;
    NSDictionary *analisisResult = test.analisisResult;
    NSString *answerTure = analisisResult[@"correctAnswers"];
    NSString *answerAll = [NSString stringWithFormat:@"正确答案:%@, 您的答案:%@",answerTure,@"A"];
    NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:answerAll];
    NSUInteger greenIndex = [answerAll rangeOfString:@"正确答案:"].location + [answerAll rangeOfString:@"正确答案:"].length;
    NSRange greenRange = NSMakeRange(greenIndex, [[noteString string] rangeOfString:answerTure].length);
    NSUInteger redIndex = [answerAll rangeOfString:@"您的答案:"].location + [answerAll rangeOfString:@"您的答案:"].length;
    NSRange redRange = NSMakeRange(redIndex, [[noteString string] rangeOfString:@"A"].length);
    [noteString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:greenRange];
    [noteString addAttribute:NSForegroundColorAttributeName value:[UIColor cyanColor] range:redRange];
    [self.answerMore setAttributedText:noteString];
    
    NSInteger submitNumber = [analisisResult[@"submitNumber"] integerValue];
    NSInteger submitErrorNumber = [analisisResult[@"submitErrorNumber"]integerValue];
    NSInteger accuracy = [analisisResult[@"accuracy"] integerValue];
    NSInteger submitAllNumber = [analisisResult[@"submitAllNumber"] integerValue];
    NSInteger allAccuracy = [analisisResult[@"allAccuracy"] integerValue];
    NSString *countAll = [NSString stringWithFormat:@"个人统计:作答本题%ld, 做错%ld次, 正确率为%ld%%\n全站统计:本题共有%ld次作答,正确率为%ld%%",
                                                        submitNumber,submitErrorNumber,accuracy,submitAllNumber,allAccuracy];
    NSUInteger submitNumberIndex = [countAll rangeOfString:@"作答本题"].location + [countAll rangeOfString:@"作答本题"].length;
    NSUInteger submitErrorNumberIndex = [countAll rangeOfString:@"做错"].location + [countAll rangeOfString:@"做错"].length;
    NSUInteger accuracyIndex = [countAll rangeOfString:@"次, 正确率为"].location + [countAll rangeOfString:@"次, 正确率为"].length;
    NSUInteger submitAllNumberIndex = [countAll rangeOfString:@"本题共有"].location + [countAll rangeOfString:@"本题共有"].length;
    NSUInteger allAccuracyIndex = [countAll rangeOfString:@"答,正确率为"].location + [countAll rangeOfString:@"答,正确率为"].length;
    NSMutableAttributedString *countString = [[NSMutableAttributedString alloc] initWithString:countAll];
    [countString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(submitNumberIndex, 1)];
    [countString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(submitErrorNumberIndex, 1)];
    [countString addAttribute:NSForegroundColorAttributeName value:[UIColor cyanColor] range:NSMakeRange(accuracyIndex, 1)];
    [countString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(submitAllNumberIndex, 1)];
    [countString addAttribute:NSForegroundColorAttributeName value:[UIColor cyanColor] range:NSMakeRange(allAccuracyIndex, 1)];
    [self.countMore setAttributedText:countString];
    
    CGFloat answerF = 0;
    answerF = [self getSizeWithContent:answerAll withFont:[UIFont systemFontOfSize:16]];
    self.answerLabel.frame = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 20, 20);
    self.answerMore.frame = CGRectMake(30, CGRectGetMaxY(self.answerLabel.frame) + 5, [UIScreen mainScreen].bounds.size.width - 40, answerF);
    CGFloat countF = 0;
    countF = [self getSizeWithContent:countAll withFont:[UIFont systemFontOfSize:16]];
    self.countLabel.frame = CGRectMake(10, CGRectGetMaxY(self.answerMore.frame) + 10, [UIScreen mainScreen].bounds.size.width - 20, 20);
    self.countMore.frame = CGRectMake(30, CGRectGetMaxY(self.countLabel.frame) + 5, [UIScreen mainScreen].bounds.size.width - 40, countF);
    CGFloat analisisF = 0;
    if (![analisisResult[@"analysis"] isKindOfClass:[NSNull class]]) {
        self.analysisMore.text = analisisResult[@"analysis"];
    }
    analisisF = [self getSizeWithContent:self.analysisMore.text withFont:[UIFont systemFontOfSize:16]];
    self.analysisLabel.frame = CGRectMake(10, CGRectGetMaxY(self.countMore.frame) + 10, [UIScreen mainScreen].bounds.size.width - 20, 20);
    self.analysisMore.frame = CGRectMake(30, CGRectGetMaxY(self.analysisLabel.frame) + 5, [UIScreen mainScreen].bounds.size.width - 40, analisisF);
    CGFloat H = answerF + countF + analisisF + 150;
    self.viewHight(H);
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

#pragma mark - 懒加载
- (UILabel *)answerMore {
    if (_answerMore == nil) {
        _answerMore = [[UILabel alloc] init];
        _answerMore.numberOfLines = 0;
        _answerMore.font = [UIFont systemFontOfSize:16];
    }
    return _answerMore;
}

- (UILabel *)countMore {
    if (_countMore == nil) {
        _countMore = [[UILabel alloc] init];
        _countMore.numberOfLines = 0;
        _countMore.font = [UIFont systemFontOfSize:16];
    }
    return _countMore;
}

- (UILabel *)analysisMore {
    if (_analysisMore == nil) {
        _analysisMore = [[UILabel alloc] init];
        _analysisMore.numberOfLines = 0;
        _analysisMore.font = [UIFont systemFontOfSize:16];
        _analysisMore.text = @"暂无解析";
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

- (CGFloat)getSizeWithContent:(NSString *)content withFont:(UIFont *)font {
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize size = [content boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    return size.height;
}

@end
