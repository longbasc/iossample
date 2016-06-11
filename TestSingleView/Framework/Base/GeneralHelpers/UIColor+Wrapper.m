//
//  UIColor+Wrapper.m
//
//  Created by luongnguyen on 7/22/14.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

#import "UIColor+Wrapper.h"

@implementation UIColor(Wrapper)

- (UIImage*) toImage
{
    @autoreleasepool {
        CGRect rect = CGRectMake(0, 0, 1, 1);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [self CGColor]);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }
}
@end
