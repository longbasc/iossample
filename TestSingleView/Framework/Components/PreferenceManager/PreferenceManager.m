//
//  PreferenceManager.m
//
//  Created by luongnguyen on 10/15/14.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

//lib def
#import "LibDefines.h"

//...
#import "PreferenceManager.h"

@implementation PreferenceManager

#pragma mark INTI
- (id) init
{
    self = [super init];
    if (self)
    {
        queueWork = dispatch_queue_create("PreferenceManager.Work", 0);
        
        queueOperationWork = [[NSOperationQueue alloc] init];
        queueOperationWork.maxConcurrentOperationCount = 1;
    }
    return self;
}

#pragma mark MAIN
- (void) loadPreferencePath:(NSString*)path
{
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSAssert(data != nil,@"Preference not found");
    
    pathSynchrozing = path;
    currentPref = [NSJSONSerialization JSONObjectWithData:data options:JSONMutable error:NULL];
    
    [[NSUserDefaults standardUserDefaults] setObject:currentPref forKey:@"Preference"];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

- (void) unloadPreference
{
    pathSynchrozing = nil;
    currentPref = nil;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Preference"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id) getPrefValueForKey:(NSString*)key
{
    return [currentPref objectForKey:key];
}

- (void) setPrefValue:(id)value forKey:(NSString*)key
{
    NSAssert([NSThread isMainThread],@"SET PREF VALUE ONLY WORK MAIN THREAD");
    
    if (!currentPref) return;
    
    [currentPref setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:currentPref forKey:@"Preference"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString* pathTmp = pathSynchrozing;
    NSDictionary* dref = [NSDictionary dictionaryWithDictionary:currentPref];
    __weak PreferenceManager* weakSelf = self;
    
    [queueOperationWork cancelAllOperations];
    [queueOperationWork addOperationWithBlock:^{
        if (!weakSelf) return ;
        NSData* data = [NSJSONSerialization dataWithJSONObject:dref options:NSJSONWritingPrettyPrinted error:NULL];
        [data writeToFile:pathTmp atomically:YES];
    }];

}

- (void) removePrefValueForKey:(NSString*)key
{
    if (!currentPref) return;

    [currentPref removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:currentPref forKey:@"Preference"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString* pathTmp = pathSynchrozing;
    NSDictionary* dref = [NSDictionary dictionaryWithDictionary:currentPref];
    __weak PreferenceManager* weakSelf = self;
    
    [queueOperationWork cancelAllOperations];
    [queueOperationWork addOperationWithBlock:^{
        if (!weakSelf) return ;
        NSData* data = [NSJSONSerialization dataWithJSONObject:dref options:NSJSONWritingPrettyPrinted error:NULL];
        [data writeToFile:pathTmp atomically:YES];
    }];
}

- (id) getGlobalPrefValueForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void) setGlobalPrefValue:(id)value forKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) removeGlobalPrefValueForKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
