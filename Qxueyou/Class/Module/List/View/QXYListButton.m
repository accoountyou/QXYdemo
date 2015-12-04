//
//  QXYListButton.m
//  Qxueyou
//
//  Created by zhu on 15/12/4.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYListButton.h"

@implementation QXYListButton

/// 构造按钮的方法
+ (QXYListButton *)listButtonWithTitleName:(NSString *)titleString andImageName:(NSString *)imageString {
    QXYListButton *button = [[QXYListButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    [button setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    [button setTitle:titleString forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    self.titleLabel.frame = CGRectMake(self.frame.size.height , 0, self.frame.size.width - CGRectGetWidth(self.imageView.frame), self.frame.size.height);
}

- (void)setHighlighted:(BOOL)highlighted {
    
}

@end
