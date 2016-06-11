//
//  UIView+Wrapper.m
//
//  Created by luongnguyen on 7/22/14.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

//lib def
#import "LibDefines.h"

//lib base
#import "NSObject+Wrapper.h"

//...
#import "UIView+Wrapper.h"

@implementation UIView (Wrapper)

- (void) iterateWithOnCheck:(BOOL(^)(id))onCheck andOnProcess:(void(^)(id))onProcess
{
    if (!onCheck) return;
    
    NSMutableArray* arr = [NSMutableArray array];
    [arr addObject:self];
    while (arr.count > 0) {
        
        UIView* vw = [arr objectAtIndex:0];
        [arr removeObjectAtIndex:0];
        
        for (UIView* sub in vw.subviews)
        {
            if (onCheck(sub))
            {
                if (onProcess) onProcess(sub);
            }
            
            if ([sub isKindOfClass:[UIView class]] || [sub isKindOfClass:[UIScrollView class]])
            {
                [arr addObject:sub];
                continue;
            }
        }
        
    }
}

- (void) setEnableUI:(BOOL)isEnable
{
    UIView* vwFadeZero = [self getDetailOfKey:@"waitingViewFadeZero"];
    
    if (!isEnable)
    {
        if (!vwFadeZero)
        {
            vwFadeZero = [[UIView alloc] initWithFrame:self.bounds];
            vwFadeZero.autoresizingMask = AUTOSIZE_FULL;
            vwFadeZero.backgroundColor = [UIColor clearColor];
            [self addSubview:vwFadeZero];
            [self setDetail:vwFadeZero forKey:@"waitingViewFadeZero"];
        }
        
        [self bringSubviewToFront:vwFadeZero];
        [vwFadeZero setHidden:NO];
    }
    else
    {
        [vwFadeZero setHidden:YES];
    }
}

- (void) setLoading:(BOOL)isLoading
{
    UIView* vwFade = [self getDetailOfKey:@"loadingViewFade"];
    UIActivityIndicatorView* vwIndicator = [self getDetailOfKey:@"loadingViewIndicator"];
    
    if (isLoading)
    {
        if (vwIndicator.isAnimating) return; //already
        
        if (!vwFade)
        {
            vwFade = [[UIView alloc] initWithFrame:self.bounds];
            vwFade.autoresizingMask = AUTOSIZE_FULL;
            vwFade.backgroundColor = [UIColor clearColor];
            vwFade.alpha = 1.0;
            [self addSubview:vwFade];
            [self setDetail:vwFade forKey:@"loadingViewFade"];
        }
        
        if (!vwIndicator)
        {
            vwIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            vwIndicator.frame = RECT((self.frame.size.width-vwIndicator.frame.size.width)/2, (self.frame.size.height-vwIndicator.frame.size.height)/2, vwIndicator.frame.size.width, vwIndicator.frame.size.height);
            vwIndicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
            [self addSubview:vwIndicator];
            [self setDetail:vwIndicator forKey:@"loadingViewIndicator"];
        }
        
        [self bringSubviewToFront:vwFade];
        [self bringSubviewToFront:vwIndicator];
        [vwIndicator startAnimating];
        
        [vwFade setHidden:NO];
        [vwIndicator setHidden:NO];
    }
    else
    {
        [vwFade setHidden:YES];
        
        [vwIndicator stopAnimating];
        [vwIndicator setHidden:YES];
    }
}

@end
