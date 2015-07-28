//
//  AppDelegate.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/27.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    //初始化hidenKeyboard程序入口
    HomeViewController *homeController = [[HomeViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = homeController;
    [self.window makeKeyAndVisible];


    //    //设置样式
    //    sideMenuTabBarViewController.scaleContentView = YES;
    //    sideMenuTabBarViewController.contentViewScaleValue = 0.95;
    //    sideMenuTabBarViewController.scaleMenuView = NO;
    //    sideMenuTabBarViewController.contentViewShadowEnabled = YES;
    //    sideMenuTabBarViewController.contentViewShadowRadius = 4.5;
    //    //设置根视图
    //    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //    self.window.rootViewController = sideMenuTabBarViewController;
    //    [self.window makeKeyAndVisible];
    //
    //    /************ 控件外观设置 **************/
    //
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //
    //    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHex:0x428bd1]];
    //    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    //    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    //    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //
    //
    //    [[UITabBar appearance] setTintColor:[UIColor colorWithHex:0x428bd1]];
    //    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHex:0xE1E1E1]];
    //    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x428bd1]} forState:UIControlStateSelected];
    //
    //
    //    [UISearchBar appearance].tintColor = [UIColor colorWithHex:0x428bd1];
    //    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setCornerRadius:14.0];
    //    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setAlpha:0.6];
    //
    //
    //    UIPageControl *pageControl = [UIPageControl appearance];
    //    pageControl.pageIndicatorTintColor = [UIColor colorWithHex:0xDCDCDC];
    //    pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    //
    //    [[UITextField appearance] setTintColor:[UIColor nameColor]];
    //    [[UITextView appearance]  setTintColor:[UIColor nameColor]];
    //
    //
    //    UIMenuController *menuController = [UIMenuController sharedMenuController];
    //
    //    [menuController setMenuVisible:YES animated:YES];
    //    [menuController setMenuItems:@[
    //                                   [[UIMenuItem alloc] initWithTitle:@"复制" action:NSSelectorFromString(@"copyText:")],
    //                                   [[UIMenuItem alloc] initWithTitle:@"删除" action:NSSelectorFromString(@"deleteObject:")]
    //                                   ]];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
