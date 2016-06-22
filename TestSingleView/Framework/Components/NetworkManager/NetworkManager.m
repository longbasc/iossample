//
//  NetworkManager.m
//
//  Created by luongnguyen on 8/23/14.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

//lib def
#import "LibDefines.h"

//lib base
#import "LibUtil.h"
#import "NSTimer+Wrapper.h"
#import "NSURLConnection+Wrapper.h"
#import "NSString+Wrapper.h"

//...
#import "Reachability.h"
#import "NetworkManager.h"

@implementation NetworkManager

#pragma mark INIT
- (id) init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onkReachabilityChangedNotification:) name:kReachabilityChangedNotification object:nil];
        reach = [Reachability reachabilityForInternetConnection];
        [reach startNotifier];
        [NSTimer timerWithTimeout:2.0 andBlock:^(NSTimer* tmr) {
            [self onkReachabilityChangedNotification:nil];
        }];
    }
    return self;
}

#pragma mark MAIN
- (void) get:(NSString*)endPoint withParams:(NSDictionary*)params andOnDone:(void(^)(id))onDone andOnError:(void(^)(id))onError
{
    NSString* surl = str(@"%@%@",self.serverURL,endPoint);
    [NSURLConnection requestGet:surl withParams:params andOnDone:onDone andOnError:onError];
}

- (void) post:(NSString*)endPoint withParams:(NSDictionary*)params andOnDone:(void(^)(id))onDone andOnError:(void(^)(id))onError
{
    NSString* surl = str(@"%@%@",self.serverURL,endPoint);
    [NSURLConnection requestPost:surl withMethod:@"POST" andParams:params andOnDone:onDone andOnError:onError];
}

- (void) postForm:(NSString*)endPoint withParams:(NSDictionary*)params andOnDone:(void(^)(id))onDone andOnError:(void(^)(id))onError
{
    NSString* surl = str(@"%@%@",self.serverURL,endPoint);
    NSMutableString* body = [NSMutableString string];
    for (id key in params)
    {
        [body appendFormat:@"%@=%@&",key,[params objectForKey:key]];
    }
    
    NSString* final = @"";
    if ([body hasSuffix:@"&"])
    {
        final = [body substringToIndex:body.length-1];
    }
    else {
        final = body;
    }
    [NSURLConnection requestPost:surl method:@"POST" postString:final onDone:onDone onError:onError];
    
}


- (void) put:(NSString*)endPoint withParams:(NSDictionary*)params andOnDone:(void(^)(id))onDone andOnError:(void(^)(id))onError
{
    NSString* surl = str(@"%@%@",self.serverURL,endPoint);
    [NSURLConnection requestPost:surl withMethod:@"PUT" andParams:params andOnDone:onDone andOnError:onError];
}

- (void) postMultiForm:(NSString*)endPoint withParams:(NSDictionary*)params cookies:(NSDictionary*)cookies andOnDone:(void(^)(id))onDone andOnError:(void(^)(id))onError
{
    NSString* surl = str(@"%@%@",self.serverURL,endPoint);
    [NSURLConnection requestPostMultiForm:surl params:params cookies:cookies onDone:onDone onError:onError];
}

#pragma mark MAIN - session

- (void) setupInitForSessionWithIdentifier:(NSString*)idf
{
    self.sessionIdentifier = idf;
    
    opqSessionHandler = [[NSOperationQueue alloc] init];
    opqSessionHandler.maxConcurrentOperationCount = 1;
    if ([LibUtil getOSMajorVersion] >= 8.0)
    {
        [opqSessionHandler setUnderlyingQueue:dispatch_queue_create("NetworkManager.SessionHandler", 0)];
    }
    
    NSURLSessionConfiguration *configuration = nil;
    NSString* identifier = self.sessionIdentifier;
    if ([LibUtil getOSMajorVersion] <= 7)
    {
        configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:identifier];
    }
    else
    {
        configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
    }
    currentSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:opqSessionHandler];
}

#pragma mark MAIN - background upload
- (void) setupInitForBackgroundUpload
{
    NSAssert(currentSession, @"Require session for background upload, please do setupInitForSession first");
    
    opqBackgroundUpload = [[NSOperationQueue alloc] init];
    opqBackgroundUpload.maxConcurrentOperationCount = 1;

    if ([LibUtil getOSMajorVersion] >= 8.0)
    {
        [opqBackgroundUpload setUnderlyingQueue:dispatch_queue_create("NetworkManager.BackgroundUpload", 0)];
    }
    
    directoryUpload = [@"D::NetworkManager/BackgroundUpload" toPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryUpload])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryUpload withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    NSData* data = [NSData dataWithContentsOfFile: [directoryUpload stringByAppendingPathComponent:@"uploading"]];
    if (data)
    {
        uploadingGUIDs = [[NSMutableArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:JSONMutable error:NULL]];
    }
    else
    {
        uploadingGUIDs = [[NSMutableArray alloc] init];
    }
}

