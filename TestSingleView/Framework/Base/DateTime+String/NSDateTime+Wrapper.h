//
//  NSDateTime+Wrapper.h
//
//
//  Created by luongnguyen on 7/23/14.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Wrapper)

#pragma mark STATIC
+ (void) setupSharedDateFormatter;
+ (NSDateFormatter*) getSharedFormatter;

#pragma mark MAIN
- (NSDate*) convertToLocalDate;
- (NSDate*) convertToUTCDate;
- (NSDateComponents*) getDifferenceWithDate:(NSDate*)date;
- (NSString*) toStringWithFormat:(NSString*)format;

- (NSString *) getNowDateDifferenceWithFormat:(NSString*)expectedFormat;

@end
