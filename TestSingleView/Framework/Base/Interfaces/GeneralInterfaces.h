//
//  GeneralInterfaces.h
//  
//
//  Created by luongnguyen on 8/21/14.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    IMAGE,
        ROUNDED_IMAGE_200
//    JSON,
//    RAW_DATA
    
} ResourceObservingType;

//**************************************************
@protocol ResourceObserverInterface <NSObject>

- (void) setObservingRef:(NSString*)ref;
- (NSString*)  getObservingRef;

- (void) didReceiveObservingObj:(id)obj;

- (void) setObservingType:(ResourceObservingType)type;
- (ResourceObservingType) getObservingType;

@end

//**************************************************
@protocol ResourceManagerInterface <NSObject>

- (void) addObserver:(id<ResourceObserverInterface>)observer forReference:(NSString*)ref ofType:(ResourceObservingType)type;
- (void) removeObserver:(id<ResourceObserverInterface>)observer;

- (void) notifyObserversOfRef:(NSString*)ref withObj:(id)obj ofType:(ResourceObservingType)type;

- (id) getResourceByRef:(NSString*)ref ofType:(ResourceObservingType)type;

@end

