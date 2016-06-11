//
//  LibUtil.m
//
//  Created by luongnguyen on 9/5/13.
//  Copyright (c) 2013 appiphany. All rights reserved.
//

//core
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCrypto.h>

//lib def
#import "LibDefines.h"

//...
#import "LibUtil.h"

@implementation LibUtil

#pragma mark STATIC
static dispatch_queue_t serialQueues_[10];
static int currentQueueIdx_ = 0;

+ (void) execBlockMainThread:(void(^)(void))block
{
    dispatch_async(dispatch_get_main_queue(), block);
}

+ (void) execBlockConcurrent:(void(^)(void))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), block);
}

+ (void) execBlockSerial:(void(^)(void))block
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        for (int i = 0; i < 10; i++)
        {
            serialQueues_[i] = dispatch_queue_create([str(@"%d",i) UTF8String], NULL);
            currentQueueIdx_ = 0;
        }
    });
    
    dispatch_queue_t q = serialQueues_[currentQueueIdx_];
    dispatch_async(q, block);
    currentQueueIdx_++;
    if (currentQueueIdx_ > 9) currentQueueIdx_ = 0;
}

+ (void) execToQueue:(dispatch_queue_t)queue block:(void(^)(void))block
{
    dispatch_async(queue, block);
}

//misc
+ (NSString*) getTimestamp
{
    time_t t;
    time(&t);
    mktime(gmtime(&t));
    int OAuthUTCTimeOffset = 0;
    return [NSString stringWithFormat:@"%lu", t + OAuthUTCTimeOffset];
}

+ (NSString*) getNonce
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef s = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge NSString*)s ;
}

+ (NSString*) getBundleInfoOfKey:(NSString*)key
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}

+ (NSString*) hashSHA1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_LONG lng = (CC_LONG) data.length;
    
    CC_SHA1(data.bytes, lng, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;    
}

+ (int) getOSMajorVersion
{
    return [[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] firstObject] intValue];
}

#pragma mark MAIN

@end
