//
//  UIFont+Wrapper.m
//
//
//  Created by luongnguyen on 7/23/14.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

//lib defs
#import "LibDefines.h"

//...
#import "UIFont+Wrapper.h"

@implementation UIFont (Wrapper)

#pragma mark STATIC
+ (void) logFontsAvailable
{
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
}
@end
