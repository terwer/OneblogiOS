//
//  TitleMenuTableViewController.h
//  OneblogiOS
//
//  Created by Terwer Green on 15/8/4.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropdownMenuView;

@protocol TitleMenuDelegate <NSObject>
#pragma mark 当前选中了哪一行
@required
- (void)selectAtIndexPath:(NSIndexPath *)indexPath title:(NSString*)title;
@end

@interface TitleMenuViewController : UITableViewController

@property (nonatomic, weak) id<TitleMenuDelegate> delegate;

@property (nonatomic, weak) DropdownMenuView * dropdownMenuView;

@end