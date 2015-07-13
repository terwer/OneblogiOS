//
//  OSCBlogDetails.h
//  iosapp
//
//  Created by chenhaoxiang on 10/31/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import "OBBaseObject.h"

@interface OBBlogDetails : OBBaseObject

@property (nonatomic, assign) int64_t blogID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) NSString *where;
@property (nonatomic, assign) int commentCount;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, assign) int64_t authorID;
@property (nonatomic, assign) int documentType;
@property (nonatomic, copy) NSString *pubDate;
@property (nonatomic, assign) BOOL isFavorite;

@property (nonatomic, strong) NSString *html;

@end
