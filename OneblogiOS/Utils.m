//
//  Utils.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/27.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(NSString *)removeSpaceAndNewlineAndChars:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"#" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"=" withString:@""];
    return temp;
}

+ (NSAttributedString *)attributedCommentCount:(int)commentCount
{
    NSString *rawString = [NSString stringWithFormat:@"%@ %d", [NSString fontAwesomeIconStringForEnum:FACommentsO], commentCount];
    NSAttributedString *attributedCommentCount = [[NSAttributedString alloc] initWithString:rawString
                                                                                 attributes:@{
                                                                                              NSFontAttributeName: [UIFont fontAwesomeFontOfSize:12],
                                                                                              }];
    
    return attributedCommentCount;
}

#pragma mark 信息处理

+ (NSDictionary *)timeIntervalArrayFromString:(NSDate *)date
{
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *compsPast = [calendar components:unitFlags fromDate:date];
    NSDateComponents *compsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSInteger daysInLastMonth = [calendar rangeOfUnit:NSDayCalendarUnit
                                               inUnit:NSMonthCalendarUnit
                                              forDate:date].length;
    
    NSInteger years = [compsNow year] - [compsPast year];
    NSInteger months = [compsNow month] - [compsPast month] + years * 12;
    NSInteger days = [compsNow day] - [compsPast day] + months * daysInLastMonth;
    NSInteger hours = [compsNow hour] - [compsPast hour] + days * 24;
    NSInteger minutes = [compsNow minute] - [compsPast minute] + hours * 60;
    
    return @{
             kKeyYears:  @(years),
             kKeyMonths: @(months),
             kKeyDays:   @(days),
             kKeyHours:  @(hours),
             kKeyMinutes:@(minutes)
             };
}


+ (NSAttributedString *)attributedTimeString:(NSDate *)date
{
    NSString *rawString = [NSString stringWithFormat:@"%@ %@", [NSString fontAwesomeIconStringForEnum:FAClockO], [self intervalSinceNow:date]];
    NSAttributedString *attributedTime = [[NSAttributedString alloc] initWithString:rawString
                                                                         attributes:@{
                                                                                      NSFontAttributeName: [UIFont fontAwesomeFontOfSize:12],
                                                                                      }];
    
    return attributedTime;
}


+ (NSString *)intervalSinceNow:(NSDate *)date
{
    NSDictionary *dic = [Utils timeIntervalArrayFromString:date];
    //NSInteger years = [[dic objectForKey:kKeyYears] integerValue];
    NSInteger months = [[dic objectForKey:kKeyMonths] integerValue];
    NSInteger days = [[dic objectForKey:kKeyDays] integerValue];
    NSInteger hours = [[dic objectForKey:kKeyHours] integerValue];
    NSInteger minutes = [[dic objectForKey:kKeyMinutes] integerValue];
    
    if (minutes < 1) {
        return @"刚刚";
    } else if (minutes < 60) {
        return [NSString stringWithFormat:@"%ld分钟前", (long)minutes];
    } else if (hours < 24) {
        return [NSString stringWithFormat:@"%ld小时前", (long)hours];
    } else if (hours < 48 && days == 1) {
        return @"昨天";
    } else if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前", (long)days];
    } else if (days < 60) {
        return @"一个月前";
    } else if (months < 12) {
        return [NSString stringWithFormat:@"%ld个月前", (long)months];
    } else {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy"];
         NSString *msg  = [df stringFromDate:date];
        return msg;
    }
}

+ (MBProgressHUD *)createHUD
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [window addSubview:HUD];
    [HUD show:YES];
    //[HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:HUD action:@selector(hide:)]];
    
    return HUD;
}


@end
