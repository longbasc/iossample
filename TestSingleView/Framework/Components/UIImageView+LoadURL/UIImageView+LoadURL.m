//
//  UIImageView+Wrapper.m
//
//
//  Created by luongnguyen on 8/21/14.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

//lib def
#import "LibDefines.h"

//lib base
#import "LibUtil.h"
#import "NSObject+Wrapper.h"

//...
#import "UIImageView+LoadURL.h"

@implementation UIImageView (LoadURL)

#pragma mark STATIC
static id<ResourceManagerInterface> resourceManager_ = nil;

+ (void) setResourceManager:(id<ResourceManagerInterface>)aManager
{
    resourceManager_ = aManager;
}

#pragma mark MAIN

- (void) setImageOfURL:(NSString*)url withPlaceHolder:(UIImage*)imgPlaceHolder andIsRound:(BOOL)isRound
{
    NSAssert(resourceManager_ != nil,@"Require a resource manager for asynchronous image loading");
    if (!url)
    {
        return;
    }
    
    if ([resourceManager_ getResourceByRef:url ofType:(isRound?ROUNDED_IMAGE_200:IMAGE)]) //find alreay one
    {
        //check if observing ref differ from url
        if (![[self getObservingRef] isEqualToString:url])
        {
            UIImage* img =  [resourceManager_ getResourceByRef:url ofType:(isRound?ROUNDED_IMAGE_200:IMAGE)];
            void(^handler)(id) = [self getDetailOfKey:@"HandlerBeforeAssignImage"];
            if (handler)
            {
                handler(img);
            }
            self.image = img;
            
            UIImageView* imgViewPlaceHolder = [self getDetailOfKey:@"ImgViewPlaceHolder"];
            imgViewPlaceHolder.alpha = 0;
            
            [self setObservingRef:url];
        }
        return;
    }
    
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.image = nil;

    UIImageView* imgViewPlaceHolder = [self getDetailOfKey:@"ImgViewPlaceHolder"];
    if (!imgViewPlaceHolder)
    {
        imgViewPlaceHolder = [[UIImageView alloc] initWithFrame:self.bounds];
        imgViewPlaceHolder.autoresizingMask = AUTOSIZE_FULL;
        imgViewPlaceHolder.contentMode = UIViewContentModeScaleAspectFit;
        imgViewPlaceHolder.backgroundColor = [UIColor clearColor];
        [self addSubview:imgViewPlaceHolder];
        [self setDetail:imgViewPlaceHolder forKey:@"ImgViewPlaceHolder"];
    }
    
    imgViewPlaceHolder.alpha = 1.0;
    imgViewPlaceHolder.image = imgPlaceHolder;
    
    [resourceManager_ addObserver:self forReference:url ofType:(isRound?ROUNDED_IMAGE_200:IMAGE)];
    
    [self setObservingRef:url];
}

- (void) setActualImage:(UIImage*)img
{
    void(^handler)(id) = [self getDetailOfKey:@"HandlerBeforeAssignImage"];
    if (handler)
    {
        handler(img);
    }

    UIImageView* imgViewPlaceHolder = [self getDetailOfKey:@"ImgViewPlaceHolder"];
    [imgViewPlaceHolder setAlpha:0];
    
    self.image = img;
    [resourceManager_ removeObserver:self];
}

- (void) setHandlerBeforeAssignImage:(void(^)(id))aHandler
{
    [self setDetail:[aHandler copy] forKey:@"HandlerBeforeAssignImage"];
}

#pragma mark ResourceObserverInterface

- (void) setObservingRef:(NSString*)ref
{
    [self setDetail:ref forKey:@"observingRef"];
}

- (NSString *)getObservingRef
{
    return [self getDetailOfKey:@"observingRef"];
}

- (void)didReceiveObservingObj:(id)obj
{
    NSAssert([NSThread isMainThread], @"Error, Main Thread only");
    
    UIImage* img = obj;
    
    void(^handler)(id) = [self getDetailOfKey:@"HandlerBeforeAssignImage"];
    if (handler)
    {
        handler(img);
    }
    
//    [self removeDetailOfKey:@"HandlerBeforeAssignImage"];

    UIImageView* imgViewPlaceHolder = [self getDetailOfKey:@"ImgViewPlaceHolder"];
    
    self.image = img;
    
    [UIView animateWithDuration:0.7 animations:^{
        imgViewPlaceHolder.alpha = 0.0;
    } completion:^(BOOL finished) {
        
//        [self removeDetailOfKey:@"observingRef"];
//        [self removeDetailOfKey:@"observingType"];
    }];
    
}

- (void) setObservingType:(ResourceObservingType)type
{
    [self setDetail:[NSNumber numberWithInt:type] forKey:@"observingType"];
}

- (ResourceObservingType) getObservingType
{
    return (ResourceObservingType)[[self getDetailOfKey:@"observingType"] intValue];
}

@end
