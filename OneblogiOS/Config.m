//
//  Config.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/9.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "Config.h"

NSString * const kPortrait = @"portrait";

@implementation Config

+ (UIImage *)getPortrait
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    UIImage *portrait = [UIImage imageWithData:[userDefaults objectForKey:kPortrait]];
    
    return portrait;
}

+ (NSArray *)getUsersInformation
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //    NSString *userName = [userDefaults objectForKey:kUserName];
    //    NSNumber *score = [userDefaults objectForKey:kUserScore];
    //    NSNumber *favoriteCount = [userDefaults objectForKey:kFavoriteCount];
    //    NSNumber *fans = [userDefaults objectForKey:kFanCount];
    //    NSNumber *follower = [userDefaults objectForKey:kFollowerCount];
    //    NSNumber *userID = [userDefaults objectForKey:kUserID];
    //    if (userName) {
    //        return @[userName, score, favoriteCount, follower, fans, userID];
    //    }
    return @[@"点击头像登录", @(0), @(0), @(0), @(0), @(0)];
}


@end
