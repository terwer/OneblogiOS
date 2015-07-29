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
        if (xmlrpc && username && password) {
            _xmlrpc = xmlrpc;
            _username = username;
            _password = password;
            return self;
        }
        return nil;
    }
    return nil;
}

@end