- (void) runBackgroundUpload
{
    uploadingGUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"NetworkManager.BackgroundUpload.UploadingGUID"];
    [currentSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        BOOL isFound = NO;
        
        for (NSURLSessionTask* task in uploadTasks)
        {
            if (!isFound && [task.taskDescription isEqualToString:uploadingGUID])
            {
                if ([task countOfBytesExpectedToSend] == 0)
                {
                    [task cancel];
                    continue;
                }
                else
                {
                    [task resume];
                    isFound = YES;
                }
            }
            else
            {
                [task cancel];
            }
        }
        
        [LibUtil execBlockMainThread:^{
            
            if (!isFound)
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NetworkManager.BackgroundUpload.UploadingGUID"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                uploadingGUID = nil;
            }
            
            [self fireUpload];
        }];
    }];
}

- (void) uploadBackgroundTo:(NSString*)endPoint withParams:(NSDictionary*)params cookies:(NSDictionary*)cookies onDone:(void(^)(id))onDone onError:(void(^)(id))onError
{
    NSAssert([NSThread isMainThread], @"MAIN THREAD ACCESS ONLY");
    
    //create record for this upload
    NSString* guid = [LibUtil getNonce];
    
    //folder for data container
    NSString* directoryData = [directoryUpload stringByAppendingPathComponent:guid];
    [[NSFileManager defaultManager] createDirectoryAtPath:directoryData withIntermediateDirectories:YES attributes:nil error:NULL];
    
    //save
    [opqBackgroundUpload addOperationWithBlock:^{
        NSString* surl = str(@"%@%@",self.serverURL,endPoint);
        NSMutableDictionary* md = [NSMutableDictionary dictionary];
        [md setObject:@"" forKey:@"upload_failed_reason"];
        [md setObject:surl forKey:@"url"];
        if (cookies)
        {
            [md setObject:cookies forKey:@"cookies"];
        }

        NSData* dataMeta = [NSJSONSerialization dataWithJSONObject:md options:NSJSONWritingPrettyPrinted error:NULL];
        NSString* path = [directoryData stringByAppendingPathComponent:@"meta"];
        [dataMeta writeToFile:path atomically:YES];
        
        NSData* dataBody = [NSURLConnection constructBodyOfParams:params];
        path = [directoryData stringByAppendingPathComponent:@"dataBody"];
        [dataBody writeToFile:path atomically:YES];
        
        [LibUtil execBlockMainThread:^{
            //register
            [self->uploadingGUIDs addObject:guid];
        
            [self synchronizeUploadingGUIDs];
            
            //invoke upload
            [self fireUpload];
            
            if (onDone) onDone(nil);
        }];
    }];
}

- (void) synchronizeUploadingGUIDs
{
    NSAssert([NSThread isMainThread], @"MAIN THREAD ACCESS ONLY");

    NSString* path = [directoryUpload stringByAppendingPathComponent:@"uploading"];
    NSArray* arr = [NSArray arrayWithArray:uploadingGUIDs];
    
    if (opSynchronizeUploadingGUIDs)
    {
        [opSynchronizeUploadingGUIDs cancel];
        opSynchronizeUploadingGUIDs = nil;
    }
    
    opSynchronizeUploadingGUIDs = [NSBlockOperation blockOperationWithBlock:^{
        NSData* data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:NULL];
        [data writeToFile:path atomically:YES];
        
        [LibUtil execBlockMainThread:^{
            self->opSynchronizeUploadingGUIDs = nil;
        }];
    }];
    [opSynchronizeUploadingGUIDs setQueuePriority:NSOperationQueuePriorityHigh];
    
    [opqBackgroundUpload addOperation:opSynchronizeUploadingGUIDs];
}

