//
//  NSURLConnection+Wrapper.h
//
//
//  Created by luongnguyen on 7/23/14.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLConnection(Wrapper)

#pragma mark STATIC
+ (void) requestGet:(NSString*)surl withParams:(NSDictionary*)params andOnDone:(void(^)(id))onDone andOnError:(void(^)(id))onError;
+ (void) requestPost:(NSString*)surl withMethod:(NSString*)method andParams:(NSDictionary*)params andOnDone:(void(^)(id))onDone andOnError:(void(^)(id))onError;

+ (void) requestPost:(NSString*)surl method:(NSString*)method postString:(NSString*)postString onDone:(void(^)(id))onDone onError:(void(^)(id))onError;

//support UIImage
+ (void) requestPostMultiForm:(NSString*)surl params:(NSDictionary*)params cookies:(NSDictionary*)cookies onDone:(void(^)(id))onDone onError:(void(^)(id))onError;

+ (NSData*) constructBodyOfParams:(NSDictionary*)params;

@end
