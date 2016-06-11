//
//  Globals.h
//  
//
//  Created by admin on 6/10/16.
//
//

#import <Foundation/Foundation.h>

extern NSString* const  G_CONST_SERVER_URL;
extern bool G_SignedIn;


//====================================================================================================
@protocol MyGlobalDelegate

// define protocol functions that can be used in any class using this delegate
- (void)doHTPPostSuccessWithMarkData:(id)markData Data:(NSData*)data;
- (void)doHTPPostFailWithMarkData:(id)markData Error:(NSError*)error;

@end


//====================================================================================================
@interface Globals : NSObject <NSURLConnectionDelegate>
{
    void(^onDoHTTPPostURLDone)(id);
    void(^onDoHTTPPostURLError)(id);
    id markCallerData;
    
}


+ (Globals*)sharedInstance;

- (id)init;
- (void)doHTTPPostWithURL:(NSString*)url postString:(NSString*)postString  markData:(id)markData onDone:(void(^)(id))onDone onError:(void(^)(id))onError;


@property (nonatomic, weak) id  delegate;


@end
