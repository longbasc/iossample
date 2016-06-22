//
//  NSString+Wrapper.m
//
//
//  Created by luongnguyen on 7/23/14.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

//lib base
#import "NSData+Wrapper.h"
#import "NSDateTime+Wrapper.h"

//...
#import "NSString+Wrapper.h"

@implementation NSString (Wrapper)

#pragma mark MAIN
- (NSString*) toPath
{
    NSString* name = self;
    NSString *path = @"";
    
    //name follow syntax : {directory}::filename
    if ([name hasPrefix:@"D::"]) //document directory
    {
        name = [name stringByReplacingOccurrencesOfString:@"D::" withString:@""];
        NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [dir stringByAppendingPathComponent:name];
    }
    else if ([name hasPrefix:@"C::"]) //cache directory
    {
        name = [name stringByReplacingOccurrencesOfString:@"C::" withString:@""];
        NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [cacheDir stringByAppendingPathComponent:name];
    }
    else if ([name hasPrefix:@"T::"]) //tmp directory
    {
        name = [name stringByReplacingOccurrencesOfString:@"T::" withString:@""];
        NSString *tmpDir = NSTemporaryDirectory();
        path = [tmpDir stringByAppendingPathComponent:name];
    }
    else
    {
        //search in bundle by default
        NSString *dir = [[NSBundle mainBundle] resourcePath];
        path = [dir stringByAppendingPathComponent:name];
    }
    
    return path;
}

- (NSDate*) toDateWithFormat:(NSString*)format
{
    NSDateFormatter* fmt = [NSDate getSharedFormatter];
    
    [fmt setDateFormat:format];
    return [fmt dateFromString:self];
}

- (NSString*) toBase64Encoded
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedString];
}

- (NSString*) escapeQuotes
{
    NSMutableString* ms = [NSMutableString stringWithFormat:@""];
    for (long i = 0; i < self.length; i++)
    {
        NSString* sub = [self substringWithRange:NSMakeRange(i, 1)];
        
        if ([sub isEqualToString:@"#"])
        {
            [ms appendString:@"#0"];
        }
        else if ([sub isEqualToString:@"'"])
        {
            [ms appendString:@"#1"];
        }
        else if ([sub isEqualToString:@"\""])
        {
            [ms appendString:@"#2"];
        }
        else
        {
            [ms appendString:sub];
        }
    }
    return ms;
}

- (NSString*) unescapeQuotes
{
    if (self.length < 2) return self;
    if ([self rangeOfString:@"#"].location == NSNotFound) return self;
    
    NSMutableString* ms = [NSMutableString stringWithFormat:@""];
    long i = 0;
    for (i = 0; i < self.length; i++)
    {
        int range = 2;
        if (i > self.length-2) range = 1;
        
        NSString* sub = [self substringWithRange:NSMakeRange(i, range)];
        
        if ([sub isEqualToString:@"#2"])
        {
            [ms appendString:@"\""];
            i++;
        }
        else if ([sub isEqualToString:@"#1"])
        {
            [ms appendString:@"'"];
            i++;
        }
        else if ([sub isEqualToString:@"#0"])
        {
            [ms appendString:@"#"];
            i++;
        }
        else
        {
            if (range == 2)
                [ms appendString:[sub substringToIndex:1]];
            else
                [ms appendString:sub];
        }
    }
        
    return ms;
}

- (BOOL) checkIfValidEmail
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
@end
