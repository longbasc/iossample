//
//  Globals.m
//  
//
//  Created by admin on 6/10/16.
//
//

#import "Globals.h"

@implementation Globals

NSString* const  G_CONST_SERVER_URL = @"www.basc.com.vn/bkticket";
bool G_SignedIn = false;
//=========================================================================================================================
+ (Globals*)sharedInstance
{
    
    @try {
        
        // 2
        static dispatch_once_t oncePredicate;
        
        // 1
        static Globals *_sharedInstance = nil;
        
        
        // 3
        dispatch_once(&oncePredicate, ^{
            _sharedInstance = [[Globals alloc] init];
            //((AppManager*)_sharedInstance).spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        });
        
        return _sharedInstance;
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    @finally {
        // NSLog(@"Char at index %d cannot be found", index);
        //NSLog(@"Max index is: %d", [test length]-1);
    }
    
    
}


//=========================================================================================================================

- (id)init {
    if (self = [super init]) {
        //_IsSignedIn = false;
    }
    return self;
    
}

//=========================================================================================================================
- (void)doHTTPPostWithURL:(NSString*)url postString:(NSString*)postString  markData:(id)markData onDone:(void(^)(id))onDone onError:(void(^)(id))onError

{
    onDoHTTPPostURLDone = [onDone copy];
    onDoHTTPPostURLError = [onError copy];
    markCallerData =  [markData copy];
    
    NSString* realURL = [NSString stringWithFormat:@"http://%@/%@",G_CONST_SERVER_URL,url];
    
    NSURL *aUrl = [NSURL URLWithString:realURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

//=========================================================================================================================
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}


//=========================================================================================================================
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSArray * trustedHosts = @[@"www.basc.com.vn"];
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        if ([trustedHosts containsObject:challenge.protectionSpace.host])
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}


//=========================================================================================================================
NSMutableData *_responseData;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

//=========================================================================================================================
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
    
    
    
    
}

//=========================================================================================================================
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

//=========================================================================================================================
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
        if (onDoHTTPPostURLDone)
        {
            onDoHTTPPostURLDone(_responseData);
        }
        onDoHTTPPostURLDone = nil;
        onDoHTTPPostURLError = nil;
        
        if ([self.delegate respondsToSelector:@selector(doHTPPostSuccessWithMarkData:Data:)])
        {
            [self.delegate doHTPPostSuccessWithMarkData:markCallerData Data:_responseData];
        }
    
    
    

}

//=========================================================================================================================
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
   

        
        if (onDoHTTPPostURLError)
        {
            onDoHTTPPostURLError(_responseData);
        }
        onDoHTTPPostURLDone = nil;
        onDoHTTPPostURLError = nil;
        
        if ([self.delegate respondsToSelector:@selector(doHTPPostFailWithMarkData:Error:)])
        {
            [self.delegate doHTPPostFailWithMarkData:markCallerData Error:error ];
        }
    
        
         markCallerData = nil; //reset callerCode
    
    
}




@end
