//
//  UIImage+Wrapper.m
//
//  Created by luongnguyen on 7/22/14.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

//core
#import <UIKit/UIKit.h>

//...
#import "UIImage+Wrapper.h"

@implementation UIImage (Wrapper)

#pragma mark STATIC

#pragma mark MAIN
- (UIImage*) toRoundedWithSize:(CGSize)sz
{
    @autoreleasepool {

        CGRect rc = CGRectMake(0, 0, sz.width*2, sz.height*2);
        
        float hh = rc.size.height;
        float ww = self.size.width/self.size.height*hh;
        
        if (ww < rc.size.width)
        {
            ww = rc.size.width;
            hh = self.size.height/self.size.width*ww;
        }
        
        CGRect rc2 = CGRectMake(0, 0, ww, hh);
        
        UIGraphicsBeginImageContextWithOptions(rc.size, NO, 0);
        [[UIBezierPath bezierPathWithRoundedRect:rc
                                    cornerRadius:sz.height] addClip];
        
        [self drawInRect:CGRectMake((rc.size.width-rc2.size.width)/2, (rc.size.height-rc2.size.height)/2, rc2.size.width, rc2.size.height)];
        UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return finalImage;
    }
    
}

- (UIImage*) toAlpha:(float)alpha
{
    @autoreleasepool {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
        
        CGContextScaleCTM(ctx, 1, -1);
        CGContextTranslateCTM(ctx, 0, -area.size.height);
        
        CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
        
        CGContextSetAlpha(ctx, alpha);
        
        CGContextDrawImage(ctx, area, self.CGImage);
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return newImage;
    }
}

- (CGAffineTransform) getTransformForOrientationOfNewSize:(CGSize)newSize
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        default:
            break;
    }
    
    return transform;
}

- (UIImage*) resizeToSize:(CGSize)sz
{
    @autoreleasepool {
        CGAffineTransform transform = [self getTransformForOrientationOfNewSize:sz];
        
        CGRect newRect = CGRectIntegral(CGRectMake(0, 0, sz.width, sz.height));
        CGImageRef imageRef = self.CGImage;
        
        // Build a context that's the same dimensions as the new size
        CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                    newRect.size.width,
                                                    newRect.size.height,
                                                    CGImageGetBitsPerComponent(imageRef),
                                                    0,
                                                    CGImageGetColorSpace(imageRef),
                                                    CGImageGetBitmapInfo(imageRef));
        
        // Rotate and/or flip the image if required by its orientation
        CGContextConcatCTM(bitmap, transform);
        
        // Set the quality level to use when rescaling
        CGContextSetInterpolationQuality(bitmap, kCGInterpolationHigh);
        
        // Draw into the context; this scales the image
        CGContextDrawImage(bitmap,newRect, imageRef);
        
        // Get the resized image from the context and a UIImage
        CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
        UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
        
        // Clean up
        CGContextRelease(bitmap);
        CGImageRelease(newImageRef);
        
        return newImage;
    }
}

- (UIImage*) compressWithFactor:(float)factor
{
    @autoreleasepool {
        NSData* data = UIImageJPEGRepresentation(self, factor);
        UIImage* img = [UIImage imageWithData:data];
        return img;
    }
    return nil;
}

- (UIImage*) decompressedImage
{
    @autoreleasepool {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
        [self drawAtPoint:CGPointZero];
        UIImage *decompressedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return decompressedImage;
    }
}

- (UIImage*) toBlurImageWithRadius:(float)radius
{
    @autoreleasepool {
        UIImage *theImage = self;
        
        //create our blurred image
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
        
        //setting up Gaussian Blur (we could use one of many filters offered by Core Image)
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        [filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        //CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches up exactly to the bounds of our original image
        CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
        UIImage* img =  [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        return img;
    }
}

- (UIImage *)fixOrientation
{
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp)
    {
        return self;
    }
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end

