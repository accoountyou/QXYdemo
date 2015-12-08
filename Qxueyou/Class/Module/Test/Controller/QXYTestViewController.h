//
//  QXYTestViewController.h
//  Qxueyou
//
//  Created by zhu on 15/12/3.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QXYTestList.h"

@interface QXYTestViewController : UIViewController

/// 回调block
@property(nonatomic, copy) void (^relate)(NSArray *listArray);

@property(nonatomic, strong) QXYTestList *list;

@end
