//
//  BlogsViewController.h
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/27.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBObjsViewController.h"

/**
 *  文章类型美剧
 */
typedef NS_ENUM(NSUInteger, PostType){
    /**
     *  最新文章
     */
    PostTypeLatest,
    /**
     *  推荐文章
     */
    PostTypeRecommended,
    /**
     *  置顶文章
     */
    PostTypeDig//置顶文章
};

@interface PostViewController : OBObjsViewController

/**
 *  文章列表数据
 */
@property(nonatomic) NSArray *posts;
/**
 *  搜索框
 */
@property(nonatomic)  UISearchBar *searchBar;
/**
 *  搜索显示控制器
 */
@property UISearchDisplayController *searchDisController;

/**
 *  根据文章类型初始化
 *
 *  @param type 文章类型
 *
 *  @return 当前对象
 */
- (instancetype)initWithPostType:(PostType)type;

@end
