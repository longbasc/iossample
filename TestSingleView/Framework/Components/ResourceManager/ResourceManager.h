//
//  ResourceManager.h
//
//  Created by luongnguyen on 8/23/14.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GeneralInterfaces.h"

@interface ResourceManager : NSObject<ResourceManagerInterface>
{
    NSFileManager* mgr;
    
    //resource observers
    NSMutableDictionary* mapObservers; //url->[observer]
    
    NSMutableDictionary* mapImage; //url->image
    NSMutableDictionary* mapRounded200Image; //url->rounded200
}

#pragma mark MAIN
- (id) getObjectFromFile:(NSString*)path;

- (NSString*) getLocalPathOfUrl:(NSString*)surl;

- (void) handleMemoryWarning;
- (BOOL) isStoreEmpty;

@end
