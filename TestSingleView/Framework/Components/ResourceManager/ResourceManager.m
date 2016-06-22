//
//  ResourceManager.m
//
//  Created by luongnguyen on 8/23/14.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

//core
#import <UIKit/UIKit.h>

//lib defs
#import "LibDefines.h"

//lib comps
#import "LibUtil.h"
#import "NSString+Wrapper.h"
#import "UIImage+Wrapper.h"

//...
#import "ResourceManager.h"

#define RESMGR_LIMIT_WIDTH_IMAGE            1024

@implementation ResourceManager

#pragma mark INIT
- (id) init
{
    self = [super init];
    if (self)
    {
        mgr = [NSFileManager defaultManager];
        
        mapObservers = [[NSMutableDictionary alloc] init];
        
        mapImage = [[NSMutableDictionary alloc] init];
        mapRounded200Image = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark MAIN
- (id) getObjectFromFile:(NSString*)path
{
    NSData* data = [NSData dataWithContentsOfFile:path];
    
    NSError* err;
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&err];
    if (err)
    {
        DLog(@"%@",err);
        return nil;
    }
    
    return obj;
}

- (NSString*) getLocalPathOfUrl:(NSString*)surl
{
    NSString* base64 = [surl toBase64Encoded];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"/" withString:@"Splash"];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"=" withString:@"Equal"];
    
    //if base64 length <= 25, make it file, if longer, each block of 25 chars create 1 folder
    long length = base64.length;
    
    NSString* path = [@"D::net" toPath];
    BOOL isDir = NO;
    if (![mgr fileExistsAtPath:path isDirectory:&isDir])
    {
        [mgr createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    while (length > 0) {
        
        if (length <= 25)
        {
            path = [path stringByAppendingPathComponent:base64];
            base64 = @"";
        }
        else
        {
            NSString* folder = [base64 substringToIndex:25];
            path = [path stringByAppendingPathComponent:folder];

            isDir = NO;
            if (![mgr fileExistsAtPath:path isDirectory:&isDir])
            {
                [mgr createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
                isDir = YES;
            }
            
            if (!isDir)
            {
                [mgr createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
            }

            base64 = [base64 stringByReplacingCharactersInRange:NSMakeRange(0, 25) withString:@""];
        }
        
        length = base64.length;
    }
    
    return path;
}

- (void) handleMemoryWarning
{
    //when received memory warning, manager release all images
    
    if (mapImage.count > 0)
        [mapImage removeAllObjects];    
    else if (mapRounded200Image.count > 0)
        [mapRounded200Image removeAllObjects];
}

- (BOOL) isStoreEmpty
{
    return (mapImage.count == 0 && mapRounded200Image.count == 0);
}

#pragma mark ResourceManagerInterface
- (void)addObserver:(id<ResourceObserverInterface>)observer forReference:(NSString *)ref ofType:(ResourceObservingType)type
{
    if (type == IMAGE)
    {
        id obj = [mapImage objectForKey:ref];
        if (obj)
        {
            [observer didReceiveObservingObj:obj];
            return;
        }
    }
    
    if (type == ROUNDED_IMAGE_200)
    {
        id obj = [mapRounded200Image objectForKey:ref];
        if (obj)
        {
            [observer didReceiveObservingObj:obj];
            return;
        }
        else if ([mapImage objectForKey:ref])
        {
            {
                NSString* oldRef = [observer getObservingRef];
                NSMutableArray* arr = [mapObservers objectForKey:oldRef];
                [arr removeObject:observer];
                
                arr = [mapObservers objectForKey:ref];
                if (!arr)
                {
                    arr = [[NSMutableArray alloc] init];
                    [mapObservers setObject:arr forKey:ref];
                }
                [arr addObject:observer];
                [observer setObservingType:type];
            }
            
            UIImage* org = [mapImage objectForKey:ref];
            
            [LibUtil execBlockSerial:^{
                UIImage* round = [org toRoundedWithSize:SIZE(200, 200)];
                
                [LibUtil execBlockMainThread:^{
                    
                    [mapRounded200Image setObject:round forKey:ref];
                    [self notifyObserversOfRef:ref withObj:round ofType:ROUNDED_IMAGE_200];                    
                }];
            }];
            
            return;
        }
    }
    
    BOOL isNeedFetch = NO;
    
    //remove observer from oldRef list,
    {
        NSString* oldRef = [observer getObservingRef];
        NSMutableArray* arr = [mapObservers objectForKey:oldRef];
        [arr removeObject:observer];
    }

    {
        NSMutableArray* arr = [mapObservers objectForKey:ref];
        if (!arr)
        {
            arr = [[NSMutableArray alloc] init];
            [mapObservers setObject:arr forKey:ref];
            isNeedFetch = YES;
        }
        
        [arr addObject:observer];
        [observer setObservingType:type];
        [observer setObservingRef:ref];
    }
    
    if (isNeedFetch)
    {
        //start fetching data
        [LibUtil execBlockSerial:^{
            
            NSString* localPath = [self getLocalPathOfUrl:ref];
            NSData* data = nil;
            if ([mgr fileExistsAtPath:localPath])
            {
                data = [NSData dataWithContentsOfFile:localPath];
            }
            
            if (!data)
            {
                data = [NSData dataWithContentsOfURL:[NSURL URLWithString:ref]];
                
                NSError* err;
                [data writeToFile:localPath options:NSDataWritingAtomic error:&err];
                if (err)
                {
                    DLog(@"%@",err);
                }
            }
            
            if (type == IMAGE)
            {
                UIImage* img = [[UIImage alloc] initWithData:data];
                
                if (img.size.width > RESMGR_LIMIT_WIDTH_IMAGE)
                {
                    img = [img resizeToSize:CGSizeMake(RESMGR_LIMIT_WIDTH_IMAGE, img.size.height/img.size.width*RESMGR_LIMIT_WIDTH_IMAGE)];
                }
                else
                {
                    img = [img decompressedImage];
                }
                
                if (img)
                {
                    [LibUtil execBlockMainThread:^{
                        
                        [mapImage setObject:img forKey:ref];
                        [self notifyObserversOfRef:ref withObj:img ofType:IMAGE];
                    }];
                }
            }
            else if (type == ROUNDED_IMAGE_200)
            {
                UIImage* img = [[UIImage alloc] initWithData:data];
                if (img.size.width > RESMGR_LIMIT_WIDTH_IMAGE)
                {
                    img = [img resizeToSize:CGSizeMake(RESMGR_LIMIT_WIDTH_IMAGE, img.size.height/img.size.width*RESMGR_LIMIT_WIDTH_IMAGE)];
                }
                else
                {
                    img = [img decompressedImage];
                }

                if (img)
                {
                    UIImage* img2 = [img toRoundedWithSize:SIZE(200, 200)];
                    
                    [LibUtil execBlockMainThread:^{
                        [mapImage setObject:img forKey:ref];
                        [mapRounded200Image setObject:img2 forKey:ref];

                        [self notifyObserversOfRef:ref withObj:img2 ofType:ROUNDED_IMAGE_200];
                        [self notifyObserversOfRef:ref withObj:img ofType:IMAGE];
                    }];
                }
            }
        }];
    }
}

- (void) removeObserver:(id<ResourceObserverInterface>)observer
{
    NSMutableArray* arr = [mapObservers objectForKey:[observer getObservingRef]];
    [arr removeObject:observer];
}

- (void) notifyObserversOfRef:(NSString*)ref withObj:(id)obj ofType:(ResourceObservingType)type
{
    NSMutableArray* arr = [mapObservers objectForKey:ref];
    NSMutableArray* clear = [NSMutableArray array];
    
    NSMutableArray* roundOrgRequests = [NSMutableArray array];
    
    for (id<ResourceObserverInterface> observer in arr)
    {
        ResourceObservingType typ = [observer getObservingType];
        if (typ == type)
        {
            [observer didReceiveObservingObj:obj];
            [clear addObject:observer];
        }
        
        if (type == IMAGE && typ == ROUNDED_IMAGE_200) //request round of org
        {
            [roundOrgRequests addObject:@{
                                      @"observer":observer,
                                      @"typ":[NSNumber numberWithInt:typ]
                                      }];
        }
    }
    
    //remove observers
    for (id obj in clear)
    {
        [arr removeObject:obj];
    }
    
    for (id d in roundOrgRequests)
    {
        [self addObserver:[d objectForKey:@"observer"] forReference:ref ofType:[[d objectForKey:@"typ"] intValue]];
    }

}

- (id) getResourceByRef:(NSString*)ref ofType:(ResourceObservingType)type
{
    if (type == IMAGE)
    {
        return [mapImage objectForKey:ref];
    }
    else if (type == ROUNDED_IMAGE_200)
    {
        return [mapRounded200Image objectForKey:ref];
    }
    return nil;
}
@end
