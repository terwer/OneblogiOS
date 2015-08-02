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
 *  文章类型枚举
 */
typedef NS_ENUM(NSUInteger, PostType){
    /**
     *  文章
     */
    PostTypePost,
    /**
     *  页面
     */
    PostTypePage,
};

@interface PostViewController : OBObjsViewController

/**
 *  文章类型
 */
@property (nonatomic) PostType postType;
/**
 *  文章列表数据
 */
@property (nonatomic) NSArray *posts;
/**
 *  是否搜索
 */
@property (nonatomic)  BOOL isSearch;
/**
 *  搜索框
 */
@property (nonatomic)  UISearchBar *searchBar;
/**
 *  文章搜索控制器
 */
@property   UISearchController *postSearchController;

/**
 *  根据文章类型初始化
 *
 *  @param type 文章类型
 *
 *  @return 当前对象
 */
- (instancetype)initWithPostType:(PostType)type;

@end
