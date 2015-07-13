//
//  OSCBlog.m
//  iosapp
//
//  Created by chenhaoxiang on 10/30/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import "OBBlog.h"
#import <UIKit/UIKit.h>
#import "Utils.h"

static NSString * const kID = @"id";
static NSString * const kAuthor = @"authorname";
static NSString * const kAuthorID = @"authorid";
static NSString * const kTitle = @"title";
static NSString * const kBody = @"body";
static NSString * const kCommentCount = @"commentCount";
static NSString * const kPubDate = @"pubDate";
static NSString * const kDocumentType = @"documentType";

@implementation OBBlog

- (instancetype)initWithXML:(ONOXMLElement *)xml
{
    self = [super init];
    if (self) {
        _blogID = [[[xml firstChildWithTag:kID] numberValue] longLongValue];
        _author = [[xml firstChildWithTag:kAuthor] stringValue];
        _authorID = [[[xml firstChildWithTag:kAuthorID] numberValue] longLongValue];
        _title = [[xml firstChildWithTag:kTitle] stringValue];
        _body = [[xml firstChildWithTag:kBody] stringValue];
        _commentCount = [[[xml firstChildWithTag:kCommentCount] numberValue] intValue];
        _pubDate = [[xml firstChildWithTag:kPubDate] stringValue];
        _documentType = [[[xml firstChildWithTag:kDocumentType] numberValue] intValue];
    }
    
    return self;
}

- (NSMutableAttributedString *)attributedTittle
{
    if (!_attributedTittle) {
        NSTextAttachment *textAttachment = [NSTextAttachment new];
        if (_documentType == 0) {
            textAttachment.image = [UIImage imageNamed:@"widget_repost"];
        } else {
            textAttachment.image = [UIImage imageNamed:@"widget-original"];
        }
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
        _attributedTittle = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
        [_attributedTittle appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [_attributedTittle appendAttributedString:[[NSAttributedString alloc] initWithString:_title]];
    }
    
    return _attributedTittle;
}

-(NSAttributedString *)attributedCommentCount
{
//    if (!_attributedCommentCount) {
//        _attributedCommentCount = [Utils attributedCommentCount:_commentCount];
//    }
//    
//    return _attributedCommentCount;
    return nil;
}

- (BOOL)isEqual:(id)object
{
    if ([self class] == [object class]) {
        return _blogID == ((OBBlog *)object).blogID;
    }
    
    return NO;
}


@end
