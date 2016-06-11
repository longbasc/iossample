//
//  NetworkManager.h
//
//  Created by luongnguyen on 8/23/14.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NETWORK_TYPE_WIFI                   1
#define NETWORK_TYPE_CELLULAR               2
#define NETWORK_TYPE_OFFLINE                3

@class Reachability;

@interface NetworkManager : NSObject <NSURLSessionDelegate>
{
    //reachability
    Reachability* reach;
    
    //session
    NSURLSession* currentSession;
    NSOperationQueue* opqSessionHandler;
    
    //background upload
    NSString* directoryUpload;
    NSOperationQueue* opqBackgroundUpload;

    NSBlockOperation* opSynchronizeUploadingGUIDs;
    NSMutableArray* uploadingGUIDs;
    NSString* uploadingGUID;
}

#pragma mark MAIN
@property (nonatomic,strong) NSString* serverURL;
@property (nonatomic) int currentNetworkType;
@property (nonatomic,copy) void(^onNetworkChange)(id);

- (void) get:(NSString*)endPoint withParams:(NSDictionary*)params andOnDone:(void(^)(id))onDone andOnError:(void(^)(id))onError;
- (void) post:(NSString*)endPoint withParams:(NSDictionary*)params andOnDone:(void(^)(id))onDone andOnError:(void(^)(id))onError;
- (void) postForm:(NSString*)endPoint withParams:(NSDictionary*)params andOnDone:(void(^)(id))onDone andOnError:(void(^)(id))onError;

- (void) put:(NSString*)endPoint withParams:(NSDictionary*)params andOnDone:(void(^)(id))onDone andOnError:(void(^)(id))onError;

- (void) postMultiForm:(NSString*)endPoint withParams:(NSDictionary*)params cookies:(NSDictionary*)cookies andOnDone:(void(^)(id))onDone andOnError:(void(^)(id))onError;

#pragma mark MAIN - session
- (void) setupInitForSessionWithIdentifier:(NSString*)idf;

#pragma mark MAIN - background upload
@property (nonatomic,strong) NSString* sessionIdentifier; //need set from client

@property (nonatomic,copy) BOOL(^onShouldFinishUploadWithResponseData)(id); //if return NO, the current upload need retry

- (void) setupInitForBackgroundUpload;
- (void) runBackgroundUpload;

- (void) uploadBackgroundTo:(NSString*)endPoint withParams:(NSDictionary*)params cookies:(NSDictionary*)cookies onDone:(void(^)(id))onDone onError:(void(^)(id))onError;
- (void) synchronizeUploadingGUIDs;
- (void) fireUpload;

#pragma mark MAIN - handlers
- (void) handleEventsForBackgroundURLSession:(NSString *)identifier;

@end
