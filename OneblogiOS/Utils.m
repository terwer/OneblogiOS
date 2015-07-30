//
//  Utils.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/27.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "Utils.h"
#import <Reachability.h>
#import "BrowserNavViewController.h"
#import "BrowserViewController.h"
#import "GHMarkdownParser.h"

@implementation Utils

/**
 *  删除字符串中的换行和空白
 *
 *  @param str 原有字符串
 *
 *  @return 处理后的字符串
 */
+(NSString *)removeSpaceAndNewlineAndChars:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"#" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"=" withString:@""];
    temp = [self deleteHTMLTag:temp];
    return temp;
}

/**
 *  街区字符串
 *
 *  @param str    原有字符串
 *  @param length 截取的长度
 *
 *  @return <#return value description#>
 */
+(NSString *)shortString:(NSString *)str andLength:(NSInteger)length{
    NSString *cleanedStr = [Utils removeSpaceAndNewlineAndChars:str];
    if ([cleanedStr length]<length) {
        return cleanedStr;
    }
    return [[cleanedStr substringToIndex:length] stringByAppendingString:@"..."];
}

/**
 *  将评论转换为属性字符串
 *
 *  @param commentCount 原有评论数
 *
 *  @return 处理后的字符串
 */
+ (NSAttributedString *)attributedCommentCount:(int)commentCount
{
    NSString *rawString = [NSString stringWithFormat:@"%@ %d", [NSString fontAwesomeIconStringForEnum:FACommentsO], commentCount];
    NSAttributedString *attributedCommentCount = [[NSAttributedString alloc] initWithString:rawString
                                                                                 attributes:@{
                                                                                              NSFontAttributeName: [UIFont fontAwesomeFontOfSize:12],
                                                                                              }];
    
    return attributedCommentCount;
}



#pragma mark - 通用

#pragma mark - emoji Dictionary

/**
 *  表情字典
 *
 *  @return 表情字典
 */
+ (NSDictionary *)emojiDict
{
    static dispatch_once_t once;
    static NSDictionary *emojiDict;
    
    dispatch_once(&once, ^ {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"emoji" ofType:@"plist"];
        emojiDict = [[NSDictionary alloc] initWithContentsOfFile:path];
    });
    
    return emojiDict;
}

#pragma mark 信息处理
/**
 *  返回从现在开始的时间字典
 *
 *  @param date 原有时间
 *
 *  @return 处理后的字典类型
 */
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


/**
 *  将字符串转换成熟型字符串
 *
 *  @param date 原有日期
 *
 *  @return 处理后的字符串
 */
+ (NSAttributedString *)attributedTimeString:(NSDate *)date
{
    NSString *rawString = [NSString stringWithFormat:@"%@ %@", [NSString fontAwesomeIconStringForEnum:FAClockO], [self intervalSinceNow:date]];
    NSAttributedString *attributedTime = [[NSAttributedString alloc] initWithString:rawString
                                                                         attributes:@{
                                                                                      NSFontAttributeName: [UIFont fontAwesomeFontOfSize:12],
                                                                                      }];
    
    return attributedTime;
}

/**
 *  从现在开始的时间
 *
 *  @param date 原有时间
 *
 *  @return 处理后的字符串
 */
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

/**
 *  创建弹出框
 *
 *  @return 弹出框实例
 */
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

/**
 *  加密啊HTML
 *
 *  @param originalHTML 原始HTML
 *
 *  @return 加密后的HTML
 */
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

/**
 *  解码HTML
 *
 *  @param originalHTML 原始HTML
 *
 *  @return 解码后的HTML
 */
+ (NSString *)unescapeHTML:(NSString *)originalHTML
{
    if (!originalHTML) {return @"";}
    
    NSMutableString *result = [[NSMutableString alloc] initWithString:originalHTML];
    [result replaceOccurrencesOfString:@"&amp;"  withString:@"&"  options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"&lt;" withString:@"<"    options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"&gt;"   withString:@">"  options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"&#39;"  withString:@"'"  options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    return result;
}

/**
 *  删除HTML标签
 *
 *  @param HTML 原油HTML内容
 *
 *  @return 处理后的HTML
 */
+ (NSString *)deleteHTMLTag:(NSString *)HTML
{
    //修复HTML为空的情况
    if (!HTML) {
        return @"";
    }
    
    NSMutableString *trimmedHTML = [[NSMutableString alloc] initWithString:HTML];
    
    NSString *styleTagPattern = @"<style[^>]*?>[\\s\\S]*?<\\/style>";
    NSRegularExpression *styleTagRe = [NSRegularExpression regularExpressionWithPattern:styleTagPattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *resultsArray = [styleTagRe matchesInString:trimmedHTML options:0 range:NSMakeRange(0, trimmedHTML.length)];
    for (NSTextCheckingResult *match in [resultsArray reverseObjectEnumerator]) {
        [trimmedHTML replaceCharactersInRange:match.range withString:@""];
    }
    
    NSString *htmlTagPattern = @"<[^>]+>";
    NSRegularExpression *normalHTMLTagRe = [NSRegularExpression regularExpressionWithPattern:htmlTagPattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    resultsArray = [normalHTMLTagRe matchesInString:trimmedHTML options:0 range:NSMakeRange(0, trimmedHTML.length)];
    for (NSTextCheckingResult *match in [resultsArray reverseObjectEnumerator]) {
        [trimmedHTML replaceCharactersInRange:match.range withString:@""];
    }
    
    return trimmedHTML;
}

/**
 *  是否是URL
 *
 *  @param string 原字符串
 *
 *  @return 是否为URL
 */
+ (BOOL)isURL:(NSString *)string
{
    NSString *pattern = @"^(http|https)://.*?$(net|com|.com.cn|org|me|)";
    
    NSPredicate *urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    
    return [urlPredicate evaluateWithObject:string];
}

/**
 *  检测网路是否可用
 *
 *  @return 网路状态
 */
+ (NSInteger)networkStatus
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.terwer.com"];
    return reachability.currentReachabilityStatus;
}

/**
 *  是否存在网络
 *
 *  @return 网路状态
 */
+ (BOOL)isNetworkExist
{
    return [self networkStatus] > 0;
}

/**
 *  将Markdown字符串转换为html 15-07-30 by terwer
 *
 *  @param markdownString markdownString
 *
 *  @return htmlString
 */
+(NSString *)toMarkdownString:(NSString *)markdownString{
    GHMarkdownParser *parser = [[GHMarkdownParser alloc] init];
    parser.options = kGHMarkdownAutoLink; // for example
    parser.githubFlavored = YES;
    NSString *htmlString = [parser HTMLStringFromMarkdownString:markdownString];
    return htmlString;
}

/**
 *  在Webview里面浏览网页 15-07-29 by terewr
 *
 *  @param target 跳转之前的仕途控制器，一般为当前视图控制器
 *  @param url    要浏览的网址
 */
+(void)navigateUrl:(UIViewController *)target withUrl:(NSURL *)url andTitle:(NSString *)pageTitle{
    BrowserNavViewController *browserNavCtl = [[BrowserNavViewController alloc]init];
    browserNavCtl.url = url;
    browserNavCtl.title = pageTitle;
    //添加浏览器视图控制器到当前导航控制器
    BrowserViewController *browserCtl = [[BrowserViewController alloc]initWithURL:url andTitle:pageTitle];
    [browserNavCtl pushViewController:browserCtl animated:YES];
    [target presentViewController:browserNavCtl animated:NO completion:^{
        NSLog(@"正在使用WebView打开网页:%@",[url absoluteString]);
    }];
}
@end
