//
//  QXYListTableViewCell.h
//  Qxueyou
//
//  Created by zhu on 15/12/4.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QXYTestList.h"

@interface QXYListTableViewCell : UITableViewCell

/// 试题模型
@property(nonatomic, strong) QXYTestList *list;


@end
