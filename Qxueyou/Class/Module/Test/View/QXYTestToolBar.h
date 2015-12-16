//
//  QXYTestToolBar.h
//  Qxueyou
//
//  Created by zhu on 15/12/3.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QXYTestButton;

@protocol QXYTestToolBarDelegate <NSObject>

- (void)qxyTestToolBarClickSaveButton:(QXYTestButton *)button;
- (void)qxyTestToolBarClickAssignmentButton:(QXYTestButton *)button;
- (void)qxyTestToolBarClickCommentButton:(QXYTestButton *)button;
- (void)qxyTestToolBarClickMoreButton:(QXYTestButton *)button;

@end

@interface QXYTestToolBar : UIView<QXYTestToolBarDelegate>

@property(nonatomic, weak) id<QXYTestToolBarDelegate> delegate;

@property(nonatomic, copy) NSString *groupId;

@end
