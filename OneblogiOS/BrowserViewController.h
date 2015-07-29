//
//  BrowserViewController.h
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/29.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserViewController : UIViewController

/**
 *  要浏览的URL
 */
@property NSURL *url;

/**
 *  用指定的URL初始化一个浏览器视图控制器
 *
 *  @param url URL
 *
 *  @return 当前视图控制器
 */
-(instancetype)initWithURL:(NSURL *)url;

@end
