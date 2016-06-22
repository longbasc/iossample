//
//  UIImageView+Wrapper.h
//
//
//  Created by luongnguyen on 8/21/14.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GeneralInterfaces.h"

@interface UIImageView (LoadURL) <ResourceObserverInterface>
{
    
}

#pragma mark STATIC
+ (void) setResourceManager:(id<ResourceManagerInterface>)aManager;

#pragma mark MAIN
- (void) setImageOfURL:(NSString*)url withPlaceHolder:(UIImage*)imgPlaceHolder andIsRound:(BOOL)isRound;
- (void) setActualImage:(UIImage*)img;

- (void) setHandlerBeforeAssignImage:(void(^)(id))aHandler;

@end
