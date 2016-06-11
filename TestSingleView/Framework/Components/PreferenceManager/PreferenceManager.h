//
//  PreferenceManager.h
//
//  Created by luongnguyen on 10/15/14.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreferenceManager : NSObject
{
    NSMutableDictionary* currentPref;
    NSString* pathSynchrozing;
    
    dispatch_queue_t queueWork;
    NSOperationQueue* queueOperationWork;
}

#pragma mark MAIN

- (void) loadPreferencePath:(NSString*)path;
- (void) unloadPreference;

- (id) getPrefValueForKey:(NSString*)key;
- (void) setPrefValue:(id)value forKey:(NSString*)key;
- (void) removePrefValueForKey:(NSString*)key;

- (id) getGlobalPrefValueForKey:(NSString*)key;
- (void) setGlobalPrefValue:(id)value forKey:(NSString*)key;
- (void) removeGlobalPrefValueForKey:(NSString*)key;

@end
