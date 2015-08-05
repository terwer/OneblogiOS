//
//  ApiInfo.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/29.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "ApiInfo.h"

@implementation ApiInfo

-(instancetype)initWithXmlrpc:(NSString *)xmlrpc andUsername:(NSString *)username andPassword:(NSString *)password{
    if (self = [super init]) {
        //确保全部都不能为空
        _baseURL = xmlrpc;
        _username = username;
        _password = password;
    }
    return self;
}

-(instancetype)initWithBaseURL:baseURL andGenerateAuthCookie:cookie{
    if (self = [super init]) {
        _generateAauthCookie = cookie;
    }
    return self;
}
@end