- (void) fireUpload
{    
    NSAssert([NSThread isMainThread], @"MAIN THREAD ACCESS ONLY");
    
    if (uploadingGUID) return; //uploading, please wait
    
    //read uploading array and do upload
    if (uploadingGUIDs.count == 0) return;
    
    uploadingGUID = [uploadingGUIDs objectAtIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:uploadingGUID forKey:@"NetworkManager.BackgroundUpload.UploadingGUID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString* directoryData = [directoryUpload stringByAppendingPathComponent:uploadingGUID];
    
    NSString* pathMeta = [directoryData stringByAppendingPathComponent:@"meta"];
    NSString* pathBody = [directoryData stringByAppendingPathComponent:@"dataBody"];
    
    [opqBackgroundUpload addOperationWithBlock:^{
        NSData* data = [NSData dataWithContentsOfFile:pathMeta];
        id meta = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
        
        [LibUtil execBlockMainThread:^{
            
            NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[meta objectForKey:@"url"]]];
            [req setHTTPMethod:@"POST"];
            NSString* boundary = @"----aBORNDWErnhrRUrEKrMqaSBnsjdypqyqeuroNYUORRYBmdoooooIII";
            NSString* contentType = str(@"multipart/form-data; boundary=%@",boundary);
            [req addValue:contentType forHTTPHeaderField:@"Content-Type"];
            
            //add cookie
            NSDictionary* cookies = [meta objectForKey:@"cookies"];
            if (cookies && cookies.count > 0)
            {
                NSMutableString* scookie = [NSMutableString string];
                for (NSString* k in cookies.allKeys)
                {
                    [scookie appendFormat:@"%@=%@;",k,[cookies objectForKey:k]];
                }
                [req addValue:scookie forHTTPHeaderField:@"Cookie"];
            }
            
            NSURLSessionUploadTask* task = [currentSession uploadTaskWithRequest:req fromFile:[NSURL fileURLWithPath:pathBody]];
            [task setTaskDescription:uploadingGUID];
            [task resume];
            
        }];
    }];
}

#pragma mark MAIN - handlers
- (void) handleEventsForBackgroundURLSession:(NSString *)identifier
{
    NLog(@"Handle background session");
}

#pragma mark NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    //uploading
    if ([task.taskDescription isEqualToString:uploadingGUID])
    {
        NLog(@"Uploading");
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if ([task.taskDescription isEqualToString:uploadingGUID])
    {
        if (error)
        {
            //retry the upload
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NetworkManager.BackgroundUpload.UploadingGUID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            uploadingGUID = nil;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self fireUpload];
            });
        }
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [LibUtil execBlockMainThread:^{
        if ([dataTask.taskDescription isEqualToString:uploadingGUID])
        {
            NLog(@"Should finish upload");
            if (self.onShouldFinishUploadWithResponseData)
            {
                NSString* directoryData = [directoryUpload stringByAppendingPathComponent:uploadingGUID];
                
                BOOL isShould = self.onShouldFinishUploadWithResponseData(data);
                if (isShould)
                {
                    //done
                    
                    //remove
                    [[NSFileManager defaultManager] removeItemAtPath:directoryData error:nil];
                    
                    [uploadingGUIDs removeObject:uploadingGUID];
                    [self synchronizeUploadingGUIDs];
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NetworkManager.BackgroundUpload.UploadingGUID"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    uploadingGUID = nil;
                    
                    NLog(@"Did finish upload, next one"); //please note, finish upload not mean successful upload, if server response valid error, there is need other way to handle such case.
                    
                    //next
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self fireUpload];
                    });
                }
                else
                {
                    NLog(@"Failed to finish upload, retry");
                    
                    NSString* pathMeta = [directoryData stringByAppendingPathComponent:@"meta"];
                    NSMutableDictionary* meta = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:pathMeta] options:JSONMutable error:NULL];
                    
                    NSString* reason = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    [meta setObject:[reason toBase64Encoded] forKey:@"upload_failed_reason"];
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NetworkManager.BackgroundUpload.UploadingGUID"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    uploadingGUID = nil;
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self fireUpload];
                    });
                    
                }
            }
        }

    }];
}

#pragma mark SELECTORs
- (void) onkReachabilityChangedNotification:(NSNotification*)notif
{
    if (self.onNetworkChange)
    {
        NSString* type = @"";
        if (reach.currentReachabilityStatus == ReachableViaWiFi)
        {
            self.currentNetworkType = NETWORK_TYPE_WIFI;
            type = @"Wifi";
        }
        else if (reach.currentReachabilityStatus == ReachableViaWWAN)
        {
            self.currentNetworkType = NETWORK_TYPE_CELLULAR;
            type = @"Cellular";
        }
        else if (reach.currentReachabilityStatus == NotReachable)
        {
            self.currentNetworkType = NETWORK_TYPE_OFFLINE;
            type = @"Offline";
        }
        self.onNetworkChange(type);
    }
}
@end
