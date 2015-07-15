//
//  OBObjsViewController.h
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/10.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AFNetworking.h>
#import <AFOnoResponseSerializer.h>
#import <Ono.h>

#import "Utils.h"
#import "OBAPI.h"
#import "LastCell.h"

@class ONOXMLDocument;

@interface OBObjsViewController : UITableViewController

@property (nonatomic, copy) void (^parseExtraInfo)(ONOXMLDocument *);
//请求url
@property (nonatomic, copy) NSString * (^generateURL)(NSUInteger page);
//post数据（xmlrpc需要）
@property (nonatomic,copy) NSString *(^postData)();
@property (nonatomic, copy) void (^tableWillReload)(NSUInteger responseObjectsCount);
@property (nonatomic, copy) void (^didRefreshSucceed)();

@property Class objClass;

@property (nonatomic, assign) BOOL shouldFetchDataAfterLoaded;
@property (nonatomic, assign) BOOL needRefreshAnimation;
@property (nonatomic, assign) BOOL needCache;
@property (nonatomic, strong) NSMutableArray *objects;
@property (nonatomic, assign) int allCount;
@property (nonatomic, strong) LastCell *lastCell;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) NSUInteger page;

- (NSArray *)parseXML:(ONOXMLDocument *)xml;
- (void)fetchMore;
- (void)refresh;

@end
