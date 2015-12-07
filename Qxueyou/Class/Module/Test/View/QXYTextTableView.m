//
//  QXYTextTableView.m
//  Qxueyou
//
//  Created by zhu on 15/12/7.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "QXYTextTableView.h"
#import "QXYTestQuestion.h"

@interface QXYTextTableView ()

@end

@implementation QXYTextTableView

//- (void)ini {
//    [super viewDidLoad];
//    
//    self.tableHeaderView = [[QXYTestQuestion alloc] init];
//    [self prepareUI];
//    
//    
//}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.tableHeaderView = [[QXYTestQuestion alloc] init];
        [self prepareUI];
    }
    return self;
}

/**
 *  准备界面
 */
- (void)prepareUI {
    
}



//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

@end
