//
//  NBSAppAgent.h
//
//  Created by yang kai on 14-3-12.
//  Copyright (c) 2014年 NBS. All rights reserved.
//


#import "NBSGCDOverrider.h"

#define NBSOption_Net 1<<0
#define NBSOption_UI  1<<1
#define NBSOption_Crash 1<<2


@interface NBSAppAgent : NSObject<NSURLConnectionDataDelegate>
/*1、启动NBSAppAgent。一般，只需本函数足矣！*/
+(void)startWithAppID:(NSString*)appId;
/*2、rate指定了启动的概率，应该是0～1之间的一个数，0.5表示一半概率。默认100%*/
+(void)startWithAppID:(NSString*)appId rateOfLaunch:(double) rate;
/*3、locationAllowed指明是否使用位置服务，默认是不使用，如果app本身使用了位置服务，此函数无效。
 SDK使用位置服务的逻辑是这样的，如果app本身使用了位置服务，则SDK也使用位置信息，否则，调用本函数指明要使用位置信息，则使用位置信息。
 换句话说：如果app没有使用位置信息，而且没有调用本函数，则SDK不取位置信息（当然也不会开启位置服务）。*/
+(void)startWithAppID:(NSString*)appId location:(BOOL)locationAllowed;
/*4、同时指定启动概率和是否使用位置服务*/
+(void)startWithAppID:(NSString*)appId location:(BOOL)locationAllowed rateOfLaunch:(double) rate;
/*5、本函数弃用，请使用setSetOption*/
+(void) setCrashCollectFlg:(BOOL) isCollectCrashInfo;
/*6、忽略某些网络请求。block返回true的，都被忽略。*/
+(void)setIgnoreBlock:(BOOL (^)(NSURLRequest* request)) block;
/*7、设置一个普通异常捕获处理块。当普通异常发生时该块会被调用。但signal异常不会调用该块*/
+(void)setUncatchExceptionCallbackBlock:(void (^)(NSException *exception))block;
/*8、setCustomerData:forKey:的目的是这样的：通过这个方法设置的信息，会在crash时作为环境信息提交，帮助用户分析问题。此函数可以在任何地方多次调用*/
+(void)setCustomerData:(NSString*)data forKey:(NSString*)key;
/*9、设置启动选项，SDK有几个功能，借此可以关闭某个。此函数应该在其他函数之前调用。option的值应该是NBSOption_Net、NBSOption_UI、NBSOption_Crash的组合*/
+(void)setSetOption:(int)option;
@end


/*
 Example 1:最简单的
 [NBSAppAgent startWithAppID:@"xxxxxxx"];

 Example 2:指定采样率 50%
 [NBSAppAgent startWithAppID:@"xxxxxxx" rateOfLaunch:0.5f];
 
 Example 3:要求采集位置信息
 [NBSAppAgent startWithAppID:@"xxxxxxx" location:YES];
 
 Example 4:忽略包含127.0.0.1的url
 [NBSAppAgent startWithAppID:@"xxxxxxx"];
 [NBSAppAgent setIgnoreBlock:^BOOL(NSURLRequest* request)
 {
 return [request.URL.absoluteString rangeOfString:@"127.0.0.1"].location!=NSNotFound;//忽略包含127.0.0.1的url
 }
 ];
 
 Example 5:使用选项启动SDK：
 [NBSAppAgent setSetOption:NBSOption_Net|NBSOption_Crash];//只开启网络和崩溃的监控，不开启UI的监控
 [NBSAppAgent startWithAppID:@"xxxxxxx"];
 
*/
