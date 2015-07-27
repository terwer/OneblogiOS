//
//  BlogsViewController.h
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/27.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBObjsViewController.h"

typedef NS_ENUM(NSUInteger, PostType)
{
    PostTypeLatest,//最新文章
    PostTypeRecommended,//热门文章
    PostTypeDig//置顶文章
};

@interface PostViewController : OBObjsViewController

- (instancetype)initWithPostType:(PostType)type;

@end
