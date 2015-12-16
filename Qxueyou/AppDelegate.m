//
//  AppDelegate.m
//  Qxueyou
//
//  Created by zhu on 15/12/2.
//  Copyright © 2015年 zhu. All rights reserved.
//

#import "AppDelegate.h"
#import "QXYLoginViewController.h"
#import "QXYTestViewController.h"
#import "QXYBaseTableViewController.h"
#import "QXYNetworkTools.h"
#import "QXYListTableViewController.h"
#import "QXYCommit.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 设置全局属性,该方法越早调用越好,所以放在这个方法里面最合适
    [self setupAppearance];
    self.window = [[UIWindow alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[QXYListTableViewController alloc] init]];
    [self.window makeKeyAndVisible];
    // 注册登录成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRootController:) name:QXYLoginSuccessNotification object:nil];
    return YES;
}

- (void)setRootController:(NSNotification *)note {
    if ([note.object isEqualToString:@"LoginSuccess"]) {
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[QXYListTableViewController alloc] init]];
    } else {
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[QXYBaseTableViewController alloc] init]];
    }
}

/// 设置全局的tabBar的外观
- (void)setupAppearance {
    // 设置导航条的背景
    // 获得全局主题导航条
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    navBar.barTintColor = [UIColor orangeColor];
//    // 设置标题属性
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    [navBar setTitleTextAttributes:attributes];
    
    // 获得全局的UIBarButtonItem
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *itemAttributes = [NSMutableDictionary dictionary];
    itemAttributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    itemAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    [navBar setTitleTextAttributes:attributes];
    [item setTitleTextAttributes:itemAttributes forState:UIControlStateNormal];
}
@end
