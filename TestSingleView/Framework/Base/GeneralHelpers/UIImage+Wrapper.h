//
//  UIImage+Wrapper.h
//
//  Created by luongnguyen on 7/22/14.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Wrapper)

#pragma mark MAIN

- (UIImage*) toRoundedWithSize:(CGSize)sz;
- (UIImage*) toAlpha:(float)alpha;

- (CGAffineTransform) getTransformForOrientationOfNewSize:(CGSize)newSize;
- (UIImage*) resizeToSize:(CGSize)sz;

- (UIImage*) compressWithFactor:(float)factor;
- (UIImage*) decompressedImage;

- (UIImage*) toBlurImageWithRadius:(float)radius;
- (UIImage *)fixOrientation;

@end
