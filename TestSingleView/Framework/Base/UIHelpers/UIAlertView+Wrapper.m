//
//  UIAlertView+Wrapper.m
//
//
//  Created by luongnguyen on 7/23/14.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

//lib base
#import "NSObject+Wrapper.h"

//...
#import "UIAlertView+Wrapper.h"

@implementation UIAlertView (Wrapper)

#pragma mark STATIC
static UIAlertView* currentAlertView__ = nil;

+ (void) showWithTitle:(NSString*)title andMsg:(NSString*)msg
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    currentAlertView__ = alert;
    [alert show];
}

+ (void) showWithTitle:(NSString*)title andMsg:(NSString*)msg andOnOK:(void(^)(void))onOK
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    currentAlertView__ = alert;

    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    if (onOK) [d setObject:[onOK copy] forKey:@"onCancel"];
    
    [alert setDetail:d forKey:@"UserInfo"];
    [alert show];
}

+ (void) showWithTitle:(NSString*)title andMsg:(NSString*)msg andOnYes:(void(^)(void))onYes andOnNo:(void(^)(void))onNo
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    currentAlertView__ = alert;

    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    if (onYes) [d setObject:[onYes copy] forKey:@"onAccept"];
    if (onNo) [d setObject:[onNo copy] forKey:@"onCancel"];

    [alert setDetail:d forKey:@"UserInfo"];
    [alert show];
}

+ (void) showWithTitle:(NSString*)title andMsg:(NSString*)msg andOnOK:(void(^)(void))onOK andOnCancel:(void(^)(void))onCancel
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    currentAlertView__ = alert;

    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    if (onOK) [d setObject:[onOK copy] forKey:@"onAccept"];
    if (onCancel) [d setObject:[onCancel copy] forKey:@"onCancel"];
    
    [alert setDetail:d forKey:@"UserInfo"];
    [alert show];
}

+ (void) showWithTitle:(NSString*)title andMsg:(NSString*)msg buttons:(NSArray*)buttons onClickedButton:(void(^)(id))onClicked
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    currentAlertView__ = alert;

    int i = 0;
    int cancelIdx = -1;
    
    for (NSString* s in buttons)
    {
        NSString* s2 = s;
        if ([s hasPrefix:@"#"])
        {
            s2 = [s2 substringFromIndex:1];
            cancelIdx = i;
        }
        
        [alert addButtonWithTitle:s2];
        i++;
    }
    
    if (cancelIdx > -1)
    {
        [alert setCancelButtonIndex:cancelIdx];
    }

    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    [d setObject:[onClicked copy] forKey:@"onClicked"];
    [d setObject:buttons forKey:@"buttons"];
    
    [alert setDetail:d forKey:@"UserInfo"];
    
    [alert show];
}

+ (UIAlertView*) getCurrentAlertView
{
    if (!currentAlertView__.isVisible)
    {
        currentAlertView__ = nil;
    }
    
    return currentAlertView__;
}

#pragma mark STATIC SELECTORS
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDictionary* d = [alertView getDetailOfKey:@"UserInfo"];
    
    void(^funcOnClicked)(id) = [d objectForKey:@"onClicked"];
    if (funcOnClicked)
    {
        NSArray* arr = [d objectForKey:@"buttons"];
        funcOnClicked([arr objectAtIndex:buttonIndex]);
        return;
    }
    
    if (buttonIndex == 0)
    {
        void(^func)(void) = [d objectForKey:@"onCancel"];
        if (func) func();
    }
    else
    {
        void(^func)(void) = [d objectForKey:@"onAccept"];
        if (func) func();
    }
}

@end
