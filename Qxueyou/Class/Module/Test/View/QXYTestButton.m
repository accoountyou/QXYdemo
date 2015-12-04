//
//  QXYTestButton.m
//  Qxueyou
//
//  Created by zhu on 15/12/3.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYTestButton.h"

@implementation QXYTestButton

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, self.frame.size.height * 0.6, self.frame.size.width, self.frame.size.height * 0.3);
    self.imageView.frame = CGRectMake((self.frame.size.width - self.frame.size.height * 0.5) * 0.5, self.frame.size.height * 0.1, self.frame.size.height * 0.5, self.frame.size.height * 0.5);
}

/// 构造按钮的方法
+ (QXYTestButton *)testButtonWithTitleName:(NSString *)titleString andImageName:(NSString *)imageString {
    QXYTestButton *button = [[QXYTestButton alloc] init];
    [button setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    [button setTitle:titleString forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    return button;
}

@end
