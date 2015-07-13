//
//  OSCBlog.h
//  iosapp
//
//  Created by chenhaoxiang on 10/30/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import "OBBaseObject.h"

@interface OBBlog : OBBaseObject

@property (nonatomic, assign) int64_t blogID;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, assign) int64_t authorID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *pubDate;
@property (nonatomic, assign) int commentCount;
@property (nonatomic, assign) int documentType;

@property (nonatomic, strong) NSMutableAttributedString *attributedTittle;
@property (nonatomic, strong) NSAttributedString *attributedCommentCount;

@end
