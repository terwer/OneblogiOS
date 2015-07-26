//
//  BlogsViewController.h
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/10.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "OBObjsViewController.h"

typedef NS_ENUM(NSUInteger, BlogsType)
{
    BlogTypeLatest,
    BlogTypeRecommended,
};

@interface BlogsViewController : OBObjsViewController

- (instancetype)initWithBlogsType:(BlogsType)type;
//- (instancetype)initWithUserID:(int64_t)userID;

@end
