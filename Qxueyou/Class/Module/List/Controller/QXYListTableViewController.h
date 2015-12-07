//
//  QXYListTableViewController.h
//  Qxueyou
//
//  Created by 熊德庆 on 15/12/4.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QXYListTableViewController : UITableViewController

/// 回调block
@property(nonatomic, copy) void (^relate)(NSArray *listArray);

@end
