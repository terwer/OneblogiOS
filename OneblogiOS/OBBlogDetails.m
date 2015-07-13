//
//  OSCBlogDetails.m
//  iosapp
//
//  Created by chenhaoxiang on 10/31/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import "OBBlogDetails.h"
#import "Utils.h"


@implementation OBBlogDetails

- (instancetype)initWithXML:(ONOXMLElement *)xml
{
    self = [super init];
    
    if (self) {
        _blogID = [[[xml firstChildWithTag:@"id"] numberValue] longLongValue];
        _title = [[xml firstChildWithTag:@"title"] stringValue];
        _url = [NSURL URLWithString:[[xml firstChildWithTag:@"url"] stringValue]];
        _body = [[xml firstChildWithTag:@"body"] stringValue];
        _commentCount = [[[xml firstChildWithTag:@"commentCount"] numberValue] intValue];
        _author = [[xml firstChildWithTag:@"author"] stringValue];
        _authorID = [[[xml firstChildWithTag:@"authorid"] numberValue] longLongValue];
        _pubDate = [[xml firstChildWithTag:@"pubDate"] stringValue];
        _isFavorite = [[[xml firstChildWithTag:@"favorite"] numberValue] boolValue];
        _where = [[xml firstChildWithTag:@"where"] stringValue];
        _documentType = [[[xml firstChildWithTag:@"documentType"] numberValue] intValue];
    }
    
    return self;
}

- (NSString *)html
{
    if (!_html) {
        NSDictionary *data = @{
                               @"title": [Utils escapeHTML:_title],
                               @"authorID": @(_authorID),
                               @"authorName": _author,
                               @"timeInterval": [Utils intervalSinceNow:_pubDate],
                               @"content": _body,
                               };
        
        _html = [Utils HTMLWithData:data usingTemplate:@"article"];
    }
    
    return _html;
}

@end
