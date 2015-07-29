//
//  NBSGCDOverrider.m
//  test_configLocal
//
//  Created by yang kai on 14-3-27.
//  Copyright (c) 2014年 NBS. All rights reserved.
//


#ifdef __BLOCKS__
#import <Foundation/Foundation.h>
//#import "NBSConsts_Types.h"
//#ifdef enable_2th_phase
#ifndef NBSGCDOverride_H
#define NBSGCDOverride_H
//#ifndef nbs_GCD_s
    #define dispatch_async(...) NBSDispatch_async(__VA_ARGS__)
    #define dispatch_sync(...) NBSDispatch_sync(__VA_ARGS__)
    #define dispatch_after(...) NBSDispatch_after(__VA_ARGS__)
    #define dispatch_apply(...) NBSDispatch_apply(__VA_ARGS__)
    #define _dispatch_once NBSDispatch_once
//#endif
#endif
void NBSDispatch_async(dispatch_queue_t queue, dispatch_block_t block);
void NBSDispatch_sync(dispatch_queue_t queue, dispatch_block_t block);
void NBSDispatch_after(dispatch_time_t when, dispatch_queue_t queue, dispatch_block_t block);
void NBSDispatch_apply(size_t iterations, dispatch_queue_t queue, void(^block)(size_t));
void NBSDispatch_once(dispatch_once_t *once, dispatch_block_t block);
#endif
//#endif
