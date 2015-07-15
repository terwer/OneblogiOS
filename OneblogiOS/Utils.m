//
//  Utils.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/9.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "Utils.h"
#import <GRMustache.h>

@implementation Utils


+ (NSString *)generateUserAgent
{
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSString *IDFV = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    return [NSString stringWithFormat:@"terwer.com/%@/%@/%@/%@/%@", appVersion,
            [UIDevice currentDevice].systemName,
            [UIDevice currentDevice].systemVersion,
            [UIDevice currentDevice].model,
            IDFV];
}


+ (NSDictionary *)timeIntervalArrayFromString:(NSString *)dateStr
{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *date = [dateFormatter dateFromString:dateStr];
//    
//    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents *compsPast = [calendar components:unitFlags fromDate:date];
//    NSDateComponents *compsNow = [calendar components:unitFlags fromDate:[NSDate date]];
//    
//    NSInteger daysInLastMonth = [calendar rangeOfUnit:NSDayCalendarUnit
//                                               inUnit:NSMonthCalendarUnit
//                                              forDate:date].length;
//    
//    NSInteger years = [compsNow year] - [compsPast year];
//    NSInteger months = [compsNow month] - [compsPast month] + years * 12;
//    NSInteger days = [compsNow day] - [compsPast day] + months * daysInLastMonth;
//    NSInteger hours = [compsNow hour] - [compsPast hour] + days * 24;
//    NSInteger minutes = [compsNow minute] - [compsPast minute] + hours * 60;
//    
//    return @{
//             kKeyYears:  @(years),
//             kKeyMonths: @(months),
//             kKeyDays:   @(days),
//             kKeyHours:  @(hours),
//             kKeyMinutes:@(minutes)
//             };
    return @"bbb";
}

+ (NSString *)intervalSinceNow:(NSString *)dateStr
{
//    NSDictionary *dic = [Utils timeIntervalArrayFromString:dateStr];
//    //NSInteger years = [[dic objectForKey:kKeyYears] integerValue];
//    NSInteger months = [[dic objectForKey:kKeyMonths] integerValue];
//    NSInteger days = [[dic objectForKey:kKeyDays] integerValue];
//    NSInteger hours = [[dic objectForKey:kKeyHours] integerValue];
//    NSInteger minutes = [[dic objectForKey:kKeyMinutes] integerValue];
//    
//    if (minutes < 1) {
//        return @"刚刚";
//    } else if (minutes < 60) {
//        return [NSString stringWithFormat:@"%ld分钟前", (long)minutes];
//    } else if (hours < 24) {
//        return [NSString stringWithFormat:@"%ld小时前", (long)hours];
//    } else if (hours < 48 && days == 1) {
//        return @"昨天";
//    } else if (days < 30) {
//        return [NSString stringWithFormat:@"%ld天前", (long)days];
//    } else if (days < 60) {
//        return @"一个月前";
//    } else if (months < 12) {
//        return [NSString stringWithFormat:@"%ld个月前", (long)months];
//    } else {
//        NSArray *arr = [dateStr componentsSeparatedByString:@" "];
//        return arr[0];
//    }
    return @"aaa";
}

+ (NSString *)escapeHTML:(NSString *)originalHTML
{
    if (!originalHTML) {return @"";}
    
    NSMutableString *result = [[NSMutableString alloc] initWithString:originalHTML];
    [result replaceOccurrencesOfString:@"&"  withString:@"&amp;"  options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"<"  withString:@"&lt;"   options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@">"  withString:@"&gt;"   options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"'"  withString:@"&#39;"  options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    return result;
}

+ (NSString *)HTMLWithData:(NSDictionary *)data usingTemplate:(NSString *)templateName
{
//    NSString *templatePath = [[NSBundle mainBundle] pathForResource:templateName ofType:@"html" inDirectory:@"html"];
//    NSString *template = [NSString stringWithContentsOfFile:templatePath encoding:NSUTF8StringEncoding error:nil];
//    
//    NSMutableDictionary *mutableData = [data mutableCopy];
//    [mutableData setObject:@(((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode)
//                    forKey:@"night"];
//    
//    return [GRMustacheTemplate renderObject:mutableData fromString:template error:nil];
    return @"ccc";
}


@end
