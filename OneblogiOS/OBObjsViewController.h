//
//  OBObjsViewController.h
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/27.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LastCell.h"
#import "TGMetaWeblogApi.h"
#import "SDFeedParser.h"

@interface OBObjsViewController : UITableViewController

@property (nonatomic, copy) NSString * (^generateURL)(NSUInteger page);
@property (nonatomic, copy) void (^tableWillReload)(NSUInteger responseObjectsCount);
@property (nonatomic, copy) void (^didRefreshSucceed)();

//MetaWeblogApi 或者 JSON API
@property(nonatomic,strong) id api;

//刷新分分页数据（需要在子类重写）
- (void)fetchObjectsOnPage:(NSUInteger)page refresh:(BOOL)refresh;

@property (nonatomic, assign) BOOL shouldFetchDataAfterLoaded;
@property (nonatomic, assign) BOOL needRefreshAnimation;
@property (nonatomic, assign) BOOL needCache;
@property (nonatomic, strong) NSMutableArray *objects;
@property (nonatomic, assign) int allCount;
@property (nonatomic, strong) LastCell *lastCell;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) NSUInteger page;

- (void)fetchMore;
- (void)refresh;

@end
