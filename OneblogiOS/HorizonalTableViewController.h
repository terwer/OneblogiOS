//
//  HorizonalTableViewController.h
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/10.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizonalTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *controllers;
@property (nonatomic, copy) void (^changeIndex)(NSUInteger index);
@property (nonatomic, copy) void (^scrollView)(CGFloat offsetRatio, NSUInteger focusIndex, NSUInteger animationIndex);
@property (nonatomic, copy) void (^viewDidAppear)(NSInteger index);

- (instancetype)initWithViewControllers:(NSArray *)controllers;

- (void)scrollToViewAtIndex:(NSUInteger)index;

@end
